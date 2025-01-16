function [] = MeasureMacbeths(imDir,resDir,gammaVis,zoom)
%Measures the color patches of Macbeth color standards
%   Presents all images in a folder for user to mark corner patches of 
%   standards. Data saved in .mat files in resDir. gammaVis = 1 (default)
%   adds gamma correction to images for visualization (measurements taken
%   from non-corrected image). zoom = 1 (default = 0) adds a cropping step
%   to allow the user to zoom in on the standard within the image (in this 
%   case, the user clicks are saved relative to the crop). 
%   NOTE CHANGE IN PATCH ORDER IMPLEMENTED SEPT 2020
%
%   INPUT
%   imdir (string): folder containing images to be measured (asks if not provided)
%   resDir (string): folder where .mat result files will be saved (asks if not provided)
%   gammaVis (boolean): add gamma correction? (default = 1)
%   zoom (boolean): crop to standard before measuring? (default = 0)
%
%   OUTPUT
%   n/a
%
%   CREATES
%   .mat files for each image (named <image_name>_macbethResults.mat, saved in resDir); each contain structure called macbeth:
%       macbeth.image (string): image filename
%       macbeth.RGB (n pixels x 3 matrix): R, G, B values (in columns) of all pixels in each patch
%       macbeth.meanRGB (vector): mean RGB values; format [R G B]
%       macbeth.sdRGB (vector) standard deviation of RGB values; format [R G B]
%       macbeth.flag (boolean): flag (0 or 1)
%       macbeth.clicks (matrix): matrix denoting x,y locations of clicks (on white, black, brown, cyan)
%       macbeth.crop (vector): crop rectangle (see imcrop)
%       macbeth.order (string): 'brown>cyan>white>balck' -- notes order of color patches in results for downstream verification
%
%   RELIES ON
%   MeasureMacbeth.m
%   divideLine.m
%
%   Sandra Winters <sandra.winters@helsinki.fi>
%   updated 25 Feb 2021

%% check args & set defaults
if nargin<1
    imDir = uigetdir('','Select folder of images'); 
end
if isfolder(imDir)==0
    error('Image directory does not exist')
end

if nargin<2
    resDir = uigetdir('','Select folder of results');
end
if isfolder(resDir)==0
    mkdir(resDir)
end

if nargin<3
    gammaVis = 1;
end

if nargin<4
    zoom = 0;
end

if ispc==1
    folderDelim = '\';
else
    folderDelim = '/';
end

ext = '.JPG';

%% get list of images in image directory
images = dir([imDir folderDelim '*' ext]);
images = {images.name};

%% run through images, skipping those that are already done
for i = 1:length(images)
    if exist([resDir folderDelim strrep(images{i},ext,'_macbethResults.mat')],'file')==0
        %measure standard
        im = imread([imDir folderDelim images{i}]);
        
        macbeth.image = images(i);
        
        [macbeth.patchRGB, ... 
         macbeth.meanRGB, ... 
         macbeth.sdRGB, ... 
         macbeth.medianRGB, ... 
         macbeth.flag, ... 
         macbeth.clicks, ...
         macbeth.crop] = MeasureMacbeth(im,gammaVis,zoom);
        
        macbeth.order = 'brown>cyan>white>black'; %note order for error checking; hopefully things don't get too fucked up...
        
        save([resDir folderDelim strrep(images{i},ext,'_macbethResults.mat')], 'macbeth');
        
        close all

        if i == length(images)
            msgbox('Congratulations! You have finished meauring all standards.','Done','modal');
        else
            resp = questdlg('Next image?','Continue','Yes','Exit','Yes');

            if strcmp(resp,'Exit')
                return
            end
        end
    end
end

%% changelog
% 27 Jan 2023
% changed ext to .JPG
