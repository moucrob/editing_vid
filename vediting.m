% https://www.mathworks.com/matlabcentral/answers/48797-how-to-extract-frames-of-a-video#answer_59652
% https://www.mathworks.com/help/matlab/examples/convert-between-image-sequences-and-video.html
clc

%% inputs :
videoFileName = 'testvid.mp4';

%% temporary folder
workingDir = 'tempFolder';

if exist(workingDir, 'dir')
	warningMessage = sprintf('The %s folder already exists! Press ok for deleting, or cancel.', workingDir);
	uiwait(warndlg(warningMessage));
  rmdir(workingDir, 's')
end

mkdir(workingDir)
mkdir(workingDir,'images')

%% Convert the vid in a bunch of frame images
shuttleVideo = VideoReader(videoFileName);
k = 1;
while hasFrame(shuttleVideo)
	k = k+1; disp(['k = ',num2str(k)])
  
  img = readFrame(shuttleVideo);
  
  frameName = [sprintf('%07d',k) '.png'];
  fullName = fullfile(workingDir,'images',frameName);
  imwrite(img,fullName, ...
          'BitDepth',16,'Compression','none','Mode','lossless')
    
% 	thisfig = figure() ; thisax = axes('Parent', thisfig);
% 	image(this_frame, 'Parent', thisax);
% 	title(thisax, sprintf('Frame #%d', k)) ;
%   pause(2)
end

%% Convert the bunch into a cell array
imageNames = dir(fullfile(workingDir,'images','*.png'));
imageNames = {imageNames.name}';

disp(numel(imageNames)) %debug

%% Create New Video with the Image Sequence
outputVideo = VideoWriter(fullfile(workingDir,'shuttle_out.avi')); %no mp4 under linux :'(
%https://www.mathworks.com/matlabcentral/answers/143051-how-to-write-a-mp4-video-using-vision-toolbox
outputVideo.FrameRate = shuttleVideo.FrameRate;
outputVideo.Quality = 100;

open(outputVideo)
for i = 1:length(imageNames)
  disp(['i = ',num2str(i)])
	img = imread(fullfile(workingDir,'images',imageNames{i}));
  img=im2double(img); %otherwise IMG must be of one of the following classes: double, single, uint8
	writeVideo(outputVideo,img)
end
close(outputVideo)