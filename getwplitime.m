function getwplitime(subjidx)

loadpaths

cd /home/sc03/Sedation-RestingState/Iulia

matrix = AggregateMaxFreqMatrix(subjidx,0,8:0.1:15);

fprintf('Writing %d WPLI frames to %swpli-time/%02d_wpli.mat\n',length(matrix),filepath,subjidx);
save(sprintf('%swpli-time/%02d_wpli.mat',filepath,subjidx),'matrix');
cd ..