function plotmap(listname,conntype,measure,plotlevel,bandidx,varargin)
    
param = finputcheck(varargin, {
    'changroup', 'string', [], ''; ...
    'caxis', 'real', [], []; ...
    'xlabel', 'string', '', ''; ...
    'ylabel', 'string', '', measure; ...
    });

loadpaths
changroups

load chanlist

weiorbin = 2;

fontname = 'Helvetica';
fontsize = 28;

if strcmpi(measure,'power')
    load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    power = load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    plotdata = power.bandpower * 100;
elseif strcmpi(measure,'pac')
    load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    for s = 1:size(allpac,1)
        plotdata(s,1,:) = diag(squeeze(allpac(s,1,:,:)));
%         plotdata(s,1,:) = squeeze(allpac(s,1,:,strcmp('Oz',{sortedlocs.labels})));
    end
    plotdata = repmat(plotdata,1,5,1);
elseif strcmpi(measure,'meanwpli')
    load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
    plotdata = mean(allcoh,4);
else
    load(sprintf('%s/%s/graphdata_%s_%s.mat',filepath,conntype,listname,conntype));
    
    m = find(strcmpi(measure,graph(:,1)));
    
    randgraph = load(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype));
    if strcmpi(measure,'centrality')
        graph{m,2} = graph{m,2} / ((length(sortedlocs)-1) * (length(sortedlocs)-2));
        randgraph.graph{m,2} = randgraph.graph{m,2} / ((length(sortedlocs)-1) * (length(sortedlocs)-2));
    end
    graph{m,2} = graph{m,2} ./ mean(randgraph.graph{m,2},ndims(randgraph.graph{m,2}));
    
    plotdata = graph{m,weiorbin};
    trange = [0.5 0.1];
    trange = (tvals <= trange(1) & tvals >= trange(2));
    plotdata = squeeze(mean(plotdata(:,:,trange,:),3));
end

loadsubj
subjlist = eval(listname);

grp = cell2mat(subjlist(:,2:end));
drug = cell2mat(subjlist(:,3));
rt = cell2mat(subjlist(:,4));
hitrate = cell2mat(subjlist(:,5));

bands = {
    'delta'
    'theta'
    'alpha'
    'beta'
    'gamma'
    };

grouplist = {
    'Responsive'
    'Drowsy'
    };

levelnames = {'Baseline','Mild Sedation','Moderate Sedation','Recovery'};

for g = 1:length(grouplist)
    groupvals = squeeze(mean(plotdata(grp(:,5) == g & grp(:,1) == plotlevel,bandidx,:),1));
    figname = sprintf('%s %s level %d',grouplist{g},bands{bandidx},plotlevel);
    figure('Color','white','Name',figname);
    if isempty(param.changroup) || g == 3
        topoplot(groupvals,sortedlocs,'maplimits','maxmin','numcontour',0);
    else
        topoplot(groupvals,sortedlocs,'maplimits','maxmin','numcontour',0,'pmask',ismember({sortedlocs.labels},eval(param.changroup)));
    end
        
    if ~isempty(param.caxis)
        caxis(param.caxis);
    end
    colorbar;
    set(gca,'FontName',fontname,'FontSize',fontsize);
    set(gcf,'Color','white');
    export_fig(gcf,sprintf('figures/%s_%s_%s_%s_topo.eps',grouplist{g},measure,levelnames{plotlevel},bands{bandidx}));
    close(gcf);
end

% hitrate = hitrate((grp(:,5) == 1 | grp(:,5) == 2) & grp(:,1) == 4) - hitrate((grp(:,5) == 1 | grp(:,5) == 2) & grp(:,1) == plotlevel);
% rt = rt(grp(:,5) == 1 & grp(:,1) == plotlevel) ./ rt(grp(:,5) == 1 & grp(:,1) == 4);
% drug = drug((grp(:,5) == 1 | grp(:,5) == 2) & grp(:,1) == plotlevel);% ./ drug((grp(:,5) == 1 | grp(:,5) == 2) & grp(:,1) == 4);
% regressor = 'drug';
% 
% for c = 1:length(sortedlocs)
%     if strcmp(regressor,'rt')
%         regvals = plotdata(grp(:,5) == 1 & grp(:,1) == plotlevel,bandidx,c) ./ plotdata(grp(:,5) == 1 & grp(:,1) == 4,bandidx,c);
%     else
%         regvals = plotdata((grp(:,5) == 1 | grp(:,5) == 2) & grp(:,1) == plotlevel,bandidx,c);% ./ plotdata((grp(:,5) == 1 | grp(:,5) == 2) & grp(:,1) == 4,bandidx,c);
%     end
% 
%     if strcmp(regressor,'hitrate')
%         [rvals(c),pvals(c)] = corr(eval(regressor),regvals,'type','spearman');
%     else
% %         [rvals(c),pvals(c)] = corr(eval(regressor),regvals);
%         mdl = LinearModel.fit(eval(regressor),regvals,'RobustOpts','on');
%         rvals(c) = mdl.Rsquared.Adjusted;
%         pvals(c) = doftest(mdl);
%     end
%     
%     if strcmp(sortedlocs(c).labels,'Oz')
%         figure('Color','white');
%         hold all
%         scatter(eval(regressor),regvals,150,'^','blue','filled');
%         b = mdl.Coefficients.Estimate;
%         plot(eval(regressor),b(1)+b(2)*eval(regressor),'-','Color','black','LineWidth',2,...
%     'Display',sprintf('R^2 = %.2f, p = %.3f',mdl.Rsquared.Adjusted,doftest(mdl)));
%         set(gca,'FontName',fontname,'FontSize',fontsize);
%         if isempty(param.xlabel)
%             param.xlabel = regressor;
%         end
%         xlabel(param.xlabel,'FontName',fontname,'FontSize',fontsize);
%         ylabel(param.ylabel,'FontName',fontname,'FontSize',fontsize);
%         legend('toggle');
%     end
% end
% 
% figname = sprintf('%s level %d: %s vs. %s',bands{bandidx},plotlevel,measure,regressor);
% figure('Color','white','Name',figname);
% topoplot(rvals,sortedlocs,'maplimits','maxmin'); colorbar
% set(gca,'FontName',fontname,'FontSize',fontsize);
% set(gcf,'Color','white');