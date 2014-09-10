function batchrun(listname)

loadsubj
subjlist = eval(listname);

for s = 1:size(subjlist,1)
    basename = subjlist{s,1};
    calcpac(basename);
end
