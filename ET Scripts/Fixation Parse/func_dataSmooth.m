function dataOut = func_dataSmooth(dataIn)

% Not sure what these are...
scales = 3;
iscales = 30;

% Prep output variable
dataOut = NaN(length(dataIn), 4);
dataOut(:,1:2) = dataIn(:,1:2);

XYdata = [mean(dataIn(:,[3 5]),2)'; mean(dataIn(:,[4 6]),2)']'; % Calculate single coordinate for looking using mean if both eyes available, if not mark as NaN (missing)
goodSamples = find(~any(isnan(XYdata),2));
XYdata(~goodSamples,:) = NaN; % Mark any samples where either X or Y coordinates are NaN

% Bilateral filtering algorithm (Magic!!)
[x1, x2] = meshgrid(XYdata(:,1), XYdata(:,1));
iwX = exp(-(x1-x2).^2./(2.*iscales.^2)); % Calculate the absolute difference between each sample and all the other samples for the X axis (expressed as exponential?)
iwaX = 1; %((x1-x2)<100);
[y1, y2] = meshgrid(XYdata(:,2), XYdata(:,2));
iwY = exp(-(y1-y2).^2./(2.*iscales.^2)); % Calculate the absolute difference between each sample and all the other samples for the Y axis (expressed as exponential?)
iwaY = 1; %((x1-x2)<100);
[t1, t2] = meshgrid((1:length(XYdata)), (1:length(XYdata)));
dw = exp(-(t1-t2).^2./(2.*scales.^2)); % Calculate the distance between each sample and all the other samples (expressed as exponential?)

tw = iwaX.*iwaY.*iwX .* iwY .* dw;

dataOut(goodSamples,3) = sum(tw(goodSamples,goodSamples) .* repmat(XYdata(goodSamples,1),1, length(XYdata(goodSamples,1))), 1) ./ sum(tw(goodSamples,goodSamples), 1);
dataOut(goodSamples,4) = sum(tw(goodSamples,goodSamples) .* repmat(XYdata(goodSamples,2),1, length(XYdata(goodSamples,2))), 1) ./ sum(tw(goodSamples,goodSamples), 1);

