% data params
srate = 250;
cooldown = 30 * 60 * srate; % only read 30 minutes after stimulation (second value in the data)
epochSizeSeconds = 10; % split data into epochs of 3 seconds
epochSizeSamples = epochSizeSeconds * srate; % the number of samples per epoch
processingWindow = 60; % calculate wpli for groups of 20 epochs (20*3 seconds)
windowOverlap = 1; % 10 epochs (0.5 minutes) forward step between wpli groups
fileChunkSamples = 750000000; % how many samples to read from file at one time
globalCoherenceWindow = 10; % calculate global coherence for windows of 10 epochs (i.e. 10*10 seconds)

% excluded chans
chanExcluded = [1,8,14,17,21,25,32,38,43,44,48,49,56,63,64,68,69,73,74,81,82,88,89,94,95,99,107,113,114,119,120,121,125,126,127,128];

% freq analysis configuration
clear freqCfg;
freqCfg.method = 'mtmfft';
freqCfg.output = 'powandcsd';
freqCfg.foi = 1:0.1:20; % frequencies of interest
freqCfg.keeptrials = 'yes';
freqCfg.taper = 'hanning';
%freqCfg.toi = 0:10:100;
%freqCfg.t_ftimwin = ones(length(freqCfg.foi),1).*10;

% connectivity analysis configuration
clear connectivityCfg;
connectivityCfg.method = 'wpli_debiased'; 

% epoching event name
EPOCH_EVENT_NAME = 'NEW_EPOCH_EVENT';

% cleaning params
% thresholdChanStdDev = 500; % how much variance per epoch to make a channel bad
% thresholdChansPerEpoch = 0.03; % how many bad channels per epoch to make it bad
% thresholdEpochsPerWpli = 0.01; % how many bad epochs per wpli window to make it bad

% check params
if( mod (fileChunkSamples, epochSizeSamples) ~= 0)
    error('Please adjust fileChunkSamples to a multiple of the nr samples per epoch.');
end
if( fileChunkSamples < epochSizeSamples * processingWindow)
    error('Please adjust fileChunkSamples to allow at least one processing window.');
end