function calcgraph(listname,conntype,varargin)

loadpaths
loadsubj

param = finputcheck(varargin, {
    'randomise', 'string', {'on','off'}, 'off'; ...
    'latticise', 'string', {'on','off'}, 'off'; ...
    'rewire', 'integer', [], 20; ...
    'heuristic', 'integer', [], 100; ...
    });

load chanlist
chandist = chandist / max(chandist(:));

subjlist = eval(listname);

tvals = 0.5:-0.025:0.025;

if strcmp(param.randomise,'on')
    savename = sprintf('%s/%s/graphdata_%s_rand_%s.mat',filepath,conntype,listname,conntype);
elseif strcmp(param.latticise,'on')
    distdiag = repmat(1:length(sortedlocs),[length(sortedlocs) 1]);
    for d = 1:size(distdiag,1)
        distdiag(d,:) = abs(distdiag(d,:) - d);
    end
    distdiag = distdiag ./ max(distdiag(:));
    savename = sprintf('%s/%s/graphdata_%s_latt_%s.mat',filepath,conntype,listname,conntype);
else
    savename = sprintf('%s/%s/graphdata_%s_%s.mat',filepath,conntype,listname,conntype);
end

graph{1,1} = 'clustering';
graph{2,1} = 'characteristic path length';
graph{3,1} = 'global efficiency';
graph{4,1} = 'modularity';
graph{5,1} = 'modules';
graph{6,1} = 'centrality';
graph{7,1} = 'modular span';
graph{8,1} = 'participation coefficient';
graph{9,1} = 'connection density';
graph{10,1} = 'mutual information';

% load(savename);
            
for s = 1:size(subjlist,1)
    basename = subjlist{s,1};
    
    fprintf('Processing %s.',basename);
    
    load([filepath 'wpli/' basename 'wplifdr.mat']);
    
    [sortedchan,sortidx] = sort({chanlocs.labels});
    if ~strcmp(chanlist,cell2mat(sortedchan))
        error('Channel names do not match!');
    end
    matrix = matrix(:,sortidx,sortidx);
%     pval = pval(:,sortidx,sortidx);
    
    chanlocs = chanlocs(sortidx);
%     chanXYZ = [cell2mat({chanlocs.X})' cell2mat({chanlocs.Y})' cell2mat({chanlocs.Z})'];
    
    for f = 1:size(matrix,1)
        cohmat = squeeze(matrix(f,:,:));
        
        %SMALL WORLD THRESHOLDING
        % %         for thresh = 1:length(tvals)
        % %             if mean(degrees_und(threshold_proportional(zeromean(cohmat),tvals(thresh)))) < log(size(cohmat,1))
        % %                 break
        % %             end
        % %         end
        % %
        % %         threshcoh = threshold_proportional(zeromean(cohmat),tvals(thresh-1));
        % %         bincohmat = double(threshcoh ~= 0);
        % %         fprintf(' %.2f',tvals(thresh-1));
        % %
        % %         %threshold value
        % %         graph{8,1} = 'threshold';
        % %         graph{8,2}(s,f) = tvals(thresh-1);
        
        for thresh = 1:length(tvals)
%             fprintf(' %.2f',tvals(thresh));
%             threshcoh = threshold_proportional(zeromean(cohmat),tvals(thresh));
%             threshcoh = cohmat;
            bincohmat = double(threshold_proportional(cohmat,tvals(thresh)) ~= 0);
            
            if strcmp(param.randomise,'on')
                %randomisation
%                 threshcoh = randmio_und_connected(threshcoh,param.rewire);
                bincohmat = randmio_und_connected(bincohmat,param.rewire);
            elseif strcmp(param.latticise,'on')
                bincohmat = latmio_und_connected(bincohmat,param.rewire,distdiag);
            end
%             %%%%%%  WEIGHTED %%%%%%%%%
% 
%             %clustering coeffcient
%             graph{1,2}(s,f,thresh,1:length(chanlocs)) = mean(clustering_coef_wu(threshcoh));
%             
%             %characteristic path length
%             graph{2,2}(s,f,thresh) = charpath(distance_wei(1./threshcoh));
% 
%             %global efficiency
%             graph{3,2}(s,f,thresh) = efficiency_wei(threshcoh);
% 
%             [Ci, Q] = modularity_louvain_und(threshcoh);
%             % modularity
%             graph{4,2}(s,f,thresh) = Q;
%             % community structure
%             graph{5,2}(s,f,thresh,1:length(chanlocs)) = Ci;
%             
%             %betweenness (centrality)
%             graph{6,2}(s,f,thresh,1:length(chanlocs)) = betweenness_wei(1./threshcoh);
%             
%             %modular span
%             modspan = zeros(1,max(Ci));
%             for m = 1:max(Ci)
%                 if sum(Ci == m) > 1
%                     distmat = chandist(Ci == m,Ci == m) .* threshcoh(Ci == m,Ci == m);
%                     distmat = nonzeros(triu(distmat,1));
%                     modspan(m) = sum(distmat)/sum(Ci == m);
%                 end
%             end
%             graph{7,2}(s,f,thresh) = max(nonzeros(modspan));
% 
%             %participation coefficient
%             graph{8,2}(s,f,thresh,1:length(chanlocs)) = participation_coef(threshcoh,Ci);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %BINARY
            
            allQ = zeros(param.heuristic,1);
            allms = zeros(param.heuristic,1);
            allpc = zeros(param.heuristic,length(chanlocs));
            for i = 1:param.heuristic
                [Ci, allQ(i)] = modularity_louvain_und(bincohmat);
                
                modspan = zeros(1,max(Ci));
                for m = 1:max(Ci)
                    if sum(Ci == m) > 1
                        distmat = chandist(Ci == m,Ci == m) .* bincohmat(Ci == m,Ci == m);
                        distmat = nonzeros(triu(distmat,1));
                        modspan(m) = sum(distmat)/sum(Ci == m);
                    end
                end
                allms(i) = max(nonzeros(modspan));
                
                allpc(i,:) = participation_coef(bincohmat,Ci);
            end
            
            %clustering coefficient
            graph{1,3}(s,f,thresh,1:length(chanlocs)) = clustering_coef_bu(bincohmat);
            
            %characteristic path length
            graph{2,3}(s,f,thresh) = charpath(distance_bin(bincohmat));

            %global efficiency
            graph{3,3}(s,f,thresh) = efficiency_bin(bincohmat);

            %modularity
            graph{4,3}(s,f,thresh) = mean(allQ);
                        
            %community structure
            graph{5,3}(s,f,thresh,1:length(chanlocs)) = Ci;
            
            %betweenness centrality
            graph{6,3}(s,f,thresh,1:length(chanlocs)) = betweenness_bin(bincohmat);

            %modular span
            graph{7,3}(s,f,thresh) = mean(allms);
            
            %participation coefficient
            graph{8,3}(s,f,thresh,1:length(chanlocs)) = mean(allpc);

            %connection density
            graph{9,3}(s,f,thresh) = density_und(bincohmat);
            
%             %rentian scaling
%             [N, E] = rentian_scaling(bincohmat,chanXYZ,5000);
%             E = E(N<size(bincohmat,1)/2);
%             N = N(N<size(bincohmat,1)/2);
%             b = robustfit(log10(N),log10(E));
%             graph{9,3}(s,f,thresh) = b(2);


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            

        end
    end
    fprintf('\n');
    grp(s,1) = subjlist{s,2};
end

save(savename, 'graph', 'grp', 'tvals', 'subjlist');
