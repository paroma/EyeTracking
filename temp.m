videofile = 'stimulus.mp4';
v = VideoReader(videofile);
figure;
times = zeros(1860,1);
tic
k = 1;
while hasFrame(v)
    video = readFrame(v);
    image(video);
    times(k) = toc;
    pause(1/30);
    k = k+1;
end
