function [] = LineariseImages_GoProHero10(imDir,saveDir)
%Linearises images from a GoProHero10
%   Linearisation generated based on YE1.jpg using MICA Toolbox: Troscianko 
%   & Stevens 2015 Methods Ecol Evol
%
%   INPUT
%   imDir (string): folder containing images to linearise
%   saveDir (string): folder where linearised images will be saved
%
%   OUTPUT
%   n/a
%
%   CREATES
%   linearised images saved in saveDir
%   
%   RELIES ON
%   n/a
%   
%   Sandra Winters <sandra.winters@helsinki.fi>
%   updated 10 Feb 2023

% from MICA: 
% equation=[JT Linearisation] a=218.098078967 b=10.230653553 c=0.000828068 d=0.003482500 slice=1
% equation=[JT Linearisation] a=221.330328765 b=9.128527373 c=0.000795581 d=-0.000487464 slice=2
% equation=[JT Linearisation] a=219.458303702 b=9.561678097 c=0.000869492 d=-0.011391363 slice=3
% JT Linearisation function: y =x*x*c +x*d + exp((x-a)/b)

%% 
if isfolder(saveDir)==0
    mkdir(saveDir)
end

%% linearisation coefficients 
coef = [218.098078967 10.230653553 0.000828068 0.003482500; ... %a,b,c,d for R
        221.330328765 9.128527373 0.000795581 -0.000487464; ... %a,b,c,d for G
        219.458303702 9.561678097 0.000869492 -0.011391363]; %a,b,c,d for B

%% get list of images
imExt = '.jpg';
ims = dir(fullfile(imDir,['*' imExt]));

%% linearise each image
for i = 1:length(ims)
    %get image
    im = double(imread(fullfile(imDir,ims(i).name)));

    %run linearisation function
    imLin = nan(size(im));
    for slice = 1:3
        imLin(:,:,slice) = (im(:,:,slice).*im(:,:,slice).*coef(slice,3)) + (im(:,:,slice).*coef(slice,4)) + exp((im(:,:,slice)-coef(slice,1))/coef(slice,2));
    end

    %save image
    imwrite(uint8(imLin),fullfile(saveDir,ims(i).name));
end

end %function