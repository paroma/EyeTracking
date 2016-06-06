clear; close all;
id = 0;
prompt = 'Enter the user ID: ';
id = input(prompt);
datadir = 'data/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup Screen Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screenDiagonal = 0.6096; % meters
screenAspectRatio = 16/9;
screenResolution = struct('x', 1920, 'y', 1080);
distToScreen = 0.51; % meters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create point coordintes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Gets dimensions in meters
screenDim = dimFromAspect(screenDiagonal, screenAspectRatio);

% Gets the calibration points as pixel on the screenResolutino display
pts = createCalibrationPoints(screenResolution, screenDim, distToScreen);

% Divide by half to create a video quarter the size (for faster playback)
ptshalf = pts/2;
if(sum(sum(mod(ptshalf,2))) ~= 0 )
    disp('ERROR WITH PTS HALF');    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup video stream
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bUseVideo = true;
% Estimate framerate
if(bUseVideo)
    vid = videoinput('macvideo',1,'ARGB32_1920x1080');
%     vid = videoinput('macvideo',1,'YCbCr422_1280x720');
    vid.FramesPerTrigger = 100;
    vid.FrameGrabInterval = 2 ;
    start(vid);
    isrunning(vid)
    wait(vid,Inf);
    [frames,time] = getdata(vid, get(vid,'FramesAvailable'));
    framerate = mean(1./diff(time))

    vid.FramesPerTrigger = 5;
    capturetime = size(pts,1)/30/2;
    %capturetime = 5;
    interval = get(vid,'FrameGrabInterval')
    numframes = floor(capturetime * framerate * interval )
    %vid.FramesPerTrigger = numframes;
    triggerconfig(vid, 'Manual');
    vid.TriggerRepeat = ceil(numframes / vid.FramesPerTrigger);

    % Log to disk
    vid.LoggingMode = 'disk';
    vwObj = VideoWriter([datadir 'eyedata' num2str(id) '.mp4']);
    vwObj.FrameRate = framerate;
    vid.DiskLogger = vwObj;

    start(vid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display Points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

videoFReader   = vision.VideoFileReader('stimsmallgray.mj2');
depVideoPlayer = vision.DeployableVideoPlayer;
depVideoPlayer.WindowSize = 'Full-screen';
depVideoPlayer.Location = [1440 900];

% ***** IMPORTANT *****
% When comparing these time stamps to the camera time stamp make sure to
% account for the offset at the beginning. The first change occurs in the
% 2nd index of the times vector.

cont = ~isDone(videoFReader);
times = zeros(size(pts(:,1)));
k = 2;

dispFrameRate = 30;
dispTime = 1/dispFrameRate;

% First step to initialize the window and everything
frame = step(videoFReader);
step(depVideoPlayer, frame);

% Trigger video capture

if(bUseVideo)    
    trigger(vid);
    %start(vid)
end
tic
while cont
    frame = step(videoFReader);
    step(depVideoPlayer, frame);
    cont = ~isDone(videoFReader) && isOpen(depVideoPlayer);
    
    cont = ~(toc > capturetime);
    
    while(toc - times(k-1) <  dispTime)
    end
    times(k) = toc;
    k = k+1;
end

vid.TimerFcn = {'stop'};
release(videoFReader);
release(depVideoPlayer);

% Record data
filename = [datadir 'timedsequence' num2str(id)];
timedsequence = [times, pts];
save(filename, 'timedsequence');

v.FramesAcquired
v.DiskLoggerFrameCount

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Close up video stream
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(bUseVideo)
    wait(vid);
    vwObj = vid.DiskLogger;
    close(vwObj);

    delete(vid);
    clear vid;
end