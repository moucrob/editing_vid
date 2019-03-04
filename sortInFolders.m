clear all
clc

%%
% To use it, export the folder /tmp/vids in Videos ubuntu folder first
% Always let your database with that name and in Videos
% Otherwise, appropriately modify the path below
% 
% NOTE that vids weren't used : here I used vidsRRTC-RRTSunrestrOnlyMovements
% feel free to modify
%%

%%
% TODO : Erase the several runs per latest subfolder, by keeping the highest
% metric difference for the files in metric folderm, and best metric for the
% files outside (optimal planners)
%%

pathRead = '/home/exs/Videos/vidsRRTC-RRTSunrestrOnlyMovements/'; %char array
nameStore = 'iplanRvidsDatabase';
path = fullfile(pathRead,'..',nameStore);
if ~exist(path,'dir')
   mkdir(path)
end
files = dir(pathRead); %careful to the capital V in Videos
fileNames = {files.name}'; %all names are char array
fileNames(1:2) = [];
clear files;

filesStructCellArray = cell(0,1);
for i=1:numel(fileNames)
   stru = struct();
   stru.name = fileNames{i};
   
   splittedCellArray = strsplit(stru.name,'__');
   
   stru.jointStatus = splittedCellArray{1};
   countdownChar = splittedCellArray{2}
   stru.countdown = str2num(countdownChar(10:end));
   queryChar = splittedCellArray{3};
   stru.query = str2num(queryChar(12:end));
   stru.planner = splittedCellArray{4};
   stru.metric = splittedCellArray{5};
   metricValueChar = splittedCellArray{6};
   stru.value = str2num(metricValueChar(8:end));
   if numel(splittedCellArray) == 7
       runChar = splittedCellArray{7};
       stru.run = str2num(runChar(5:end-4));
   else %numel(splittedCellArray) == 8
       acceptanceChar = splittedCellArray{7};
       stru.acceptance = acceptanceChar(12:end);
       runChar = splittedCellArray{8};
       stru.run = str2num(runChar(5:end-4));
   end
   
   filesStructCellArray{i,1} = stru;
   
   
   source = [pathRead,filesStructCellArray{i}.name]
   if numel(splittedCellArray) == 6
       destinationElems = {filesStructCellArray{i}.metric,...
                           filesStructCellArray{i}.jointStatus,...
                           filesStructCellArray{i}.planner,...
                           ['query',num2str(filesStructCellArray{i}.query)],... %num2str actually converts to char array
                           ['timeout',num2str(filesStructCellArray{i}.countdown)]};     
   else %numel(splittedCellArray) == 7
       destinationElems = {filesStructCellArray{i}.metric,...
                           filesStructCellArray{i}.jointStatus,...
                           filesStructCellArray{i}.acceptance,...
                           filesStructCellArray{i}.planner,...
                           ['query',num2str(filesStructCellArray{i}.query)],... %num2str actually converts to char array
                           ['timeout',num2str(filesStructCellArray{i}.countdown)]};
   end
   
   toMaybeCreate = destinationElems;
   pathIter = path;
   for j=1:numel(toMaybeCreate)
       pathIter = fullfile(pathIter, toMaybeCreate{j});
       if ~exist(pathIter,'dir')
           mkdir(pathIter)
       end
   end
   
   destination = fullfile(pathIter,filesStructCellArray{i}.name)
   
   if exist(destination) ; rm destination ; end
   
   movefile(source,destination)
end