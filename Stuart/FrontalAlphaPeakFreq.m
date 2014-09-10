function FrontalAlphaPeakFreq

loadpaths
loadsubj
load chanlist
load grp2.mat

channame = {
    'Fz'  'Oz'
    'F3'  'O1'
    'F4'  'O2'
    'E16' 'E65'
    'E19' 'E71'
    'F4'  'E76'
    'E5'  'E90'
    'E6'  'E66'
    'E12' 'E84'
    };

nchans = length(channame);
nsubj = length(subjlist);
k = 1;
for i = 1:length(subjlist)
        basename = sprintf('%s',cell2mat(subjlist(i,1)));
        EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');      
        for chan = 1:nchans
            alphapower = mean(EEG.spectra(strcmp(channame(chan,k),{EEG.chanlocs.labels}),...
                EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),3);
        end
        [~,alphapeak(i)] = max(mean(alphapower,1),[],2);
        alphapeak(i) = EEG.freqs(find(EEG.freqs >= EEG.freqwin(3),1) + alphapeak(i) - 1);
end
k = 2;
for i = 1:length(subjlist)
        basename = sprintf('%s',cell2mat(subjlist(i,1)));
        EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');      
        for chan = 1:nchans
            alphapower2 = mean(EEG.spectra(strcmp(channame(chan,k),{EEG.chanlocs.labels}),...
                EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),3);
        end
        [~,alphapeak2(i)] = max(mean(alphapower2,1),[],2);
        alphapeak2(i) = EEG.freqs(find(EEG.freqs >= EEG.freqwin(3),1) + alphapeak2(i) - 1);
end

figure('Color','white');
% Frontal Level 3 vs Occipital Level 3
output = [mean(alphapeak(grp(:,1) == 3));mean(alphapeak2(grp(:,1) == 3))];
errors = [std(alphapeak(grp(:,1) == 3))/sqrt(length(alphapeak(grp(:,1) == 3)));std(alphapeak2(grp(:,1) == 3))/sqrt(length(alphapeak2(grp(:,1) == 3)))];
barweb(output,errors,[],[],[],'Frontal Level 3 vs Occipital Level 3','Peak Frequency (Hz)');
p = ranksum(alphapeak(grp(:,1) == 3),alphapeak2(grp(:,1) == 3))

end


