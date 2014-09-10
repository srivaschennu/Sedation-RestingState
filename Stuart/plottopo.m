function plottopo(basename,bandidx)

loadpaths

if ischar(basename)
    EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');
else
    EEG = basename;
    clear basename
end

bpower = mean(mean(EEG.spectra(:,...
    EEG.freqs >= EEG.freqwin(bandidx) & EEG.freqs <= EEG.freqwin(bandidx+1),:),2),3);
figure;
topoplot(bpower,EEG.chanlocs,'electrodes','labels');
colorbar