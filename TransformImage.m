function [imTrans] = TransformImage(im,fun,lum)
%Transforms image between color spaces using specified mapping function
%
%   INPUT
%   im (matrix): image to transform
%   fun (string): name of function to transform image (function should be on path)
%   lum (boolean): generate luminance image? (0 = no, 1 = yes; default = 0)
%       0 - generates LMS image
%       1 - generates luminance image
%       note: luminance image will only work if the transformation function is designed to return this as a second variable
%   
%   OUTPUT
%   imTrans (matrix): transformed LMS image (double level precision)
%       if lum==0 will return m x n x 3 LMS image
%       if lum==1 will return m x n x 1 luminance image
%
%   CREATES
%   n/a
%
%   RELIES ON
%   function specified in 'fun' argument
%
%   Sandra Winters <sandra.winters@bristol.ac.uk>
%   last updated 03 Jun 2020

%% check args & set defaults
% get variables
if nargin<1
    [imName,path] = uigetfile('.tiff','Select image to transform');
    im = imread([path imName]);
    clear imName path
end
if nargin<2
    [fun,path] = uigetfile('.m','Select image transformation function');
    addpath([path fun])
    fun = strrep(fun,'.m','');
    clear path
end
if nargin<3
    lum = 0;
end

%check variables
if exist([fun '.m'],'file')~=2
    error('Image transformation function does not exist on current path')
end

im = uint2double(im);

%% transform image
dims = size(im);

px = reshape(im,[],3);

if lum==1
    [~,pxTrans] = feval(fun,px);
    imTrans = reshape(pxTrans,[dims(1) dims(2) 1]);
else
    pxTrans = feval(fun,px);
    imTrans = reshape(pxTrans,dims);
end

