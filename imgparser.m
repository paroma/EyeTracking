% % Script to parse dataset images, demean and augment and save new images
% for training
clc;
clear all;
close all;

labelmat = zeros(50000,1);
for label = 0:9
count = 5000*(label) + 1;

pathval = label;
path = strcat(pwd,'\data\');
% ,num2str(pathval),'\data',num2str(pathval),'\');
storepath = strcat(pwd,'\final_data\img_');
labelmat(count:count+5000-1) = label;
for i = 32:32 : 1888
    for j = 32:32:992
        for k=1:21
    count
    pause(0.001);
    name = sprintf('cropped_%d_%d_%d',i,j,k);
    name = strcat(name,'.jpg');
    imageloc = strcat(path,name);
    temp = imread(imageloc);
    newimg = temp;
    
% % % %     Demean Image
% %     meanimg = mean(mean(newimg,1),2);
% %     meanfilt = ones(size(newimg));
% %     meanfilt(:,:,1) = meanimg(:,:,1);
% %     meanfilt(:,:,2) = meanimg(:,:,2);
% %     meanfilt(:,:,3) = meanimg(:,:,3);
% %     newimg = newimg - meanfilt;
    
% %     newimg = rgb2gray(newimg); Keep Color
    newimg1 = flipdim(newimg,2);
    newimg2 = imnoise(newimg,'poisson');
    newimg3 = imnoise(newimg,'salt & pepper');
    newimg4 = imnoise(newimg,'gaussian');
    newimg5 = imnoise(newimg,'speckle');
    newimg6 = imnoise(newimg1,'poisson');
    newimg7 = imnoise(newimg1,'salt & pepper');
    newimg8 = imnoise(newimg1,'gaussian');
    newimg9 = imnoise(newimg1,'speckle');
    
% %  Visualize
    figure(1);
    subplot(2,5,1);
    imshow(newimg);
    subplot(2,5,2);
    imshow(newimg1);
    subplot(2,5,3);
    imshow(newimg2);
    subplot(2,5,4);
    imshow(newimg3);
    subplot(2,5,5);
    imshow(newimg4);
    subplot(2,5,6);
    imshow(newimg5);
    subplot(2,5,7);
    imshow(newimg6);
    subplot(2,5,8);
    imshow(newimg7);
    subplot(2,5,9);
    imshow(newimg8);
    subplot(2,5,10);
    imshow(newimg9);
    pause();    
% % %  Write Files
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg,fname,'jpg');
    count = count + 1;
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg1,fname,'jpg');
    count = count + 1;
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg2,fname,'jpg');
    count = count + 1;
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg3,fname,'jpg');
    count = count + 1;
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg4,fname,'jpg');
    count = count + 1;
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg5,fname,'jpg');
    count = count + 1;
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg6,fname,'jpg');
    count = count + 1;
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg7,fname,'jpg');
    count = count + 1;
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg8,fname,'jpg');
    count = count + 1;
    fname = strcat(strcat(storepath,sprintf('%03d',count),'.jpg'));
    imwrite(newimg9,fname,'jpg');
    count = count + 1;
        end
    end
%     
end

save labeldata.mat labelmat
    
end

save labeldata.mat labelmat