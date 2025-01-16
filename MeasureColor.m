function [] = MeasureColor(imDir,resDir,gamma)
%Measures color from user-selected regions of images
%
%   INPUT
%   imdir (asks if not provided): folder containing images to be measured
%   resDir (asks if not provided): folder where .mat result files will be saved
%   gamma (optional, default=1): add gamma correction for visualization? (1=yes, 0=no) (note: *only* for visualization, does not influence recorded data)
%
%   OUTPUT
%   n/a
%
%   CREATES
%   .mat files containing results for each image (named *image_name*_roiData.mat, saved in resDir)
%       roiData.image: image filename
%       roiData.RGB: RGB measurements from ROI
%       roiData.meanRGB: mean RGB
%       roiData.stdRGB: standard deviation of RGB
%       roiData.crop_area: area of cropped region (see doc imcrop, argument rect)
%       roiData.crop_mask: binary mask denoting ROI location in crop
%       roiData.mask: binary image denoting ROI location in full image
%       roiData.flag: flag (0 or 1)
%
%   RELIES ON
%   mark_faces.m
%   mask_crops.m
%   prg folder & contents
%
%   Sandra Winters <sandra.winters@helsinki.fi>
%   based on code from Will Allen
%   updated 27 Jan 2023

%% check args & set defaults
if nargin<1
    imDir = uigetdir('','Select folder of images');
end
if nargin<2
    resDir = uigetdir('','Select folder of results');
end
if nargin<3
    disp('adding gamma correction for visualization')
    gamma = 1;
end

if isfolder(imDir)==0
    error(['ERROR from MeasureColor: ' imDir ' is not a folder'])
end
if isfolder(resDir)==0
    mkdir(resDir)
end

ext = '.JPG';

%% get list of images in image directory
if ispc
    foldDelim = '\';
else
    foldDelim = '/';
end

images = dir([imDir foldDelim '*' ext]);
images = {images.name};

if isempty(images)
    error(['No ' ext ' images in ' imDir])
end

%% measure images
%run through images, skipping those that are already done
for i = 1:length(images)
    if exist([resDir foldDelim strrep(images{i},ext,'_roiData.mat')],'file')==0
        roiData.image = images{i};
        %run the face marking script
        [roiData.RGB, ...
            roiData.meanRGB, ...
            roiData.stdRGB, ...
            roiData.crop_area, ...
            roiData.crop_mask, ...
            ~, ...
            roiData.flag] = mark_faces([imDir foldDelim images{i}],gamma);
        
        %quick & dirty hack to get full image mask...
        im = imread([imDir foldDelim images{i}]);
        crop_area = round(roiData.crop_area);
        roiData.mask = false(size(im,1),size(im,2));
        roiData.mask(crop_area(2):crop_area(2)+size(roiData.crop_mask,1)-1, ...
                           crop_area(1):crop_area(1)+size(roiData.crop_mask,2)-1) = roiData.crop_mask;
        clear im

        % TODO make ^ less shitty

        %put the data into a structure
%         data{1,1} = images(i);
%         data{1,2} = RGB;
%         data{1,3} = avRGB;
%         data{1,4} = stdRGB;
%         data{1,5} = crop_area;
%         data{1,6} = binaryImage;
%         data{1,7} = maskedTIFFcrop;
%         data{1,8} = flag;

        %save the files
        save ([resDir foldDelim strrep(images{i},ext,'_roiData.mat')], 'roiData');

        %ask if want to continue
        if i == length(images)
            msgbox('Congratulations! You have finished meauring all images.','Done','modal');
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
% changed ext to .JPG for Sam's images
