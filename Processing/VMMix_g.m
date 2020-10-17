% g
function g = VMMix_g(x, mu, k)
g = exp(k*cos(x - mu))/(2*pi*besseli(0, k));
end