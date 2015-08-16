function copydata(listname,outpath)

loadpaths
loadsubj

subjlist = eval(listname);

for s = 1:length(subjlist)
    fprintf('Copying %s...',subjlist{s});
    copyfile([filepath subjlist{s} '.set'],[outpath subjlist{s} '.set']);
    copyfile([filepath subjlist{s} '.fdt'],[outpath subjlist{s} '.fdt']);
%     copyfile([filepath 'wpli/' subjlist{s} 'wplifdr.mat'],[outpath 'wpli/' subjlist{s} 'wplifdr.mat']);
    fprintf('\n');
end