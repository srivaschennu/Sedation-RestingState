function calcfmridata(listname,conntype)

loadpaths
loadsubj

subjlist = eval(listname);

for s = 1:size(subjlist,1)
    basename = subjlist{s,1};
    fprintf('Processing %s.\n',basename);
    
    load([filepath conntype filesep basename '.mat']);

    for f = 1:size(matrix,1)
        cohmat = zeromean(squeeze(matrix(f,:,:)));
        allcoh(s,f,:,:) = cohmat;
        degree(s,f,:) = degrees_und(cohmat);
    end
    grp(s,1) = subjlist{s,2};
end
save(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype), 'grp', 'allcoh', 'subjlist', 'degree');