function [ time, pos ] = getTimeandPos( vid, timedpts)
% From the CurrentTime of a video object, get the closest time and point of
% the stimulus
%   -- video is an opened video reader object
%   -- timed pts is a nx3 matrix, whereh the 1st column are the times,
%   and the 2nd and 3rd columns describe the pts in pixels on the screen.

[m, I] = min( abs(vid.CurrentTime - timedpts(:,1)));
time = timedpts(I,1);
pos = timedpts(I,2:3);

end

