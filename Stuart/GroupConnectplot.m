function GroupConnectplot
loadsubj
load chanlist

% tvals = 0.5:-0.025:0.025;
% for i = 1:length(subjlist)
%     filename = sprintf('%splifdr.mat',cell2mat(subjlist(i,1)));
%     filename2 = horzcat('C:\Users\Stuart\Documents\MATLAB\Sedation Resting State\',filename);
%     load(filename2)
%     
%     [sortedchan,sortidx] = sort({chanlocs.labels});
%     if ~strcmp(chanlist,cell2mat(sortedchan))
%         error('Channel names do not match!');
%     end
%     matrix = matrix(:,sortidx,sortidx);
%     
%     for f = 1:size(matrix,1)
%         cohmat = squeeze(matrix(f,:,:));
%         for t = 1:length(tvals)
%             threshcoh = threshold_proportional(cohmat,tvals(t));
%             bincohmat = double(threshcoh ~= 0);
%             allcoh(f,1:size(bincohmat,1),1:size(bincohmat,2),t,i) = bincohmat;
%         end
%     end
% end
% save allcoh.mat allcoh grp

load allcoh.mat
load grp2.mat
% for g = 1:2
%     groupcoh = squeeze(mean(mean(allcoh(3,:,:,:,grp(:,3) == g & grp(:,1) == 3),5),4));
%     plotgraph(groupcoh,sortedlocs,0.85);
% end

% Comparing Participant 17 & 26 (matched drug)
coh = squeeze(mean(allcoh(3,:,:,:,grp(:,5) == 2),4));
plotgraph(coh,sortedlocs,0.85);

end

