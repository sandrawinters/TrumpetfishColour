function s = snoise(q,c)

% q is an estimate of the quantal flux in the cone - only affects the
% output much at low light levels

% c is the cone catch (before log transformation)

a = q*c;

s = 1/a;