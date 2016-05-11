function dataOut = func_dataResample(dataIn, fixParams)

samplePoints  = 0:1/fixParams.SamplingFrequency:fixParams.TrialLength-1/fixParams.SamplingFrequency;
resampledData = interp1(dataIn(:,2),dataIn(:,3:6), samplePoints, 'pchip');

for sample_n = 1:size(resampledData,1)
    sample_before = find(dataIn(:,2) <= samplePoints(sample_n),1,'last');
    sample_after  = find(dataIn(:,2) > samplePoints(sample_n),1,'first');
    notLooking = isnan(dataIn([sample_before, sample_after], 3:6));
    if any(notLooking(:))
        resampledData(sample_n, any(notLooking)) = NaN;
    end
end

dataOut = [(dataIn(1,1) + samplePoints*1e6)' samplePoints' resampledData];