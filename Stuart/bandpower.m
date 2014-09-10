function bandpower
loadpaths
load graphdata_subjlist_pli
freqwin = [4 8];
channame = {
    'E7'
    'E106'
    'E80'
    'E55'
    'E31'
    };
numchans = length(channame);
numsubj = length(subjlist);

for subj = 1:numsubj    
        EEG = pop_loadset('filepath',filepath,'filename',[subjlist{subj,1} '.set']);
    for chan = 1:numchans
        power{chan} = squeeze(mean(mean(EEG.spectra(strcmp(channame(chan),{EEG.chanlocs.labels}),...
        EEG.freqs >= freqwin(1) & EEG.freqs <= freqwin(2),:),2),3));
    end  
    bandpower{subj} = mean(cell2mat(power));   
end