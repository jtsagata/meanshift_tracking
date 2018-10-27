clc
clearvars
close all

%% read images
imPath = '../Data/car'; imExt = 'jpg';

%%%%% LOAD THE IMAGES
%=======================
% check if directory and files exist
if isdir(imPath) == 0
    error('USER ERROR : The image directory does not exist');
end

filearray = dir([imPath filesep '*.' imExt]); % get all files in the directory
NumImages = size(filearray,1); % get the number of images
if NumImages < 0
    error('No image in the directory');
end

disp('Loading image files from the video sequence, please be patient...');
% Get image parameters
imgname = [imPath filesep filearray(1).name]; % get image name
I = imread(imgname);
VIDEO_WIDTH = size(I,2);
VIDEO_HEIGHT = size(I,1);

ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, NumImages);
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; % get image name
    ImSeq(:,:,i) = imread(imgname); % load image
end
disp(' DATA LOADING ... OK!');

disp(' PICK A REGION');
[patch, rect] = imcrop(ImSeq(:,:,1)./255);
ROI_Center = round([rect(1)+rect(3)/2 , rect(2)+rect(4)/2]); 
ROI_Width = round(rect(3));
ROI_Height = round(rect(4));
disp(' PICK A REGION ... OK!');

Video = ImSeq ./255;
[Video_Height,Video_Width,NumFrames] = size(Video);

disp(' SAVING DATA');


save("cars.mat", 'Video','ROI_Center','ROI_Width','ROI_Height',...
    'Video_Height','Video_Width','NumFrames', '-v7.3');
disp(' SAVING DATA ... OK!');
whos('-file','cars.mat')

