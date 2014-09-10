function plotpacgraph(matrix,chanlocs,varargin)

% matrix - NxN symmetric connectivity matrix, where N is the number of channels
% chanlocs - 1xN EEGLAB chanlocs structure specifying channel locations

% OPTIONAL ARGUMENTS
% plotqt - proportion of strongest edges to plot
% legend - whether or not to plot legend with max and min edge weights

param = finputcheck(varargin, {
    'plotqt', 'real', [], 0.9; ...
    'legend', 'string', {'on','off'}, 'on'; ...
    'escale', 'real', [], []; ...
    'vscale', 'real', [], []; ...
    });

%%%%% VISUAL FEATURES

% text attributes
fontname = 'Gill Sans';
fontsize = 16;
fontweight = 'bold';

% range of line widths
lwrange = [0.5 2];

% range of point sizes
ptrange = [10 800];

origmatrix = matrix;
matrix = abs(matrix);

% keep only top <plotqt>% of weights
matrix = threshold_proportional(matrix,1-param.plotqt);

for c = 1:size(matrix,1)
    vsize(c) = sum(matrix(c,:))/(size(matrix,2)-1);
end

% rescale weights
if isempty(param.escale)
    param.escale(1) = min(matrix(logical(triu(matrix,1))));
    param.escale(2) = max(matrix(logical(triu(matrix,1))));
end
matrix = (matrix - param.escale(1))/(param.escale(2) - param.escale(1));
matrix(matrix < 0) = 0;

% rescale degrees
if isempty(param.vscale)
    param.vscale(1) = min(vsize);
    param.vscale(2) = max(vsize);
end
vsize = (vsize - param.vscale(1))/(param.vscale(2) - param.vscale(1));
vsize(vsize < 0) = 0;

figure('Color','white','Name',mfilename);

colormap(jet);
cmap = colormap;

vcol = 'black';

hScat = scatter3(cell2mat({chanlocs.X}), cell2mat({chanlocs.Y}), cell2mat({chanlocs.Z}),...
    ptrange(1)+(vsize*(ptrange(2)-ptrange(1))), vcol, 'filled', 'MarkerEdgeColor', [0 0 0],'LineWidth',2);
hAnnotation = get(hScat,'Annotation');
hLegendEntry = get(hAnnotation,'LegendInformation');
set(hLegendEntry,'IconDisplayStyle','off')

set(gca,'Visible','off','DataAspectRatioMode','manual');
view(-90,90);

plotmax = true;
plotmin = true;
colorlist = {'blue','green'};
for r = 1:size(matrix,1)
    for c = 1:size(matrix,2)
        if r < c && matrix(r,c) > 0
            ecol = colorlist{(origmatrix(r,c) > 0)+1};
            hLine = line([chanlocs(r).X chanlocs(c).X],[chanlocs(r).Y chanlocs(c).Y],...
                [chanlocs(r).Z chanlocs(c).Z],'Color',ecol,'LineWidth',...
                lwrange(1)+(matrix(r,c)*(lwrange(2)-lwrange(1))),'LineStyle','-');
            
            if ~isempty(hLine)
                if origmatrix(r,c) == max(nonzeros(origmatrix)) && plotmax
                    set(hLine,'DisplayName',sprintf('%.02f',origmatrix(r,c)));
                    plotmax = false;
                elseif origmatrix(r,c) == min(nonzeros(origmatrix)) && plotmin
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
set(gcf,'Position',[figpos(1) figpos(2) figpos(3)*2 figpos(4)*2]);
if strcmp(param.legend,'on')
    legend('show');
end