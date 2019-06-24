function [data] = MPC_run(screen_param, expt_param, data)  
%% Assign variables
font = screen_param.window_info.font ;
fontsize = screen_param.window_info.fontsize;
theWindow = screen_param.window_info.theWindow;
window_num = screen_param.window_info.window_num ;
window_rect = screen_param.window_info.window_rect;
H = screen_param.window_info.H ;
W = screen_param.window_info.W;

lb1 = screen_param.line_parameters.lb1 ;
lb2 = screen_param.line_parameters.lb2 ;
rb1 = screen_param.line_parameters.rb1;
rb2 = screen_param.line_parameters.rb2;
scale_H = screen_param.line_parameters.scale_H ;
scale_W = screen_param.line_parameters.scale_W;
anchor_lms = screen_param.line_parameters.anchor_lms;

bgcolor = screen_param.color_values.bgcolor;
orange = screen_param.color_values.orange;
red = screen_param.color_values.red;
white = screen_param.color_values.white;  


%% SETUP: Eyelink
% need to be revised when the eyelink is here.
% It located after open screen
if expt_param.USE_EYELINK
    %eyelink_filename = 'F_NAME'; % name should be equal or less than 8
    %edf_filename = ['M_' new_SID '_' num2str(runNbr)];
    edfFile = sprintf('%s.EDF', expt_param.eyelink_filename);
    eyelink_main(edfFile, window_info, 'Init');
    
    status = Eyelink('Initialize');
    if status
        error('Eyelink is not communicating with PC. Its okay baby.');
    end
    Eyelink('Command', 'set_idle_mode');
    waitsec_fromstarttime(GetSecs, .5);
end


% Keyboard input setting
% device(1).product = 'Apple Keyboard';   % imac scanner (full keyboard)
% device(1).vendorID= 1452;
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


% ===== Scanner trigger setting
% device(3).product = 'KeyWarrior8 Flex';
% device(3).vendorID= 1984;
% scanner = IDkeyboards(device(3));

%% Waitting for 's' or 't' key
while true
    msgtxt = '\n스캔(s) \n\n 테스트(t)';
    DrawFormattedText(theWindow, double(msgtxt), 'center', 'center', white, [], [], [], 2);
    Screen('Flip', theWindow);
    
%   [~,~,keyCode] = KbCheck(scanner);
    [~,~,keyCode] = KbCheck;
    % If it is for fMRI experiment, it will start with "s",
    % But if it is test time, it will start with "t" key.
    if expt_param.dofmri
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
if expt_param.dofmri
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('스캔이 시작됩니다.'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    waitsec_fromstarttime(data.dat.fmri_start_time, 5);
end


%% SETUP: BIOPAC and EYELINK
if expt_param.USE_BIOPAC
    bio_t = GetSecs;
    data.dat.biopac_triggertime = bio_t;
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    unix('python3 labjack.py 2')
end

if expt_param.USE_EYELINK
    Eyelink('StartRecording');
    %data.dat{runNbr}{trial_Number(j)}.eyetracker_starttime = GetSecs; % eyelink timestamp
    Eyelink('Message','Run start');
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


%% Making shuffled Heat intensity list and movie-nomovie type list
quotient = fix(expt_param.Trial_nums/length(expt_param.heat_intensity_table));
remainder = mod(expt_param.Trial_nums, length(expt_param.heat_intensity_table));

%Error handling
if not(remainder==0)
    error('Value error! \nmod(Trial_nums, length(expt_param.heat_intensity_table)) have to be 0 which is now mod(%d, %d)=%d', ...
    expt_param.Trial_nums, length(expt_param.heat_intensity_table), remainder);
end

if not(mod(quotient, 2)==0)
    error('Value error! \nmod(fix(Trial_nums/length(expt_param.heat_intensity_table)),2) have to be 0 which is now mod(%d, 2) = %d', ...
        quotient, mod(quotient, 2));
end

heat_program_table = [];
for i = 1:quotient
    heat_program_table = [heat_program_table expt_param.heat_intensity_table];
end

movie_list = [];
no_movie_list = [];
for i = 1:length(expt_param.heat_intensity_table)
    movie_list = [movie_list string('movie')];
    no_movie_list = [no_movie_list string('no_movie')];
end

trial_type = [];
for i = 1:fix(quotient/2)
    trial_type = [trial_type movie_list no_movie_list];
end

rng('shuffle')
arr = 1:length(heat_program_table);
sample_index = datasample(arr, length(arr), 'Replace',false);

shuffled_heat_list = heat_program_table(sample_index);
shuffled_type_list = trial_type(sample_index);

% Making pathway program list
PathPrg = load_PathProgram('MPC');

for mm = 1:length(shuffled_heat_list)
    index = find([PathPrg{:,1}] == shuffled_heat_list(mm));
    heat_param(mm).program = PathPrg{index, 4};
    heat_param(mm).intensity = shuffled_heat_list(mm);
end

data.dat.heat_param = heat_param;

%% Adjusting time from fmri started.
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

[~,~,keyCode] = KbCheck;
if keyCode(KbName('q')) == 1
    abort_experiment('manual');
end


%% Wating 13 seconds from fmri started
waitsec_fromstarttime(data.dat.fmri_start_time, 13);


%% Saving Run start time
data.dat.run_starttime = GetSecs;
data.dat.between_fmri_run_start_time = data.dat.run_starttime - data.dat.fmri_start_time;


%% Run start
if strcmp(expt_param.run_type, 'no_movie_heat') % No movie heat Run
    for Trial_num = 1:expt_param.Trial_nums
        data = MPC_trial_heat(screen_param, expt_param, Trial_num, data, ckpt, heat_param(Trial_num));
    end
    
elseif strcmp(expt_param.run_type, 'movie_heat') % Movie heat Run
    for Trial_num = 1:expt_param.Trial_nums % movie -> no_movie -> movie -> no_movie ... sequence
        if strcmp(shuffled_type_list(Trial_num),'movie')
            [data, ckpt] = MPC_trial_movie_heat(screen_param, expt_param, Trial_num, data, ckpt, heat_param(Trial_num));
        else
            [data, ckpt] = MPC_trial_heat(screen_param, expt_param, Trial_num, data, ckpt, heat_param(Trial_num));
        end
    end
    
else % CAPS Run
    data = MPC_trial_caps(screen_param, expt_param, data);
end


%% Shutdown eyelink, Saving Biopack end time
if expt_param.USE_EYELINK
    Eyelink('Message','Run ends');
    eyelink_main(edfFile, window_info, 'Shutdown');
end

if expt_param.USE_BIOPAC %end BIOPAC
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