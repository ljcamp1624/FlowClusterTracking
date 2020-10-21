% dg/dmu
function dgdmu = VMMix_dg_dmu(x, mu, k)
g = VMMix_g(x, mu, k);
dgdmu = k*sin(x - mu).*g;
end