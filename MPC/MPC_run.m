function [data] = MPC_run(window_info, line_parameters, color_values, Trials_nums, Run_num, Stimulus_type, Pathway, USE_BIOPAC, USE_EYELINK, dofmri, data, heat_intensity_table)  

%Assign variables
font = window_info.font ;
fontsize = window_info.fontsize;
theWindow = window_info.theWindow;
window_num = window_info.window_num ;
window_rect = window_info.window_rect;
H = window_info.H ;
W = window_info.W;

lb1 = line_parameters.lb1 ;
lb2 = line_parameters.lb2 ;
rb1 = line_parameters.rb1;
rb2 = line_parameters.rb2;
scale_H = line_parameters.scale_H ;
scale_W = line_parameters.scale_W;
anchor_lms = line_parameters.anchor_lms;

bgcolor = color_values.bgcolor;
orange = color_values.orange;
red = color_values.red;
white = color_values.white;  


%% SETUP: Biopack
if USE_BIOPAC
    channel_n = 3;
    biopac_channel = 0;
    ljHandle = BIOPAC_setup(channel_n); % BIOPAC SETUP
end

%% SETUP: Eyelink
% need to be revised when the eyelink is here.
% It located after open screen
if USE_EYELINK
    edf_filename = 'FILE_NAME_HERE'; % name should be equal or less than 8
    %edf_filename = ['M_' new_SID '_' num2str(runNbr)];
    edfFile = sprintf('%s.EDF', edf_filename);
    eyelink_main(edfFile, 'Init');
    
    status = Eyelink('Initialize');
    if status
        error('Eyelink is not communicating with PC. Its okay baby.');
    end
    Eyelink('Command', 'set_idle_mode');
    waitsec_fromstarttime(GetSecs, .5);
end


%% Ready for start run
while true % To Start, Push Space
    msgtxt = '\n???? ????????????, a ?? ??????????.\n\n (Check Eyelink, Biopack, etc...)\n\n';
    DrawFormattedText(theWindow, double(msgtxt), 'center', 'center', white, [], [], [], 2);
    Screen('Flip', theWindow);
    
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('a')) == 1
        break
    elseif keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end
end


%% Waitting for 's' or 't' key
while (1)
    msgtxt = '\n????(s) \n\n ??????(t)';
    DrawFormattedText(theWindow, double(msgtxt), 'center', 'center', white, [], [], [], 2);
    Screen('Flip', theWindow);
    
    [~,~,keyCode] = KbCheck;
    % If this is for fMRI experiment, it will start with "s",
    % But if test time, it will start with "t" key.
    if dofmri
        if keyCode(KbName('s'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment;
        end
    else
        if keyCode(KbName('t'))==1
            break
        elseif keyCode(KbName('q'))==1
            abort_experiment;
        end
    end
end


%% fMRI
data.dat.fmri_start_time(1, Run_num) = GetSecs;
if dofmri
    % gap between 5 key push and the first stimuli (disdaqs: data.disdaq_sec)
    % 5 seconds:
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('?????? ??????????.'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    waitsec_fromstarttime(data.dat.fmri_start_time(1, Run_num), 5); % ADJUST THIS
end

%% SETUP: BIOPAC and EYELINK
if USE_BIOPAC
    bio_t = GetSecs;
    %data.dat{runNbr}{trial_Number(j)}.biopac_triggertime = bio_t; %BIOPAC timestamp
    BIOPAC_trigger(ljHandle, biopac_channel, 'on');
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    waitsec_fromstarttime(bio_t, 2); % ADJUST THIS
end

if USE_BIOPAC
    BIOPAC_trigger(ljHandle, biopac_channel, 'off');
end

if USE_EYELINK
    Eyelink('StartRecording');
    %data.dat{runNbr}{trial_Number(j)}.eyetracker_starttime = GetSecs; % eyelink timestamp
    Eyelink('Message','Run start');
end


%% Adjusting time from fmri started.
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

[~,~,keyCode] = KbCheck;
if keyCode(KbName('q')) == 1
    abort_experiment('manual');
end

waitsec_fromstarttime(data.dat.fmri_start_time(1, Run_num), 9); % waitting for 9 second from fmri started time


%% Saving Run start time
data.dat.run_starttime(1, Run_num) = GetSecs;
data.dat.between_fmri_run_start_time(1, Run_num) = data.dat.run_starttime(1, Run_num) - data.dat.fmri_start_time(1, Run_num);


%% Trial start
if strcmp(Stimulus_type(1,Run_num), 'no_movie_heat')
    data = MPC_trial_heat(window_info, line_parameters, color_values, Trials_nums, Run_num, Pathway, data, heat_intensity_table);
elseif strcmp(Stimulus_type(1,Run_num), 'movie_heat')
    data = MPC_trial_movie_heat(window_info, line_parameters, color_values, Trials_nums, Run_num, Pathway, data, heat_intensity_table);
else
    data = MPC_trial_caps(window_info, line_parameters, color_values, Run_num, data);
end


%% Shutdown eyelink, Saving Biopack end time
if USE_EYELINK
    Eyelink('Message','Run ends');
    eyelink_main(edfFile, 'Shutdown');
end

if USE_BIOPAC %end BIOPAC
    bio_t = GetSecs;
    data.dat{runNbr}{trial_Number(j)}.biopac_endtime = bio_t;% biopac end timestamp
    BIOPAC_trigger(ljHandle, biopac_channel, 'on');
    waitsec_fromstarttime(bio_t, 0.1); % it should be adjusted
    BIOPAC_trigger(ljHandle, biopac_channel, 'off');
end


%% Saving Data
data.dat.run_end_time(1, Run_num) = GetSecs;
data.dat.run_duration_time(1, Run_num) = data.dat.run_end_time(1, Run_num) - data.dat.fmri_start_time(1, Run_num);

save(data.datafile, 'data', '-append');

end     