function [cohval, sigval, bootcoh] = bandcoh(freq1,freq2,cohall,cohbootall,freqsout)

[~, minidx] = min(abs(freqsout-freq1));
a=minidx;
[~, minidx] = min(abs(freqsout-freq2));
b=minidx;

cohall = cohall(a:b,:);
cohbootall = cohbootall(:,a:b,:);

% %take max over time
% cohval = max(max(cohall,[],2));
% bootcoh = max(max(cohbootall,[],3),[],2);

%take mean over time
cohval = max(mean(cohall,2));
bootcoh = max(mean(cohbootall,3),[],2);

sigval = sum(bootcoh >= cohval)/length(bootcoh);