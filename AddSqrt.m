function [] = AddSqrt(origDir,newDir,overwrite)
% Adds square root transformation to folder of images
%
%   INPUT
%   origDir (string): folder containing images to process (asks if not included)
%   newDir (string): folder where processed images will be saved (asks if not included)
%   overwrite (boolean): overwrite existing files? (0=no, 1=yes; default=0)
%
%   OUTPUT
%   n/a
%
%   CREATES/SAVES
%   processed images (saved in newDir)
%
%   RELIES ON
%   uint2double.m
%
%   Sandra Winters <sandra.winters@helsinki.fi>
%   updated 14 Oct 2020

%% check args & set defaults
if nargin<1
    origDir = uigetdir(cd,'Select directory of original images');
end
if nargin<2
    newDir = uigetdir(origDir,'Select directory to save transformed images');
end
if nargin<3
    overwrite=0;
end

if exist(origDir,'dir')==0
    error([origDir ' is not a folder'])
end
if exist(newDir,'dir')==0
    mkdir(newDir)
end

if ispc==1
    folderDelim = '\';
else
    folderDelim = '/';
end

ext = '.jpg';

%% get images
ims = dir([origDir folderDelim '*' ext]);

if isempty(ims)
    error(['No ' ext ' images in ' origDir])
end

%% add gamma, & save
for i = 1:size(ims,1)
    if exist([newDir folderDelim ims(i).name],'file')==0 || overwrite==1
        im = uint2double(imread([ims(i).folder folderDelim ims(i).name]));
        imwrite(real(sqrt(im)),[newDir folderDelim ims(i).name])
    end
end
