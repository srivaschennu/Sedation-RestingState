function calcmi(listname,conntype)

loadpaths

load(sprintf('%s/%s/graphdata_%s_%s.mat',filepath,conntype,listname,conntype), 'graph');

if any(strcmp('mutual information',graph(:,1)))
    midx = find(strcmp('mutual information',graph(:,1)));
else
    graph{end+1,1} = 'mutual information';
    midx = size(graph,1);
end

for weiorbin = 3
    modinfo = graph{strcmp('modules',graph(:,1)),weiorbin};
    mutinfo = zeros(size(modinfo,1),size(modinfo,1),size(modinfo,2),size(modinfo,3));
    
    for bandidx = 1:size(modinfo,2)
        for t = 1:size(modinfo,3)
            for s1 = 1:size(modinfo,1)
                for s2 = 1:size(modinfo,1)
                    if s1 < s2
                        [~, mutinfo(s1,s2,bandidx,t)] = ...
                            partition_distance(squeeze(modinfo(s1,bandidx,t,:)),squeeze(modinfo(s2,bandidx,t,:)));
                    elseif s1 > s2
                        mutinfo(s1,s2,bandidx,t) = mutinfo(s2,s1,bandidx,t);
                    elseif s1 == s2
                        mutinfo(s1,s2,bandidx,t) = 0;
                    end
                end
            end
        end
    end
    graph{midx,weiorbin} = mutinfo;
end

save(sprintf('%s/%s/graphdata_%s_%s.mat',filepath,conntype,listname,conntype), 'graph','-append');
