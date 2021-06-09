% f
function f = VMMix_f_proportions(x, b)
if isempty(b)
    f = zeros(size(x));
    return;
end
mu = b(1);
k = b(2);
p1 = b(3);
p2 = b(4);
p3 = b(5);
g = VMMix_g(x, mu, k);
g_pi = VMMix_g(x, mu + pi, k);
const = 1/2/pi;
f = p1*g + p2*g_pi + p3*const;
f = f/sum(f);
end