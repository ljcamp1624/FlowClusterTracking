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