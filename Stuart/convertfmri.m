function convertfmri

filepath = 'C:\Users\Stuart\Documents\MATLAB\fMRI\';

load([filepath 'Wcor_cientosesenta_gmremoved.mat']);
load([filepath 'beh_stats.mat']);
load([filepath 'drug_level.mat']);

cnt = 0;
for subjidx = 1:length(Wcor)
    for runidx = 1:length(Wcor(subjidx).run)
        cnt = cnt+1;
        filename = sprintf('sub%02d_run%02d',subjidx,runidx);
        matrix = zeros(2,size(Wcor(subjidx).run(runidx).scale2,1),...
            size(Wcor(subjidx).run(runidx).scale2,1));
        matrix(1,:,:) = Wcor(subjidx).run(runidx).scale2;
        matrix(2,:,:) = Wcor(subjidx).run(runidx).scale3;
        
        save(filename,'matrix');
        
        subjlist{cnt,1} = filename;
        subjlist{cnt,2} = runidx;
        subjlist{cnt,3} = drug_level(subjidx,runidx);
        subjlist{cnt,4} = beh_stats.RT_test(runidx,subjidx);
        subjlist{cnt,5} = 1-beh_stats.miss_test(runidx,subjidx);
    end
end

printcell(subjlist,{'%s','%d','%.3f','%.3f','%.3f'});