for subj=1:56
    folder_path = sprintf('/Users/paroma/Desktop/Columbia Gaze Data Set/%04d/', subj);
    cd(folder_path);
    filename_match = sprintf('%04d_2m_0P_*', subj);
    
    jpegFiles = dir(filename_match); 
    numfiles = length(jpegFiles);
    for k = 1:numfiles 
        img_to_move =jpegFiles(k).name; 
        source = strcat(folder_path,img_to_move);
        destination = '/Users/paroma/Desktop/Dataset';
        movefile(source, destination);
    end
    
end
%%
files = dir('*.jpg');
for file = files'
    a = imread(file.name);
    a_crop = rgb2gray(a(1460:2173, 1800:3245,:));
    a_crop = imresize(a_crop, 0.04);
    imwrite(a_crop,strcat('crop_',file.name));
end