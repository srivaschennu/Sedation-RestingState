% coherences
function [coh, cohbootall, freqsout] = calcpli(EEG,chann1,chann2)

[~,coh,~,~,freqsout,~,~,~,~,~,cohbootall] = ...
    evalc(['pop_newcrossf( EEG, 1, chann1, chann2, [EEG.xmin  EEG.xmax] * 1000, 0 ,' ...
    '''type'', ''wpli'',''boottype'',''rand'',''alpha'',0.0002,''padratio'', 1,''plotamp'',''off'',''plotphase'',''off'')']);

end

% calcule cross coherence entre 2 canaux