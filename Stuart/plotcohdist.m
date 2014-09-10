function plotcohdist(listname,bandidx)

load(sprintf('alldata_%s.mat',listname));
load chanlist

% grp(grp == 2) = 1;
% grp(grp == 3) = 2;

groups = unique(grp)';
chandist = chandist ./ max(chandist(:));

chandist = chandist(:);
uniqcd = unique(chandist);
uniqcd = linspace(uniqcd(1),uniqcd(end),10);

figure;
hold all;
for g = groups
    groupcoh = squeeze(allcoh(grp == g,bandidx,:,:));
    plotvals = zeros(length(uniqcd)-1,size(groupcoh,1));
    
    for u = 1:length(uniqcd)-1
        selvals = (chandist > uniqcd(u) & chandist <= uniqcd(u+1));
        for s = 1:size(groupcoh,1)
            cohmat = squeeze(groupcoh(s,:,:));
            cohmat = cohmat(:);
            cohmat = cohmat(selvals);
            plotvals(u,s) = mean(cohmat);
        end
    end
    errorbar(uniqcd(1:end-1),mean(plotvals,2),std(plotvals,[],2)/sqrt(size(plotvals,2)),'DisplayName',num2str(g));
    set(gca,'XLim',[uniqcd(1) uniqcd(end-1)]);
end
xlabel('Normalidrug inter-electrode distance');
ylabel('Phase lag index');
legend('show');