function HitvsHit

loadpaths
loadsubj
rt = cell2mat(subjlist(:,4));
hitrate = cell2mat(subjlist(:,5));
grp = cell2mat(subjlist(:,2:end));

figure('Color','White');
output = [mean(rt(grp(:,1) == 1 & grp(:,7) == 1));mean(rt(grp(:,1) == 1 & grp(:,7) == 2))];
errors = [std(rt(grp(:,1) == 1 & grp(:,7) == 1))/sqrt(length(rt(grp(:,1) == 1 & grp(:,7) == 1)));std(rt(grp(:,1) == 1 & grp(:,7) == 2))/sqrt(length(rt(grp(:,1) == 1 & grp(:,7) == 2)))];
subplot(2,2,1);
barweb(output,errors,[],[],[],'Responsive vs Decreased Hits','Hit Rate Level 0'); 
p = ranksum(rt(grp(:,1) == 1 & grp(:,7) == 1),rt(grp(:,1) == 1 & grp(:,7) == 2))    

end