function plotpolar(basename)

fontname = 'Helvetica';
fontsize = 20;

loadpaths

ampvals = [];
phangles = [];
load([filepath basename 'phamp.mat']);
for c1 = find(ismember({chanlocs.labels},{'Oz'}))
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

amph(end+1) = amph(1);
binc(end+1) = binc(1);

figure;
set(gcf,'Color','white');
set(gca,'FontName',fontname,'FontSize',fontsize,'LineWidth',2);

hpol = polar(binc,amph);
set(hpol,'LineWidth',2);

export_fig(gcf,sprintf('figures/%s_phamp.eps',basename));
close(gcf);

% [x,y] = pol2cart(binc,amph);
% figure; compass(x,y);

end