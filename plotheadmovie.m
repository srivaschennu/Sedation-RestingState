function plotheadmovie(subjids,conntype)

loadpaths

plotqt = 0.7;
load 91_chanlocs

% skipframes = 2;
% for s = 1:length(subjids)
%     subjid = subjids(s);
%     load(sprintf('%s%s//%02d_wpli.mat',filepath,conntype,subjid),'matrix');
%     
%     wb_h = waitbar(0,'Starting...');
%     groupcoh{s} = zeros(length(1:skipframes:length(matrix)),size(matrix{1},1),size(matrix{1},2));
%     groupdeg{s} = zeros(length(1:skipframes:length(matrix)),size(matrix{1},1));
%     g = 1;
%     for i = 1:skipframes:length(matrix)
%         waitbar(i/length(matrix),wb_h,sprintf('Processing frame %d of %d',i,length(matrix)));
%         if ~isnan(matrix{i})
%             groupcoh{s}(g,:,:) = threshold_proportional(matrix{i},1-plotqt);
%             for c = 1:size(groupcoh{s},2)
%                 groupdeg{s}(g,c) = sum(groupcoh{s}(g,c,:))/(size(groupcoh{s},2)-1);
%             end
%         end
%         g = g+1;
%     end
%     clear matrix
%     close(wb_h);
% end
% 
% numframes = [size(groupcoh{1},1) size(groupcoh{2},1)];
% groupcoh = cat(1,groupcoh{1},groupcoh{2});
% groupdeg = cat(1,groupdeg{1},groupdeg{2});
% 
% erange = [min(nonzeros(groupcoh(:))) max(groupcoh(:))];
% vrange = [min(nonzeros(groupdeg(:))) max(groupdeg(:))];


load matlab.mat
mkdir(sprintf('figures/%02d_%02d_headmovie',subjids));

figure('Color','black','Name',mfilename);
colormap(jet);
figpos = get(gcf,'Position');
set(gcf,'Position',[figpos(1) figpos(2) figpos(3)*4 figpos(4)*2],'Color','black');

for t = 1:min(numframes)
    for p = 1:2
        subplot(1,2,p);
        hold all
        plotgraph3d(squeeze(groupcoh(t+(p-1)*numframes(1),:,:)),chanlocs,'plotqt',plotqt,'escale',erange,'vscale',vrange);
        camva(7.5);
        camtarget([-9.7975  -28.8277   41.8981]);
        campos([-1.7547    1.7161    1.4666]*1000);
    end
    %     ViewZ = [0 0; 360 0];
    % %     ViewZ = cat(2,ViewZ,zeros(size(ViewZ,1),1));
    %     OptionZ.Duration=5;OptionZ.Periodic=true;
    %     CaptureFigVid(ViewZ,sprintf('figures/headmovie_%s_%s',grouplist{g},bands{bandidx}),OptionZ)
    set(gcf,'Name',sprintf('%02d_%02d',subjid,t),'InvertHardCopy','off');
    saveas(gcf,sprintf('figures/%02d_headmovie/%02d_%02d.jpg',subjid,subjid,t));%,'-m2');
    %     export_fig(gcf,sprintf('figures/%02d_headmovie/%02d_%02d.tif',subjid,subjid,t),'-nocrop');%,'-m2');
end
close(gcf);
