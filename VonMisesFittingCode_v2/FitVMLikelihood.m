function b2 = FitVMLikelihood(data)
%% choose initial parameters
[mu, k, p] = MixedVonMisesFit(data);
p1 = p; 
p2 = 1-p; 
p3 = 0;
b = [mu; k; p1; p2; p3];

%% fit data
options = optimoptions('fminunc', 'GradObj', 'on');
b2 = fminunc(@(b) VMMix_logF(data, b), b, options);

%% plot fit
% figure;
% 
% % plot histogram
% numBins = 72;
% polarhistogram(data, numBins, 'normalization', 'probability');
% 
% % plot line
% numPoints = 10*numBins;
% x = linspace(-pi, pi, numPoints);
% y = VMMix_f(x, b2(1), b2(2), b2(3), b2(4), b2(5));
% hold on;
% polarplot(x, y/sum(y)*numPoints/numBins, 'linewidth', 2);
% hold off;