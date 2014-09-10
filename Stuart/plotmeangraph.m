function plotmeangraph(listname,conntype,bandidx)

loadpaths

load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
load chanlist
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
    minfo = [];
end
minfo = [];

grouplist = {
    'Fully Responsive'
    'Decreased Hits'
    };

for g = 1:2
    groupcoh = squeeze(mean(allcoh(grp(:,5) == g & grp(:,1) == 1,bandidx,:,:),1));
    plotgraph(groupcoh,sortedlocs,'plotqt',0.5,'legend','off','plotinter','off','minfo',minfo);
    set(gcf,'Name',sprintf('group %s: %s band',grouplist{g},bands{bandidx}));
    %         export_fig(gcf,sprintf('figures/meangraph_%s_%s.tif',grouplist{g},bands{bandidx}));
    %         close(gcf);
end