%% Log Likelihood Function
function [logF, dlogF] = VMMix_logF(data, b)
% parse parameters
mu = b(1);
k = b(2);
p1 = b(3);
p2 = b(4);
p3 = b(5);

% logF
f = VMMix_f(data, mu, k, p1, p2, p3);

% dlogF/dmu
dfdmu = VMMix_df_dmu(data, mu, k, p1, p2, p3);
dlogFdmu = sum(dfdmu./f);

% dlogF/dk
dfdk = VMMix_df_dk(data, mu, k, p1, p2, p3);
dlogFdk = sum(dfdk./f);

% dlogF/dp1
dfdp1 = VMMix_df_dp1(data, mu, k, p1, p2, p3);
dlogFdp1 = sum(dfdp1./f);

% dlogF/dp2
dfdp2 = VMMix_df_dp2(data, mu, k, p1, p2, p3);
dlogFdp2 = sum(dfdp2./f);

% dlogF/dp3
dfdp3 = VMMix_df_dp3(data, mu, k, p1, p2, p3);
dlogFdp3 = sum(dfdp3./f);

% Accumulate output
logF = -sum(log(f));
dlogF = -[dlogFdmu; dlogFdk; dlogFdp1; dlogFdp2; dlogFdp3]; 

end