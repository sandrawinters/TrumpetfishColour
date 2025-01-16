% Calculates difference between photon catch for two patch types for a cone
% type -- log form of V-O model

function d = patch_diff(a, b)

% a and b are the photon catch of patches 1 and 2 for cone type 1

d = log(a/b);
