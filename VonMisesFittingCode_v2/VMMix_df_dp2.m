% df/dp2
function dfdp2 = VMMix_df_dp2(x, mu, k, p1, p2, p3)
gpi = VMMix_g(x, mu + pi, k);
f = VMMix_f(x, mu, k, p1, p2, p3);
z = sum(exp([p1, p2, p3]));
dfdp2 = (exp(p2)/z)*(gpi - f);
end