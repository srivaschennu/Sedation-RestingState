function GroupAlphaTopo

loadpaths
loadsubj
load chanlist
load grp2.mat

for i = 1:length(subjlist)
        basename = sprintf('%s',cell2mat(subjlist(i,1)));
        EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');
        [~,sortidx] = sort({EEG.chanlocs.labels});       
        bpower(:,i) = mean(mean(EEG.spectra(sortidx,EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),2),3);                
end

% % Level 1 vs Level 3
%  figure('Color','white');
%  i = 1;
%  g = 1;
% for i = 1:2
%     subplot(2,2,i)
%     allbpower = mean(bpower(:,grp(:,1) == (g)),2);
%     topoplot(allbpower,sortedlocs,'electrodes','on');
%     colorbar
%     g = g+2;
% end

% Level 3 Split by Groups
for g = 1:2
    allbpower = mean(bpower(:,grp(:,1) == 3 & grp(:,3) == (g)),2);
    figure;
    topoplot(allbpower,sortedlocs,'electrodes','on');
    colorbar
end


end