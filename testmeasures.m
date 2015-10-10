function [rmanovatbl,multcomptbl] = testmeasures(listname,conntype,measure,bandidx,varargin)

levels = [1 2 3 4];
levelnames = {'Baseline','Mild','Moderate','Recovery'};
bands = {
    'delta'
    'theta'
    'alpha'
    'beta'
    'gamma'
    };

siglevels = {
    0.001   '***'
    0.01    '**'
    0.05    '*'
    0.1     '+'
    1       ''
    };

for l = 1:length(levels)
    [data(:,l),group] = testmeasure(listname,conntype,measure,levels(l),bandidx,'noplot','on',varargin{:});
end

% pvals = bonf_holm(pvals,0.05);
% pvals = fdr(pvals);

% fprintf('After correction:\n');
% for l = 1:length(levels)
%     siglevel = siglevels{find(pvals(l) < cell2mat(siglevels(:,1)),1,'first'),2};
%     fprintf('%s %s: t(%.1f) = %.2f, p = %.3f%s.\n',levelnames{levels(l)},measure,stats(l).df,abs(stats(l).tstat),pvals(l),siglevel);
% end

grouplist = cell(size(group));
grouplist(group == 1) = {'Responsive'};
grouplist(group == 2) = {'Drowsy'};

if strcmp(measure,'drug')
    datatable = table(grouplist,data(:,2),data(:,3),data(:,4),'VariableNames',{'group','Mild','Moderate','Recovery'});
    design = table({'Mild'; 'Moderate'; 'Recovery'},'VariableNames',{'Levels'});
    rmmodel = fitrm(datatable,'Mild-Recovery~group','WithinDesign',design);
else
    datatable = table(grouplist,data(:,1),data(:,2),data(:,3),data(:,4),'VariableNames',{'group','Baseline','Mild','Moderate','Recovery'});
    design = table({'Baseline'; 'Mild'; 'Moderate'; 'Recovery'},'VariableNames',{'Levels'});
    rmmodel = fitrm(datatable,'Baseline-Recovery~group','WithinDesign',design);
end

% datatable = table(group,data(:,1),data(:,3),'VariableNames',{'group','Baseline','Moderate'});
% design = table({'Baseline'; 'Moderate'},'VariableNames',{'Levels'});
% rmmodel = fitrm(datatable,'Baseline-Moderate~group','WithinDesign',design);

rmanovatbl = ranova(rmmodel);
fprintf('\n');

fprintf('Main effect of sedation F(%d) = %.1f, p = ',rmanovatbl.DF(1),rmanovatbl.F(1));
if rmanovatbl.pValueGG(1) >= 1e-4
    fprintf('%.4f',rmanovatbl.pValueGG(1));
else
    fprintf('%.0e',rmanovatbl.pValueGG(1));
end
fprintf('\n');

fprintf('Group-sedation Interaction F(%d) = %.1f, p = ',rmanovatbl.DF(2),rmanovatbl.F(2));
if rmanovatbl.pValueGG(2) >= 1e-4
    fprintf('%.4f',rmanovatbl.pValueGG(2));
else
    fprintf('%.0e',rmanovatbl.pValueGG(2));
end
fprintf('\n');

fprintf('\n');
multcomptbl = multcompare(rmmodel,'group','By','Levels');

for r = 1:2:size(multcomptbl,1)
    fprintf('%s: Diff = %.2f, ',multcomptbl{r,1}{1},multcomptbl{r,4});
    if multcomptbl{r,6} >= 1e-4
        fprintf('p = %.4f\n',multcomptbl{r,6});
    else
        fprintf('p = %.0e\n',multcomptbl{r,1}{1},multcomptbl{r,6});
    end
end
fprintf('\n');

