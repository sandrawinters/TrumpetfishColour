function [RGB avRGB stdRGB crop_area binaryImage maskedTIFFcrop flag] = mark_faces(face_path,gamma)

warning('off', 'Images:initSize:adjustingMag');

addpath('PRG')

% %get the photo info
% EXIF = imfinfo(face_path);      
% info.ISOVal = EXIF.DigitalCamera.ISOSpeedRatings;
% info.ApertureVal = EXIF.DigitalCamera.FNumber;
% info.FocalVal = EXIF.DigitalCamera.FocalLength;
% info.ITVal = EXIF.DigitalCamera.ExposureTime;
% info.date = EXIF.DateTime;

%read the image in
TIFFim = imread(face_path);

H = vision.GammaCorrector; %create gamma function
if gamma==1
    gTIFFim = step(H, TIFFim);%apply gamma correction to aid visualisation
else
    gTIFFim = TIFFim;
end
    
figure;
title(face_path)
[gTIFFcrop,crop_area] = imcrop(gTIFFim);

%get the same crop from the linear tiff
TIFFcrop = imcrop(TIFFim, crop_area);

%clear big vars - no longer needed
clear TIFFim gTIFFim
close all

%save crop temporarily - this is a bit of a hackky way of getting the
%data to the PRG function
save 'temp.mat' gTIFFcrop face_path

%trace out the red patch outline.
prg

pause 

% %create a mask
load temp_res % again a hack to get the data from the PRG function

flag = flag;

binaryImage = poly2mask(xy(:,1), xy(:,2), size(TIFFcrop,1),size(TIFFcrop,2));

[maskedTIFFcrop RGB] = mask_crops(TIFFcrop, binaryImage);%could eliminate the maskedTIFFcrop calculation for speed

% figure;
%imshow(maskedTIFFcrop); %have confirmed it all works - don't need this
%check

%convert to double before finding averages
RGB = double(RGB);

%find the average RGB
avRGB = mean(RGB);
%find the std_dev
stdRGB = std(RGB);
%delete temporary variables
delete('temp.mat','temp_res.mat');

close all



