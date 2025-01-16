function [lms,lum] = GoProHero10_Anemonefish(rgb)
%Converts from Nikon D3200 RGB color space to blackbird LMS (no UV) color space
%   Converts from RGB to LMS & LUM ((L+M)/2) using chart-based 
%   cone-catch model generated in MICA (see details below). Barrier Reef 
%   anemonefish (Amphiprion akindynos) visual system based on Stieb et al. 
%   2019 Sci Rep 
%
%   INPUT:
%   rbg (matrix): rgb triplets (n pixels x 3)
%   
%   OUTPUT:
%   lms (matrix): lms triplets (double precision, n pixles x 3)
%   lum (matrix): luminance values based on (L+M)/2 (double precision, n pixels x 1)
%   
%   CREATES: 
%   n/a
%
%   RELIES ON: 
%   uint2double.m
%
%   Mapping based on polynomial transform calculated using MICA ImageJ toolbox (Troscianko & Stevens 2015 Methods Ecol Evol) based on following parameters: 
%   X-rite Passport standard measured from image: YE1.JPG (after linearization & standardization)
%   Barrier Reef anemonefish (Amphiprion akindynos) LMS spectral sensitivities, visual system data from Stieb et al. 2019 Sci Rep doi.org/10.1038/s41598-019-52297-0: 
%           visual pigment lambda max: lw = 541, mw = 520, sw = 498
%           ocular media transmission spectra digitally extracted from fig 1b
%   D65 illuminant (400-700nm)
%   Interaction levels = 2, polynomial levels = 1 (i.e. r + g + b + rg + rb + gb)
%   Model R^2 values:
%       lw 0.9871302827430574
%       mw 0.9866941572221286
%       sw 0.9838640893325971



%% check args & set defaults
if nargin<1
    error('no rgb values provided')
end

rgb = uint2double(rgb);

%% transform RGB --> LMS
r = rgb(:,1);
g = rgb(:,2);
b = rgb(:,3);

lms = zeros(size(rgb));

lms(:,1) = 0.02964043880249989 + r.*-0.007155020810963704 + g.*0.5846378797137859 + b.*0.11501434945673943 + r.*g.*0.29567864342357675 + r.*b.*0.20284536806557824 + g.*b*-0.16754190120191473;
lms(:,2) = 0.028044667867148907 + r.*-0.03400751088768918 + g.*0.5752341099566223 + b.*0.15952707553945353 + r.*g.*0.13958841847569586 + r.*b.*0.3076488386179823 + g.*b.*-0.1253740513793698;
lms(:,3) = 0.0269634547326353 + r.*-0.036603432090747276 + g.*0.5063986816030795 + b.*0.220212767855884 + r.*g.*-0.03203442412814125 + r.*b.*0.43231071941364574 + g.*b.*-0.06832184516676484;

%% correct out of gamut pixels
lms(lms<0) = 0;
lms(lms>1) = 1;

%% generate luminance image based on (L+M)/2 (see doi.org/10.1038/s41598-019-52297-0; doi.org/10.3389/fncir.2014.00118; doi.org/10.1242/jeb.232090)
lum = (lms(:,1) + lms(:,2) )./2;

end %function

