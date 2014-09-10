function plotmeangraph(listname,conntype,plotlevel,bandidx)

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

plotqt = 0.7;

grouplist = {
    'Responsive'
    'Drowsy'
    };

levelnames = {'Baseline','Mild Sedation','Moderate Sedation','Recovery'};

for g = 1:length(grouplist)
    groupcoh(g,:,:) = squeeze(mean(allcoh(grp(:,5) == g & grp(:,1) == plotlevel,bandidx,:,:),1));
    threshcoh(g,:,:) = threshold_proportional(squeeze(groupcoh(g,:,:)),1-plotqt);
    for c = 1:size(threshcoh,2)
        groupdeg(g,c) = sum(threshcoh(g,c,:))/(size(threshcoh,2)-1);
    end
end

erange = [min(nonzeros(threshcoh(:))) max(threshcoh(:))];
vrange = [min(nonzeros(groupdeg(:))) max(groupdeg(:))];

for g = 1:length(grouplist)
    minfo(g,:) = plotgraph(squeeze(groupcoh(g,:,:)),sortedlocs,'plotqt',plotqt,'escale',erange,'vscale',vrange,'legend','off','plotinter','off');
    fprintf('%s %s %s - number of modules: %d\n',grouplist{g},levelnames{plotlevel},bands{bandidx},length(unique(minfo(g,:))));
    set(gcf,'Name',sprintf('%s %s %s',grouplist{g},levelnames{plotlevel},bands{bandidx}));
    export_fig(gcf,sprintf('figures/meangraph_%s_%s_%s.tif',grouplist{g},levelnames{plotlevel},bands{bandidx}));
    close(gcf);
end