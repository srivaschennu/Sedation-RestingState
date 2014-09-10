function PowerGraph2

loadpaths
load graphdata_subjlist_pli
randgraph = load('graphdata_subjlist_rand_pli');
load grp2.mat

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

channame = {
    'E16'   'Oz'
    'F3'    'O1'
    'F4'    'O2'
    'Fz'    'E65'
    'E19'   'E71'
    'F4'    'E76'
    'E5'    'E90'
    'E6'    'E66'
    'E12'   'E84'
    };

drug = cell2mat(subjlist(:,3));
RT = cell2mat(subjlist(:,4));
hits = cell2mat(subjlist(:,5));

% Calculate Power
        numchans = length(channame);
        numsubj = length(subjlist);
        f = 3;
        for k =1:2
        for subj = 1:numsubj
                EEG = pop_loadset('filepath',filepath,'filename',[subjlist{subj,1} '.set'],'loadmode','info');
                freqwin = EEG.freqwin;
                if numchans >= 1
                    for chan = 1:numchans
                        bandpowers(subj,chan) = squeeze(mean(mean(EEG.spectra(strcmp(channame(chan,k),{EEG.chanlocs.labels}),...
                        EEG.freqs >= freqwin(1,f) & EEG.freqs <= freqwin(1,f+1),:),2),3));
                    end
                else
                    bandpowers(subj) = squeeze(mean(mean(mean(EEG.spectra(:,EEG.freqs >= freqwin(1,f) & EEG.freqs <= freqwin(1,f+1),:),1),2),3));
                end
        end
            if k == 1
                bandpowers1 = mean(bandpowers,2);
            else
                bandpowers2 = mean(bandpowers,2);
            end
        end
% Correlate Power with Graph Theory Metrics
nfreq = size(graph{1,3},2);
nmes = length(graphmeasures);
figure('Color','white');
i = 1;
        for midx = 1:nmes  
            subplot(2,3,i);
            m = find(strcmp(graphmeasures{midx},graph(:,1)));
            testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
            scatter(bandpowers1,testdata);
            lsline
            [rho, pval] = corr(bandpowers1,testdata,'type','spearman');
            fprintf('Spearman rho = %.2f P-value = %.3f.\n',rho,pval);
            fprintf('\n')
            ylabel(graph{m,1});
            xlabel('Power');     
            i = i+1; 
        end
[~,h4]=suplabel('Power vs Graph Theory Metrics','t');
set(h4,'FontSize',16)
fprintf('\n')   

figure('Color','white');
i = 1;
        for midx = 1:nmes  
            subplot(2,3,i);
            m = find(strcmp(graphmeasures{midx},graph(:,1)));
            testdata = squeeze(mean(graph{m,3}(:,f,trange),3));
            scatter(bandpowers2,testdata);
            lsline
            [rho, pval] = corr(bandpowers2,testdata,'type','spearman');
            fprintf('Spearman rho = %.2f P-value = %.3f.\n',rho,pval);
            fprintf('\n')
            ylabel(graph{m,1});
            xlabel('Power');     
            i = i+1; 
        end                                                        
[~,h4]=suplabel('Power vs Graph Theory Metrics','t');
set(h4,'FontSize',16)
fprintf('\n')       
end

