function peekdata

loadpaths
filepath = '/imaging/sc03/';
javaaddpath /home/sc03/MATLAB/eeglab/plugins/MFFimport1.00/MFF-1.0.d0004.jar

filelist = {
%     '02-2010-anest 20100210 1354.mff'
    '03-2010-anest 20100211 1421.mff'
    };

for f = 1:length(filelist)
    evt = read_mff_event([filepath filelist{f}]);
    eventinfo = cat(2,{evt.type}',{evt.sample}',{evt.value}');
    for e = 1:length(evt)
        evtcodes = evt(e).codes';
        evtcodes = evtcodes(:)';
        if ~isempty(evtcodes)
            eventinfo(e,4:4+length(evtcodes)-1) = evtcodes;
        end
    end
    save(sprintf('%s/%s_eventinfo.mat',filepath,filelist{f}),'eventinfo');
end
