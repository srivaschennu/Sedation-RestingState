function CovarsPeakFreq

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

Alphapeak = alphapeak';
Drug = cell2mat(subjlist(:,3));
RT = cell2mat(subjlist(:,4));
Hits = cell2mat(subjlist(:,5));

figure('Color','White');
for i = 1:3
    subplot(2,3,i) 
    if i == 1
        f = fit(Drug(Drug > 0),Alphapeak(Drug > 0),'poly1');
        plot(f,Drug(Drug > 0),Alphapeak(Drug > 0),'.b');        
        xlabel('Drug');
        [rho, pval] = corr(Drug(Drug > 0),Alphapeak(Drug > 0),'type','spearman');
        fprintf('Rho = %.2f     p = %.3f\n',rho,pval); 
    elseif i == 2
        f = fit(RT(RT ~= -1),Alphapeak(RT ~= -1),'poly1');
        plot(f,RT(RT ~= -1),Alphapeak(RT ~= -1),'.b');
        xlabel('Perceptual RT');
        [rho, pval] = corr(RT(RT ~= -1),Alphapeak(RT ~= -1),'type','spearman');
        fprintf('Rho = %.2f     p = %.3f\n',rho,pval); 
    else
        f = fit(Hits(grp(:,1) == 3),Alphapeak(grp(:,1) == 3),'exp1');
        plot(f,Hits(grp(:,1) == 3),Alphapeak(grp(:,1) == 3),'.');        
        xlabel('Perceptual Hits');      
        [rho, pval] = corr(Hits(grp(:,1) == 3),Alphapeak(grp(:,1) == 3),'type','spearman');
        fprintf('Rho = %.2f     p = %.3f\n',rho,pval); 
    end
    ylabel('Alpha Peak Frequency (Hz)')
    legend('off');
end
[~,h4]=suplabel('Alpha Peak Frequency vs Covariates','t');
set(h4,'FontSize',16)
end


