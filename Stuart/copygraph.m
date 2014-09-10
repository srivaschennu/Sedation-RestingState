function copygraph(listname,conntype,randomise)

loadpaths
loadsubj

if ~exist('randomise','var') || isempty(randomise)
    randomise = false;
end

subjlist = eval(listname);

if randomise
    savename = sprintf('%s%s\\graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype);
else
    savename = sprintf('%s%s\\graphdata_%s_%s.mat',filepath,conntype,listname,conntype);
end

oldgraph = load(savename);
graph = oldgraph.graph(:,1);
grp = oldgraph.grp;
tvals = oldgraph.tvals;

for s = 1:size(subjlist,1)
    basename = subjlist{s,1};
    grp(s,1) = subjlist{s,2};
    
    oldsubjidx = find(strcmp(basename,oldgraph.subjlist(:,1)));
    if isempty(oldsubjidx)
        error('%d: %s not found!',s,basename);
    elseif s ~= oldsubjidx
        fprintf('%d: found %s at position %d.\n',s,basename,oldsubjidx);
    end
    for m = 1:size(graph,1)
        if ndims(oldgraph.graph{m,3}) == 3
            graph{m,3}(s,:,:) = oldgraph.graph{m,3}(oldsubjidx,:,:);
        elseif ndims(oldgraph.graph{m,3}) == 4
            graph{m,3}(s,:,:,:) = oldgraph.graph{m,3}(oldsubjidx,:,:,:);
        end
    end
end

save(savename, 'graph', 'grp', 'tvals', 'subjlist');
