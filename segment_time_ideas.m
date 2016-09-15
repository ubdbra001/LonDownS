L = linspace(0,2.*pi,6);
xv = cos(L)';
yv = sin(L)';

rng default
xq = randn(250,1);
yq = randn(250,1);

[in,on] = inpolygon(xq,yq,xv,yv);


figure

plot(xv,yv) % polygon
axis equal

hold on
plot(xq(in),yq(in),'r+') % points inside
plot(xq(~in),yq(~in),'bo') % points outside
hold off


xlimit = [0 768];
ylimit = [0 768];
xbox = xlimit([1 1 2 2 1]);
ybox = ylimit([1 2 2 1 1]);
mapshow(xbox,ybox,'DisplayType','polygon','LineStyle','none')

% x = [0 6  4  8 8 10 14 10 14 NaN 4 4 6 9 15];
% y = [4 6 10 11 7  6 10 10  6 NaN 0 3 4 3  6];


x1 = [384 539 NaN 808 384 -196];
y1 = [384 964 NaN -40 384 229];

mapshow(x1,y1)

figure(2)
xCenter = 0.5;
yCenter = 0.5;
radius = 0.5;

angles = [75 195 315 75];


theta = 195/180*pi :1/180*pi: 315/180*pi;
poly(n).x = [xCenter radius * cos(theta) + xCenter xCenter];
poly(n).y = [yCenter radius * sin(theta) + yCenter yCenter];
mapshow(x, y);

%%

colours = hsv(3);

for foundEvent_n = 1:length(foundEvents);
    
    a = allData(foundEvents{foundEvent_n,3}:foundEvents{foundEvent_n,6},:);
    b = func_preprocessData(a);
    eyeXY = [nanmean(b(:,3:4),2)'; nanmean(b(:,5:6),2)']';     % Calculate single coordinate for looking
    
    clear in
    figure(foundEvent_n); hold on
    im1 = imread('Cat.png', 'BackgroundColor', [1 1 1]);
    for n = 1:3
        im(n) = image(unique(stim(n).x), sort(1-unique(stim(n).y)), im1);
        set(im(n), 'AlphaData', 0.5)
        in(n,:) = inpolygon(eyeXY(:,1), eyeXY(:,2), AoIs(n).x, AoIs(n).y)';
        plot(AoIs(n).x, AoIs(n).y, 'Color', colours(n,:))
        plot(eyeXY(in(n,:),1),eyeXY(in(n,:),2), '+' ,'Color',colours(n,:))
        %mapshow(stim(n).x,(1-stim(n).y), 'Color', colours(n,:))
        %plot(eyeXY(~in,1),eyeXY(~in,2),'bo')
    end
    %mapshow(stim(4).x,(1-stim(4).y), 'Color', 'yellow')
    %axis square
    xlim([0 1])
    ylim(xlim)
    hold off
    set(gca,'Ydir','reverse')
    
    saveas(figure(foundEvent_n), sprintf('%s - %s: trial %d', eventsToFind{1}, eventsToFind{2}, foundEvent_n), 'fig');


end

close all
