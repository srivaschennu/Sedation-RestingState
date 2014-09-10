function GraphMatchedDrug

loadpaths
load graphdata_subjlist_wpli
randgraph = load('graphdata_subjlist_rand_wpli');
load grp2.mat

weiorbin = 3;
trange = [0.5 0.1];
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


figure('Color','white');
for midx = 1:nmes  
    subplot(2,2,midx)
    m = find(strcmp(graphmeasures{midx},graph(:,1)));
    testdata = squeeze(mean(graph{m,3}(:,3,trange),3));
    testdata = [testdata(grp(:,5) == 2); testdata(grp(:,5) == 3)];
    bar(testdata);
    xlabel('Responsive vs Decreased Hits');
    ylabel(graph{m,1});
end

end