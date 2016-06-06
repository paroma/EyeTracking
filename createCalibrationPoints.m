function [ pts ] = createCalibrationPoints( windowPx, windowDim, distToScreen )
% Creates an array of calibration points that the user will look at

pixelPitch = windowDim.x / windowPx.x;

% Need to compute angular resolution per pixel of this setup
% This angular resolution determines how many pixels I can go down to
% maintain a 1 degree 

angres = 2*atan2(pixelPitch/2, distToScreen);
angres = angres * 180/pi; % convert to angular degrees

pxperdegree = 1 / angres;

xvalues.horz = (floor(pxperdegree) : floor(pxperdegree)/4 : windowPx.x - floor(pxperdegree))';
xvalues.vertleft = floor(pxperdegree);
xvalues.vertright = windowPx.x - floor(pxperdegree);

yvalues.horz = floor(pxperdegree);
yvalues.vert = (floor(pxperdegree)/4:floor(pxperdegree)/4:floor(pxperdegree))'+ floor(pxperdegree);

isRightMotion = @(i) mod(i,2);

pts = [];
for j = 1 : floor((windowPx.y - 2*floor(pxperdegree)) / floor(pxperdegree))
   if(isRightMotion(j))
       xhorzpts = xvalues.horz;
       xvertpts = xvalues.vertright;
       
   else
       xhorzpts = flipud(xvalues.horz);
       xvertpts = xvalues.vertleft;
   end
    
   vertoffset = (j-1) * floor(pxperdegree);
   ptshorz = [xhorzpts, ...
             repmat(yvalues.horz + vertoffset, [size(xvalues.horz,1),1]) ];
      
   ptsvert = [repmat(xvertpts, [size(yvalues.vert,1)-1, 1]) , ...
                  yvalues.vert(1:end-1) + vertoffset];
   pts = [ pts; ptshorz; ptsvert];
end

%pts = [32, 32; 32 960; 32 1920-32; 1080/2 32; 1080/2 960; 1080/2 1920-32; 1080-32 32; 1080-32 960; 1080-32 1920-32]; 

%pts = unique(pts,'rows');


end

