function GroupDrug

loadsubj
load grp2.mat

drug = cell2mat(subjlist(:,3));

output = [mean(drug(drug ~= -1 & grp(:,3) == 1 & grp(:,1) == 3));mean(drug(drug ~= -1 & grp(:,3) == 2 & grp(:,1) == 3))];
errors = [std(drug(drug ~= -1 & grp(:,3) == 1 & grp(:,1) == 3))/sqrt(length(drug(drug ~= -1 & grp(:,3) == 1 & grp(:,1) == 3)));std(drug(drug ~= -1 & grp(:,3) == 2 & grp(:,1) == 3))/sqrt(length(drug(drug ~= -1 & grp(:,3) == 2 & grp(:,1) == 3)))];

figure('Color','White');
barweb(output,errors,[],[],[],'Responsive vs Decreased Hits','Drug Level'); 

p = ranksum(drug(drug ~= -1 & grp(:,3) == 1 & grp(:,1) == 3),drug(drug ~= -1 & grp(:,3) == 2 & grp(:,1) == 3))    

end