function plotmeanfmrigraph(listname,scaleidx)

loadpaths
filepath = fmripath;
load(sprintf('%s/alldata_%s_fMRI.mat',filepath,listname));
load(sprintf('%s/roilocs.mat',filepath));

grp = cell2mat(subjlist(:,2:end));

scales = {
    'scale2'
    'scale3'
    };

grouplist = {
    'Fully Responsive'
    'Decreased Hits'
    };

    for g = 1:2
        groupcoh = squeeze(mean(allcoh(grp(:,5) == g & grp(:,1) == 3,scaleidx,:,:),1));
        plotgraph(groupcoh,roilocs,'plotqt',0.9,'legend','off','view',[0 90]);
        set(gcf,'Name',sprintf('group %s: %s',grouplist{g},scales{scaleidx}));
%         export_fig(gcf,sprintf('figures/meangraph_%s_%s.tif',grouplist{g},bands{scaleidx}));
%         close(gcf);
    end