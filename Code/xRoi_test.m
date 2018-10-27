% test xRoI operations

%%% Even dimensions

% Create from xRoi([cx,cy],w,h)
r =xRoi([7,7],9,7);
assert(isequal(r.center,[7 7]));
assert(isequal(r.size,  [9 7]));
assert(isequal(r.tl,    [3 4]));
assert(isequal(r.br,    [11 10]));

% Create from xRoi[x1,x2],[w,h])
r =xRoi([3,4],[9,7]);
assert(isequal(r.center,[7 7]));
assert(isequal(r.size,  [9 7]));
assert(isequal(r.tl,    [3 4]));
assert(isequal(r.br,    [11 10]));

% Create from xRoi(x1,x2,y1,y2)
r =xRoi(3,4,11,10);
assert(isequal(r.center,[7 7]));
assert(isequal(r.size,  [9 7]));
assert(isequal(r.tl,    [3 4]));
assert(isequal(r.br,    [11 10]));

%%% Odd dimensions

% Create from xRoi(x1,x2,y1,y2)
r = xRoi(1,1,4,6);
assert(isequal(r.center,[2 3]));
assert(isequal(r.size,  [4 6]));
assert(isequal(r.tl,    [1 1]));
assert(isequal(r.br,    [4 6]));

% Create from xRoi[x1,x2],[w,h])
r = xRoi([1,1],[4,6]);
assert(isequal(r.center,[2 3]));
assert(isequal(r.size,  [4 6]));
assert(isequal(r.tl,    [1 1]));
assert(isequal(r.br,    [4 6]));

% Create from xRoi([cx,cy],w,h)
r = xRoi([2,3],4,6);
assert(isequal(r.size,  [4 6]));
assert(isequal(r.tl,    [1 1]));
assert(isequal(r.br,    [4 6]));
assert(isequal(r.center,[2 3]));


return
clearvars
close all
load("cars.mat");
od = repmat({':'},1,ndims(Video)-1);
ROI=xRoi(ROI_Center(1),ROI_Center(2),ROI_Width,ROI_Height);



figure
frame = Video(od{:},1);
% 
% tImg = ROI.annotate(frame);
% subplot(2,3,[1 2 4 5]);imshow(tImg);
% 
% patch = ROI.getRoiImage(frame);
% subplot(2,3,3);imshow(patch,[]);
% 
% return

for h = 1:Video_Height
    roi1 = xRoi(ROI_Center(1), h, ROI_Width,ROI_Height);
    
    tImg = roi1.annotate(frame);
    subplot(2,3,[1 2 4 5]);imshow(tImg,[]);
    
    [patch, patchROI] = roi1.getRoiImage(frame);
    subplot(2,3,3);imshow(patch,[]);
    
    drawnow;
end