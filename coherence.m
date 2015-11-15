function coherence(basename)
% matrix with all coherence number for a frequency interval : freq1:freq2

loadpaths

alpha = 0.05;
nboot = 50;

%     if exist([filepath basename 'wplifdr.mat'],'file')
%         fprintf('%s exists. Skipping...\n',[basename 'wplifdr.mat']);
%         continue;
%     end

EEG = pop_loadset('filename',[basename '.set'],'filepath',filepath);
chanlocs = EEG.chanlocs;

% EEG = rereference(EEG,5);

matrix=zeros(size(EEG.freqlist,1),EEG.nbchan,EEG.nbchan); % size(EEG.freqlist,1) lines ; EEG.nbchan columns ; EEG.nbchan time this table
pval=zeros(size(EEG.freqlist,1),EEG.nbchan,EEG.nbchan);
bootmat=zeros(size(EEG.freqlist,1),EEG.nbchan,EEG.nbchan,nboot);

% matrixcoherence of each pair of electrodes
for chann1=1:EEG.nbchan
    fprintf('%d',chann1);
    for chann2=1:EEG.nbchan
        fprintf(' %d',chann2);
        if chann1 < chann2
            [cohall, cohbootall, freqsout] = calcwpli(EEG,chann1,chann2);
            
            for fidx = 1:size(EEG.freqlist,1)
                [matrix(fidx,chann1,chann2), pval(fidx,chann1,chann2), bootmat(fidx,chann1,chann2,:)] = ...
                    bandcoh(EEG.freqlist(fidx,1),EEG.freqlist(fidx,2),cohall,cohbootall,freqsout);
            end
        elseif chann1 > chann2
            matrix(:,chann1,chann2) = matrix(:,chann2,chann1);
            pval(:,chann1,chann2) = pval(:,chann2,chann1);
            bootmat(:,chann1,chann2,:) = bootmat(:,chann2,chann1,:);
        end
    end
    fprintf('\n');
end
fprintf('\n');

%%%% FDR correction
% for f = 1:size(EEG.freqlist,1)
%     coh = squeeze(matrix(f,:,:));
%     pvals = squeeze(pval(f,:,:));
%     
%     tmp_pvals = pvals(logical(triu(ones(size(pvals)),1)));
%     tmp_coh = coh(logical(triu(ones(size(coh)),1)));
%     
%     [~, p_masked]= fdr(tmp_pvals,alpha);
%     tmp_pvals(~p_masked) = 1;
%     tmp_coh(tmp_pvals >= alpha) = 0;
%     
%     coh = zeros(size(coh));
%     coh(logical(triu(ones(size(coh)),1))) = tmp_coh;
%     coh = triu(coh,1)+triu(coh,1)';
%     
%     pvals = zeros(size(pvals));
%     pvals(logical(triu(ones(size(pvals)),1))) = tmp_pvals;
%     pvals = triu(pvals,1)+triu(pvals,1)';
%     
%     matrix(f,:,:) = coh;
%     pval(f,:,:) = pvals;
% end

save([filepath 'wpli/' basename 'wplifdr.mat'],'matrix','pval','bootmat','chanlocs');
