resolution = [1360 768];

centre = resolution/2;

origin = 0;
radius = 600;

angles = [0:15:360];

[t, r] = cart2pol(origin, radius);

t = degtorad(angles)+t;

[x,y] = pol2cart(t,r);

x = x+centre(2);
y = y+centre(2);

positions = round([360-angles', [x',y']]);

%positions = round([centre; x', y']);

% ax = axes;
% 
% scatter(ax, positions(:,1), positions(:,2), 'filled')
% 
% ax.XLim = [0 resolution(1)];
% ax.YLim = [0 resolution(2)];

