function [dataout,grpout,pval,stats] = testmeasure(listname,conntype,measure,testlevel,bandidx,varargin)

param = finputcheck(varargin, {
    'changroup', 'string', [], ''; ...
    'xlabel', 'string', [], ''; ...
    'ylabel', 'string', [], measure; ...
    'xlim', 'real', [], []; ...
    'ylim', 'real', [], []; ...
    });

fontname = 'Helvetica';
fontsize = 28;

loadpaths
loadsubj
changroups

load chanlist

subjlist = eval(listname);
drug = cell2mat(subjlist(:,3));
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
elseif strcmpi(measure,'mean')
    load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    testdata = mean(mean(allcoh(:,bandidx,:,:),4),3);
elseif strcmpi(measure,'pac')
    load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    allpac = allpac(:,:,ismember({sortedlocs.labels},eval(param.changroup)),ismember({sortedlocs.labels},eval(param.changroup)));
    for s = 1:size(allpac,1)
        testdata(s,1,:) = mean(diag(squeeze(allpac(s,1,:,:))));
    end
    testdata = repmat(testdata,1,5);
else
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
        testdata = squeeze(mean(max(graph{m,weiorbin}(:,bandidx,trange,:),[],4),3));
    elseif strcmpi(measure,'centrality')
        testdata = squeeze(mean(max(graph{m,weiorbin}(:,bandidx,trange,:),[],4),3));
    elseif strcmpi(measure,'mutual information')
        testdata = squeeze(mean(mean(graph{m,weiorbin}(:,:,bandidx,trange),4),2));
    elseif strcmpi(measure,'participation coefficient')
        testdata = squeeze(mean(std(graph{m,weiorbin}(:,bandidx,trange,:),[],4),3));
    else
        testdata = squeeze(mean(mean(graph{m,weiorbin}(:,bandidx,trange,:),4),3));
    end
end

subjlist = eval(listname);
grp = cell2mat(subjlist(:,2:end));

if strcmp(listname,'fmri')
    bands = {
        'scale2'
        'scale3'
        };
    bandidx = bandidx-1;
else
    bands = {
        'delta'
        'theta'
        'alpha'
        'beta'
        'gamma'
        };
end

levelnames = {'Baseline','Mild','Moderate','Recovery'};

testgroups = [1 2];

markers = {'^','v'};
figure('Color','white');
hold all
scatter(hitrate(grp(:,1) == 3 & grp(:,5) == testgroups(1)),testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(1)),...
    200,'blue',markers{testgroups(1)},'filled');
sg_h = scatter(hitrate(grp(:,1) == 3 & grp(:,5) == testgroups(2)),testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(2)),...
    200,'green',markers{testgroups(2)},'filled');
set(sg_h,'MarkerFaceColor',[0 0.5 0]);
set(gca,'FontName',fontname,'FontSize',fontsize);
xlabel('Perceptual Accuracy (%)','FontName',fontname,'FontSize',fontsize);
ylabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);

xdata = hitrate(grp(:,1) == 3);
ydata = testdata(grp(:,1) == testlevel);

% for d = 1:length(xdata)
%     text(1.05*xdata(d),1.05*ydata(d),sprintf('%d',d),'FontName',fontname,'FontSize',fontsize-4);
% end
export_fig(gcf,sprintf('figures/%s_scatter_%s_%s.eps',measure,levelnames{testlevel},bands{bandidx}));
close(gcf);

% title('Level 2 Hit Rate vs Level 0 Graph Theory Metrics');

figure('Color','white');
figpos = get(gcf,'Position');
figpos(3) = figpos(3)*1/2;
% figpos(4) = figpos(4)/2;
set(gcf,'Position',figpos);

hold all
if strcmpi(measure,'power')
    testdata2 = mean(power.bandpower(:,bandidx,ismember({sortedlocs.labels},eval('frontaldelta'))),3) * 100;
end
dataout = [];
grpout = [];
for g = 1:2
    if strcmpi(measure,'power')
        plotdata = ( testdata2(grp(:,1) == testlevel & grp(:,5) == g) ./ testdata(grp(:,1) == testlevel & grp(:,5) == g) );
    else
        plotdata = testdata(grp(:,1) == testlevel & grp(:,5) == g);
    end
    groupmean(g) = nanmean(plotdata);
    groupste(g) = nanstd(plotdata)/sqrt(length(plotdata));
    dataout = cat(1,dataout,plotdata);
    grpout = cat(1,grpout,repmat(g,length(plotdata),1));
end

hdl = barweb(groupmean,groupste,[],[],[],'','');
[~,pval,~,stats] = ttest2(testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(1)),...
    testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(2)),[],[],'unequal');
fprintf('t(%.1f) = %.2f, p = %.3f.\n',stats.df,stats.tstat,pval);
set(hdl.ax,'FontName',fontname,'FontSize',fontsize);
defcolororder = get(0,'DefaultAxesColorOrder');
set(hdl.bars(2),'FaceColor',defcolororder(2,:));
xlabel(levelnames{testlevel},'FontName',fontname,'FontSize',fontsize);
ylabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
% set(gca,'YTick',[]);
set(gcf,'Color','white');
if ~isempty(param.ylim)
    ylim(param.ylim);
end
export_fig(gcf,sprintf('figures/%s_%s_%s.eps',measure,levelnames{testlevel},bands{bandidx}));
close(gcf);

%title('Level 0 Graph Theory Metrics: Fully Responsive vs Decreased Hit Rates at Level 2');

% Correlate Graph Theory vs Drug Level
xdata = drug(grp(:,1) == testlevel & (grp(:,5) == 1 | grp(:,5) == 2));
ydata = testdata(grp(:,1) == testlevel & (grp(:,5) == 1 | grp(:,5) == 2));
figure('Color','white');
hold all
legendoff(scatter(drug(grp(:,1) == testlevel & grp(:,5) == 1),testdata(grp(:,1) == testlevel & grp(:,5) == 1),200,'^','blue','filled'));
legendoff(scatter(drug(grp(:,1) == testlevel & grp(:,5) == 2),testdata(grp(:,1) == testlevel & grp(:,5) == 2),200,'v','green','filled'));

mdl = LinearModel.fit(xdata,ydata,'RobustOpts','on');
b = mdl.Coefficients.Estimate;
plot(sort(xdata),b(1)+b(2)*sort(xdata),'Color','black','LineWidth',2,'LineStyle','--',......
    'Display',sprintf('R^2 = %.2f, p = %.3f',mdl.Rsquared.Adjusted,doftest(mdl)));
set(gca,'FontName',fontname,'FontSize',fontsize);
xlabel('Drug in blood (\mug/l)','FontName',fontname,'FontSize',fontsize);
ylabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
if ~isempty(param.xlim)
    xlim(param.xlim);
end
legend('Location','Best');
legend('boxoff');

figpos = get(gcf,'Position');
figpos(3) = figpos(3)*3/2;
% figpos(4) = figpos(4)/2;
set(gcf,'Position',figpos);

export_fig(gcf,sprintf('figures/%s_vs_drug_%s_%s.eps',measure,levelnames{testlevel},bands{bandidx}));
close(gcf);

% Correlate Perceptual RT with Graph Theory Metrics
xdata = rt(grp(:,1) == testlevel & grp(:,5) == 1) ./ rt(grp(:,1) == 4 & grp(:,5) == 1);
ydata = testdata(grp(:,1) == testlevel & grp(:,5) == 1) ./ testdata(grp(:,1) == 4 & grp(:,5) == 1);
figure('Color','white');
hold all
legendoff(scatter(xdata(:,1),ydata,200,'^','blue','filled'));
mdl = LinearModel.fit(xdata,ydata,'RobustOpts','on');
b = mdl.Coefficients.Estimate;
plot(sort(xdata),b(1)+b(2)*sort(xdata),'Color','black','LineWidth',2,'LineStyle','--',...
    'Display',sprintf('R^2 = %.2f, p = %.3f',mdl.Rsquared.Adjusted,doftest(mdl)));
set(gca,'FontName',fontname,'FontSize',fontsize);
if isempty(param.xlabel)
    xlabel(sprintf('Relative reaction time',levelnames{testlevel},levelnames{end}),'FontName',fontname,'FontSize',fontsize);
else
    xlabel(param.xlabel,'FontName',fontname,'FontSize',fontsize);
end
ylabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
legend('Location','Best');
legend('boxoff');

figpos = get(gcf,'Position');
figpos(3) = figpos(3)*3/2;
% figpos(4) = figpos(4)/2;
set(gcf,'Position',figpos);

export_fig(gcf,sprintf('figures/%s_vs_rt_%s_%s.eps',measure,levelnames{testlevel},bands{bandidx}));
close(gcf);
% Correlate Hit Rates at Level 2 with Graph Theory at Level 0
