function [maskedTIFFcrop RGB] = mask_crops(TIFFcrop, binaryImage);

%split into three channels (could eliminate this)
maskedTIFFcropR = TIFFcrop(:,:,1);
maskedTIFFcropG = TIFFcrop(:,:,2);
maskedTIFFcropB = TIFFcrop(:,:,3);

%find where the mask does not equal zero (i.e. the region)
R = maskedTIFFcropR(binaryImage~=0);
G = maskedTIFFcropG(binaryImage~=0);
B = maskedTIFFcropB(binaryImage~=0);

%a vectorized output
RGB = [R G B];

%to visualize the crop
maskedTIFFcropR(~binaryImage) = 0;
maskedTIFFcropG(~binaryImage) = 0;
maskedTIFFcropB(~binaryImage) = 0;

%recombine into an RGB image
maskedTIFFcrop = zeros(size(TIFFcrop));
maskedTIFFcrop(:,:,1) = maskedTIFFcropR;
maskedTIFFcrop(:,:,2) = maskedTIFFcropG;
maskedTIFFcrop(:,:,3) = maskedTIFFcropB;

%make 16-bit image type
maskedTIFFcrop = uint16(maskedTIFFcrop);

