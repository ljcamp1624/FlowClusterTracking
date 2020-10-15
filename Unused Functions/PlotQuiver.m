function PlotQuiver(im, vx, vy, rel, relThresh, s, magFac)

figure;
h1 = imagesc(im(:, :, 1), [min(im(:)), max(im(:))]);
hold on;
h2 = quiver(1, 1, 1, 1, 0, 'g');
hold off;

[vxShow, vyShow, relShow] = DeclutterQuiver(vx, vy, rel, s);
[ix, iy] = meshgrid(1:size(im, 1), 1:size(im, 2));
for i = 1:size(im, 3)
    vxShowTemp = vxShow(:, :, i);
    vyShowTemp = vyShow(:, :, i);
    relMask = relShow(:, :, i) > relThresh;
    set(h1, 'cdata', im(:, :, i)); 
    set(h2, 'xdata', iy(relMask), 'ydata', ix(relMask), 'udata', magFac*s*vxShowTemp(relMask), 'vdata', magFac*s*vyShowTemp(relMask));
    drawnow;
end