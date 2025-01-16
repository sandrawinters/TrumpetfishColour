function [] = TransformImages(origDir,newDir,fun,append,lum,overwrite)
%Transforms a folder of .tiff images from RGB to LMS color space using specified mapping function
%   
%   INPUT
%   origDir (string): folder containing .tiff images to transform (asks if not provided)
%   newDir (string): folder where transformed images will be saved (asks if not provided)
%   fun (string): name of function to transform RGB to LMS (must be in current path; asks if not provided)
%   append (string): text to append to file names when saving new images (default='')
%   lum (boolean): generate luminance image? (0 = no, 1 = yes; default = 0)
%       0 - generates LMS image
%       1 - generates luminance image
%       note: luminance image will only work if the transformation function is designed to return this as a second variable
%   overwrite (boolean): overwrite existing files? (0 = no, 1 = yes; default = 0)
%   
%   OUTPUT
%   n/a
%
%   CREATES
%   transformed images (saved in newDir)
%
%   RELIES ON
%   TransformImage.m
%   uint2double.m
%   function specified in 'fun' argument
%
%   Sandra Winters <sandra.winters@bristol.ac.uk>
%   las updated 03 Jun 2020

%% check args & set defaults
%set variables
if nargin<1
    newDir = uigetdir(cd,'Select directory to save transformed images');
end
if nargin<2
    origDir = uigetdir(cd,'Select directory of images to transform');
end
if nargin<3
    [fun,path] = uigetfile('.m','Select image transformation function');
    addpath([path fun])
    fun = strrep(fun,'.m','');
    clear path
end
if nargin<4
    append = '';
end
if nargin<5
    lum = 0;
end
if nargin<6
    overwrite=0;
end    

%check variables
if isfolder(origDir)==0
    error([origDir ' does not exist'])
end
if isfolder(newDir)==0
    mkdir(newDir)
end
if exist([fun '.m'],'file')~=2
    error('Image transformation function does not exist on current path')
end
if ischar(append)==0
    error('Text to append to image names must be a character vector')
end

%defaults
if ispc
    foldDelim = '\';
else
    foldDelim = '/';
end

imExt = '.JPG';

%% transform images
ims = dir([origDir foldDelim '*' imExt]);
for i = 1:length(ims)
    if exist([newDir foldDelim strrep(ims(i).name,imExt,[append imExt])],'file')==0 || overwrite==1
        imOrig = imread([origDir foldDelim ims(i).name]);
        imOrig = uint2double(imOrig);

        imTrans = TransformImage(imOrig,fun,lum);
        imwrite(imTrans,[newDir foldDelim strrep(ims(i).name,imExt,[append imExt])])
    end
end