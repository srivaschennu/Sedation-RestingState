function CovarsHori

loadsubj
Drug = cell2mat(subjlist(:,3));
RT = cell2mat(subjlist(:,4));
Hits = cell2mat(subjlist(:,5));
Hori = cell2mat(subjlist(:,6));

figure('Color','White');
for i = 1:2
    subplot(2,2,i) 
    if i == 1
        f = fit(Drug(Drug > 0),Hori(Drug > 0),'poly1');
        plot(f,Drug(Drug > 0),Hori(Drug > 0),'.b');        
        xlabel('Drug');
        [rho, pval] = corr(Drug(Drug > 0),Hori(Drug > 0),'type','spearman');
        fprintf('Rho = %.2f     p = %.3f\n',rho,pval); 
    elseif i == 2
        f = fit(RT(RT ~= -1),Hori(RT ~= -1),'poly1');
        plot(f,RT(RT ~= -1),Hori(RT ~= -1),'.b');
        xlabel('Perceptual RT');
        [rho, pval] = corr(RT(RT ~= -1),Hori(RT ~= -1),'type','spearman');
        fprintf('Rho = %.2f     p = %.3f\n',rho,pval); 
    else
        f = fit(Hits,Hori,'exp1');
        plot(f,Hits,Hori,'.');        
        xlabel('Perceptual Hits');
    end
    ylabel('Hori Score')
    legend('off');
end
[~,h4]=suplabel('Hori Score vs Covariates','t');
set(h4,'FontSize',16)
end