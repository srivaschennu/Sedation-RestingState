function plotheadmovie(subjid,conntype)

loadpaths

plotqt = 0.7;

load(sprintf('%s%s//%02d_wpli.mat',filepath,conntype,subjid));
load 91_chanlocs

numinterp = 25;
for g = 1:length(matrix)
    if ~isnan(matrix{g})
        groupcoh(g,:,:) = matrix{g};
        threshcoh(g,:,:) = threshold_proportional(squeeze(groupcoh(g,:,:)),1-plotqt);
        for c = 1:size(threshcoh,2)
            groupdeg(g,c) = sum(threshcoh(g,c,:))/(size(threshcoh,2)-1);
        end
    end
end

t = 1;
for g = 1:size(groupcoh,1)-1
    for c1 = 1:length(chanlocs)
        for c2 = 1:length(chanlocs)
            allcoh(t:t-1+numinterp,c1,c2) = linspace(groupcoh(g,c1,c2),groupcoh(g+1,c1,c2),numinterp);
        end
    end
    t = t-1+numinterp;
end

erange = [min(nonzeros(threshcoh(:))) max(threshcoh(:))];
vrange = [min(nonzeros(groupdeg(:))) max(groupdeg(:))];

for t = 1:size(allcoh,1)
        minfo(t,:) = modularity_louvain_und(threshold_proportional(squeeze(allcoh(t,:,:)),1-plotqt));
end

smoothwin = 5;
for t = 1:size(allcoh,1)-smoothwin
    smoothminfo(t:t+smoothwin-1,:) = repmat(round(mean(minfo(t:t+smoothwin-1,:),1)),5,1);
end
minfo = smoothminfo;
viewangles = linspace(1,360,size(allcoh,1));
mkdir(sprintf('figures/%02d_headmovie',subjid));

figure('Color','black','Name',mfilename);
colormap(jet);
figpos = get(gcf,'Position');
set(gcf,'Position',[figpos(1) figpos(2) figpos(3)*2 figpos(4)*2],'Color','black');

for t = 1:size(allcoh,1)
    plotgraph3d(squeeze(allcoh(t,:,:)),chanlocs,'plotqt',plotqt,'escale',erange,'vscale',vrange,...
        'minfo',minfo(t,:),'view',[viewangles(t) 0]);
    set(gca,'CameraViewAngleMode','manual')
    hold all

%     ViewZ = [0 0; 360 0];
% %     ViewZ = cat(2,ViewZ,zeros(size(ViewZ,1),1));
%     OptionZ.Duration=5;OptionZ.Periodic=true;
%     CaptureFigVid(ViewZ,sprintf('figures/headmovie_%s_%s',grouplist{g},bands{bandidx}),OptionZ)
    set(gcf,'Name',sprintf('%02d_%02d',subjid,t));
    saveas(gcf,sprintf('figures/%02d_headmovie/%02d_%02d.jpg',subjid,subjid,t));%,'-m2');
%     export_fig(gcf,sprintf('figures/%02d_headmovie/%02d_%02d.tif',subjid,subjid,t),'-nocrop');%,'-m2');
end
close(gcf);
