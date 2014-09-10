% coherences
function [coh, cohbootall, freqsout] = calcpli(EEG,chann1,chann2)

chann1
chann2 

[coh,~,~,freqsout,~,~,...
~,~,~,cohbootall] = ...
pop_newcrossf( EEG, 1, chann1, chann2, [EEG.xmin  EEG.xmax] * 1000, 0 ,...@ 0 dc fait fft au lieu de l'autre. permet de commencer analyse a 0.5Hz. 1 : wavelet dc mieux, commence aussi a 0.5hz comparer
    'type', 'pli','alpha',0.001,'padratio', 1,'plotamp','off','plotphase','off');

end

% calcule cross coherence entre 2 canaux