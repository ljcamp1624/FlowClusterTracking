function [mu, kappa, p] = MixedVonMisesFit(angListInRadians, varargin)
if isempty(varargin)
    cLevel = 0.95;
else
    cLevel = varargin{1};
end
%% Calculate Modified Bessel Functions of the First Kind
xVec = 0:0.001:1000;
I0 = besseli(0, xVec); 
I1 = besseli(1, xVec);
I2 = besseli(2, xVec);
A1 = I1./I0;
A2 = I2./I0;

%% Calculate Special Function Values
n = length(angListInRadians);
psiList = mod(angListInRadians, pi);
cosPsi = sum(cos(2*psiList))/n; 
sinPsi = sum(sin(2*psiList))/n;
radPsi = sqrt(cosPsi^2 + sinPsi^2);
cosList = cos(angListInRadians);
sinList = sin(angListInRadians);
cosAvg = mean(cosList);
sinAvg = mean(sinList);
radNet = sqrt(sum(cosList.^2) + sum(sinList.^2));
radAvg = radNet/n;
invZ = abs(norminv((1 - cLevel)/2, 0, 1));
invX2_lower = chi2inv((1 - cLevel)/2, n - 1);
invX2_upper = chi2inv(1 - (1 - cLevel)/2, n - 1);

%% Calculate Model Parameters
mu = atan2(sinPsi, cosPsi)/2;
idx = find(abs(A2 - radPsi) == min(abs(A2 - radPsi)), 1);
kappa = xVec(idx);
p = (((cosAvg*cos(mu) + sinAvg*sin(mu))/A1(idx)) + 1)/2;