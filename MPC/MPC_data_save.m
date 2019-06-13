function [data]= MPC_data_save(Run_name, Run_Num, basedir)

    % data
    
    savedir = fullfile(basedir, 'Data');

    nowtime = clock;
    SubjDate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

    data.run_name = Run_name;
    data.datafile = fullfile(savedir, [SubjDate, '_', sprintf('%.3d', Run_Num), '_', Run_name, '_MPC', '.mat']);
    data.version = 'MPC_06-12-2019_Cocoanlab';  % month-date-year
    data.starttime = datestr(clock, 0);
    data.dat.experiment_start_time = GetSecs;
    
    % if the same file exists, break and retype subject info
    if exist(data.datafile, 'file')
        fprintf('\n ** EXSITING FILE: %s %s **', Run_Num, SubjDate);
        cont_or_not = input(['\nThe typed Run name and number are already saved.', ...
            '\nWill you go on with your Run name and number that saved before?', ...
            '\n1: Yes, continue with Run name and number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
        if cont_or_not == 2
            error('Breaked.')
        elseif cont_or_not == 1
            save(data.datafile, 'data');
        end
    else
        save(data.datafile, 'data');
    end

end