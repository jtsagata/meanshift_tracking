clearvars
close all
load("head.mat");
od = repmat({':'},1,ndims(Video)-1);

% Parameters
NBins = 8;
rhoLimit = 0.9;

% Allocate Memory to store Video result
VideoResult = zeros(Video_Height,Video_Width,3,NumFrames);
od3 = repmat({':'},1,ndims(VideoResult)-1);


frame = Video(od{:},1);
target_roi   = xRoi(ROI_Center,ROI_Width,ROI_Height);
target_image = target_roi.getRoiImage(frame);
target_model = xRoi(target_image).color_model(target_image);

% Anaotate 1st video frame
displayFrame=target_roi.annotate(frame);
displayFrame=annotate_frame(displayFrame, 1);
VideoResult(od3{:},1) = displayFrame;

% Video Progress display
videoH = figure('name', 'Mean Shift Algorithm');
title =("Mean shift tracking");

totalTime=0;
prev_center = ROI_Center;
for frameNo = 2:NumFrames
    frame = Video(od{:},frameNo);
    
    % Start measure of execution time
    tic;
    
    % Adapt to varius scales
    scales = 0.8:0.1:1.2;
    minDist = 1e99;
    for s = 1:size(scales,1)
        var_roi = target_roi.scale(scales(s));
        [patch_var_roi,v_rho]=meanshift_algorithm(frame,prev_center,var_roi,target_model,NBins);
        % Find region with minimum distance
        dist = norm(prev_center-patch_var_roi.center);
        if (dist < minDist)
            minDist = dist;
            patch_roi = patch_var_roi;
            rho = v_rho;
        end
    end
    prev_center=patch_roi.center;
    if rho<rhoLimit
        % Reset roi if not a good match
        prev_center=ROI_Center;
    end
        
    % End measure of execution time 
    totalTime = totalTime + toc;
    
    % Show only good matches
    displayFrame=annotate_frame(frame, frameNo);
    if rho>rhoLimit
        displayFrame=patch_roi.annotate(displayFrame);
    end
        
    VideoResult(od3{:},frameNo) = displayFrame;

    imshow(displayFrame);
    drawnow;
end


p = mfilename('fullpath');
[filepath,name,ext]=fileparts(p);
movieFile=fullfile(filepath,'../Videos/',[name,'.avi']);

movie=immovie(VideoResult);
myVideo = VideoWriter(movieFile);
open(myVideo);
writeVideo(myVideo, movie);
close(myVideo);

pngFile=fullfile(filepath,'../Videos/',[name,'.png']);
video_to_img_seq(VideoResult,pngFile);

txtFile=fullfile(filepath,'../Videos/',[name,'.txt']);
fileID = fopen(txtFile,'w');
fprintf(fileID,'ExecutionTime %1.4f secs.\n',totalTime);
fclose(fileID);

