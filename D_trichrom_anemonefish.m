%Vorobyev-Osorio model; trichromat e.g. primate

function D = D_trichrom_anemonefish(Sf, Mf, Lf, Sg, Mg, Lg)

% Inputs are cone responses for S, M, and L cones, for colour patches 'a'
% and 'b'. Cone responses are relative to the illuminant

%PARAMETERS
% Weber fractions
Wl = 0.1;
Wm = 0.1;
Ws = 0.1;

% Cone proportions - if 1, errors will be based on Weber fractions only
Pl = 2;
Pm = 2;
Ps = 1; 

% q = Estimate of quantal flux in the cones; only has an effect at low
% light levels
q = 1e10;
qS = q/10; %Estimate of sensitivity for S cones

%1.========================================================================
%Shot Noise model: Estimates quantum flux and shot noise in each cone
%type

sSa = snoise(qS,Sf);
sMa = snoise(q,Mf);
sLa = snoise(q,Lf);
sSb = snoise(qS,Sg);
sMb = snoise(q,Mg);
sLb = snoise(q,Lg);


%2.========================================================================
% Weberian errors

wbSa = recept_error(Ps,Ws,sSa);
wbMa = recept_error(Pm,Wm,sMa);
wbLa = recept_error(Pl,Wl,sLa);
wbSb = recept_error(Ps,Ws,sSb);
wbMb = recept_error(Pm,Wm,sMb);
wbLb = recept_error(Pl,Wl,sLb);


%3.========================================================================
% Combined quantum and webber effects for 2 patches

ES = (wbSa + wbSb)/2;
EM = (wbMa + wbMb)/2;
EL = (wbLa + wbLb)/2;


%4.========================================================================
% Difference between patches for each cone type with LOG transformed values

DS = patch_diff(Sf, Sg);
DM = patch_diff(Mf, Mg);
DL = patch_diff(Lf, Lg);

%5.========================================================================
% The model

DTa = (((DL-DM)^2)*ES^2)+(((DL-DS)^2)*EM^2)+(((DM-DS)^2)*EL^2);
DTb = (((EL*EM)^2)+((EL*ES)^2)+((EM*ES)^2));
DT = DTa/DTb;

D = sqrt(DT);



