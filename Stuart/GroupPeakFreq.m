function GroupPeakFreq

loadpaths
loadsubj
load chanlist
load grp2.mat

for i = 1:length(subjlist)
        basename = sprintf('%s',cell2mat(subjlist(i,1)));
        EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');      
        alphapower(i) = mean(mean(mean(EEG.spectra(:,EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),1),2),3);
        [~,alphapeak(i)] = max(mean(mean(EEG.spectra(:,EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),1),3),[],2);
        alphapeak(i) = EEG.freqs(find(EEG.freqs >= EEG.freqwin(3),1) + alphapeak(i) - 1);
end

% % Level 0 vs Level 2
output = [mean(alphapeak(grp(:,1) == 1));mean(alphapeak(grp(:,1) == 3))];
errors = [std(alphapeak(grp(:,1) == 1))/sqrt(length(alphapeak(grp(:,1) == 1)));std(alphapeak(grp(:,1) == 3))/sqrt(length(alphapeak(grp(:,1) == 3)))];
barweb(output,errors,[],[],[],'Level 0 vs Level 2','Peak Frequency (Hz)');
p = ranksum(alphapeak(grp(:,1) == 1),alphapeak(grp(:,1) == 3))

% % % Groups (sedated vs oversedated) Level 2
% output = [mean(alphapeak(grp(:,1) == 3 & grp(:,3) == 1));mean(alphapeak(grp(:,1) == 3 & grp(:,3) == 2))];
% errors = [std(alphapeak(grp(:,1) == 3 & grp(:,3) == 1))/sqrt(length(alphapeak(grp(:,1) == 3 & grp(:,3) == 1)));std(alphapeak(grp(:,1) == 3 & grp(:,3) == 2))/sqrt(length(alphapeak(grp(:,1) == 3 & grp(:,3) == 2)))];
% barweb(output,errors,[],[],[],'Fully Responsive vs Decreased Hit Rate','Peak Frequency (Hz)');
% p = ranksum(alphapeak(grp(:,1) == 3 & grp(:,3) == 1),alphapeak(grp(:,1) == 3 & grp(:,3) == 2))
 
% % Groups (sedated vs oversedated) Level 0
% output = [mean(alphapeak(grp(:,1) == 1 & grp(:,3) == 1));mean(alphapeak(grp(:,1) == 1 & grp(:,3) == 2))];
% errors = [std(alphapeak(grp(:,1) == 1 & grp(:,3) == 1))/sqrt(length(alphapeak(grp(:,1) == 1 & grp(:,3) == 1)));std(alphapeak(grp(:,1) == 1 & grp(:,3) == 2))/sqrt(length(alphapeak(grp(:,1) == 1 & grp(:,3) == 2)))];
% barweb(output,errors,[],[],[],'Responsive vs Decreased Hits','Peak Frequency (Hz) Level 0');
% p = ranksum(alphapeak(grp(:,1) == 1 & grp(:,3) == 1),alphapeak(grp(:,1) == 1 & grp(:,3) == 2))


end


