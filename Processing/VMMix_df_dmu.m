% df/dmu
function dfdmu = VMMix_df_dmu(x, mu, k, p1, p2, p3)
z = sum(exp([p1, p2, p3]));
dgdmu = VMMix_dg_dmu(x, mu, k); 
dgpidmu = VMMix_dg_dmu(x, mu + pi, k);
dfdmu = (1/z)*(exp(p1)*dgdmu + exp(p2)*dgpidmu);
end