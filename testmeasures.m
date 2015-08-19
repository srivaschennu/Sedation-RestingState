function testmeasures(listname,conntype,measure,bandidx,varargin)

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
    [data(:,l),group,pvals(l),stats(l)] = testmeasure(listname,conntype,measure,levels(l),bandidx,varargin{:});
end

pvals = bonf_holm(pvals,0.05);
% pvals = fdr(pvals);

fprintf('After correction:\n');
for l = 1:length(levels)
    siglevel = siglevels{find(pvals(l) < cell2mat(siglevels(:,1)),1,'first'),2};
    fprintf('%s %s: t(%.1f) = %.2f, p = %.3f%s.\n',levelnames{levels(l)},measure,stats(l).df,abs(stats(l).tstat),pvals(l),siglevel);
end

% group = cat(1,repmat({'Responsive'},13,1),repmat({'Drowsy'},7,1));
% 
% datatable = table(group,data(:,1),data(:,2),data(:,3),data(:,4),'VariableNames',{'group','Baseline','Mild','Moderate','Recovery'});
% design = table({'Baseline'; 'Mild'; 'Moderate'; 'Recovery'},'VariableNames',{'Levels'});
% rmmodel = fitrm(datatable,'Baseline-Recovery~group','WithinDesign',design);

% datatable = table(group,data(:,1),data(:,2),data(:,3),'VariableNames',{'group','Mild','Moderate','Recovery'});
% design = table({'Mild'; 'Moderate'; 'Recovery'},'VariableNames',{'Levels'});
% rmmodel = fitrm(datatable,'Mild-Recovery~group','WithinDesign',design);

% datatable = table(group,data(:,1),data(:,2),'VariableNames',{'group','Baseline','Moderate'});
% design = table({'Baseline'; 'Moderate'},'VariableNames',{'Levels'});
% rmmodel = fitrm(datatable,'Baseline-Moderate~group','WithinDesign',design);

% rmanovatbl = ranova(rmmodel)


