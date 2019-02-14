% https://www.mathworks.com/matlabcentral/answers/48797-how-to-extract-frames-of-a-video#answer_59652
FileName = 'testvid.mp4';
obj = VideoReader(FileName);
k = 0;
while hasFrame(obj)
    k = k+1;
    this_frame = readFrame(obj);
  thisfig = figure() ; thisax = axes('Parent', thisfig);
  image(this_frame, 'Parent', thisax);
  title(thisax, sprintf('Frame #%d', k)) ;
end
