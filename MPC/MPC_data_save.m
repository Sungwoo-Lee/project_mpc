function [data]= MPC_data_save(SID, SubjNum, basedir)

    % data
    
    savedir = fullfile(basedir, 'Data');

    nowtime = clock;
    SubjDate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

    data.subject = SID;
    data.datafile = fullfile(savedir, [SubjDate, '_', sprintf('%.3d', SubjNum), '_', SID, '_MPC', '.mat']);
    data.version = 'MPC_v1_03-2-2019_Cocoanlab';  % month-date-year
    data.starttime = datestr(clock, 0);
    data.dat.experiment_start_time = GetSecs;
    
    % if the same file exists, break and retype subject info
    if exist(data.datafile, 'file')
        fprintf('\n ** EXSITING FILE: %s %s **', data.subject, SubjDate);
        cont_or_not = input(['\nThe typed subject name and number are already saved.', ...
            '\nWill you go on with your subject name and number that saved before?', ...
            '\n1: Yes, continue with subject name and number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
        if cont_or_not == 2
            error('Breaked.')
        elseif cont_or_not == 1
            save(data.datafile, 'data');
        end
    else
        save(data.datafile, 'data');
    end

end