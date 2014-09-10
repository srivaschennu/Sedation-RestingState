function plotmeanpacgraph(listname,conntype,plotlevel)

loadpaths

load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
load chanlist

loadsubj
subjlist = eval(listname);

grp = cell2mat(subjlist(:,2:end));

if strcmp(conntype,'fmri')
    bands = {
        'scale2'
        'scale3'
        };
    load('roilocs');
    sortedlocs = roilocs;
else
    bands = {
        'delta'
        'theta'
        'alpha'
        'beta'
        'gamma'
        };
end

plotqt = 0.9;

grouplist = {
    'Fully Responsive'
    'Decreased Hits'
    };


for g = 1:length(grouplist)
    groupcoh(g,:,:) = squeeze(mean(allpac(grp(:,5) == g & grp(:,1) == plotlevel,1,:,:),1));
end

for d = 1:2
    if d == 2
        groupcoh = permute(groupcoh,[1 3 2]);
    end
    
    for g = 1:length(grouplist)
        threshcoh(g,:,:) = threshold_proportional(abs(squeeze(groupcoh(g,:,:))),1-plotqt);
        meancohmat = squeeze(threshcoh(g,:,:));
        meancohmat(~logical(triu(ones(size(meancohmat)),1))) = 0;
        threshcoh(g,:,:) = meancohmat;
        
        for c = 1:size(threshcoh,2)
            groupdeg(g,c) = sum(threshcoh(g,c,:))/(size(threshcoh,3)-1);
        end
    end
    
    erange = [min(nonzeros(threshcoh(:))) max(threshcoh(:))];
    vrange = [min(nonzeros(groupdeg(:))) max(groupdeg(:))];
    
    for g = 1:length(grouplist)
        plotpacgraph(squeeze(groupcoh(g,:,:)),sortedlocs,'plotqt',plotqt,'escale',erange,'vscale',vrange,'legend','off');
        fprintf('group %s level %d: %d\n',grouplist{g},plotlevel,d);
        set(gcf,'Name',sprintf('group %s level %d: %d',grouplist{g},plotlevel,d));
        export_fig(gcf,sprintf('figures/pacgraph_%s_%d_%d.tif',grouplist{g},plotlevel,d));
        close(gcf);
    end
end