% code for extracting standardized RGB values from ROIs in images

% Sandra Winters <sandra.winters@helsinki.fi>
% updated 16 Jan 2025

%% Set current directory
cd XXX % SET CURRENT DIRECTORY TO THE FOLDER WHERE YOU HAVE THE CODE & IMAGES

% should contain a folder called 'original_images' that contains the raw images to process

%% Linearise images
LineariseImages_GoProHero10('original_images', ... %folder of original images 
                            'linearised_images') %folder to save linearised images

%% Measure color standards
MeasureMacbeths('linearised_images', ... %folder of linearised images
                'standard_results') %folder to save standard measurements

%   1. click on the center of the corner squares, in the order specified
%   2. inspect the plot of the achromatic measurements to make sure everything looks fine -- should be smoothly decreasing for all colors
%      (it's probably fine, click no)
%   3. repeat until all images are measured

%% Standardize images
StandardizeImages('linearised_images', ... %folder of linearised images
                  'standard_results', ... %folder of standard measurements
                  'standardized_images') %folder to save standardised images

%% Convert to anemonefish colorspace
TransformImages('standardized_images', ... %folder of standardised images
                'anemonefish_images', ... %folder to save transformed images
                'GoProHero10_Anemonefish') %transformation function

%% Add square root transformation
% Note: linear images look dark; if you want to generate images that look 
% better (e.g. for figures or just for easier screening), run: 
AddSqrt('anemonefish_images', ... %folder of linear images
        'anemonefish_images_sqrt') %folder to save nonlinear images

%% Measure RGB color in standardized images
MeasureColor('anemonefish_images', ... %folder of images to measure
             'roi_results') %folder to save color measurements

%   1. image pops up, drag cursor to select region to magnify
%      (select the general region of the image you're interested in marking)
%   2. double-click inside selected region
%   3. new window pops up, click start
%   4. click once to bring up crosshairs
%   5. click to add each new point to outline the region of interest
%   6. double-click for the final point, which will connect the region
%   7. drag points to modify ROI as necessary
%   8. when satisfied, click 'save & exit' (or click 'reset' to re-start from #3)
%   9. matlab is paused, press any key to continue
%   10. repeat until all images are marked

%% Compile, format, and export RGB data for measured ROIs
colorData = CompileFilesStruct('roi_results', ... %folder of results to compile
                               'roiData', ... %name of structure containing data
                               'meanRGB'); %name of variable(s) (structure fields) to compile
colorData.meanRGB = uint2double(colorData.meanRGB); %convert to 0-1 scale (so black = [0 0 0], white = [1 1 1]
colorData = splitvars(colorData,'meanRGB','newVariableNames',{'l','m','s'}); %split RGB values (just so it exports nicely)
writetable(colorData,'color_data.csv') %save to csv file

%% calculate JNDs
%add luminance channel
colorData.lum = (colorData.l + colorData.m)/2; % use average of m & l cones for luminance (e.g. doi.org/10.1038/s41598-019-52297-0; doi.org/10.3389/fncir.2014.00118; doi.org/10.1242/jeb.232090)

%set up table for results
jnds = table('Size', [(size(colorData,1)-1)*2 4], ... 
             'VariableTypes', {'string','string','double','double'}, ... 
             'VariableNames',{'patch1','patch2','chromaticJND','luminanceJND'});

%calculate JNDs
row = 0;
for p1 = 1:size(colorDat,1)
    for p2 = 1:size(colorDat,1)
        if p1~=p2
            row = row + 1;

            jnds.patch1{row} = colorData.filename{p1};
            jnds.patch2{row} = colorData.filename{p2};
            
            jnds.chromaticJND(row) = D_trichrom_anemonefish(colorData.s(p1), colorData.m(p1), colorData.l(p1), ... 
                                                            colorData.s(p2), colorData.m(p2), colorData.l(p2));
            jnds.luminanceJND(row) = D_lum_anemonefish(colorData.lum(p1), colorData.lum(p2));
        end
    end
end

%save to csv
writetable(jnds,'jnd_data.csv')

