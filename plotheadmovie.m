function plotheadmovie(basename,conntype)

loadpaths

plotqt = 0.7;

skipframes = 1;
load(sprintf('%s%s/%s_wpli.mat',filepath,conntype,basename),'matrix');
load 91_chanlocs.mat

wb_h = waitbar(0,'Starting...');
groupcoh = zeros(length(1:skipframes:length(matrix)),size(matrix{1},1),size(matrix{1},2));
groupdeg = zeros(length(1:skipframes:length(matrix)),size(matrix{1},1));
g = 1;
for i = 1:skipframes:length(matrix)
    waitbar(i/length(matrix),wb_h,sprintf('Processing frame %d of %d',i,length(matrix)));
    if ~isnan(matrix{i})
        groupcoh(g,:,:) = threshold_proportional(matrix{i},1-plotqt);
        for c = 1:size(groupcoh,2)
            groupdeg(g,c) = sum(groupcoh(g,c,:))/(size(groupcoh,2)-1);
        end
    end
    g = g+1;
end
clear matrix
close(wb_h);

numframes = size(groupcoh,1);

erange = [min(nonzeros(groupcoh(:))) max(groupcoh(:))];
vrange = [min(nonzeros(groupdeg(:))) max(groupdeg(:))];

mkdir(sprintf('figures/%s_headmovie',basename));

figure('Color','black','Name',mfilename);
colormap(jet);
figpos = get(gcf,'Position');
set(gcf,'Position',[figpos(1) figpos(2) figpos(3)*1.5 figpos(4)*2],'Color','black');

for t = 517:numframes
        hold on
        plotgraph3d(squeeze(groupcoh(t,:,:)),chanlocs,'91_spline.spl','plotqt',plotqt,'escale',erange,'vscale',vrange,'cshift',0.2,'numcolors',5);
        camva(8);
        camtarget([-9.7975  -28.8277   41.8981]);
        campos([-1.7547    1.7161    1.4666]*1000);
    %     ViewZ = [0 0; 360 0];
    % %     ViewZ = cat(2,ViewZ,zeros(size(ViewZ,1),1));
    %     OptionZ.Duration=5;OptionZ.Periodic=true;
    %     CaptureFigVid(ViewZ,sprintf('figures/headmovie_%s_%s',grouplist{g},bands{bandidx}),OptionZ)
    set(gcf,'Name',sprintf('%d',t),'InvertHardCopy','off');
    
    print(gcf,sprintf('figures/%s_headmovie/%d.tif',basename,t),'-dtiff','-r150');
    %     saveas(gcf,sprintf('%s/figures/%02d_headmovie/%d.jpg',scriptspath,subjids,t));%,'-m2');
    %     export_fig(gcf,sprintf('figures/%02d_headmovie/%02d_%02d.tif',subjid,subjid,t),'-nocrop');%,'-m2');
end
close(gcf);
