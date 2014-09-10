function CovarsPower

loadpaths
loadsubj
load grp2.mat

Drug = cell2mat(subjlist(:,3));
RT = cell2mat(subjlist(:,4));
Hits = cell2mat(subjlist(:,5));

channame = {
    'Fz'  'Oz'
    'F3'  'O1'
    'F4'  'O2'
    'E16' 'E65'
    'E19' 'E71'
    'F4'  'E76'
    'E5'  'E90'
    'E6'  'E66'
    'E12' 'E84'
    };

% Calculate Power
    nchans = length(channame);
    nsubj = length(subjlist);
    f = 3;
    k = 1;
    for subj = 1:nsubj
            EEG = pop_loadset('filepath',filepath,'filename',[subjlist{subj,1} '.set'],'loadmode','info');
            freqwin = EEG.freqwin;
            if nchans >= 1
                for chan = 1:nchans
                    if f < 5
                        Bandpower(subj,chan) = squeeze(mean(mean(EEG.spectra(strcmp(channame(chan,k),{EEG.chanlocs.labels}),...
                        EEG.freqs >= freqwin(1,f) & EEG.freqs <= freqwin(1,f+1),:),2),3));
                    else
                       Bandpower(subj,chan) = squeeze(mean(mean(EEG.spectra(strcmp(channame(chan,k),{EEG.chanlocs.labels}),...
                       EEG.freqs >= freqwin(1,f),:),2),3)); 
                    end
                end
            else
                if f < 5
                    Bandpower(subj) = squeeze(mean(mean(mean(EEG.spectra(:,EEG.freqs >= freqwin(1,f) & EEG.freqs <= freqwin(1,f+1),:),1),2),3));
                else
                    Bandpower(subj) = squeeze(mean(mean(mean(EEG.spectra(:,EEG.freqs >= freqwin(1,f),:),1),2),3));
                end
            end
    end
    if nchans >= 1           
        Bandpower = mean(Bandpower,2);
    else
        Bandpower = Bandpower';
    end
        
% Correlate Power with Covariates
    figure('Color','white');
    i = 1;
    for i = 1:3
        subplot(2,3,i);
        if i == 1;
            f = fit(Drug(Drug > 0),Bandpower(Drug > 0),'poly1');
            plot(f,Drug(Drug > 0),Bandpower(Drug > 0),'.b');   
            xlabel('Drug Level');
            ylabel('Power'); 
            [rho, pval] = corr(Drug(Drug > 0),Bandpower(Drug > 0),'type','spearman');
            fprintf('\n')
            fprintf('Rho = %.2f     p = %.3f\n',rho,pval);
            fprintf('\n')
            
        elseif i == 2;
            f = fit(RT(RT ~= -1 & grp(:,1) ~= 1),Bandpower(RT ~= -1 & grp(:,1) ~= 1),'poly1');
            plot(f,RT(RT ~= -1 & grp(:,1) ~= 1),Bandpower(RT ~= -1 & grp(:,1) ~= 1),'.b');
            xlabel('Perceptual RT');
            ylabel('Power');
            [rho, pval] = corr(RT(RT ~= -1 & grp(:,1) ~= 1),Bandpower(RT ~= -1 & grp(:,1) ~= 1),'type','spearman');
            fprintf('Rho = %.2f     p = %.3f\n',rho,pval);
            fprintf('\n')
            
        elseif i == 3;
            f = fit(Hits(grp(:,1) == 3),Bandpower(grp(:,1) == 3),'poly1');
            plot(f,Hits(grp(:,1) == 3),Bandpower(grp(:,1) == 3),'.b');
            xlabel('Hit Rate');
            ylabel('Power');
            [rho, pval] = corr(Hits(grp(:,1) == 3),Bandpower(grp(:,1) == 3),'type','spearman');
            fprintf('Rho = %.2f     p = %.3f\n',rho,pval);
            fprintf('\n')                  
        end  
        hold all;
        legend('off');
    end
    [~,h4]=suplabel('Power vs Covariates','t');
    set(h4,'FontSize',16)
end    

