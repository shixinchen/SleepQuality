%This version of the file would record 200 frames and then analyse them.
%Issues with this are that something could be missed when not recording
%And other methods will need to be changed to take into account what
%happened before.
utilpath = fullfile(matlabroot, 'toolbox', 'imaq', 'imaqdemos', ...
    'html', 'KinectForWindows');
addpath(utilpath);

vid2 = videoinput('kinect',2,'Depth_640x480'); % Depth camera
srcDepth = getselectedsource(vid2);

fnum = 200;

vid2.FramesPerTrigger = 1;
vid2.TriggerRepeat = 2200;
triggerconfig(vid2,'manual');
start(vid2);

vidHeight = 480;
vidWidth = 640;

s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
t = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
u = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

counter = 0;

whitePixelCount = [];

for x = 1:10
    starttime = clock;
    for i = 1:fnum+1
        % Trigger both objects.
        trigger(vid2)
    
        [imgDepthAll, ts_depthAll, metaData_DepthAll] = getdata(vid2);
    
        s(i).cdata = imgDepthAll;
        %  t(i).cdata = ts_depthAll;
        %  u(i).cdata = metaData_DepthAll;
        
    end
    endtime = clock;
    s = ApproximateMedian(s);

    whitePixelCount = [whitePixelCount; countWhitePixels(s, fnum)];
end

save('Data\whitepixels.mat','whitePixelCount','starttime','endtime');

stop(vid2);

%[x, pewpdi] = VideoAnalysis(s(1).cdata);
% If you don't stop you can't start video acquisition again. it will give
% error when you try to start again. in this case call fnc below

%close(vidObj);