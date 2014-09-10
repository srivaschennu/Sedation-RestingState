function GroupAlphaPower

loadpaths
loadsubj
load chanlist
load grp2.mat

channame = {
% Frontal
    'E16'
    'F3'
    'F4'
    'Fz'
    'E19'
    'F4'
    'E5'
    'E6'
    'E12'
    };

channame2 = {
% Occipital
    'Oz'
    'O1'
    'O2'
    'E65'
    'E71'
    'E76'
    'E90'
    'E66'
    'E84'
    };

numchans = length(channame);
numchans2 = length(channame2);


for i = 1:length(subjlist)
        basename = sprintf('%s',cell2mat(subjlist(i,1)));
        EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');      
        alphapower(i) = mean(mean(mean(EEG.spectra(:,EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),1),2),3);
     
        [~,alphapeak(i)] = max(mean(mean(EEG.spectra(:,EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),1),3),[],2);
        alphapeak(i) = EEG.freqs(find(EEG.freqs >= EEG.freqwin(3),1) + alphapeak(i) - 1);  
       
        for chan = 1:numchans
            frontalpower(chan,i) = squeeze(mean(mean(mean(EEG.spectra(strcmp(channame(chan),{EEG.chanlocs.labels}),...
                EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),1),2),3));
        end
        
        for chan = 1:numchans2
            occipitalpower(chan,i) = squeeze(mean(mean(mean(EEG.spectra(strcmp(channame2(chan),{EEG.chanlocs.labels}),...
                EEG.freqs >= EEG.freqwin(3) & EEG.freqs <= EEG.freqwin(4),:),1),2),3));
        end
end

% % Level 2 Frontal & Occipital Alpha Power by Group
% 
% frontalpower = squeeze(mean(frontalpower,1));
% frontaloutput = [mean(frontalpower(grp(:,2) == 1 & grp(:,1) == 3));mean(frontalpower(grp(:,2) == 2 & grp(:,1) == 3))];
% occipitalpower = squeeze(mean(occipitalpower,1));
% occipitaloutput = [mean(occipitalpower(grp(:,2) == 1 & grp(:,1) == 3));mean(occipitalpower(grp(:,2) == 2 & grp(:,1) == 3))];
% 
% figure('Color','White');
%     for k = 1:2
%         subplot(1,2,k)
%         if k == 1
%             bar(frontaloutput);
%             hold all;
%             p = ranksum(frontalpower(grp(:,2) == 1 & grp(:,1) == 3),frontalpower(grp(:,2) == 2 & grp(:,1) == 3))
%         else
%             bar(occipitaloutput);
%             hold all;
%             p = ranksum(occipitalpower(grp(:,2) == 1 & grp(:,1) == 3),occipitalpower(grp(:,2) == 2 & grp(:,1) == 3))
%         end
%         k = k+1;
%     end

% Level 0 Frontal Power by Group
frontalpower = squeeze(mean(frontalpower,1));
frontalpower = 10*(10.^frontalpower);
frontaloutput = [mean(frontalpower(grp(:,2) == 1 & grp(:,1) == 1));mean(frontalpower(grp(:,2) == 2 & grp(:,1) == 1))];
errors = [std(frontalpower(grp(:,1) == 1 & grp(:,3) == 1))/sqrt(length(frontalpower(grp(:,1) == 1 & grp(:,3) == 1)));std(frontalpower(grp(:,1) == 1 & grp(:,3) == 2))/sqrt(length(frontalpower(grp(:,1) == 1 & grp(:,3) == 2)))];

figure('Color','White');
barweb(frontaloutput,errors,[],[],[],'Responsive vs Decreased Hits','Frontal Alpha Power Level 0');
p = ranksum(frontalpower(grp(:,2) == 1 & grp(:,1) == 1),frontalpower(grp(:,2) == 2 & grp(:,1) == 1))
    
end
    



