% df/dp1
function dfdp1 = VMMix_df_dp1(x, mu, k, p1, p2, p3)
g = VMMix_g(x, mu, k);
f = VMMix_f(x, mu, k, p1, p2, p3);
z = sum(exp([p1, p2, p3]));
dfdp1 = (exp(p1)/z)*(g - f);
end