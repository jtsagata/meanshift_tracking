%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PARTICLE FILTER TRACKING
% ================================

%%%%%%%%%%%%%%%
% AUTHORS  : Desiré Sidibé 
% DATE     : January 5th 2010
% Modified : February 5th 2010
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

%% INITIALIZATION
%=================
% Read image sequence
imPath = 'car'; imExt = 'jpg';

% check if directory and files exist
if exist(imPath, 'dir') ~= 7
    error('ERROR USER: The image directory does not exist');
end

filearray = dir([imPath filesep '*.' imExt]); % get all files in the directory
NumImages = size(filearray,1); % get the number of images
if NumImages < 0
    error('No image in the directory');
end

%NumImages = 10;
disp('Loading image files from the video sequence, please be patient...');
imgname = [imPath filesep filearray(1).name];
I = imread(imgname);
VIDEO_WIDTH = size(I,2);
VIDEO_HEIGHT = size(I,1);
ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, NumImages);

for i=1:NumImages
    imgname = [imPath filesep filearray(i).name];
    ImSeq(:,:, i) = imread(imgname);
end
disp(' ... OK!');

%% Create a figure we will use to display the video sequence
clf; figure(1); set(gca, 'Position', [0 0 1 1]);
imshow(ImSeq(:,:, 1), []);

%% Because we don't have an automatic detection method to initialize the
%% tracker, we will do it by hand. A GUI interface allows us to select a 
%% bouding box from the first frame of the sequence.
display('Initialize the bounding box by cropping the object.');
[patch bB] = imcrop();
bB = round(bB);
disp(' ... OK!');

%% INITIAL STATE AND PARTICLES
%=============================

%% Fill the initial state vector with our hand initialization
% The state here is the position of the center of the bounding box!
x_init = round([bB(1)+bB(3)/2, bB(2)+bB(4)/2]); 

%% Show the initial state vector on the image
figure(1), imshow(ImSeq(:,:, 1), []); hold on;
plot(x_init(1), x_init(2), 'ro'); 
hold off;

%% Initialization of the color model
% We initialize the color model as the color histogram of the detected ROI
% (so we need the size of the ROI)
% Nbins = ;
% imPatch = ;
% ColorModel = color_distribution(imPatch, Nbins); % you need extract impatch first

%% Initial Set of Particles
N = 200;    % number of particles
xp = zeros(N,length(x_init));

% Here we generate the set of particle
sig_x = 10;
sig_y = sig_x;
for i = 1:N
    xp(i,:) = round( x_init + ([sig_x sig_y].^2).*randn(1,length(x_init)) );
end

% check for the particles
figure(2); imshow(ImSeq(:,:,1), []); hold on;
for i=1:N
   % show the i-th particle
   plot(xp(i,1), xp(i,2), 'bx');
end

%show the mean of all particles
hold off;


%=================
% TRACKING
%=================
xpPred = xp;
w = zeros(1,N);

% for t=2:NumImages
% %    disp(['image number : ' num2str(t)]);
%     % load the current image and display it in the figure
%     I = ImSeq(:,:,t);
% 
%     figure(2); imshow(I);
%     
%     % Prediction step: We use the transition prior as proposal.
%     for i=1:N
%         xpPred(i,:) = round( xpPred(i,:) + ([sig_x sig_y].^2).*randn(1,length(x_init)) );
%     end
%     
%      % Evaluate Importance Weights
%     for i=1:N  
%         % for each particle xpPred(i,:) do:
%         % - extract a ptach around xpPred(i,:)
%         % - compute color distribution
%         % - compute batt. coeff
%         % - compute weight w(i)
%       % w(i) = ; 
%     end
%     w = w./sum(w);      % Normalise the weights.        
%     
%     % Selection Step: Resampling  
%     outIndex = residualR(1:N, w');       % Residual resampling.
%     xp = xpPred(outIndex, :); % Keep particles with resampled indices.                 
%     
%     x_estimate = w*xp;
%     xpPred = round(xp);
%     x_estimate = round(x_estimate);
%     
%     % show the estimated location 
%         
%     %% allow the figure to refresh so we can see our results
%     pause(0.01); refresh;    
% end
%  









