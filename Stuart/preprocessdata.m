function preprocessdata

loadpaths
path1020 = 'C:\Users\Stuart\Documents\MATLAB\only1020\';
loadsubj

for f = 1:size(subjlist,1)
    basename = subjlist{f,1};
    
    
%     % REMOVE EXCLUDED CHANNELS
%     chanexcl = [1,8,14,17,21,25,32,38,43,44,48,49,56,63,64,68,69,73,74,81,82,88,89,94,95,99,107,113,114,119,120,121,125,126,127,128];
%     fprintf('Removing excluded channels.\n');
%     for c = 1:length(chanexcl)
%         chanlist(c) = find(strcmp(sprintf('E%d',chanexcl(c)),{EEG.chanlocs.labels}));
%     end
%     EEG = pop_select(EEG,'nochannel',chanlist);
%     
%     %FILTER
%     lpfreq = 45;
%     fprintf('Low-pass filtering below %dHz...\n',lpfreq);
%     EEG = pop_eegfilt(EEG, 0, lpfreq, [], [0], 0, 0, 'fir1', 0);
%     
%     hpfreq = 0.5;
%     fprintf('High-pass filtering above %dHz...\n',hpfreq);
%     EEG = pop_eegfilt(EEG, hpfreq, 0, [], [0], 0, 0, 'fir1', 0);
    
%     %MANUAL STEP
%     rejartifacts2(basename,2,1,[],[],500,250);
%     
    
%     AUTOMATED
    
%         calcspec(basename);
%     
%         EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');
%         EEG1020 = pop_loadset('filepath',path1020,'filename',[basename '.set'],'loadmode','info');
%         EEG.freqwin = EEG1020.freqwin;
%         for freq = 1:length(EEG1020.freqwin)-1
%             EEG.freqlist(freq,1) = EEG1020.freqwin(freq);
%             EEG.freqlist(freq,2) = EEG1020.freqwin(freq+1);
%         end
%     pop_saveset(EEG,'savemode','resave');
%     
    fix1020(basename);
% 
%     plotspec(basename);
%     saveas(gcf,sprintf('figures/%s_spectrum.jpg',basename));
%     close(gcf);
    
%     coherence(basename);
end