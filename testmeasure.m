function [dataout,grpout,pval,stats] = testmeasure(listname,conntype,measure,testlevel,bandidx,varargin)

param = finputcheck(varargin, {
    'changroup', 'string', [], ''; ...
    'xlabel', 'string', [], measure; ...
    'ylabel', 'string', [], ''; ...
    'xlim', 'real', [], []; ...
    'ylim', 'real', [], []; ...
    'xtick', 'real', [], []; ...
    'ytick', 'real', [], []; ...
    'legendlocation', 'string', [], 'Best'; ...
    });

fontname = 'Helvetica';
fontsize = 34;

loadpaths
loadsubj
changroups

load chanlist

subjlist = eval(listname);
drug = cell2mat(subjlist(:,3))/1000;
rt = cell2mat(subjlist(:,4));
hitrate = (cell2mat(subjlist(:,5))/40)*100;

colorlist = [
    0 0.0 1
    0 0.5 0
%     0.5 0.0 0
%     0   0.5 0.5
    ];

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
    testdata = mean(mean(allcoh(:,bandidx,ismember({sortedlocs.labels},eval(param.changroup)),ismember({sortedlocs.labels},eval(param.changroup))),4),3);
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
    200,colorlist(1,:),markers{testgroups(1)},'filled');
scatter(testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(2)),hitrate(grp(:,1) == 3 & grp(:,5) == testgroups(2)),...
    200,colorlist(2,:),markers{testgroups(2)},'filled');

set(gca,'FontName',fontname,'FontSize',fontsize);
if isempty(param.ylabel)
    ylabel('Perceptual hit rate (%)','FontName',fontname,'FontSize',fontsize);
else
    ylabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
end

xlabel(param.xlabel,'FontName',fontname,'FontSize',fontsize);
if ~isempty(param.xlim)
    set(gca,'XLim',param.xlim);
end
if ~isempty(param.ytick)
    set(gca,'YTick',param.ytick);
end

% xlimits = xlim;
% xdata = testdata(grp(:,1) == testlevel);
% ydata = drug(grp(:,1) == 3);
% zdata = hitrate(grp(:,1) == 3);
% grpdata = grp(grp(:,1) == testlevel,5);
% for p = 1:size(xdata,1)
%     if grpdata(p) == testgroups(1) || grpdata(p) == testgroups(2)
%         plot3([xdata(p) xdata(p)],[ydata(p) ydata(p)],[zdata(p) 0],'LineStyle',':','Color',colorlist(grpdata(p),:));
% %         plot3([xdata(p) xlimits(2)],[ydata(p) ydata(p)],[zdata(p) zdata(p)],'LineStyle',':','Color',colorlist(grpdata(p),:));
% %         plot3([xdata(p) xdata(p)],[ydata(p) 0],[zdata(p) zdata(p)],'LineStyle',':','Color',colorlist(grpdata(p),:));
%     end
% end
% 
% view(-46,30)
% grid on
% zlabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
% ylabel('Drug in blood (\mug/ml)')
% set(gca,'YDir','reverse')

figpos = get(gcf,'Position');
figpos(3) = figpos(3)*9/8;
set(gcf,'Position',figpos);

export_fig(gcf,sprintf('figures/%s_scatter_%s_%s.eps',measure,levelnames{testlevel},bands{bandidx}));
close(gcf);


%bar graph
figure('Color','white');
figpos = get(gcf,'Position');
figpos(3) = figpos(3)*1/2;
% figpos(4) = figpos(4)*3/4;
set(gcf,'Position',figpos);

hold all
if strcmpi(measure,'power') && bandidx <= 3
    testdata2 = mean(power.bandpower(:,bandidx,ismember({sortedlocs.labels},eval('frontalalpha'))),3) * 100;
end
dataout = [];
grpout = [];
for g = 1:2
    if strcmpi(measure,'power') && bandidx <= 3
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
for g = 1:2
    set(hdl.bars(g),'FaceColor',colorlist(g,:));
end
xlabel(levelnames{testlevel},'FontName',fontname,'FontSize',fontsize);
ylabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
if ~isempty(param.ytick)
    set(gca,'YTick',param.ytick);
end
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

legendoff(scatter(xdata{1}(keepidx{1}),ydata{1}(keepidx{1}),200,colorlist(1,:),'^','filled'));
legendoff(scatter(xdata{1}(~keepidx{1}),ydata{1}(~keepidx{1}),200,colorlist(1,:),'^'));
legendoff(scatter(xdata{2}(keepidx{2}),ydata{2}(keepidx{2}),200,colorlist(2,:),'v','filled'));
legendoff(scatter(xdata{2}(~keepidx{2}),ydata{2}(~keepidx{2}),200,colorlist(2,:),'v'));

mdl = LinearModel.fit(xvals(keepvals),yvals(keepvals));
b = mdl.Coefficients.Estimate;
plot(sort(xvals),b(1)+b(2)*sort(xvals),'Color','black','LineWidth',2,'LineStyle','--',......
    'Display',sprintf('R^2 = %.2f, p = %.4f',mdl.Rsquared.Adjusted,doftest(mdl)));

set(gca,'FontName',fontname,'FontSize',fontsize);
xlabel(param.xlabel,'FontName',fontname,'FontSize',fontsize);
ylabel('Drug in blood (\mug/ml)','FontName',fontname,'FontSize',fontsize);
if ~isempty(param.xlim)
    xlim(param.xlim);
end
legend('Location','Best');
legend('boxoff');

figpos = get(gcf,'Position');
figpos(3) = figpos(3)*3/2;
% figpos(4) = figpos(4)/2;
% set(gcf,'Position',figpos);
if ~isempty(param.xtick)
    set(gca,'XTick',param.xtick);
end
if ~isempty(param.ylim)
    ylim(param.ylim);
end

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

legendoff(scatter(xdata(keepidx),ydata(keepidx),200,colorlist(1,:),'^','filled'));
legendoff(scatter(xdata(~keepidx),ydata(~keepidx),200,colorlist(1,:),'^','filled'));

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

% %optionally plot drowsy group at infinity reaction time
% yticks = get(gca,'YTick');
% ylimits = ylim;
% ylim([ylimits(1) ylimits(2) + (yticks(2)-yticks(1))]);
% 
% xdata2 = testdata(grp(:,1) == testlevel & grp(:,5) == 2) ./ testdata(grp(:,1) == 4 & grp(:,5) == 2);
% ydata2 = repmat(yticks(end) + (yticks(2)-yticks(1)),length(xdata2),1);
% legendoff(scatter(xdata2,ydata2,200,colorlist(2,:),'v','filled'));
% 
% yticklabels = get(gca,'YTickLabel');
% yticklabels = mat2cell(yticklabels,ones(size(yticklabels,1),1));
% yticklabels{end} = '   ';
% set(gca,'YTickLabel',yticklabels);

legend('Location',param.legendlocation);
legend('boxoff');

figpos = get(gcf,'Position');
% figpos(3) = figpos(3)*3/2;
% figpos(4) = figpos(4)/2;
set(gcf,'Position',figpos);

export_fig(gcf,sprintf('figures/%s_vs_rt_%s_%s.eps',measure,levelnames{testlevel},bands{bandidx}));
close(gcf);
