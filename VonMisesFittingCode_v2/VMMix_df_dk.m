% df/dk
function dfdk = VMMix_df_dk(x, mu, k, p1, p2, p3)
z = sum(exp([p1, p2, p3]));
dgdk = VMMix_dg_dk(x, mu, k); 
dgpidk = VMMix_dg_dk(x, mu + pi, k);
dfdk = (1/z)*(exp(p1)*dgdk + exp(p2)*dgpidk);
end