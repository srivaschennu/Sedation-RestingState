function [features,labels] = getfeatures(listname,conntype,measure,varargin)

param = finputcheck(varargin, {
    'changroup', 'string', [], 'all'; ...
    'xlabel', 'string', [], measure; ...
    'ylabel', 'string', [], ''; ...
    'xlim', 'real', [], []; ...
    'ylim', 'real', [], []; ...
    'xtick', 'real', [], []; ...
    'ytick', 'real', [], []; ...
    'legendlocation', 'string', [], 'Best'; ...
    'noplot', 'string', {'on','off'}, 'off'; ...
    });

loadpaths
loadsubj
changroups

load chanlist

subjlist = eval(listname);
drug = cell2mat(subjlist(:,3))/1000;
rt = cell2mat(subjlist(:,4));
hitrate = (cell2mat(subjlist(:,5))/40)*100;

weiorbin = 2;

if strcmpi(measure,'drug')
    testdata = drug;
elseif strcmpi(measure,'rt')
    testdata = rt;
elseif strcmpi(measure,'hitrate')
    testdata = hitrate;
elseif strcmpi(measure,'power')
    load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    power = load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    testdata = mean(power.bandpower(:,bandidx,ismember({sortedlocs.labels},eval(param.changroup))),3) * 100;
elseif strcmpi(measure,'median')
    load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    testdata = median(median(allcoh(:,:,ismember({sortedlocs.labels},eval(param.changroup)),ismember({sortedlocs.labels},eval(param.changroup))),4),3);
elseif strcmpi(measure,'pac')
    load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    allpac = allpac(:,:,ismember({sortedlocs.labels},eval(param.changroup)),ismember({sortedlocs.labels},eval(param.changroup)));
    for s = 1:size(allpac,1)
        testdata(s,1,:) = mean(diag(squeeze(allpac(s,1,:,:))));
    end
else
    trange = [0.5 0.1];
    load(sprintf('%s%s//graphdata_%s_%s.mat',filepath,conntype,listname,conntype));
    trange = (tvals <= trange(1) & tvals >= trange(2));
    
    randgraph = load(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype));
    graph{end+1,1} = 'small-worldness';
    graph{end,2} = ( mean(graph{1,2},4) ./ mean(mean(randgraph.graph{1,2},5),4) ) ./ ( graph{2,2} ./ mean(randgraph.graph{2,2},4) ) ;
    %     graph{end,3} = ( mean(graph{1,3},4) ./ mean(mean(randgraph.graph{1,3},5),4) ) ./ ( graph{2,3} ./ mean(randgraph.graph{2,3},4) ) ;
    
    if ~strcmpi(measure,'small-worldness')
        m = find(strcmpi(measure,graph(:,1)));
        graph{m,2} = graph{m,2} ./ mean(randgraph.graph{m,2},ndims(randgraph.graph{m,2}));
        %         graph{m,3} = graph{m,3} ./ mean(randgraph.graph{m,3},ndims(randgraph.graph{m,3}));
    end
    m = find(strcmpi(measure,graph(:,1)));
    testdata = squeeze(graph{m,weiorbin}(:,:,trange,:));
end

subjlist = eval(listname);
grp = cell2mat(subjlist(:,2:end));

if strcmpi(measure,'power') && bandidx <= 3
    testdata2 = mean(power.bandpower(:,bandidx,ismember({sortedlocs.labels},eval('frontalalpha'))),3) * 100;
end
features = [];
labels = [];
for g = 1:2
    if strcmpi(measure,'power') && bandidx <= 3
        plotdata = ( testdata2(grp(:,1) == testlevel & grp(:,5) == g) ./ testdata(grp(:,1) == testlevel & grp(:,5) == g) );
    else
        plotdata = testdata(grp(:,5) == g,:,:,:);
        grpinfo = [repmat(g,[size(plotdata,1) 1]) grp(grp(:,5) == g,1)];
    end
    features = cat(1,features,plotdata);
    labels = cat(1,labels,grpinfo);
end
