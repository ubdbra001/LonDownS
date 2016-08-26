function figHandle = func_producePlots(eyeXY, AoIs, stim, in)

addpath('/Volumes/ADDS/Dan/New ET tasks/stimuli/images');

colours = hsv(length(AoIs));
    
figHandle = figure('Visible', 'off'); hold on
set(gca,'Ydir','reverse')
    
for stim_n = 1:numel(stim.image)
    im = imread(sprintf('%s.png', stim.image{stim_n}), 'BackgroundColor', [1 1 1]);
    imHand(stim_n) = image([stim.loc.x(stim_n)-ETAnalysis_constants.stimSize(1) stim.loc.x(stim_n)+ETAnalysis_constants.stimSize(1)],...
        [stim.loc.y(stim_n)-ETAnalysis_constants.stimSize(2) stim.loc.y(stim_n)+ETAnalysis_constants.stimSize(2)], im);
    set(imHand(stim_n), 'AlphaData', 0.5)
end

for AoI_n = 1:numel(AoIs)
    plot(AoIs(AoI_n).x, AoIs(AoI_n).y, 'Color', colours(AoI_n,:))
    plot(eyeXY(in(AoI_n,:),1),eyeXY(in(AoI_n,:),2), '+' ,'Color',colours(AoI_n,:))
end

xlim([0 1])
ylim(xlim)
hold off
figHandle.Visible = 'on';