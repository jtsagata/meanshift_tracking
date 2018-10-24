clearvars
close all
load("cars.mat");
od = repmat({':'},1,ndims(Video)-1);


% Calculate Weight matrix
weights = kernelMatrix(ROI_Width,ROI_Height,'kernel','epanechnikov');

% Allocate Memory to store Video result
VideoResult = zeros(width,height,3,frames);
odr = repmat({':'},1,ndims(VideoResult)-1);
% Allocate Memory to store tracking possitions

% Video Progress display
videoH = figure('name', 'Mean Shift Algorithm', 'units', 'normalized', 'outerposition', [0 0 1 1]);


frame = Video(:,:,1);

displayFrame = annotate_frame(gray2rgb(frame), ROI_Center,ROI_Width,ROI_Height,1);
VideoResult(odr{:},1) = displayFrame;
update_display(displayFrame)
                                   
for frameNo = 2:frames
    frame = Video(od{:},frameNo);
    
    displayFrame = annotate_frame(gray2rgb(frame), ROI_Center,ROI_Width,ROI_Height,frameNo);
    VideoResult(odr{:},frameNo) = displayFrame;
    update_display(displayFrame)
end

%implay(VideoResult);

%% Helper functions
function update_display(displayFrame) 
        subplot(1,1,1); imshow(displayFrame);
end