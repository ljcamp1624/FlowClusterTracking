function fitParams = AnalyticalVonMisesFit(angList)
%%  Calculate Modified Bessel Functions of the First Kind
xVec = 0:0.001:1000;
I0 = besseli(0, xVec); 
I1 = besseli(1, xVec);
I2 = besseli(2, xVec);
A1 = I1./I0;
A2 = I2./I0;

%%  Calculate Special Function Values
n = length(angList);
psiList = mod(angList, pi);
cosPsi = sum(cos(2*psiList))/n; 
sinPsi = sum(sin(2*psiList))/n;
radPsi = sqrt(cosPsi^2 + sinPsi^2);
cosList = cos(angList);
sinList = sin(angList);
cosAvg = mean(cosList);
sinAvg = mean(sinList);

%%  Calculate Model Parameters
mu = atan2(sinPsi, cosPsi)/2;
idx = find(abs(A2 - radPsi) == min(abs(A2 - radPsi)), 1);
kappa = xVec(idx);
p = (((cosAvg*cos(mu) + sinAvg*sin(mu))/A1(idx)) + 1)/2;

%%  Output
fitParams = [mu, kappa, p, 1 - p, 0];
end