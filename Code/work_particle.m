clearvars
close all
load("cars.mat");
od = repmat({':'},1,ndims(Video)-1);

% Parameters
NBins = 16;
NParticle = 200;
lambda = 10;
sig_x = 7;
sig_y = sig_x;

% Allocate Memory to store Video result
VideoResult = zeros(Video_Height,Video_Width,3,NumFrames);
od3 = repmat({':'},1,ndims(VideoResult)-1);


frame = Video(od{:},1);
frame_roi    = xRoi(frame);

target_roi   = xRoi(ROI_Center,ROI_Width,ROI_Height);
target_image = target_roi.getRoiImage(frame);
target_model = xRoi(target_image).color_model(target_image, 'nbins', NBins, 'kernel', 'epanechnikov');

displayFrame=target_roi.annotate(frame);

%% Generate the set of particles
x_init = target_roi.center;
% xp = zeros(NParticle,length(x_init));
% for i = 1:NParticle
%     xp(i,:) = round( x_init + ([sig_x sig_y].^2).*randn(1,length(x_init)) );
% end
xp = generate_points_inside_box(NParticle,target_roi.center,frame_roi,sig_x,sig_y);


displayFrame=annotate_frame_vectors(displayFrame,xp,'yellow');

subplot(1,2,1);
subimage(displayFrame);xlabel('Frame1');


 %% Next step
xpPred = xp;
w = zeros(1,NParticle);

% for t=2:NumImages
next_frame=Video(od{:},2);
pos =1;
for ii = 1:NParticle
     % create a random point inside the ROI
     new_point = round( xpPred(ii,:) + ([sig_x sig_y].^2).*randn(1,length(x_init)) );
     if frame_roi.point_inside(new_point)
        xpPred(pos,:) = new_point;
        pos = pos +1;
     end
end

% Evaluate Importance Weights
for ii=1:NParticle
    particle = xpPred(ii,:);
    % - extract a patch around xpPred(i,:)
    patch_roi = xRoi(particle, target_roi.width,target_roi.height);
    patch_image = patch_roi.getRoiImage(next_frame);
    % - compute color distribution
    patch_model = xRoi(patch_image).color_model(patch_image, 'nbins', NBins);
    % - compute batt. coeff
    rho = region_rho(next_frame, patch_roi, target_model, NBins);        
    % - compute weight w(i)
    w(ii) = exp(-1 * lambda * (1-rho)^2); 
end
% Normalise the weights.
w = w./sum(w); 

% Selection Step: Resampling  
outIndex = residualR(1:NParticle, w');       % Residual resampling.
xp = xpPred(outIndex, :); % Keep particles with resampled indices. 

x_estimate = w*xp;
xpPred = round(xp);
x_estimate = round(x_estimate);

% New roi
target_roi   = xRoi(x_estimate,ROI_Width,ROI_Height);
displayFrame2=target_roi.annotate(next_frame);
displayFrame2=annotate_frame_vectors(displayFrame2,xp,'yellow');

subplot(1,2,2);
subimage(displayFrame2);xlabel('Frame 2');

