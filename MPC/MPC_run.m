function [data] = MPC_run(window_info, line_parameters, color_values, Trial_nums, run_type, Pathway, USE_BIOPAC, USE_EYELINK, eyelink_filename, dofmri, data, heat_intensity_table, moviefile, movie_duration, caps_stim_duration)  
%% Assign variables
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


%% SETUP: Eyelink
% need to be revised when the eyelink is here.
% It located after open screen
if USE_EYELINK
    eyelink_filename = 'F_NAME'; % name should be equal or less than 8
    %edf_filename = ['M_' new_SID '_' num2str(runNbr)];
    edfFile = sprintf('%s.EDF', eyelink_filename);
    eyelink_main(edfFile, window_info, 'Init');
    
    status = Eyelink('Initialize');
    if status
        error('Eyelink is not communicating with PC. Its okay baby.');
    end
    Eyelink('Command', 'set_idle_mode');
    waitsec_fromstarttime(GetSecs, .5);
end


%% Ready for start run
while true
    msgtxt = '\n모두 준비되었으면, a를 눌러주세요.\n\n (Check Eyelink, Biopack, etc...)\n\n';
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
    msgtxt = '\n스캔(s) \n\n 테스트(t)';
    DrawFormattedText(theWindow, double(msgtxt), 'center', 'center', white, [], [], [], 2);
    Screen('Flip', theWindow);
    
    [~,~,keyCode] = KbCheck;
    % If it is for fMRI experiment, it will start with "s",
    % But if it is test time, it will start with "t" key.
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


%% fMRI starts
data.dat.fmri_start_time = GetSecs;
if dofmri
    % gap between 5 key push and the first stimuli (disdaqs: data.disdaq_sec)
    % 5 seconds:
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('스캔이 시작됩니다.'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    waitsec_fromstarttime(data.dat.fmri_start_time, 5); % ADJUST THIS
end

%% SETUP: BIOPAC and EYELINK
if USE_BIOPAC
    bio_t = GetSecs;
    data.dat.biopac_triggertime = bio_t;
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    unix('python3 labjack.py 2')
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

%% Making or Loading checkpoint of Movie
basedir = pwd;
ckpt_folderdir = fullfile(basedir, 'Video_ckpt');
nowtime = clock;
filename = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));
ckpt_filedir = fullfile(ckpt_folderdir, [filename, '.mat']);

if exist(ckpt_filedir, 'file')
    load(ckpt_filedir);
else
    ckpt.ckptfile = ckpt_filedir;
    ckpt.movie_start_point = 999999999; %This can be any number for initialize which means empty
end

%% Wating 9 seconds from fmri started
waitsec_fromstarttime(data.dat.fmri_start_time, 9);


%% Saving Run start time
data.dat.run_starttime = GetSecs;
data.dat.between_fmri_run_start_time = data.dat.run_starttime - data.dat.fmri_start_time;


%% Run start
if strcmp(run_type, 'no_movie_heat') % No movie heat Run
    for Trial_num = 1:Trial_nums
        data = MPC_trial_heat(window_info, line_parameters, color_values, Trial_num, Pathway, data, ckpt, heat_intensity_table);
    end
    
elseif strcmp(run_type, 'movie_heat') % Movie heat Run
    for Trial_num = 1:Trial_nums % movie -> no_movie -> movie -> no_movie ... sequence
        if rem(Trial_num, 2) == 1
            [data, ckpt] = MPC_trial_movie_heat(window_info, line_parameters, color_values, Trial_num, Pathway, data, ckpt, heat_intensity_table, moviefile, movie_duration);
        else
            [data, ckpt] = MPC_trial_heat(window_info, line_parameters, color_values, Trial_num, Pathway, data, ckpt, heat_intensity_table);
        end
    end
    
else % CAPS Run
    data = MPC_trial_caps(window_info, line_parameters, color_values, data, caps_stim_duration);
end


%% Shutdown eyelink, Saving Biopack end time
if USE_EYELINK
    Eyelink('Message','Run ends');
    eyelink_main(edfFile, window_info, 'Shutdown');
end

if USE_BIOPAC %end BIOPAC
    bio_t = GetSecs;
    data.dat.biopac_endtime = bio_t;
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    unix('python3 labjack.py 2')
end


%% Saving Data
data.dat.run_end_time = GetSecs;
data.dat.run_duration_time = data.dat.run_end_time - data.dat.fmri_start_time;

save(data.datafile, 'data', '-append');
save(ckpt.ckptfile, 'ckpt');

end    