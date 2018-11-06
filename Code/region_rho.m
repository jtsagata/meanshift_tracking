function rho = region_rho(frame, roi, target_model, NBins)
    patch_image = roi.getRoiImage(frame);
    patch_model = xRoi(patch_image).color_model(patch_image, 'nbins', NBins);
    rho = bhattacharyya_coeff(target_model,patch_model);
end
