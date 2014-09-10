function plotfmrimeasure(listname)

loadpaths
filepath = fmripath;
load(sprintf('%s/graphdata_%s_fMRI.mat',filepath,listname));
grp = cell2mat(subjlist(:,2:end));

weiorbin = 3;
fontsize = 12;

if exist(sprintf('%s/graphdata_%s_rand_fMRI.mat',filepath,listname),'file')
    randgraph = load(sprintf('%s/graphdata_%s_rand_fMRI.mat',filepath,listname));
    graph{end+1,1} = 'small-worldness index';
    graph{end,2} = ( mean(graph{1,2},4) ./ mean(randgraph.graph{1,2},4) ) ./ ( graph{2,2} ./ randgraph.graph{2,2}) ;
    graph{end,3} = ( mean(graph{1,3},4) ./ mean(randgraph.graph{1,3},4) ) ./ ( graph{2,3} ./ randgraph.graph{2,3}) ;
end

scales = {
    'scale2'
    'scale3'
    };

plotlist = {
        'clustering'
    %     'characteristic path length'
    %     'global efficiency'
%     'small-worldness index'
%     'modularity'
    % %     'modules'
    %     'centrality'
%     'participation coefficient'
%     'modular span'
%     'mutual information'
    %     'connection density'
    %     'rentian scaling'
    %     'threshold'
    };

trange = [0.5 0.1];
trange = (tvals <= trange(1) & tvals >= trange(2));
plottvals = tvals(trange);
nfreq = length(scales);
nmes = length(plotlist);

selector = '(grp(:,1) == 1 & grp(:,5) == g)';

figure;
i = 1;

for f = 1:nfreq
    for midx = 1:nmes
        subplot(nfreq,nmes,i);
        hold all
        m = find(strcmp(plotlist{midx},graph(:,1)));
        if isempty(m)
            continue;
        end
        
        for g = 1:2
            if strcmp(graph{m,1},'modules') || strcmp(graph{m,1},'centrality')
                groupvals = squeeze(max(graph{m,weiorbin}(eval(selector),f,:,:),[],4));
            elseif strcmp(graph{m,1},'mutual information')
                groupvals = squeeze(graph{m,weiorbin}(eval(selector),:,f,:));
            elseif strcmp(graph{m,1},'participation coefficient')
                groupvals = squeeze(std(graph{m,weiorbin}(eval(selector),f,:,:),[],4));
            else
                groupvals = squeeze(mean(graph{m,weiorbin}(eval(selector),f,:,:),4));
            end
            groupmean = mean(groupvals,1);
            groupste = std(groupvals,[],1)/sqrt(size(groupvals,1));
            errorbar(plottvals(trange),groupmean(trange),groupste(trange));
            hold all
        end
        set(gca,'Xdir','reverse');
        set(gca,'XLim',[plottvals(end) plottvals(1)],'FontSize',fontsize);
        xlabel('Graph connection density','FontSize',fontsize);
        
        i = i+1;
        if f == 1
            title(graph{m,1},'FontSize',fontsize);
        end
        if midx == 1
            ylabel(scales{f,1},'FontSize',fontsize);
        end
    end
end

[~,h4]=suplabel('Fully Responsive vs Decreased Hit Rates - Graph Theory Metrics','t');
set(h4,'FontSize',16);
legend('Location',[0.01 0.92 0.1 0.1],'Sedated','Oversedated');









