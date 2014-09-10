function testmeasure(listname,conntype,measure,bandidx)

loadpaths
load(sprintf('%s%s\\graphdata_%s_%s.mat',filepath,conntype,listname,conntype));
randgraph = load(sprintf('%s%s\\graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype));
grp = cell2mat(subjlist(:,2:end));

drug = cell2mat(subjlist(:,3));
rt = cell2mat(subjlist(:,4));
hitrate = cell2mat(subjlist(:,5));

weiorbin = 3;
fontsize = 12;

bands = {
    'delta'
    'theta'
    'alpha'
    'beta'
    'gamma'
    };

if exist(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype),'file')
    randgraph = load(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype));
    graph{end+1,1} = 'small-worldness index';
    graph{end,2} = ( mean(graph{1,2},4) ./ mean(randgraph.graph{1,2},4) ) ./ ( graph{2,2} ./ randgraph.graph{2,2}) ;
    graph{end,3} = ( mean(graph{1,3},4) ./ mean(randgraph.graph{1,3},4) ) ./ ( graph{2,3} ./ randgraph.graph{2,3}) ;
end

trange = [0.5 0.025];
trange = (tvals <= trange(1) & tvals >= trange(2));

testlevel = 1;
testgroups = [1 2];
selector = '(grp(:,1) == testlevel & grp(:,5) == g)';

% % Correlate Graph Theory vs Drug Level
% figure('Color','white');
% i = 1;
%     for midx = 1:nmes
%         m = find(strcmp(graphmeasures{midx},graph(:,1)));
%         testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
%         subplot(2,3,i);
%         hold all
%         scatter(drug(drug > 0),testdata(drug > 0));
%         lsline
%         [rho, pval] = corr(drug(drug > 0),testdata(drug > 0),'type','spearman');
%         fprintf('Spearman rho = %.2f P-value = %.3f.\n',rho,pval);
%         ylabel(graph{m,1},'FontSize',fontsize);
%         xlabel('Drug Level');
%         i = i+1;
%     end
% [~,h4]=suplabel('Drug Level vs Graph Theory Metrics','t');
% set(h4,'FontSize',16)
% fprintf('\n')
%
% % Correlate Perceptual RT with Graph Theory Metrics
% i = 1;
% figure('Color','white');
% for midx = 1:nmes
%     m = find(strcmp(graphmeasures{midx},graph(:,1)));
%     testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
%     subplot(2,3,i)
%     hold all
%     scatter(rt(rt ~= -1),testdata(rt ~= -1));
%     lsline
%     [rho, pval] = corr(rt(rt ~= -1),testdata(rt ~= -1),'type','spearman');
%     fprintf('Spearman rho = %.2f P-value = %.3f.\n',rho,pval);
%     ylabel(graph{m,1},'FontSize',fontsize);
%     xlabel('Perceptual RT');
%     set(gca,'XLim',[0 2500]);
%   i = i+1;
% end
% [~,h4]=suplabel('Perceptual RT vs Graph Theory Metrics','t');
% set(h4,'FontSize',16)
% fprintf('\n')

% % Correlate Hit Rate with Graph Theory Metrics
% i = 1;
% figure('Color','white');
% for midx = 1:nmes
%
%     m = find(strcmp(graphmeasures{midx},graph(:,1)));
%     testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
%     subplot(2,3,i)
%     hold all
%     scatter(hitrate(grp(:,1) == 3),testdata(grp(:,1) == 3));
%     [rho, pval] = corr(hitrate(grp(:,1) == 3),testdata(grp(:,1) == 3),'type','spearman');
%     fprintf('Spearman rho = %.2f P-value = %.3f.\n',rho,pval);
%     ylabel(graph{m,1},'FontSize',fontsize);
%     xlabel('Hit Rate');
%     set(gca,'XLim',[0 45]);
%     i = i+1;
% end
% [~,h4]=suplabel('Hit Rate Level 2 vs Graph Theory Metrics','t');
% set(h4,'FontSize',16)

% Correlate Hit Rates at Level 2 with Graph Theory at Level 0

figure('Color','white');
m = find(strcmp(measure,graph(:,1)));
if strcmp(measure,'modules') || strcmp(measure,'centrality')
    testdata = squeeze(mean(max(graph{m,weiorbin}(:,bandidx,trange,:),[],4),3));
elseif strcmp(measure,'mutual information')
    testdata = squeeze(mean(mean(graph{m,weiorbin}(:,:,bandidx,trange),4),2));
elseif strcmp(measure,'participation coefficient')
    testdata = squeeze(mean(std(graph{m,weiorbin}(:,bandidx,trange,:),[],4),3));
else
    testdata = squeeze(mean(mean(graph{m,3}(:,bandidx,trange,:),4),3));
end

hold all
scatter(hitrate(grp(:,1) == 3 & grp(:,5) == testgroups(1)),testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(1)),...
    [],'blue','filled');
scatter(hitrate(grp(:,1) == 3 & grp(:,5) == testgroups(2)),testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(2)),...
    [],'red','filled');
% lsline
% [rho, pval] = corr(hitrate(grp(:,1) == 3),testdata(grp(:,1) == testlevel),'type','spearman');
% fprintf('Spearman rho = %.2f P-value = %.3f.\n',rho,pval);
ylabel(graph{m,1},'FontSize',fontsize);
xlabel('Hit Rate');

title('Level 2 Hit Rate vs Level 0 Graph Theory Metrics');

figure('Color','white');
m = find(strcmp(measure,graph(:,1)));
hold all
for g = 1:2
    groupmean(g) = mean(testdata(eval(selector)));
    groupste(g) = std(testdata(eval(selector)))/sqrt(length(testdata(eval(selector))));
end
barweb(groupmean,groupste,[],[],[],'Responsive vs Decreased Hits',graph{m,1});
[~,p,~,stats] = ttest2(testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(1)),...
    testdata(grp(:,1) == testlevel & grp(:,5) == testgroups(2)),[],[],'unequal');
fprintf('t = %.2f, p = %.4f.\n',stats.tstat,p);

title('Level 0 Graph Theory Metrics: Fully Responsive vs Decreased Hit Rates at Level 2');
