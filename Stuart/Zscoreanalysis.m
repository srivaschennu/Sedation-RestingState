function Zscoreanalysis

loadsubj
loadpaths
load graphdata_subjlist_pli.mat
randgraph = load('graphdata_subjlist_rand_pli');

drug = cell2mat(subjlist(:,3));

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
nmes = length(graphmeasures);

load grp2.mat

smworld = squeeze(mean(graph{11,3}(:,3,trange),3));
mod = squeeze(mean(graph{4,3}(:,3,trange),3));
modspan = squeeze(mean(graph{7,3}(:,3,trange),3));

smworld = smworld(grp(:,1) == 1);
mod = mod(grp(:,1) == 1);
modspan = modspan(grp(:,1) == 1);
drug = drug(grp(:,1) == 3);

Zdrug = zscore(drug);
Zsmworld = zscore(smworld);
Zmod = zscore(mod);
Zmodspan = zscore(modspan);

groups = grp((grp(:,1) == 1),3);

Zsmworld = Zsmworld + Zdrug ;
Zmod = Zmod + Zdrug;
Zmodspan = Zmodspan + Zdrug;


% Graph Theory Zscores + Drug Zscores by Group

figure('Color','White')
for i = 1:4
    subplot(2,2,i)
        
        if i == 1
        datasmworld = [mean(Zsmworld(groups == 1)); mean(Zsmworld(groups == 2))];
        errorsmworld = [std(Zsmworld(groups == 1))/sqrt(length(Zsmworld(groups == 1)));std(Zsmworld(groups == 2))/sqrt(length(Zsmworld(groups == 2)))];
%         barweb(datasmworld,errorsmworld);
        bar(datasmworld)
        ylabel('Small worldliness');
        ranksum(Zsmworld(groups == 1),Zsmworld(groups == 2))
        
        elseif i == 2
        datamod = [mean(Zmod(groups == 1)); mean(Zmod(groups == 2))];
        errormod = [std(Zmod(groups == 1))/sqrt(length(Zmod(groups == 1)));std(Zmod(groups == 2))/sqrt(length(Zmod(groups == 2)))];
%         barweb(datamod,errormod);
        bar(datamod)
        ylabel('Modularity');
        ranksum(Zmod(groups == 1),Zmod(groups == 2))
        
        elseif i == 3
        datamodspan = [mean(Zmodspan(groups == 1)); mean(Zmodspan(groups == 2))];
        errormodspan = [std(Zmodspan(groups == 1))/sqrt(length(Zmodspan(groups == 1)));std(Zmodspan(groups == 2))/sqrt(length(Zmodspan(groups == 2)))];
%         barweb(datamodspan,errormodspan);
        bar(datamodspan)
        ranksum(Zmodspan(groups == 1),Zmodspan(groups == 2))
        ylabel('Modular Span');
        
        else
        datadrug = [mean(Zdrug(groups == 1)); mean(Zdrug(groups == 2))];
        errormodspan = [std(Zdrug(groups == 1))/sqrt(length(Zdrug(groups == 1)));std(Zdrug(groups == 2))/sqrt(length(Zdrug(groups == 2)))];
%         barweb(datamodspan,errormodspan);
        bar(datadrug)
        ranksum(Zdrug(groups == 1),Zdrug(groups == 2))
        ylabel('Drug');
                
        end
        
    xlabel('Responsive vs Decreased Hits');
    hold all
    i = i+1;

end

end










