function fix1020(basename)

loadpaths

chanlocmat = 'GSN-HydroCel-128.mat';
% 
% EEG = pop_loadset('filepath','/Users/chennu/Data/RestingState/','filename',[basename '_orig.set'],'loadmode','info');
% 
% RENAME 10/20 CHANNELS
% load([chanlocpath chanlocmat]);
% for c = 1:length(idx1020)
%     chanidx = strcmp(sprintf('E%d',idx1020(c)),{EEG.chanlocs.labels});
%     if sum(chanidx) == 1
%         fprintf('Replaced %s with %s.\n',EEG.chanlocs(chanidx).labels,name1020{c});
%         EEG.chanlocs(chanidx).labels = name1020{c};
%     end
% end
% 
% pop_saveset(EEG,'savemode','resave');
% 
% 
% 
% EEG = pop_loadset('filepath','/Users/chennu/Data/RestingState/','filename',[basename '_epochs.set'],'loadmode','info');
% 
% RENAME 10/20 CHANNELS
% load([chanlocpath chanlocmat]);
% for c = 1:length(idx1020)
%     chanidx = strcmp(sprintf('E%d',idx1020(c)),{EEG.chanlocs.labels});
%     if sum(chanidx) == 1
%         fprintf('Replaced %s with %s.\n',EEG.chanlocs(chanidx).labels,name1020{c});
%         EEG.chanlocs(chanidx).labels = name1020{c};
%     end
% end
% 
% pop_saveset(EEG,'savemode','resave');

EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');

% RENAME 10/20 CHANNELS
load([chanlocpath chanlocmat]);
for c = 1:length(idx1020)
    chanidx = strcmp(sprintf('E%d',idx1020(c)),{EEG.chanlocs.labels});
    if sum(chanidx) == 1
        fprintf('Replaced %s with %s.\n',EEG.chanlocs(chanidx).labels,name1020{c});
        EEG.chanlocs(chanidx).labels = name1020{c};
    end
end

pop_saveset(EEG,'savemode','resave');

fprintf('Loading %s%splifdr.mat\n', filepath, basename);
EEG = load([filepath basename 'plifdr.mat']);
% RENAME 10/20 CHANNELS
load([chanlocpath chanlocmat]);
for c = 1:length(idx1020)
    chanidx = strcmp(sprintf('E%d',idx1020(c)),{EEG.chanlocs.labels});
    if sum(chanidx) == 1
        fprintf('Replaced %s with %s.\n',EEG.chanlocs(chanidx).labels,name1020{c});
        EEG.chanlocs(chanidx).labels = name1020{c};
    end
end

save([filepath basename 'plifdr.mat'],'-struct','EEG');

% fprintf(['Loading ' filepath basename 'spectra.mat\n']);
% EEG = load([filepath basename 'spectra.mat']);
% % RENAME 10/20 CHANNELS
% load([chanlocpath chanlocmat]);
% for c = 1:length(idx1020)
%     chanidx = strcmp(sprintf('E%d',idx1020(c)),{EEG.chann.labels});
%     if sum(chanidx) == 1
%         fprintf('Replaced %s with %s.\n',EEG.chann(chanidx).labels,name1020{c});
%         EEG.chann(chanidx).labels = name1020{c};
%     end
% end

% save([filepath basename 'spectra.mat'],'-struct','EEG');