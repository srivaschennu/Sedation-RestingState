function TopoPeakFreq

loadpaths
loadsubj
load chanlist
load grp2.mat

for i = 1:length(subjlist)
        basename = sprintf('%s',cell2mat(subjlist(i,1)));
        EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');      
            j = 1;
            for j = 1:91        
                [~,sortidx] = sort({EEG.chanlocs.labels});  
                [~,alphapeak(i,j)] = max(squeeze(mean(EEG.spectra(sortidx(:,j),EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),3)),[],2);
                alphapeak(i,j) = EEG.freqs(find(EEG.freqs >= EEG.freqwin(3),1) + alphapeak(i,j) - 1);
                j =  j+1;
            end
end
figure;
for k = 1:2
subplot(1,2,k)
    if k == 1;
    alphapeaks = alphapeak((grp(:,1) == 1),:);
    else
    alphapeaks = alphapeak((grp(:,1) == 3),:);
    end
alphapeaks = squeeze(mean(alphapeaks,1));
alphapeaks = alphapeaks';
topoplot(alphapeaks,sortedlocs,'electrodes','on','maplimits',[8 12]);
colorbar
hold all;
k = k+1;
end


