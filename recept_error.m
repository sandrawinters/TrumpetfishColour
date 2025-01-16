% file to calculate the estimated receptor noise e

function wb = recept_error(p,w,s)

% w = Weber error (normally 0.5)
% p = relative proportion of receptor to most abundant

e = w./sqrt(p);

wb = s+e;