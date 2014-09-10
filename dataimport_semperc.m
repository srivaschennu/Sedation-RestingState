function dataimport_semperc(basename)

loadpaths

filenames = dir(sprintf('%s%s*', rawpath, basename));

if isempty(filenames)
    error('No files found to import!\n');
end

mfffiles = filenames(logical(cell2mat({filenames.isdir})));
if length(mfffiles) > 1
    error('Expected 1 MFF recording file. Found %d.\n',length(mfffiles));
end

filename = mfffiles.name;
fprintf('\nProcessing %s.\n\n', filename);

mffjarpath = which('MFF-1.0.d0004.jar');
javaaddpath(mffjarpath);
evt = read_mff_event(sprintf('%s%s', rawpath, filename));
javarmpath(mffjarpath);

chunk = 1;
breakidx = find(strcmp('break cnt',{evt.type}));
for e = 1:length(evt)-2
    if strcmp('break cnt',evt(e).type) && (strcmp('sync',evt(e+1).type) && strcmp('word',evt(e+2).type) || strcmp('word',evt(e+1).type))
        chunks(chunk,1) = evt(e).sample;
        chunks(chunk,2) = evt(breakidx(find((breakidx-e) > 0,1,'first'))).sample;
        chunk = chunk+1;
    end
end

for chunk = 1:size(chunks,1)
    EEG = pop_readegimff(sprintf('%s%s', rawpath, filename),...
        'firstsample',chunks(chunk,1),'lastsample',chunks(chunk,2));
    chunkname = sprintf('%d',chunk);
    
    %%PREPROCESSING
    
%     % REMOVE EXCLUDED CHANNELS
%     chanexcl = [1,8,14,17,21,25,32,38,43,44,48,49,56,63,64,68,69,73,74,81,82,88,89,94,95,99,107,113,114,119,120,121,125,126,127,128];
%     %chanexcl = [];
%     fprintf('Removing excluded channels.\n');
%     EEG = pop_select(EEG,'nochannel',chanexcl);
    
    %resample
    if EEG.srate > 250
        EEG = pop_resample(EEG,250);
    end
    
%     %Filter
%     hpfreq = 0.5;
%     lpfreq = 45;
%     fprintf('Low-pass filtering below %.1fHz...\n',lpfreq);
%     EEG = pop_eegfiltnew(EEG, 0, lpfreq);
%     fprintf('High-pass filtering above %.1fHz...\n',hpfreq);
%     EEG = pop_eegfiltnew(EEG, hpfreq, 0);
%     
%     %Remove line noise
%     fprintf('Removing line noise at 50Hz.\n');
%     EEG = rmlinenoisemt(EEG);
    
    EEG.setname = sprintf('%s_%s_orig',basename,chunkname);
    EEG.filename = sprintf('%s_%s_orig.set',basename,chunkname);
    EEG.filepath = filepath;
    
    EEG = eeg_checkset(EEG);
    
    fprintf('Saving %s%s.\n', EEG.filepath, EEG.filename);
    pop_saveset(EEG,'filename', EEG.filename, 'filepath', EEG.filepath);
end