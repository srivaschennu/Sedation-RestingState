function batchrun(listname)

loadsubj
loadpaths

subjlist = eval(listname);

for s = 1:size(subjlist,1)
    basename = subjlist{s,1};
    EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'], 'loadmode','info');
    batchres{s,1} = basename;
    batchres{s,2} = subjlist{s,2};
    batchres{s,3} = EEG.trials;% * EEG.pnts/EEG.srate;
    if isfield(EEG,'rejepoch')
        batchres{s,4} = length(EEG.rejepoch);% * EEG.pnts/EEG.srate;
    else
        batchres{s,4} = 0;
    end
end

save batchres.mat batchres