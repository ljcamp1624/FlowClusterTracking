% df/dp3
function dfdp3 = VMMix_df_dp3(x, mu, k, p1, p2, p3)
const = 1/2/pi;
f = VMMix_f(x, mu, k, p1, p2, p3);
z = sum(exp([p1, p2, p3]));
dfdp3 = (exp(p3)/z)*(const - f);
end