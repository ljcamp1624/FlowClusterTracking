% f
function f = VMMix_f(x, mu, k, p1, p2, p3)
g = VMMix_g(x, mu, k);
g_pi = VMMix_g(x, mu + pi, k);
const = 1/2/pi;
z = sum(exp([p1, p2, p3]));
f = (1/z)*(exp(p1)*g + exp(p2)*g_pi + exp(p3)*const);
end