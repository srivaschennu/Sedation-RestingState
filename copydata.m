function copydata(listname,outpath)

loadpaths
loadsubj

subjlist = eval(listname);
grp = cell2mat(subjlist(:,2:end));

for s = 1:length(subjlist)
    if grp(s,5) ~= 0
        fprintf('Copying %s...',subjlist{s});
        copyfile([filepath subjlist{s} '.set'],[outpath num2str(s) '.set']);
        copyfile([filepath subjlist{s} '.fdt'],[outpath num2str(s) '.fdt']);
        %     copyfile([filepath 'wpli/' subjlist{s} 'wplifdr.mat'],[outpath 'wpli/' subjlist{s} 'wplifdr.mat']);
        fprintf('\n');
    end
end