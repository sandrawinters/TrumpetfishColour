function L = D_lum_anemonefish(a, b)

q = 1e10;% quantal flux
Wd = 0.08; % Weber error
Pd = 1; % cone proportions

%===============

% shot noise
sDa = snoise(q,a);
sDb = snoise(q,b);

% recept error
wDa = recept_error(Pd,Wd,sDa);
wDb = recept_error(Pd,Wd,sDb);

% combined error
Ed = (wDa + wDb)/2;

% patch diff
d = log(a/b);

Df = d^2/Ed^2;

L = sqrt(Df);