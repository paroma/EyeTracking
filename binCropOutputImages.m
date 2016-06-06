%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script does the following for each image in current folder 
% 1) Loads in Image
% 2) Convert to Grayscale
% 3) Uses imcrop to get bounding box
%      - after creating bounding box, right click, select 'Crop Image'
% 4) Applies that bounding box to rest of images
% 5) Downsamples cropped image to 28x28
% 6) Saves out cropped images with prefix 'cropped_'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = binCropOutputImages( binsize, frames, frametimes, stimulus, outputdir, bbox)
    tic
    first_image = true;

    % Remove last 3 samples due to error
    stimulus(end-2:end,:) = [];

    % Bin stimulus points ( only works for 4 binsize right now)
    idx = 1:size(stimulus,1);
    kp = idx( mod(idx,binsize) == 1);
    
    binnedstim = stimulus;
    
    for i = kp
        if( i-2 > 1)
            binnedstim( i-2, 2:3) = binnedstim(i,2:3);
        end
        if(i-1 > 1)
            binnedstim( i-1, 2:3) = binnedstim(i,2:3);
        end
        if( i+1 < size(binnedstim,1))
            binnedstim( i+1, 2:3) = binnedstim(i,2:3);
        end
    end
    
    % Remove any points after the last stimulus
    frametimes(frametimes > max(binnedstim(:,1)), :) = [];
    
    % Assign frame to each stimulus point
    for i = 1:size(frametimes,1)
        
        % Assign to stimulus point        
        [m, I] = min( abs(frametimes(i) - binnedstim(:,1)));
        time = binnedstim(I,1);
        pos = binnedstim(I,2:3);
        
        img = frames(:,:,:,i);
        img_grayscale = rgb2gray(img);
        
        if isempty(bbox)
            [img_crop,bbox] = imcrop(img_grayscale);
            bbox
            first_image = false;
            close all;
        else
            img_crop = imcrop(img_grayscale, bbox);
        end
        
        img_resized = imresize(img_crop, [28 28]);
        
        
        % Write to file
        d = dir([outputdir 'cropped_' num2str(pos(1)) '_' num2str(pos(2)) '*.jpg']);
        nums = [];
        if( isempty(d))
            nums = 0;
        else
            for j = 1:size(d,1)
                parsedname = strsplit(d(j).name, '_'); % split on underscore
                parsedname = strsplit(parsedname{4},'.'); %remove .jpg
                nums(end+1) = str2num(parsedname{1}); %convert to number
            end
        end
        
        outname = [ 'cropped_' num2str(pos(1)) '_' num2str(pos(2)) ...
                    '_' num2str(max(nums)+1) '.jpg'];
        imwrite(img_resized,[outputdir outname]);
    end
    toc
end