clearvars
close all
load("cars.mat");
od = repmat({':'},1,ndims(Video)-1);

% Parameters
NBins = 8;


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

prev_center = ROI_Center;
for frameNo = 2:NumFrames
    frame = Video(od{:},frameNo);
   
    stable_center=false;
    loop_count = 0;
    while ( not(stable_center) & (loop_count < 10))

        patch_roi = xRoi(prev_center, target_roi.width,target_roi.height);
        patch_image = patch_roi.getRoiImage(frame);
        patch_model = xRoi(patch_image).color_model(patch_image);

        rho0 = region_rho(frame, patch_roi, target_model);

        % Derive the weights and compute the mean-shift vector
        W = meanshift_weights(patch_image, patch_model, target_model, NBins);
        new_center = meanshift_vector(patch_image,  W);

        % Re-evaluate at new center
        patch_roi = xRoi(new_center, target_roi.width,target_roi.height);
        rho1 = region_rho(frame, patch_roi, target_model);

        % Converge to the new center
        while rho1 < rho0
            new_center = ceil((prev_center + new_center) / 2);
            patch_roi = xRoi(new_center, target_roi.width,target_roi.height);
            rho1 = region_rho(frame, patch_roi, target_model);
            %old_centers =[old_centers ; new_center];
        end

        if norm(new_center-prev_center, 1) < 1
            stable_center = true;
        else
            loop_count = loop_count+1;
        end
    end % while
    
    displayFrame=patch_roi.annotate(frame);
    displayFrame=annotate_frame(displayFrame, frameNo);
    VideoResult(od3{:},frameNo) = displayFrame;

    imshow(displayFrame);
    xlabel('Video sequence');
    drawnow;
    
end

%implay(VideoResult);

function rho = region_rho(frame, roi, target_model)
    patch_image = roi.getRoiImage(frame);
    patch_model = xRoi(patch_image).color_model(patch_image);
    rho = bhattacharyya_coeff(target_model,patch_model);
end

