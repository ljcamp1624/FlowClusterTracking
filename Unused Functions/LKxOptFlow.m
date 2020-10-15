function [vx, vy, rel, coh, vx2] = LKxOptFlow(I1, I2, sig, thresh)

w = fspecial('gaussian', 6*sig + 1, sig);

I1 = double(I1);
I2 = double(I2);

[dxI, dyI]=imgradientxy(I1, 'central');
dtI = I2 - I1;

wdx2 = imfilter((dxI.^2), w);
% wdxy = imfilter((dxI.*dyI), w);
% wdy2 = imfilter((dyI.^2), w);
wdtx = imfilter((dxI.*dtI), w);
% wdty = imfilter((dyI.*dtI), w);

% trace = wdx2 + wdy2;
% determinant = (wdx2.*wdy2) - (wdxy.^2);
% 
% e1 = (trace + sqrt(trace.^2 - 4*determinant))/2;
% e2 = (trace - sqrt(trace.^2 - 4*determinant))/2;
% rel = min(e1, e2);
% coh = abs(e1 - e2)./(e1 + e2 + eps);

% vx = ((determinant + eps).^-1).*((wdy2.*-wdtx)+(-wdxy.*-wdty));
% vy = ((determinant + eps).^-1).*((-wdxy.*-wdtx)+(wdx2.*-wdty));
% vx(rel < thresh) = 0;
% vy(rel < thresh) = 0;
vx2 = -wdxt./wdx2;