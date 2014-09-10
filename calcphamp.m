function calcphamp(basename)

loadpaths
changroups

lowfreqrange = [0.01 4];
highfreqrange = [8 15];

EEG = pop_loadset('filepath',filepath,'filename',[basename '.set']);
chanlocs = EEG.chanlocs;

fprintf('Calculating PAC between phase of %.1f-%.1fHz and amplitude of %.1f-%.1fHz.\n',lowfreqrange,highfreqrange);
[PAC,lowfreqs,highfreqs,PHASE,AMP] = bst_pac(reshape(EEG.data,EEG.nbchan,EEG.pnts*EEG.trials),EEG.srate,lowfreqrange,highfreqrange);

fprintf('Saving %s%sphamp.mat\n',filepath,basename);
save([filepath basename 'phamp.mat'],'chanlocs','PAC','lowfreqs','highfreqs','PHASE','AMP');

