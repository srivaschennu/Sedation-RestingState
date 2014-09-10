function preprocessdata

loadpaths

filelist = dir([filepath '*.set']);

for f = 1:length(filelist)
    [~,newname] = fileparts(filelist(f).name);
    EEG = pop_loadset('filepath',filepath,'filename',[newname '.set']);
    EEG.setname = newname;
    EEG.filename = [newname '.set'];
    EEG.datfile = [newname '.fdt'];
    pop_saveset(EEG,'savemode','resave');
    
%     %     EEG = select1020(EEG);
%     
%     % REMOVE EXCLUDED CHANNELS
%     chanexcl = [1,8,14,17,21,25,32,38,43,44,48,49,56,63,64,68,69,73,74,81,82,88,89,94,95,99,107,113,114,119,120,121,125,126,127,128];
%     %chanexcl = [];
%     fprintf('Removing excluded channels.\n');
%     EEG = pop_select(EEG,'nochannel',chanexcl);
%     
%     %     EEG = rereference(EEG,1);
%     
%     lpfreq = 45;
%     fprintf('Low-pass filtering below %dHz...\n',lpfreq);
%     EEG = pop_eegfilt(EEG, 0, lpfreq, [], [0], 0, 0, 'fir1', 0);
%     hpfreq = 0.5;
%     fprintf('High-pass filtering above %dHz...\n',hpfreq);
%     EEG = pop_eegfilt(EEG, hpfreq, 0, [], [0], 0, 0, 'fir1', 0);
%     
%     pop_saveset(EEG,'filepath',[filepath 'only91/'],'filename', EEG.filename);
end