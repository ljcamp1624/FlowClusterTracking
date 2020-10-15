function cqObj = ColorQuiver(vx, vy, cmap, lineWidth, varargin)
numBins = size(cmap, 1);
ang = atan2(vy, vx);
ang = round((numBins - 1)*mod(ang, 2*pi)/2/pi) + 1;

if isempty(varargin)
    cqObj = [];
    mask = ones(size(vx));
elseif length(varargin) == 1
    cqObj = varargin{1};
    mask = ones(size(vx));
elseif length(varargin) == 2
    cqObj = varargin{1};
    mask = varargin{2};
end

if isempty(cqObj)
    hold on;
    cqObj = cell(numBins, 1);
    for i = 1:numBins
        angMask = double(ang == i);
        totalMask = angMask & mask;
        [ix, iy] = find(totalMask);
        cqObj{i} = quiver(iy, ix, vx(totalMask(:) == 1), vy(totalMask(:) == 1), 0, 'Color', cmap(i, :), 'LineWidth', lineWidth, 'MaxHeadSize', 100);
    end
    hold off;
else
    for i = 1:numBins
        angMask = double(ang == i);
        totalMask = angMask & mask;
        [ix, iy] = find(totalMask);
        if isempty(ix)
            set(cqObj{i}, 'XData', 1, 'YData', 1, 'UData', 0, 'VData', 0);
        else
            set(cqObj{i}, 'XData', iy, 'YData', ix, 'UData', vx(totalMask(:) == 1), 'VData', vy(totalMask(:) == 1));
        end
    end
end