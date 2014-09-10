function plotspec(basename,freqwin)

loadpaths

if ischar(basename)
    EEG = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');
else
    EEG = basename;
    clear basename
end

if exist('freqwin','var') && ~isempty(freqwin)
    EEG.freqwin = freqwin;
    pop_saveset(EEG,'savemode','resave');
end

fontsize = 16;

figure('Name',EEG.setname);
figpos = get(gcf,'Position');
set(gcf,'Position',[10 10 figpos(3)*2 figpos(4)*2]);

% EEG.spectra = 10.^(EEG.spectra/10);

plot(EEG.freqs,mean(EEG.spectra,3),'LineWidth',1.5);
set(gca,'XLim',[0 50],'FontSize',fontsize);
xlabel('Frequency (Hz)','FontSize',fontsize);
ylabel('Power (dB)','FontSize',fontsize);
% ylabel('Power (uV2/Hz)','FontSize',fontsize);

ylimits = ylim;

if isfield(EEG,'freqlist')
    for f = 1:size(EEG.freqlist,1)
        line([EEG.freqlist(f,1) EEG.freqlist(f,1)],[ylimits(1) ylimits(2)],'LineStyle',':','Color','blue','LineWidth',1);
        line([EEG.freqlist(f,2) EEG.freqlist(f,2)],[ylimits(1) ylimits(2)],'LineStyle',':','Color','blue','LineWidth',1);
    end
end
