% test xRoI operations

clearvars
close all
load("cars.mat");
ROI=xRoi(ROI_Center(1),ROI_Center(2),ROI_Width,ROI_Height);

od = repmat({':'},1,ndims(Video)-1);

figure
frame = Video(od{:},1);

tImg = ROI.annotate(frame);
subplot(2,3,[1 2 4 5]);imshow(tImg);

patch = ROI.getRoiImage(frame);
subplot(2,3,3);imshow(patch,[]);

return

for h = 1:ROI_Height
    roi1 = xRoi(ROI_Center(1), h, ROI_Width,ROI_Height);
    
    tImg = roi1.annotate(frame);
    subplot(2,3,[1 2 4 5]);imshow(tImg,[]);
    
    patch = roi1.getRoiImage(frame);
    subplot(2,3,3);imshow(patch,[]);
    
    drawnow;
end