function AddScaleBar(position)
x = position(1);
y = position(2);
len = position(3);
wid = position(4);
fill([x; x; x + len; x + len], ...
    [y; y + wid; y + wid; y], 'w', 'edgecolor', 'none');