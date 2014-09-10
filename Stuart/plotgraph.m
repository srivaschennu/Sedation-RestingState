function plotgraph(matrix,chanlocs,varargin)

% matrix - NxN symmetric connectivity matrix, where N is the number of channels
% chanlocs - 1xN EEGLAB chanlocs structure specifying channel locations

% OPTIONAL ARGUMENTS
% plotqt - proportion of strongest edges to plot
% minfo - 1xN module affiliation vector. Will be calculated if unspecified
% legend - whether or not to plot legend with max and min edge weights
% plotinter - whether or not to plot inter-modular edges

param = finputcheck(varargin, {
    'plotqt', 'real', [], 0.9; ...
    'minfo', 'integer', [], []; ...
    'legend', 'string', {'on','off'}, 'on'; ...
    'plotinter', 'string', {'on','off'}, 'on'; ...
    'view', 'real', [], [-90,90]; ...
    });

%%%%% VISUAL FEATURES

% text attributes
fontname = 'Gill Sans';
fontsize = 16;
fontweight = 'bold';

% range of line widths
lwrange = [0.1 6];

% range of point sizes
ptrange = [10 1000];

% keep only top <plotqt>% of weights and rescale them to be between 0 and 1
origmatrix = matrix;
allval = sort(nonzeros(matrix),'descend');
plotthresh = quantile(allval,param.plotqt);
matrix = matrix - plotthresh;
matrix(matrix < 0) = 0;
matrix = matrix / max(max(matrix));

% calculate modules *after* thresholding edges
if isempty(param.minfo)
    param.minfo = modularity_louvain_und(matrix);
end

figure('Color','white','Name',mfilename);

colormap(jet);
cmap = colormap;
num_mod = max(param.minfo);
vcol = cmap(ceil((param.minfo/num_mod)*size(cmap,1)),:);

for c = 1:length(chanlocs)
    vsize(c) = length(nonzeros(matrix(c,:)));
end
vsize = vsize - min(vsize);
vsize = vsize/max(vsize);

hScat = scatter3(cell2mat({chanlocs.X}), cell2mat({chanlocs.Y}), cell2mat({chanlocs.Z}),...
    ptrange(1)+(vsize*(ptrange(2)-ptrange(1))), vcol, 'filled', 'MarkerEdgeColor', [0 0 0],'LineWidth',2);
hAnnotation = get(hScat,'Annotation');
hLegendEntry = get(hAnnotation,'LegendInformation');
set(hLegendEntry,'IconDisplayStyle','off')

set(gca,'Visible','off','DataAspectRatioMode','manual');
view(param.view);

plotmax = true;
plotmin = true;
for r = 1:size(matrix,1)
    for c = 1:size(matrix,2)
        if r < c && matrix(r,c) > 0
            if param.minfo(r) == param.minfo(c)
                ecol = cmap(ceil((param.minfo(r)/num_mod)*size(cmap,1)),:);
                hLine = line([chanlocs(r).X chanlocs(c).X],[chanlocs(r).Y chanlocs(c).Y],...
                    [chanlocs(r).Z chanlocs(c).Z],'Color',ecol,'LineWidth',...
                    lwrange(1)+(matrix(r,c)*(lwrange(2)-lwrange(1))),'LineStyle','-');
            elseif strcmp(param.plotinter,'on')
                hLine = line([chanlocs(r).X chanlocs(c).X],[chanlocs(r).Y chanlocs(c).Y],...
                    [chanlocs(r).Z chanlocs(c).Z],'Color',[0 0 0],'LineWidth',...
                    lwrange(1)+(matrix(r,c)*(lwrange(2)-lwrange(1))),'LineStyle','-');
            else
                hLine = [];
            end
            
            if ~isempty(hLine)
                if matrix(r,c) == max(nonzeros(matrix)) && plotmax
                    set(hLine,'DisplayName',sprintf('%.02f',origmatrix(r,c)));
                    plotmax = false;
                elseif matrix(r,c) == min(nonzeros(matrix)) && plotmin
                    set(hLine,'DisplayName',sprintf('%.02f',origmatrix(r,c)));
                    plotmin = false;
                else
                    hAnnotation = get(hLine,'Annotation');
                    hLegendEntry = get(hAnnotation,'LegendInformation');
                    set(hLegendEntry,'IconDisplayStyle','off')
                end
            end
        end
    end
end

% for c = 1:length(chanlocs)
%     text(chanlocs(c).X,chanlocs(c).Y,chanlocs(c).Z+0.5,chanlocs(c).labels,...
%     'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
% end

figpos = get(gcf,'Position');
set(gcf,'Position',[10 10 figpos(3)*2 figpos(4)*2]);
if strcmp(param.legend,'on')
    legend('show');
end