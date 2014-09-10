function batchrun

loadsubj

for s = 1:size(subjlist,1)
    basename = subjlist{s,1};
    ftcoherence(basename);
end