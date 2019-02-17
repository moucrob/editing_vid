% https://www.mathworks.com/matlabcentral/answers/48797-how-to-extract-frames-of-a-video#answer_59652
% https://www.mathworks.com/help/matlab/examples/convert-between-image-sequences-and-video.html
clc

%% inputs :
videoFileName = 'testvid.mp4';
videoFileName2 = [videoFileName(1:end-4),'Reduced.mp4'];

%% temporary folder
workingDir = 'tempFolder';
allFramesDir = 'allFrames';
movesFramesDir = 'movesFrames';

if exist(workingDir, 'dir')
	warningMessage = sprintf('The %s folder already exists! Press ok for deleting, or cancel.', workingDir);
	uiwait(warndlg(warningMessage));
  rmdir(workingDir, 's')
end

mkdir(workingDir)
mkdir(workingDir,allFramesDir)
mkdir(workingDir,movesFramesDir)

%% Remove the duplicate frames, as OCR will take a hell lot of time
% OCR takes 30sec when shell overlap the recording area SO BE CAREFUL
% 1.5sec otherwise when there is only RViz text
if ~exist(videoFileName2,'file')
  command = sprintf(['ffmpeg -i %s', ...
                     ' -vf mpdecimate,setpts=N/FRAME_RATE/TB', ...
                     ' %s'], videoFileName, videoFileName2)
  [status,cmdout] = system(command)
end

%% Convert the vid in a bunch of frame allFrames
shuttleVideo = VideoReader(videoFileName2);
k = 1;
while hasFrame(shuttleVideo)
	disp(['k = ',num2str(k)])
  
  img = readFrame(shuttleVideo);
  
  frameName = [sprintf('%07d',k) '.png'];
  fullName = fullfile(workingDir,allFramesDir,frameName);
  imwrite(img,fullName, ...
          'BitDepth',16,'Compression','none','Mode','lossless')
    
% 	thisfig = figure() ; thisax = axes('Parent', thisfig);
% 	image(this_frame, 'Parent', thisax);
% 	title(thisax, sprintf('Frame #%d', k)) ;
%   pause(2)

  k = k+1; 
end

%% Convert the bunch into a cell array
imageNames = dir(fullfile(workingDir,allFramesDir,'*.png'));
imageNames = {imageNames.name}';

%% To perhaps do later: %TODO
% Remove the frames containing "GreenRecorder" and all that do not contain
% both "plan computation countdown" and "start/goal joint configuration"

%% Remove the frames/queries where there is no move at all
% See which frame contains "(metric)" or "%" and keep+name them accordingly
% to the query
pattern = "vancy";
% "%" keeps definitely ONLY the frames containing the shell and doesn't recognize at all the move frames! Strange...
% "metrics" is always read "mama" by their algo unfortunately... see output
% below:
m = 1;
for j = 1:numel(imageNames)
  disp(['j = ',num2str(j)])
  img = imread( fullfile(workingDir,allFramesDir,imageNames{j}) );
  tic
  ocrResults = ocr(img);
  t1 = toc ; disp(['OCR took ',num2str(t1),' sec'])
  txtExtracted = ocrResults.Text; %1xN char array
  disp(txtExtracted)
  
% % % ac:Ep|arIcE(t) 7 wt
% % % tzm expeumem vephca)
% % % re\evancy (mama) :
% % % '1 r “ w m
% % % Versus
% % % 
% % % plan campulallun cmmmawn T : monuuo sec
% % % smnlgnm mm: conng-muons : Aquery 'RANnoM,pose35‘)
% % % (vmm base Amp at the M50 [0 wnsl)
% % % 71233330 / $157430 rad
% % % .1 543350 1 .2 azsszau van
% % % 0.175294 / —2.12327u van
% % % .2 125950 / u eaasm rad
% % % 0035732 / sasasoa rad
% % % 1145450 / 4242129 ma
  
  tic
  idxOccur = strfind(string(txtExtracted),string(pattern));
  disp(['idxOccur = ',num2str(idxOccur)])
  t2 = toc ; disp(['String search took ',num2str(t2),' sec'])
  if ~isempty(idxOccur) %keep the image
    imgName = [sprintf('%07d',m) '.png']; m = m+1;
    imwrite(img,fullfile(workingDir,movesFramesDir,imgName), ...
            'BitDepth',16,'Compression','none','Mode','lossless')
  end
end

%% Name the kept move-associated frames accordingly to the query+run


%% Remove the dead times after the moves


%% Create New Video with the Image Sequence
% outputVideo = VideoWriter(fullfile(workingDir,'shuttle_out.avi')); %no mp4 under linux :'(
% %https://www.mathworks.com/matlabcentral/answers/143051-how-to-write-a-mp4-video-using-vision-toolbox
% outputVideo.FrameRate = shuttleVideo.FrameRate;
% outputVideo.Quality = 100;
% 
% open(outputVideo)
% for i = 1:length(imageNames)
%   disp(['i = ',num2str(i)])
% 	img = imread(fullfile(workingDir,allFramesDir,imageNames{i}));
%   img=im2double(img); %otherwise IMG must be of one of the following classes: double, single, uint8
% 	writeVideo(outputVideo,img)
% end
% close(outputVideo)