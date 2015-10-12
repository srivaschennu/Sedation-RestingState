function [rmanovatbl,multcomptbl] = testmeasures(listname,conntype,measure,bandidx,varargin)

levels = [1 2 3 4];
levelnames = {'Baseline';'Mild';'Moderate';'Recovery'};

for l = 1:length(levels)
    [data(:,l),group] = testmeasure(listname,conntype,measure,levels(l),bandidx,'noplot','on',varargin{:});
end

grouplist = cell(size(group));
grouplist(group == 1) = {'Responsive'};
grouplist(group == 2) = {'Drowsy'};

if strcmp(measure,'drug')
    datatable = table(grouplist,data(:,2),data(:,3),data(:,4),'VariableNames',{'group','Mild','Moderate','Recovery'});
    design = table(levelnames(2:end),'VariableNames',{'levels'});
    rmmodel = fitrm(datatable,'Mild-Recovery~group','WithinDesign',design);
elseif strcmp(measure,'rt')
    data = data(strcmp('Responsive',grouplist),:);
    datatable = table(data(:,2),data(:,3),data(:,4),'VariableNames',{'Mild','Moderate','Recovery'});
    design = table(levelnames(2:end),'VariableNames',{'levels'});
    rmmodel = fitrm(datatable,'Mild-Recovery~1','WithinDesign',design);
else
    datatable = table(grouplist,data(:,1),data(:,2),data(:,3),data(:,4),'VariableNames',{'group','Baseline','Mild','Moderate','Recovery'});
    design = table(levelnames,'VariableNames',{'levels'});
    rmmodel = fitrm(datatable,'Baseline-Recovery~group','WithinDesign',design);
end

rmanovatbl = ranova(rmmodel);
fprintf('\n');

fprintf('Main effect of sedation F(%d) = %.1f, p = ',rmanovatbl.DF(1),rmanovatbl.F(1));
if rmanovatbl.pValueGG(1) >= 1e-4
    fprintf('%.4f',rmanovatbl.pValueGG(1));
else
    fprintf('%.0e',rmanovatbl.pValueGG(1));
end
fprintf('\n');

if strcmp(measure,'rt')
    multcomptbl = multcompare(rmmodel,'levels');
    
    fprintf('\n');
    for r = 1:size(multcomptbl,1)
        fprintf('%s vs. %s: Diff = %.2f, ',multcomptbl.levels_1{r},multcomptbl.levels_2{r},multcomptbl.Difference(r));
        if multcomptbl.pValue(r) >= 1e-4
            fprintf('p = %.4f\n',multcomptbl.pValue(r));
        else
            fprintf('p = %.0e\n',multcomptbl.pValue(r));
        end
    end
else
    fprintf('Group-sedation Interaction F(%d) = %.1f, p = ',rmanovatbl.DF(2),rmanovatbl.F(2));
    if rmanovatbl.pValueGG(2) >= 1e-4
        fprintf('%.4f',rmanovatbl.pValueGG(2));
    else
        fprintf('%.0e',rmanovatbl.pValueGG(2));
    end
    fprintf('\n');
    
    multcomptbl = multcompare(rmmodel,'group','By','levels');
    
    fprintf('\n');
    for r = 1:size(multcomptbl,1)
        fprintf('%s - %s vs. %s: Diff = %.2f, ',multcomptbl.levels{r},multcomptbl.group_1{r},multcomptbl.group_2{r},multcomptbl.Difference(r));
        if multcomptbl.pValue(r) >= 1e-4
            fprintf('p = %.4f\n',multcomptbl.pValue(r));
        else
            fprintf('p = %.0e\n',multcomptbl.pValue(r));
        end
    end
end
fprintf('\n');
