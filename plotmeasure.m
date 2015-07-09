function plotmeasure(listname,conntype,measure,plotlevel,bandidx,varargin)

loadpaths
loadsubj

param = finputcheck(varargin, {
    'ylim', 'real', [], []; ...
    'legend', 'string', {'on','off'}, 'on'; ...
    'plotinfo', 'string', {'on','off'}, 'on'; ...
    'plotticks', 'string', {'on','off'}, 'on'; ...
    'ylabel', 'string', {}, measure; ...
    'randratio', 'string', {'on','off'}, 'on'; ...
    'legendposition', 'string', {}, 'NorthEast'; ...
    });

fontname = 'Helvetica';
fontsize = 28;

load(sprintf('%s/%s/graphdata_%s_%s.mat',filepath,conntype,listname,conntype));

subjlist = eval(listname);
grp = cell2mat(subjlist(:,2:end));

if ~exist('measure','var') || isempty(measure)
    for m = 1:size(graph,1)
        fprintf('%s\n',graph{m,1});
    end
    return;
end

weiorbin = 3;

if strcmpi(measure,'small-worldness') || strcmp(param.randratio,'on')
    if exist(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype),'file')
        randgraph = load(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype));
    else
        error('%s/%s/graphdata_%s_rand_%s.mat not found!',filepath,conntype,listname,conntype);
    end
end

if strcmpi(measure,'small-worldness')
    graph{end+1,1} = 'small-worldness';
    graph{end,2} = ( mean(graph{1,2},4) ./ mean(mean(randgraph.graph{1,2},5),4) ) ./ ( graph{2,2} ./ mean(randgraph.graph{2,2},4) ) ;
    graph{end,3} = ( mean(graph{1,3},4) ./ mean(mean(randgraph.graph{1,3},5),4) ) ./ ( graph{2,3} ./ mean(randgraph.graph{2,3},4) ) ;
elseif strcmp(param.randratio,'on')
    m = find(strcmpi(measure,graph(:,1)));
    graph{m,2} = graph{m,2} ./ mean(randgraph.graph{m,2},ndims(randgraph.graph{m,2}));
    graph{m,3} = graph{m,3} ./ mean(randgraph.graph{m,3},ndims(randgraph.graph{m,3}));
end

levelnames = {'Baseline','Mild','Moderate','Recovery'};

bands = {
    'Delta'
    'Theta'
    'Alpha'
    'Beta'
    'Gamma'
    };

trange = [0.5 0.1];
trange = (tvals <= trange(1) & tvals >= trange(2));

groups = [1 2];
selector = '(grp(:,1) == plotlevel & grp(:,5) == groups(g))';

plottvals = tvals(trange);

m = find(strcmpi(measure,graph(:,1)));

    figure('Color','white');
    hold all

    for g = 1:length(groups)
        if strcmp(graph{m,1},'modules')
            groupvals = squeeze(max(graph{m,weiorbin}(eval(selector),bandidx,:,:),[],4));
        elseif strcmp(graph{m,1},'mutual information')
            groupvals = squeeze(mean(graph{m,weiorbin}(eval(selector),eval(selector),bandidx,:),2));
        elseif strcmp(graph{m,1},'participation coefficient')
            groupvals = squeeze(std(graph{m,weiorbin}(eval(selector),bandidx,:,:),[],4));
        else
            groupvals = squeeze(mean(graph{m,weiorbin}(eval(selector),bandidx,:,:),4));
        end
        groupmean = mean(groupvals,1);
        groupste = std(groupvals,[],1)/sqrt(size(groupvals,1));
        set(gca,'XDir','reverse');
        errorbar(plottvals,groupmean(trange),groupste(trange),'LineWidth',1);
        set(gca,'XLim',[plottvals(end) plottvals(1)],'FontName',fontname,'FontSize',fontsize);
        if ~isempty(param.ylim)
            set(gca,'YLim',param.ylim);
        end
        
    end
    
    if strcmp(param.plotticks,'on')
        if bandidx == 1
            ylabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
        else
            ylabel(' ','FontName',fontname,'FontSize',fontsize);
        end
        if bandidx == 1 && strcmp(param.plotinfo,'on')
            xlabel('Graph connection density','FontName',fontname,'FontSize',fontsize);
        else
            xlabel(' ','FontName',fontname,'FontSize',fontsize);
        end
        if bandidx == 1 && strcmp(param.legend,'on')
            legend(groupnames,'Location',param.legendposition);
        end
        
    else
        set(gca,'XTick',[],'YTick',[]);
    end
    
    if bandidx == 1
        ylimits = ylim;
    end
    
    export_fig(gcf,sprintf('figures/%s_%s_%s.eps',listname,measure,bands{bandidx}));
    close(gcf);
end