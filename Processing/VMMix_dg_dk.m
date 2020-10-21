% dg/dk
function dgdk = VMMix_dg_dk(x, mu, k)
g = VMMix_g(x, mu, k);
dgdk = (cos(x - mu) - (besseli(1, k)/besseli(0, k))).*g;
end