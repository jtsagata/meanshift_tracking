% test xRoI operations
clearvars
close all
imtool close all

load("cars.mat");
od = repmat({':'},1,ndims(Video)-1);
ROI=xRoi(ROI_Center,ROI_Width,ROI_Height);


frame = Video(od{:},1);
frameROI = xRoi(frame);

figure
iptsetpref('ImshowBorder','tight');

tImg = ROI.annotate(frame);
subplot(2,3,[1 2 4 5]);imshow(tImg);xlabel('Image patch');

patch = ROI.getRoiImage(frame);
subplot(2,3,3);imshow(patch,[]);
target_model = xRoi(patch).color_model(patch);
subplot(2,3,6);bar(target_model);xlabel('Model pdf/Patch pdf'); axis on; 

for h = 1:Video_Height
    roi1 = xRoi([ROI_Center(1), h], ROI_Width,ROI_Height);
    
    tImg = roi1.annotate(frame,'green');
    inter = frameROI.intersect(roi1);  
    tImg = inter.annotate(tImg,'red');
    
    subplot(2,3,[1 2 4 5]);imshow(tImg);
   
    patch = roi1.getRoiImage(frame);
    subplot(2,3,3);imshow(patch);
    
    patch_model = xRoi(patch).color_model(patch);xlabel('Image patch');
    subplot(2,3,6); ax = bar([target_model; patch_model]', 'Barwidth', 2);
    xlabel('Model pdf/Patch pdf'); axis on; ylim([0 2000]); 
    
    rho = bhattacharyya_coeff(target_model,patch_model);
    subplot(2,3,[1 2 4 5]);xlabel(sprintf('Batacharaya xoeff is %1.3f',rho));

    drawnow;
    if IsNear(rho,1.0)
        pause(1.0);
    end
   
end

for w = 1:Video_Width
    roi1 = xRoi([w,ROI_Center(2), h], ROI_Width,ROI_Height);
    
    tImg = roi1.annotate(frame,'green');
    inter = frameROI.intersect(roi1);  
    tImg = inter.annotate(tImg,'red');
    
    subplot(2,3,[1 2 4 5]);imshow(tImg);
   
    patch = roi1.getRoiImage(frame);
    subplot(2,3,3);imshow(patch);
    
    patch_model = xRoi(patch).color_model(patch);xlabel('Image patch');
    subplot(2,3,6);bar([target_model; patch_model]', 'Barwidth', 2);
    xlabel('Model pdf/Patch pdf'); axis on;ylim([0 2000]); 

    rho = bhattacharyya_coeff(target_model,patch_model);
    subplot(2,3,[1 2 4 5]);xlabel(sprintf('Batacharaya xoeff is %1.3f',rho));

    drawnow;
    if IsNear(rho,1.0)
        pause(1.0)
    end

end
