function testmeasures

load graphdata_subjlist_pli
randgraph = load('graphdata_subjlist_rand_pli');

weiorbin = 3;
trange = [0.5 0.025];
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
    'participation coefficient'
    'modular span'
    'mutual information'
    };

graph{end+1,1} = 'small-worldness index';
graph{end,2} = ( mean(graph{1,2},4) ./ mean(randgraph.graph{1,2},4) ) ./ ( graph{2,2} ./ randgraph.graph{2,2}) ;
graph{end,3} = ( mean(graph{1,3},4) ./ mean(randgraph.graph{1,3},4) ) ./ ( graph{2,3} ./ randgraph.graph{2,3}) ;

trange = (tvals <= trange(1) & tvals >= trange(2));

  
% Correlate Graph Theory with Perceptual RT

behaviour = cell2mat(subjlist(:,4));
drug = cell2mat(subjlist(:,3));

nfreq = size(graph{1,3},2);
nmes = length(graphmeasures);
figure('Color','white');
i = 1;

for f = 1:nfreq
    for midx = 1:nmes  
         
        m = find(strcmp(graphmeasures{midx},graph(:,1)));

        if strcmp(m,'mutual information') || strcmp(m,'participation coefficient')   
            testdata = squeeze(mean(mean(graph{m,3}(:,f,:,trange),4),2));
        else
            testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
        end
        
        subplot(nfreq,nmes,i);
        hold all
        scatter(behaviour(behaviour ~= -1),testdata(behaviour ~= -1));
        lsline
        
        [rho, pval] = corr(behaviour(behaviour ~= -1),testdata(behaviour ~= -1),'type','spearman');
        
        fprintf('Spearman rho = %.2f P-value = %.3f.\n',rho,pval);
                
%         if f == 1
            title(graph{m,1},'FontSize',fontsize);
%         end
        if midx == 1
            ylabel(bands{f,1})    
        end
        set(gca,'XLim',[0,3000]);
        
        i = i+1;   
    end
end
[~,h4]=suplabel('Behavioural RT vs Graph Theory Metrics','t');
set(h4,'FontSize',16)

fprintf('.\n')


% Correlate Graph Theory vs Drug Level

figure('Color','white');
i = 1;

for f = 1:nfreq
    for midx = 1:nmes  
         
        m = find(strcmp(graphmeasures{midx},graph(:,1)));

        if strcmp(m,'mutual information') || strcmp(m,'participation coefficient')   
            testdata = squeeze(mean(mean(graph{m,3}(:,f,:,trange),4),2));
        else
            testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
        end
        
        subplot(nfreq,nmes,i);
        hold all
        scatter(drug(drug > 0),testdata(drug > 0));
        lsline
        
        [rho, pval] = corr(drug(drug > 0),testdata(drug > 0),'type','spearman');
        
        fprintf('Spearman rho = %.2f P-value = %.3f.\n',rho,pval);
                
        if f == 1
            title(graph{m,1},'FontSize',fontsize);
        end
        if midx == 1
            ylabel(bands{f,1})    
        end
        set(gca,'XLim',[0,2000]);
        
        i = i+1;   
    end
end
[~,h4]=suplabel('Drug Level vs Graph Theory Metrics','t');
set(h4,'FontSize',16)


