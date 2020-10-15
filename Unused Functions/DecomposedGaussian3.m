function [xFil, yFil, zFil] = DecomposedGaussian3(sigR, numSig)

if length(sigR) == 1
    sigR = repmat(sigR, [1, 3]); 
elseif length(sigR) == 3
else
    error(''); 
end

kernelSize = ceil(sigR.*numSig) + mod(ceil(sigR.*numSig), 2) + 1; 
x = -kernelSize(1):kernelSize(1);
y = -kernelSize(2):kernelSize(2);
z = -kernelSize(3):kernelSize(3);

Gx = exp(-x.*x/2/sigR(1)/sigR(1)); Gx = Gx/sum(Gx(:)); 
Gy = exp(-y.*y/2/sigR(2)/sigR(2)); Gy = Gy/sum(Gy(:)); 
Gz = exp(-z.*z/2/sigR(3)/sigR(3)); Gz = Gz/sum(Gz(:)); 

xFil = Gx; 
yFil = permute(Gy, [2, 1]); 
zFil(1, 1, :) = Gz; 