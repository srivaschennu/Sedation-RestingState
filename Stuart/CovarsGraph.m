function CovarsGraph

loadpaths
load graphdata_subjlist_pli
randgraph = load('graphdata_subjlist_rand_pli');

rt = cell2mat(subjlist(:,4));
drug = cell2mat(subjlist(:,3));
hitrate = cell2mat(subjlist(:,5));

weiorbin = 3;
trange = [0.3 0.1];
fontsize = 12;

bands = {
    'delta'
    'theta'
    'alpha'
    'beta'
    'gamma'
    };

graphmeasures = {
    'small-worldness index'
    'modularity'
%     'participation coefficient'
    'modular span'
%     'mutual information'
    };

graph{end+1,1} = 'small-worldness index';
graph{end,2} = ( mean(graph{1,2},4) ./ mean(randgraph.graph{1,2},4) ) ./ ( graph{2,2} ./ randgraph.graph{2,2}) ;
graph{end,3} = ( mean(graph{1,3},4) ./ mean(randgraph.graph{1,3},4) ) ./ ( graph{2,3} ./ randgraph.graph{2,3}) ;

trange = (tvals <= trange(1) & tvals >= trange(2));
nfreq = size(graph{1,3},2);
nmes = length(graphmeasures);
f = 5;

% Correlate Graph Theory vs Drug Level
figure('Color','white');
i = 1;
    for midx = 1:nmes   
        m = find(strcmp(graphmeasures{midx},graph(:,1)));
        testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
        subplot(2,3,i);
        hold all
        scatter(drug(drug > 0),testdata(drug > 0));
        lsline
        [rho, pval] = corr(drug(drug > 0),testdata(drug > 0),'type','spearman');
        fprintf('Spearman rho = %.2f P-value = %.3f.\n',rho,pval);       
        ylabel(graph{m,1},'FontSize',fontsize);
        xlabel('Drug Level');   
        i = i+1;   
    end
[~,h4]=suplabel('Drug Level vs Graph Theory Metrics','t');
set(h4,'FontSize',16)
fprintf('\n')
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

% Correlate Hit Rate with Graph Theory Metrics
i = 1;
figure('Color','white');
for midx = 1:nmes  

    m = find(strcmp(graphmeasures{midx},graph(:,1)));
    testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
    subplot(2,3,i)
    hold all
    scatter(hitrate(grp(:,1) ~= 1),testdata(grp(:,1) ~= 1));
    ylabel(graph{m,1},'FontSize',fontsize);
    xlabel('Hit Rate');
    set(gca,'XLim',[0 45]);    
    i = i+1;    
end
[~,h4]=suplabel('Hit Rate vs Graph Theory Metrics','t');
set(h4,'FontSize',16)

% 
% % Correlate Change in Hit Rate 2 --> 3 with Graph Theory Metrics at 2
% hits = (hitrate(grp(:,1) == 3) - hitrate(grp(:,1) == 2));
% i = 1;
% figure('Color','white');
% for midx = 1:nmes  
%     m = find(strcmp(graphmeasures{midx},graph(:,1)));
%     testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
%     subplot(2,3,i)
%     hold all
%     scatter(hits,testdata(grp(:,1) == 2));
%     ylabel(graph{m,1},'FontSize',fontsize);
%     xlabel('Hit Rate'); 
%     i = i+1;    
% end
[~,h4]=suplabel('Hit Rate vs Graph Theory Metrics','t');
set(h4,'FontSize',16)
end