function bpower = bandpower(basename,channame,freqwin)

AddPaths;
eeglab;
clearvars -except basename channame freqwin;

filepath = '/home/sc03/Iulia/Iulia/Stein_pow';

if ischar(basename)
    EEG = pop_loadset('filepath',filepath,'filename',[basename '_spec.set']);
else
    EEG = basename;
    clear basename
end

bpower = squeeze(mean(EEG.spectra(strcmp(channame,{EEG.chanlocs.labels}),...
    EEG.freqs >= freqwin(1) & EEG.freqs <= freqwin(2),:),2));

save([filepath '/bpower' basename '.mat'], 'bpower');