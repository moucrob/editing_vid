%% https://www.mathworks.com/matlabcentral/answers/48721-how-to-extract-the-region-of-interest
grayImage = imread('pout.tif');
imshow(grayImage);
h = imrect;
position = wait(h);
croppedImage = imcrop(grayImage, position);
figure;
imshow(croppedImage);
