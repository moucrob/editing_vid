%% https://www.mathworks.com/help/vision/ug/train-optical-character-recognition-for-custom-fonts.html
% It exists an OCR trainer which seems to be able to speed up the process
% by taking the character set of all the ones that may occur in the real
% life and that has to be recognized so let's do that list:
clc

possible = ["acceptance(t) = 1-t/T exp", ...
            "(th experiment replica)", ...
            "relevancy energy (metric)", ...
            "TRRT star PRM EST Connect", ...
            "wrapped Versus. kConfigDefault %", ...
            "plan computation countdown T = . sec", ...
            "start/goal joint configurations + angle limits : ", ...
            "'(query 'RANDOM_pose')", ...
            "-0123456789. / rad min max :"
           ];

charArr = [];
for i=1:numel(possible)
  charArr = [charArr,char(possible(i))];
end

list = [];
for i=1:numel(charArr)
  if ~ismember(charArr(i),list)
    %list(end+1) = charArr(i); %doesn't work
    list = [list,charArr(i)];
  end
end
list

%% remove the " ' ", as the trainer wants a list 'dfhjehuj' with delimiters in input
i=1
while i <= numel(list)
  if strcmp("'",string(list(i)))
    list(i)='';
  end
  i = i+1;
end
list