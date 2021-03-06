function PlotBadChans(patientnr, nightnr)
    
    % load stddevs & noisiness
    [stddevs, noise] = MarkNoisyData(patientnr, nightnr);
    
    % plot nr of bad channels at every epoch
    thresholdChanStdDev = GetThresholdChannelStdDev(patientnr, nightnr);
    t1 = MakeTimeLabelsCrossSpectraEpochs(size(stddevs,2));
    figure;
    bar(t1,sum(stddevs>thresholdChanStdDev));
    xlabel('Time');
    ylabel('Nr. bad chans');
     
end
    
    