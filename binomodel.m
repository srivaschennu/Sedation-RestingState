function binomodel(listname)

loadsubj

subjlist = eval(listname);

testgroups = [1 2];

grp = cell2mat(subjlist(:,2:end));
hitrate = cell2mat(subjlist(:,5));

[~, basepci] = binofit(hitrate(grp(:,1) == 1 & (grp(:,5) == testgroups(1) | grp(:,5) == testgroups(2))),40);
[~, l3pci] = binofit(hitrate(grp(:,1) == 3 & (grp(:,5) == testgroups(1) | grp(:,5) == testgroups(2))),40);

subjgroup = (l3pci(:,2) < basepci(:,1))+1;

disp([subjlist(grp(:,1) == 1 & (grp(:,5) == testgroups(1) | grp(:,5) == testgroups(2)),1), ...
    num2cell(hitrate(grp(:,1) == 1 & (grp(:,5) == testgroups(1) | grp(:,5) == testgroups(2)))), ...
    num2cell(basepci(:,1)),...
    num2cell(hitrate(grp(:,1) == 3 & (grp(:,5) == testgroups(1) | grp(:,5) == testgroups(2)))), ...
    num2cell(l3pci(:,2)),...
    num2cell(subjgroup),...
    num2cell(grp(grp(:,1) == 1 & (grp(:,5) == testgroups(1) | grp(:,5) == testgroups(2)),5)),...
    num2cell(subjgroup == grp(grp(:,1) == 1 & (grp(:,5) == testgroups(1) | grp(:,5) == testgroups(2)),5))]);