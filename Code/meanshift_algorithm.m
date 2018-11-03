function patch_roi=meanshift_algorithm(frame,prev_center,target_roi,target_model,NBins)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

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
        %prev_center = patch_roi.center;

        % Converge to the new center
        rho_loop_count = 0;
        while ( (rho1 < rho0) & (rho_loop_count<100) )
            new_center = ceil((prev_center + new_center) / 2);
            patch_roi = xRoi(new_center, target_roi.width,target_roi.height);
            rho1 = region_rho(frame, patch_roi, target_model);
            rho_loop_count = rho_loop_count +1;
        end

        if norm(new_center-prev_center, 1) < 1
            stable_center = true;
        else
            loop_count = loop_count+1;
        end
    end % while

end

function rho = region_rho(frame, roi, target_model)
    patch_image = roi.getRoiImage(frame);
    patch_model = xRoi(patch_image).color_model(patch_image);
    rho = bhattacharyya_coeff(target_model,patch_model);
end
