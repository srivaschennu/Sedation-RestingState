function calcpac(basename)

loadpaths

lowfreqrange = [0.01 4];
highfreqrange = [8 15];

EEG = pop_loadset('filepath',filepath,'filename',[basename '.set']);
chanlocs = EEG.chanlocs;

fprintf('Calculating PAC between phase of %.1f-%.1fHz and amplitude of %.1f-%.1fHz.\n',lowfreqrange,highfreqrange);
[PAC,lowfreqs,highfreqs] = bst_pac(reshape(EEG.data,EEG.nbchan,EEG.pnts*EEG.trials),EEG.srate,lowfreqrange,highfreqrange);

PAC = abs(PAC) .* sign((pi/2) - abs(angle(PAC)));

for c1 = 1:length(chanlocs)
    for c2 = 1:length(chanlocs)
        chanPAC = PAC(c1,c2,lowfreqs >= 0.1 & lowfreqs <= 1,:);
        [~, maxidx] = max(abs(chanPAC(:)));
        matPAC(c1,c2) = chanPAC(maxidx);
    end
end

fprintf('Saving %s%spac.mat\n',filepath,basename);
save([filepath basename 'pac.mat'],'chanlocs','PAC','lowfreqs','highfreqs','matPAC');
