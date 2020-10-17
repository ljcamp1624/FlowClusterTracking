function newFitParams = LikelihoodVonMisesFit(angList, fitParams)
%%  choose initial parameters
b = fitParams(:); % Should be in the form  b = [mu; k; p1; p2; p3];

%   assumes that fitParams are initialized by AnalyticalVonMisesFit*.m
z1 = fitParams(3);
z2 = fitParams(4);
x1 = log(z1./z2)./(1 - log(1 - z1) + log(z1));
x2 = x1 - log(z1./z2);
fitParams(3) = x1;
fitParams(4) = x2;
fitParams(5) = -inf;

%%  fit data
options = optimoptions('fmincon', 'GradObj', 'on');
lowerBound = [-inf; 2; -inf; -inf; -inf];
newFitParams = fmincon(@(b) VMMix_logF(angList, b), fitParams, [], [], [], [], lowerBound, [], options);

%%  process output
z = sum(exp(newFitParams(3:5)));
newFitParams(3:5) = exp(newFitParams(3:5))/z;
newFitParams = newFitParams(:)';
end