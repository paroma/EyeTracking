function [ ] = ptsToMovie( pts, videodim,  moviename, type )
% Convert the points to a videodim movie
% With name moviename
img = ones(videodim(1), videodim(2),3, 'uint8') * 210;
v = VideoWriter(moviename, type);
open(v);
tic
for i = 1:size(pts,1)
    RGB = insertShape(img, 'filledrectangle', [pts(i,1)-1 pts(i,2)-1 3 3], 'Color', 'red', 'Opacity', 1);
    writeVideo(v,RGB);
end
toc
close(v);
end

