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
first_image = true;
files = dir('*.jpg');
for file = files'
    img = imread(file.name);
    img_grayscale = rgb2gray(img);
    if first_image
        [img_crop,bbox] = imcrop(img_grayscale);
        first_image = false;
        close all;
    else
        img_crop = imcrop(img_grayscale, bbox);
    end
    img_resized = imresize(img_crop, [28 28]);
    imwrite(img_resized,strcat('cropped_',file.name));
end