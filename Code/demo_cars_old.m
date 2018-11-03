clearvars
close all
load("cars.mat");
od = repmat({':'},1,ndims(Video)-1);

% Parameters
NBins = 8;

% Calculate Weight matrix

% Allocate Memory to store Video result
VideoResult = zeros(width,height,3,frames);
odr = repmat({':'},1,ndims(VideoResult)-1);
% Allocate Memory to store tracking possitions

% Video Progress display
videoH = figure('name', 'Mean Shift Algorithm');
title =("Mean shift tracking");

frame = Video(:,:,1);
displayFrame = annotate_frame(gray2rgb(frame), ROI_Center,ROI_Width,ROI_Height,1);
VideoResult(odr{:},1) = displayFrame;

[patch,ROI_Width,ROI_Height] = getPatch(frame, ROI_Center,ROI_Width,ROI_Height);
weights = kernelMatrix(ROI_Width,ROI_Height,'kernel','epanechnikov');
model_pdf = color_distribution(patch, NBins, weights);

prev_center = ROI_Center;
for frameNo = 2:frames
    frame = Video(od{:},frameNo);
    while(true)
        [patch, patch_Width,patch_Height] = getPatch(frame, prev_center,ROI_Width,ROI_Height);
        weights = kernelMatrix(patch_Width,patch_Height,'kernel','epanechnikov');
        patch_pdf = color_distribution(patch,NBins,weights);
        rho0 = bhattacharyya_coeff(model_pdf,patch_pdf);

        % Derive the weights and compute the mean-shift vector
        W = mean_shift_weights(patch, patch_pdf, model_pdf, NBins);
        Z = meanshift_vector(patch,  weights);
        new_center = Z;

        % Re-evaluate at new center
        [patch,patch_Width,patch_Height] = getPatch(frame, new_center, ROI_Width, ROI_Height);
        weights = kernelMatrix(patch_Width,patch_Height,'kernel','epanechnikov');
        patch_pdf = color_distribution(patch, NBins,weights);
        rho1 = bhattacharyya_coeff(model_pdf,patch_pdf);

        % Converge to the new center
        while rho1 < rho0
            new_center = ceil((prev_center + new_center) / 2);
            patch = getPatch(frame, new_center, ROI_Width, ROI_Height);
            [patch_Width,patch_Height] = size(patch);
            weights = kernelMatrix(patch_Width,patch_Height,'kernel','epanechnikov');
            patch_pdf = color_distribution(patch, NBins,weights);
            rho1 = bhattacharyya_coeff(model_pdf,patch_pdf);
        end

        if norm(new_center-prev_center, 1) < 1
            break;
        end
        prev_center = new_center;
    end % while(true)
    
    displayFrame = annotate_frame(gray2rgb(frame), new_center, patch_Width,patch_Height,frameNo);
    VideoResult(odr{:},frameNo) = displayFrame;
    subplot(2,3,[1 2 4 5]);imshow(displayFrame);
    subplot(2,3,3);bar([model_pdf; patch_pdf]', 'Barwidth', 2);xlabel('Model pdf/Patch pdf'); axis on; 
    subplot(2,3,6);imagesc(W);xlabel('Mean Shift Weights'); axis on; 
    drawnow;
end

%implay(VideoResult);