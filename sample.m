% sample.m is developed by Quanshi Zhang and used to read RGBD images.
% This RGBD object dataset is for non-commercial research/educational use only.
% Please cite the following paper if you use this dataset:
% Category Modeling from just a Single Labeling: Use Depth Information to Guide the Learning of 2D Models
% Quanshi Zhang, Xuan Song, Xiaowei Shao, Huijing Zhao, and Ryosuke Shibasaki
% In IEEE International Conference on Computer Vision and Pattern Rcognition (CVPR), 2013.

% Decompress the data files to the directory .//data
% The '.jpg' file is the original RGB image with size of 480X640.
% The '.csv' file is a matrix with size of 480X1920, indicating the 3D
% coordinates of each pixel in the '.jpg' file. The unit is centimeter.
% The format of the '.csv. file is
% [X11,Y11,Z11,X12,Y12,Z12,...,X1n,Y1n,Z1n;
% X21,Y21,Z21,X22,Y22,Z22,...,X2n,Y2n,Z2n;
% .........Xmn,Ymn,Zmn]
% This is the average measurement of 100 static frames. Coordinate Z
% indicates the depth.
% Note that the RGB image is a bit larger than the RGBD image in data
% collection due to the hardware design of the Kinect sensor. Therefore,
% the meansurement values in the edges of the RGBD images are 0.

function sample

FileName='box1';
img=imread(sprintf('..//data//%s.jpg',FileName));
figure;
imshow(img);
RGBD=csvread(strcat(strcat('..//data//',FileName),'.csv'));
DepthImage=RGBD(:,3:3:size(RGBD,2));
DepthImage=medfilt2(DepthImage,[7,7]); % reduce "peper & salt" noise
showCldDepth(DepthImage); % Only show the depth data in a selected range for clarity


function showCldDepth(CldDepth)
% set different values for DepthLimit to show objects in different ranges.
%DepthLimit=300;
DepthLimit=150;
%DepthLimit=80;

CldDepth=CldDepth-min(min(CldDepth(CldDepth>0)));
CldDepth(CldDepth>DepthLimit)=0;
CldDepth(CldDepth<0)=0;
[h,w]=size(CldDepth);
ColorImg=ones(h,w,3).*255;
figure;
CM=colormap('jet');
tmp=ones(h,w).*255;
tmp(CldDepth>0)=CM(ceil(CldDepth(CldDepth>0)./DepthLimit.*64),1).*255;
ColorImg(:,:,1)=tmp;
tmp(CldDepth>0)=CM(ceil(CldDepth(CldDepth>0)./DepthLimit.*64),2).*255;
ColorImg(:,:,2)=tmp;
tmp(CldDepth>0)=CM(ceil(CldDepth(CldDepth>0)./DepthLimit.*64),3).*255;
ColorImg(:,:,3)=tmp;
imshow(uint8(ColorImg));
