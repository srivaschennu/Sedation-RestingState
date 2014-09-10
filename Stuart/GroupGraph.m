function GroupGraph(listname,measure)

loadpaths
load(sprintf('%s/%s/graphdata_%s_%s.mat',filepath,measure,listname,measure));
grp = cell2mat(subjlist(:,2:end));

weiorbin = 3;
fontsize = 12;

if exist(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,measure,listname,measure),'file')
    randgraph = load(sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,measure,listname,measure));
    graph{end+1,1} = 'small-worldness index';
    graph{end,2} = ( mean(graph{1,2},4) ./ mean(randgraph.graph{1,2},4) ) ./ ( graph{2,2} ./ randgraph.graph{2,2}) ;
    graph{end,3} = ( mean(graph{1,3},4) ./ mean(randgraph.graph{1,3},4) ) ./ ( graph{2,3} ./ randgraph.graph{2,3}) ;
end

bands = {
    'delta'
    'theta'
    'alpha'
    'beta'
    'gamma'
    };

plotlist = {
%         'clustering'
%         'characteristic path length'
%         'global efficiency'
    'small-worldness index'
    'modularity'
    % %     'modules'
%         'centrality'
%     'participation coefficient'
%     'modular span'
    %     'mutual information'
    %     'connection density'
    %     'rentian scaling'
    %     'threshold'
    };

trange = [0.5 0.025];
trange = (tvals <= trange(1) & tvals >= trange(2));
plottvals = tvals(trange);
nfreq = size(graph{1,3},2);
nmes = length(plotlist);

figure;
i = 1;
selectfreqs = 1:3;
for f = selectfreqs
    for midx = 1:nmes
        subplot(length(selectfreqs),nmes,i);
        hold all
        m = find(strcmp(plotlist{midx},graph(:,1)));
        if isempty(m)
            continue;
        end
        for g = 1:2
            groupvals = squeeze(mean(graph{m,weiorbin}(grp(:,1) == 1 & grp(:,7) == g,f,trange),1));
            groupstd = squeeze(std(graph{m,weiorbin}(grp(:,1) == 1 & grp(:,7) == g,f,trange)))/sqrt(length(groupvals));
            errorbar(plottvals,groupvals,groupstd);
            hold all
        end
        %         if strcmp(graph{m,1},'modular span')
        %            set(gca,'YLim',[0.2 0.4])
        %         end
        %         if strcmp(graph{m,1},'small-worldness index')
        %            set(gca,'YLim',[0.8 1.6])
        %         end
        %         if strcmp(graph{m,1},'modularity')
        %            set(gca,'YLim',[0.05 0.35])
        %         end
        set(gca,'Xdir','reverse','XLim',[min(plottvals) max(plottvals)],'XTick',[0.1 0.2 0.3 0.4 0.5],'XTickLabel',[0.1 0.2 0.3 0.4 0.5],...
            'FontSize',fontsize);
        xlabel('Graph connection density','FontSize',fontsize);
        ylabel(graph{m,1},'FontSize',fontsize);
        i = i+1;
    end
end


% [~,h4]=suplabel('Fully Responsive vs Decreased Hit Rates - Graph Theory Metrics','t');
% set(h4,'FontSize',16);
legend('Location',[0.01 0.92 0.1 0.1],'Fully Responsive','Decreased Hits');
% legend('Location',[0.01 0.92 0.1 0.1],'Level 1','Level 3');
end








