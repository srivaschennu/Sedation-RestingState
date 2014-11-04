function minfo = plotgraph3d(matrix,chanlocs,varargin)

% matrix - NxN symmetric connectivity matrix, where N is the number of channels
% chanlocs - 1xN EEGLAB chanlocs structure specifying channel locations

% OPTIONAL ARGUMENTS
% plotqt - proportion of strongest edges to plot
% minfo - 1xN module affiliation vector. Will be calculated if unspecified
% legend - whether or not to plot legend with max and min edge weights
% plotinter - whether or not to plot inter-modular edges

param = finputcheck(varargin, {
    'plotqt', 'real', [], 0.7; ...
    'minfo', 'integer', [], []; ...
    'plotinter', 'string', {'on','off'}, 'off'; ...
    'escale', 'real', [], []; ...
    'vscale', 'real', [], []; ...
    });

%%%%% VISUAL FEATURES

%spline file
splinefile = '91_spline.spl';

% range of line heights
lhfactor = 2;

%%%%%%

% load chanlist
% [sortedchan,sortidx] = sort({chanlocs.labels});
% if ~strcmp(chanlist,cell2mat(sortedchan))
%     error('Channel names do not match!');
% end
% matrix = matrix(sortidx,sortidx);

% keep only top <plotqt>% of weights
matrix = threshold_proportional(matrix,1-param.plotqt);

for c = 1:size(matrix,1)
    vsize(c) = sum(matrix(c,:))/(size(matrix,2)-1);
end

% calculate modules after thresholding edges
if isempty(param.minfo)
    minfo = modularity_louvain_und(matrix);
else
    minfo = param.minfo;
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

% assign all modules with only one vertex the same colour
modsize = hist(minfo,unique(minfo));
[modsize,modidx] = sort(modsize,'descend');

num_mod = sum(modsize > 1);
mcount = 1;
for m = 1:length(modsize)
    if modsize(modidx == m) == 1
        minfo(minfo == m) = num_mod + 1;
    else
        minfo(minfo == m) = mcount;
        mcount = mcount + 1;
    end
end
num_mod = length(unique(minfo));

figure('Color','black','Name',mfilename);
colormap(jet);
cmap = colormap;

[~,chanlocs3d] = headplot(vsize,splinefile,'electrodes','off','maplimits',[param.vscale(1)-0.4 param.vscale(2)+0.4],'view','frontleft');
hold all
xlim('auto'); ylim('auto'); zlim('auto');

for r = 1:size(matrix,1)
    for c = 1:size(matrix,2)
        if r < c && matrix(r,c) > 0
            eheight = (matrix(r,c)*lhfactor)+1;
            if minfo(r) == minfo(c)
                hLine = plotarc3d(chanlocs3d([r,c],:),eheight);
                ecol = cmap(ceil((minfo(r)/num_mod)*size(cmap,1)),:);
                set(hLine,'Color',ecol,'LineWidth',0.5);
            elseif strcmp(param.plotinter,'on')
                hLine = plotarc3d(chanlocs3d([r,c],:),eheight);
                ecol = [0 0 0];
                set(hLine,'Color',ecol,'LineWidth',0.5);
            end
        end
    end
end

figpos = get(gcf,'Position');
set(gcf,'Position',[figpos(1) figpos(2) figpos(3)*2 figpos(4)*2]);