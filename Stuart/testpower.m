function testpower(listname)

load(sprintf('alldata_%s.mat',listname));
load chanlist

bands = {
    'delta'
    'theta'
    'alpha'
    'beta'
    'gamma'
    };

drug = cell2mat(subjlist(:,3));
beh = cell2mat(subjlist(:,4));

groups = unique(grp);
barvals = zeros(size(bandpower,2),length(groups));
errvals = zeros(size(bandpower,2),length(groups));
figure('Color','white');
p = 1;
% for bandidx = 1:size(bandpower,2)
for bandidx = 2
    for g = 1:length(groups)
%         barvals(bandidx,g) = mean(mean(bandpower(grp == groups(g),bandidx,:),3),1);
%         errvals(bandidx,g) = std(mean(bandpower(grp == groups(g),bandidx,:),3),[],1)/sqrt(sum(grp == groups(g)));
%         
%         subplot(2,length(groups),p); hold all;
          subplot(2,2,p); hold all;
        topoplot(squeeze(mean(bandpower(grp == groups(g),bandidx,:),1)),chanlocs,'maplimits','maxmin'); colorbar
        if g == 1
            title(bands{bandidx});
        end
        if bandidx == 1
            text(0,0,num2str(groups(g)));
        end
        p = p+1;
    end
%     testdata = mean(bandpower(:,bandidx,:),3);
%     pval = ranksum(testdata(grp == 0 | grp == 1),testdata(grp == 2));
%     fprintf('%s band power: Mann-whitney p = %.3f.\n',bands{bandidx},pval);
    
%     % correlate drug with band power
%     testdata = mean(bandpower(drug > 0,bandidx,:),3);
%     [rho,pval] = corr(drug(drug > 0),testdata,'type','spearman');
%     fprintf('%s band power vs drug: Spearman rho = %.2f, p = %.3f.\n',bands{bandidx},rho,pval);
% %     subplot(2,length(groups),[p p+1]); hold all;
%     subplot(2,2,p); hold all;
%     scatter(drug(drug > 0),testdata);
%     lsline
%     xlabel('Drug level');
%     ylabel(sprintf('Power in %s',bands{bandidx}));
%     p = p+1;
%     
%     %correlate behaviour with band power
%     testdata = mean(bandpower(beh ~= -1,bandidx,:),3);
%     [rho,pval] = corr(beh(beh ~= -1),testdata,'type','spearman');
%     fprintf('%s band power vs behaviour: Spearman rho = %.2f, p = %.3f.\n',bands{bandidx},rho,pval);
% %     subplot(2,length(groups),[p p+1]); hold all;
%     subplot(2,2,p); hold all;
%     scatter(beh(beh ~= -1),testdata);
%     lsline
%     xlabel('Behaviour');
%     ylabel(sprintf('Power in %s',bands{bandidx}));
%     p = p+1;
    
%     testdata = bandpeak(grp == 0 | grp == 1,bandidx);
%     testdata = testdata(~logical(fuinfo));
%     [rho,pval] = corr(crs,testdata,'type','spearman');
%     fprintf('%s band peak freq: Spearman rho = %.2f, p = %.3f.\n',bands{bandidx},rho,pval);
end
% figure('Color','white');
% barweb(barvals,errvals,[],bands,[],[],[],[],[],{'Baseline','Level 1','Level 2','Recovery'},[],[]);