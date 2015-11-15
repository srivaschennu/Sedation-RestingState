function groupgraph(listname,conntype,varargin)

loadpaths
loadsubj

param = finputcheck(varargin, {
    'randomise', 'string', {'on','off'}, 'off'; ...
    'latticise', 'string', {'on','off'}, 'off'; ...
    });

load chanlist

subjlist = eval(listname);

if strcmp(param.randomise,'on')
    savename = sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype);
    filesuffix = 'randgraph';
elseif strcmp(param.latticise,'on')
    savename = sprintf('%s/%s/graphdata_%s_latt_%s.mat',filepath,conntype,listname,conntype);
    filesuffix = 'lattgraph';
else
    savename = sprintf('%s/%s/graphdata_%s_%s.mat',filepath,conntype,listname,conntype);
    filesuffix = 'graph';
end

for s = 1:size(subjlist,1)
    basename = subjlist{s,1};
    grp(s,1) = subjlist{s,2};
    
    fprintf('Processing %s.\n',basename);
    
    loadname = sprintf('%s/%s/%s%s%s.mat',filepath,conntype,basename,conntype,filesuffix);
    load(loadname);
    
    if s == 1
        graph = graphdata(:,1);
        for m = 1:size(graph,1)
            graph{m,2} = zeros([size(subjlist,1) size(graphdata{m,2})]);
            graph{m,3} = zeros([size(subjlist,1) size(graphdata{m,3})]);
        end
    end
    
    for m = 1:size(graph,1)
        graph{m,2}(s,:) = graphdata{m,2}(:);
        graph{m,3}(s,:) = graphdata{m,3}(:);
    end
    
%     %clustering coeffcient
%     graph{1,2}(s,:,:,:,:) = graphdata{1,2};
%     
%     %characteristic path length
%     graph{2,2}(s,:,:,:) = graphdata{2,2};
%     
%     %global efficiency
%     graph{3,2}(s,:,:,:) = graphdata{3,2};
%     
%     % modularity
%     graph{4,2}(s,:,:,:) = graphdata{4,2};
%     
%     % community structure
%     graph{5,2}(s,:,:,:,:) = graphdata{5,2};
%     
%     %betweenness centrality
%     graph{6,2}(s,:,:,:,:) = graphdata{6,2};
%     
%     %modular span
%     graph{7,2}(s,:,:,:) = graphdata{7,2};
%     
%     %participation coefficient
%     graph{8,2}(s,:,:,:,:) = graphdata{8,2};
%     
%     %connection density
%     graph{9,2}(s,:,:,:) = graphdata{9,2};
end

save(savename, 'graph', 'grp', 'tvals', 'subjlist','-v7.3');