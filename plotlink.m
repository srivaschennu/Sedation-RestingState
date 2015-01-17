function plotlink(listname,conntype,measure,bandidx,varargin)

param = finputcheck(varargin, {
    'ylabel', 'string', [], measure; ...
    'ylim', 'real', [], []; ...
    'legend', 'string', {'on','off'}, 'off'; ...
    'xlabel', 'string', {'on','off'}, 'off'; ...
    });

fontname = 'Helvetica';
fontsize = 30;

colorlist = [
%     0 0.0 1
%     0 0.5 0
    0.5 0.0 0
    0   0.5 0.5
    ];

loadpaths

load(sprintf('%s/%s/graphdata_%s_%s.mat',filepath,conntype,listname,conntype));

loadsubj
subjlist = eval(listname);

grp = cell2mat(subjlist(:,2:end));
m = find(strcmpi(measure,graph(:,1)));

if strcmp(listname,'fmri')
    bandidx = bandidx-1;
end

% randgraph = load(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype));
% graph{end+1,1} = 'small-worldness';
% graph{end,2} = ( mean(graph{1,2},4) ./ mean(mean(randgraph.graph{1,2},5),4) ) ./ ( graph{2,2} ./ mean(randgraph.graph{2,2},4) ) ;
% if ~strcmpi(measure,'small-worldness')
%     graph{m,2} = graph{m,2} ./ mean(randgraph.graph{m,2},ndims(randgraph.graph{m,2}));
% end

weiorbin = 2;
trange = [0.5 0.1];
trange = (tvals <= trange(1) & tvals >= trange(2));

switch measure
    case 'drug'
        plotdata = grp(:,2)/1000;
        param.ylabel = 'Drug in blood (\mug/ml)';
    case 'rt'
        plotdata = grp(:,3);
        param.ylabel = 'Reaction times (ms)';
    case 'hits'
        plotdata = (grp(:,4)/40)*100;
        param.ylabel = 'Perceptual hit rate (%)';
    otherwise
    trange = [0.5 0.1];
    load(sprintf('%s%s//graphdata_%s_%s.mat',filepath,conntype,listname,conntype));
    trange = (tvals <= trange(1) & tvals >= trange(2));
    
    randgraph = load(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype));
    graph{end+1,1} = 'small-worldness';
    graph{end,2} = ( mean(graph{1,2},4) ./ mean(mean(randgraph.graph{1,2},5),4) ) ./ ( graph{2,2} ./ mean(randgraph.graph{2,2},4) ) ;
    
    if ~strcmpi(measure,'small-worldness')
        m = find(strcmpi(measure,graph(:,1)));
        graph{m,2} = graph{m,2} ./ mean(randgraph.graph{m,2},ndims(randgraph.graph{m,2}));
    end
    m = find(strcmpi(measure,graph(:,1)));
    if strcmpi(measure,'modules')
        plotdata = squeeze(mean(max(graph{m,weiorbin}(:,bandidx,trange,:),[],4),3));
    elseif strcmpi(measure,'centrality')
        plotdata = squeeze(mean(max(graph{m,weiorbin}(:,bandidx,trange,:),[],4),3));
    elseif strcmpi(measure,'mutual information')
        plotdata = squeeze(mean(mean(graph{m,weiorbin}(:,:,bandidx,trange),4),2));
    elseif strcmpi(measure,'participation coefficient')
        plotdata = squeeze(mean(std(graph{m,weiorbin}(:,bandidx,trange,:),[],4),3));
    else
        plotdata = squeeze(mean(mean(graph{m,weiorbin}(:,bandidx,trange,:),4),3));
    end
end

subjlist = eval(listname);
grp = cell2mat(subjlist(:,2:end));

figure('Color','white');
hold all

markers = {'^','v'};

if strcmp(measure,'rt')
    grouplist = 1;
else
    grouplist = [1 2];
end

groupnames = {'Responsive','Drowsy'};
levelnames = {'Baseline','Mild','Moderate','Recovery'};
bands = {
    'delta'
    'theta'
    'alpha'
    'beta'
    'gamma'
    };

for g = grouplist
    sg_h(g) = scatter(grp(grp(:,5) == g,1),plotdata(grp(:,5) == g),200,colorlist(g,:),markers{g},...
        'filled','DisplayName',groupnames{g});
end

set(gca,'FontSize',fontsize,'FontName',fontname);
set(gca,'XTick',unique(grp(grp(:,5) == g,1)),'XTickLabel',levelnames);
set(gcf,'Color','white');

% set(gca,'XLim',[2 4]);

if strcmp(param.xlabel,'on')
    xlabel('Sedation level');
else
    xlabel(' ');
end

ylabel(param.ylabel);
if ~isempty(param.ylim)
    ylim(param.ylim);
end

if strcmp(param.legend,'on')
    legend('show');
end

for s = 1:4:size(subjlist,1)
    if sum(ismember(grp(s,5),grouplist)) == 1
        linecolor = get(sg_h(grp(s,5)),'CData');
        line([grp(s,1) grp(s+1,1)],[plotdata(s) plotdata(s+1)],'Color',linecolor,'LineWidth',1);
        line([grp(s+1,1) grp(s+2,1)],[plotdata(s+1) plotdata(s+2)],'Color',linecolor,'LineWidth',1);
        line([grp(s+2,1) grp(s+3,1)],[plotdata(s+2) plotdata(s+3)],'Color',linecolor,'LineWidth',1);
    end
end

export_fig(gcf,sprintf('figures/plotlink_%s_%s.eps',measure,bands{bandidx}));
close(gcf);
