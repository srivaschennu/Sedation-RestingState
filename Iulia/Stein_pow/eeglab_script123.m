function eeglab_script123(index)
    eeglab;
    clear;
    LoadFolderNames;
    LoadParams;
    index = 16;
    
    filename = data{index,1};
    chunkFirstSample = data{index,2};
    chunkLastSample = 100000; %data{index,1};
    
    eeglabSet = pop_readegimff([folderData filename], 'firstsample', chunkFirstSample, 'lastsample', chunkLastSample);

        % remove channels we don't want to see
        fprintf('*** Selecting channels...\n');
        eeglabSet = pop_select(eeglabSet, 'nochannel', chanExcluded);

        % make sure the sampling rate is the one we want
        if(actualSrate ~= eeglabSet.srate)
            error('unexpected sampling rate');
        elseif(eeglabSet.srate > srate)
            eeglabSet = pop_resample(eeglabSet, 250);
        elseif(eeglabSet.srate < srate)
            error('too small sampling rate');
        end

        % filter data between 0.05 and 21 Hz
        % eeglabSet = pop_eegfilt(eeglabSet,0,21);
        % eeglabSet = pop_eegfilt(eeglabSet,1,0);
        
        % create events for epoching
        nrEpochs = floor ( length(eeglabSet.times) / epochSizeSamples );
        ft_progress('init', 'text', '*** Creating events...');
        events = cell(nrEpochs,2);
        for epochIndex = 1 : nrEpochs
            newlatency = (epochIndex-1) * epochSizeSeconds;
            events{epochIndex,2} = newlatency;
            events{epochIndex,1} = EPOCH_EVENT_NAME;
            ft_progress(epochIndex/nrEpochs);
        end
        ft_progress('close');
        eeglabSet = pop_importevent(eeglabSet, 'event', events, 'fields', {'type','latency'}, 'append', 'no');

        % epoch the data 
        fprintf('*** Epoching...\n');
        eeglabSet = pop_epoch(eeglabSet, {EPOCH_EVENT_NAME}, [0 epochSizeSeconds]);
        
        % rereference
        fprintf('*** Rereferencing...\n');
        eeglabSet = rereference(eeglabSet,1);
    
    
    pop_saveset(eeglabSet,'filepath',int2str(index));
end