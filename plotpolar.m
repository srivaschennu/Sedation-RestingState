function plotpolar(listname,plotlevel)

fontname = 'Helvetica';
fontsize = 24;

loadpaths
loadsubj
changroups

figure;
set(gcf,'Color','white');
set(gca,'FontName',fontname,'FontSize',fontsize,'LineWidth',2);

subjlist = eval(listname);
subjidx = [0 16]+plotlevel;

colorlist = [
    0 0.0 1
    0 0.5 0
    ];

for s = 1:length(subjidx)
    basename = subjlist{subjidx(s),1};
    binc = [];
    amph = [];
    ampvals = [];
    phangles = [];

    load([filepath basename 'phamp.mat']);
    for c1 = find(ismember({chanlocs.labels},occipitalalpha))
        chanPAC = squeeze(PAC(c1,1,lowfreqs >= 0.1 & lowfreqs <= 1,:));
        [~, maxidx] = max(abs(chanPAC(:)));
        phangles = cat(2,phangles,PHASE(c1,:,lowfreqs >= 0.1 & lowfreqs <= 1));
        ampvals = cat(2,ampvals,AMP(c1,:,maxidx));
    end
    
    phbins = linspace(min(phangles),max(phangles),13);
    
    for bidx = 1:length(phbins)-1
        amph(bidx) = mean(ampvals(phangles >= phbins(bidx) & phangles < phbins(bidx+1)));
        binc(bidx) = (phbins(bidx)+phbins(bidx+1))/2;
    end
    
    amph = amph * 100 / sum(amph);
    
    amph(end+1) = amph(1);
    binc(end+1) = binc(1);
    
    hpol = polar(binc,amph);
    set(hpol,'Color',colorlist(s,:),'LineWidth',2);
    hold on
end
export_fig(gcf,sprintf('figures/polarplot_%d.eps',plotlevel));
close(gcf);

end