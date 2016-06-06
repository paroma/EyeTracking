clear; close all;

datadir = '/Volumes/My Passport/cs231a/';
d = dir([datadir '*.mat']);

bbox = [    67.5100  102.5100  135.9800   99.9800 ; ...
            107.5100  202.5100  143.9800  103.9800; ...
            6.5100  164.5100  202.9800  115.9800 ;  ...
            38.5100  112.5100  216.9800  137.9800;  ...
            53.5100  186.5100  173.9800  117.9800 ];

for i = 1:size(d,1)-1
    clear frames frametimes stimulus
    load([datadir d(i).name]);
    d(i).name
    binCropOutputImages(4, frames, frametimes, stimulus, 'data/', bbox(i,:));
end