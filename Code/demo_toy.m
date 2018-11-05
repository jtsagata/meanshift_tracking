clearvars
close all
load("toy.mat");
od = repmat({':'},1,ndims(Video)-1);

% Rought background claculation
background=mean(Video,4);

% Parameters
NBins = 8;

% Allocate Memory to store Video result
VideoResult = zeros(Video_Height,Video_Width,3,NumFrames);
od3 = repmat({':'},1,ndims(VideoResult)-1);


frame_bg = Video(od{:},1);
frame = imsubtract(background .* 0.75 ,frame_bg);
frame = frame_bg - background .* 0.75;
frame = imsubtract(background,frame_bg);

%frame = Video(od{:},1);

target_roi   = xRoi(ROI_Center,ROI_Width,ROI_Height);
target_image = target_roi.getRoiImage(frame);
target_model = xRoi(target_image).color_model(target_image);

% Anotate 1st video frame
displayFrame=target_roi.annotate(frame);
displayFrame=annotate_frame(displayFrame, 1);
VideoResult(od3{:},1) = displayFrame;

% Video Progress display
videoH = figure('name', 'Mean Shift Algorithm');
title =("Mean shift tracking");

totalTime=0;
prev_center = ROI_Center;
for frameNo = 2:NumFrames
    frame_bg = Video(od{:},frameNo);
    %frame = imsubtract(background .* 0.25,frame_bg);
    frame = imsubtract(background,frame_bg);
    frame = frame_bg - background .* 0.75;

%     frame = Video(od{:},frameNo);
    
    % Start measure of execution time
    tic; 
    [patch_roi,rho]=meanshift_algorithm(frame,prev_center,target_roi,target_model,NBins);
    prev_center=patch_roi.center;
    totalTime = totalTime + toc;
    % End measure of execution time 
    
    displayFrame=patch_roi.annotate(frame);
    displayFrame=annotate_frame(displayFrame, frameNo);
    VideoResult(od3{:},frameNo) = displayFrame;

    imshow(displayFrame);
    xlabel('Video sequence');
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

