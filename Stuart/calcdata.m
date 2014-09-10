function calcdata(listname,conntype)

loadpaths
loadsubj

subjlist = eval(listname);

load chanlist.mat

tvals = 0.5:-0.025:0.025;

for s = 1:size(subjlist,1)
    basename = subjlist{s,1};
    fprintf('Processing %s.\n',basename);
    
    specinfo = pop_loadset('filepath',filepath,'filename',[basename '.set'],'loadmode','info');
    specinfo.spectra = mean(specinfo.spectra,3);
    [sortedchan,sortidx] = sort({specinfo.chanlocs.labels});
    if ~strcmp(chanlist,cell2mat(sortedchan))
        error('Channel names do not match!');
    end
    specinfo.spectra = specinfo.spectra(sortidx,:);
    specinfo.spectra = 10.^(specinfo.spectra/10);
    
    load([filepath conntype filesep basename conntype 'fdr.mat']);
    [sortedchan,sortidx] = sort({chanlocs.labels});
    if ~strcmp(chanlist,cell2mat(sortedchan))
        error('Channel names do not match!');
    end
    matrix = matrix(:,sortidx,sortidx);
    
    if s == 1
        freqbins = specinfo.freqs;
        spectra = zeros(size(subjlist,1),length(chanlocs),length(specinfo.freqs));
        bandpower = zeros(size(subjlist,1),size(matrix,1),length(chanlocs));
        bandpeak = zeros(size(subjlist,1),size(matrix,1),length(chanlocs));
%         allcoh = zeros(length(subjlist),size(matrix,1),length(tvals),length(chanlocs),length(chanlocs));
%         degree = zeros(length(subjlist),size(matrix,1),length(tvals),length(chanlocs));
    end
    
    spectra(s,:,:) = specinfo.spectra;
    for f = 1:size(matrix,1)
%         cohmat = squeeze(matrix(f,:,:));
        cohmat = zeromean(squeeze(matrix(f,:,:)));
        
        %collate spectral info
        [~, bstart] = min(abs(specinfo.freqs-specinfo.freqlist(f,1)));
        [~, bstop] = min(abs(specinfo.freqs-specinfo.freqlist(f,2)));
        bandpower(s,f,:) = mean(specinfo.spectra(:,bstart:bstop),2);
        
        [~, maxfreq] = max(specinfo.spectra(:,bstart:bstop),[],2);
        bandpeak(s,f,:) = specinfo.freqs(bstart-1+maxfreq);
        
%         %collate connectivity info
%         for thresh = 1:length(tvals)
%             threshcoh = threshold_proportional(zeromean(cohmat),tvals(thresh));
%             bincohmat = double(threshold_proportional(cohmat,tvals(thresh)) ~= 0);
%             
%             allcoh(s,f,thresh,:,:) = bincohmat;
%             degree(s,f,thresh,:) = degrees_und(bincohmat);
%         end
        allcoh(s,f,:,:) = cohmat;
        degree(s,f,:) = degrees_und(cohmat);
    end
    for c = 1:size(bandpower,3)
        bandpower(s,:,c) = bandpower(s,:,c)./sum(bandpower(s,:,c));
    end
    grp(s,1) = subjlist{s,2};
end
save(sprintf('%s/%s/alldata_%s_%s.mat',filepath,conntype,listname,conntype), 'grp', 'spectra', 'freqbins', 'bandpower', 'bandpeak', 'allcoh', 'subjlist', 'degree');