function [dataout,grpout,pval,stats] = testmeasure(listname,conntype,measure,testlevel,bandidx,varargin)

param = finputcheck(varargin, {
    'changroup', 'string', [], ''; ...
    'xlabel', 'string', [], measure; ...
    'ylabel', 'string', [], ''; ...
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


%scatter plot
markers = {'^','v'};
figure('Color','white');
hold all
scatter(testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(1)),hitrate(grp(:,1) == 3 & grp(:,5) == testgroups(1)),...
    200,'blue',markers{testgroups(1)},'filled');
sg_h = scatter(testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(2)),hitrate(grp(:,1) == 3 & grp(:,5) == testgroups(2)),...
    200,'green',markers{testgroups(2)},'filled');
set(sg_h,'MarkerFaceColor',[0 0.5 0]);
set(gca,'FontName',fontname,'FontSize',fontsize);
xlabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
ylabel('Perceptual Accuracy (%)','FontName',fontname,'FontSize',fontsize);

export_fig(gcf,sprintf('figures/%s_scatter_%s_%s.eps',measure,levelnames{testlevel},bands{bandidx}));
close(gcf);


%bar graph
figure('Color','white');
figpos = get(gcf,'Position');
figpos(3) = figpos(3)*1/2;
% figpos(4) = figpos(4)/2;
set(gcf,'Position',figpos);

hold all
if strcmpi(measure,'power')
    testdata2 = mean(power.bandpower(:,bandidx,ismember({sortedlocs.labels},eval('frontalalpha'))),3) * 100;
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


% Correlate Graph Theory vs Drug Level
for g = 1:2
    xdata{g,1} = testdata(grp(:,1) == testlevel & (grp(:,5) == g));
    ydata{g,1} = drug(grp(:,1) == testlevel & (grp(:,5) == g));
end
figure('Color','white');
hold all

xvals = cell2mat(xdata);
yvals = cell2mat(ydata);
keepvals = true(length(xvals),1);
keepvals(isnan(cell2mat(xdata))) = 0;
[~,~,~,outid,~,~] = skipped_correlation(xvals(keepvals),yvals(keepvals),0);
keepvals(outid{1}) = 0;
keepidx{1,1} = keepvals(1:length(xdata{1}),1);
keepidx{2,1} = keepvals(length(xdata{1})+1 : (length(xdata{1})+length(xdata{2})) );

legendoff(scatter(xdata{1}(keepidx{1}),ydata{1}(keepidx{1}),200,'^','blue','filled'));
legendoff(scatter(xdata{1}(~keepidx{1}),ydata{1}(~keepidx{1}),200,'^','blue'));
legendoff(scatter(xdata{2}(keepidx{2}),ydata{2}(keepidx{2}),200,'v','green','filled'));
legendoff(scatter(xdata{2}(~keepidx{2}),ydata{2}(~keepidx{2}),200,'v','green'));

mdl = LinearModel.fit(xvals(keepvals),yvals(keepvals));
b = mdl.Coefficients.Estimate;
plot(sort(xvals),b(1)+b(2)*sort(xvals),'Color','black','LineWidth',2,'LineStyle','--',......
    'Display',sprintf('R^2 = %.2f, p = %.3f',mdl.Rsquared.Adjusted,doftest(mdl)));

set(gca,'FontName',fontname,'FontSize',fontsize);
xlabel(param.xlabel,'FontName',fontname,'FontSize',fontsize);
ylabel('Drug in blood (\mug/l)','FontName',fontname,'FontSize',fontsize);
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
xdata = testdata(grp(:,1) == testlevel & grp(:,5) == 1) ./ testdata(grp(:,1) == 4 & grp(:,5) == 1);
ydata = rt(grp(:,1) == testlevel & grp(:,5) == 1) ./ rt(grp(:,1) == 4 & grp(:,5) == 1);
figure('Color','white');
hold all

keepidx = true(length(xdata),1);
keepidx(isnan(xdata)) = 0;
[~,~,~,outid,~,~] = skipped_correlation(xdata(keepidx),ydata(keepidx),0);
keepidx(outid{1}) = 0;

legendoff(scatter(xdata(keepidx),ydata(keepidx),200,'^','blue','filled'));
legendoff(scatter(xdata(~keepidx),ydata(~keepidx),200,'^','blue'));

mdl = LinearModel.fit(xdata(keepidx),ydata(keepidx));
b = mdl.Coefficients.Estimate;
plot(sort(xdata),b(1)+b(2)*sort(xdata),'Color','black','LineWidth',2,'LineStyle','--',...
    'Display',sprintf('R^2 = %.2f, p = %.3f',mdl.Rsquared.Adjusted,doftest(mdl)));

set(gca,'FontName',fontname,'FontSize',fontsize);
xlabel(param.xlabel,'FontName',fontname,'FontSize',fontsize);
if isempty(param.ylabel)
    ylabel('Relative reaction time','FontName',fontname,'FontSize',fontsize);
else
    ylabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
end
if ~isempty(param.xlim)
    xlim(param.xlim);
end
if ~isempty(param.ylim)
    ylim(param.ylim);
end
legend('Location','Best');
legend('boxoff');

figpos = get(gcf,'Position');
figpos(3) = figpos(3)*3/2;
% figpos(4) = figpos(4)/2;
set(gcf,'Position',figpos);

export_fig(gcf,sprintf('figures/%s_vs_rt_%s_%s.eps',measure,levelnames{testlevel},bands{bandidx}));
close(gcf);
