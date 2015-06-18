function samplepac

colorlist = [
    0 0.0 1
    0 0.5 0
    ];

theta = [pi:0.001:2*pi;0:0.001:pi];
figname = {'trough-max-pac';'peak-max-pac'};

for t = 1:2
    figure('Color','none','Name',figname{t});
    plot(theta(t,:),sin(theta(t,:)) + (0.05+0.1*abs(sin(theta(t,:)))).*sin(15*theta(t,:)), ...
        'Color',colorlist(t,:),'LineWidth',8);
    set(gca,'Visible','off');
    export_fig(gcf,sprintf('figures/%s.eps',figname{t}));
    close(gcf);
end