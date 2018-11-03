close all
clearvars

f2 = figure('visible','off');
iptsetpref('ImshowBorder','tight');

load("cars.mat");
od = repmat({':'},1,ndims(Video)-1);
frame = Video(od{:},1);
frameROI = xRoi(frame);
target_model = frameROI.color_model(frame);

weights = kernelMatrix(frameROI.length(2),frameROI.length(1),'kernel','epanechnikov');
binSize = 1.0/8;
whereToPut = arrayfun(@(x) uint8(floor(x/binSize))+1,frame);

subplot(2,2,1);subimage(frame);xlabel('Image');

subplot(2,2,4);b=bar(target_model,'FaceColor','flat');xlabel('Model pdf'); axis on;
colors=colormap(jet); b.CData =flipud(colors(1:8:64,:));


subplot(2,2,2);imagesc(weights);colormap(spring);colorbar;axis equal;
xlabel('Pixel weights');

subplot(2,2,3);imshow(label2rgb(whereToPut,'jet'));axis equal;
xlabel('Pixels to bins assignment');

drawnow;
saveas(f2,'../Report/historgram.png');
close(f2);


%% EpanechnikovMatrix
z1=kernelMatrix(30,30, 'kernel','epanechnikov'); 
z2=kernelMatrix(30,30, 'kernel','gaussian'); 

f1 = figure('visible','off');
set(f1, 'Position', [100, 300, 1200, 400])

subplot(1,2,1)
surf(z1, 'FaceAlpha',0.85, 'EdgeColor', 'interp');
zlim([0 3]);colorbar;
hold on;
imagesc(z1)
contour(z1,'LineColor','w');
title('Epanechnikov kernel');


subplot(1,2,2)
surf(z2, 'FaceAlpha',0.85, 'EdgeColor', 'interp');
zlim([0 3]);
hold on;
imagesc(z2);colorbar;
contour(z2,'LineColor','w');
title('Gaussian kernel');


saveas(f1,'../Report/kernels.png');
close(f1)