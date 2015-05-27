function plotpower(listname,conntype,plotlevel,varargin)

loadpaths
loadsubj

param = finputcheck(varargin, {
    'xlabel', 'string', [], ''; ...
    'ylabel', 'string', [], ''; ...
    'xlim', 'real', [], []; ...
    'ylim', 'real', [], []; ...
    });

load(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype));
load chanlist
load freqlist

fontname = 'Helvetica';
fontsize = 28;

bands = {
    'Delta'
    'Theta'
    'Alpha'
    'Beta'
    'Gamma'
    };

groups = [1 2];
grouplist = {
    'Responsive'
    'Drowsy'
    };

levelnames = {'Baseline','Mild','Moderate','Recovery'};

loadsubj
subjlist = eval(listname);

grp = cell2mat(subjlist(:,2:end));
% 
% barvals = zeros(size(bandpower,2),length(groups));
% errvals = zeros(size(bandpower,2),length(groups));
% 
% p = 1;
% for bandidx = 1:size(bandpower,2)
%     for g = 1:length(groups)
%         barvals(bandidx,g) = mean(mean(bandpower(grp(:,1) == plotlevel & grp(:,5) == groups(g),bandidx,:),3),1);
%         errvals(bandidx,g) = std(mean(bandpower(grp(:,1) == plotlevel & grp(:,5) == groups(g),bandidx,:),3),[],1)/sqrt(sum(grp(:,1) == plotlevel & grp(:,5) == groups(g)));
%         
%         plotdata = squeeze(mean(bandpower(grp(:,1) == plotlevel & grp(:,5) == groups(g),bandidx,:),1))*100;
% %         if bandidx == 3 && groups(g) == 1
% %             plotdata = (squeeze(mean(bandpower(grp == 1,3,:),1)) - squeeze(mean(bandpower(grp == 0,3,:),1))) *100;
% %         end
%         figure;
% %         subplot(size(bandpower,2),length(groups),p); hold all;
%         topoplot(plotdata,sortedlocs,'maplimits','maxmin');
%         set(colorbar,'FontName',fontname,'FontSize',fontsize);
%         set(gcf,'Color','white');
%         export_fig(gcf,sprintf('figures/powertopo_%s_%s.eps',bands{bandidx},grouplist{g}));
%         close(gcf);
%         p = p+1;
%     end
% end
% 
% figure('Color','white');
% hdl = barweb(barvals*100,errvals*100,[],bands,[],[],[],[],[],grouplist,[],[]);
% set(hdl.ax,'FontName',fontname,'FontSize',fontsize);
% ylabel('Power contribution (%)','FontName',fontname,'FontSize',fontsize)
% set(hdl.legend,'FontName',fontname,'FontSize',fontsize);
% export_fig(gcf,'figures/powerbar.eps');
% close(gcf);

p = 1;
for g = 1:length(groups)
    %     subplot(1,length(groups),p);
    figure('Color','white');
    plot(freqbins,10*log10(squeeze(mean(spectra(grp(:,1) == plotlevel & grp(:,5) == groups(g),:,:),1))),'LineWidth',2);
    set(gca,'XLim',[0 45],'YLim',[-25 25],'FontName',fontname,'FontSize',fontsize);
    if strcmp(param.xlabel,'on') && g == 1
        xlabel('Frequency (Hz)','FontName',fontname,'FontSize',fontsize);
    else
        xlabel(' ','FontName',fontname,'FontSize',fontsize);
        set(gca,'XTick',[]);
    end
    if strcmp(param.ylabel,'on') && g == 1
        ylabel('Power (dB)','FontName',fontname,'FontSize',fontsize);
    else
        ylabel(' ','FontName',fontname,'FontSize',fontsize);
        set(gca,'YTick',[]);
    end
    if ~isempty(param.xlim)
        xlim(param.xlim);
    end
    if ~isempty(param.ylim)
        ylim(param.ylim);
    end
    for f = 1:size(freqlist,1)
        line([freqlist(f,1) freqlist(f,1)],ylim,'LineWidth',1,'LineStyle','--','Color','black');
    end
    p = p+1;
    
    export_fig(gcf,sprintf('figures/%s_%s_spec.eps',grouplist{g},levelnames{plotlevel}));
    close(gcf);
end
