function [data] = MPC_run(screen_param, expt_param, data)  
%% Assign variables
global theWindow edfFile
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
    eyelink_main(edfFile, 'Init');
    
    status = Eyelink('Initialize');
    if status
        error('Eyelink is not communicating with PC. Its okay baby.');
    end
    Eyelink('Command', 'set_idle_mode');
    waitsec_fromstarttime(GetSecs, 0.5);
end


% Keyboard input setting
if expt_param.dofmri
    device(1).product = 'Apple Keyboard';
    device(1).vendorID= 1452;
    apple = IDkeyboards(device(1));
end 

%% Ready for start run
while true
    msgtxt = '\n모두 준비되었으면, a를 눌러주세요.\n\n (Check Eyelink, Biopack, etc...)\n\n';
    DrawFormattedText(theWindow, double(msgtxt), 'center', 'center', white, [], [], [], 2);
    Screen('Flip', theWindow);
    
    if expt_param.dofmri
        [~,~,keyCode] = KbCheck(apple);
    else
        [~,~,keyCode] = KbCheck;
    end
    
    if keyCode(KbName('a')) == 1
        break
    elseif keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end
end


% ===== Scanner trigger setting
if expt_param.dofmri
    device(2).product = 'KeyWarrior8 Flex';
    device(2).vendorID= 1984;
    scanner = IDkeyboards(device(2));
end

%% Waitting for 's' or 't' key
while true
    msgtxt = '\n스캔(s) \n\n 테스트(t)';
    DrawFormattedText(theWindow, double(msgtxt), 'center', 'center', white, [], [], [], 2);
    Screen('Flip', theWindow);
    
    if expt_param.dofmri
        [~,~,keyCode] = KbCheck(scanner);
        [~,~,keyCode2] = KbCheck(apple);
    else
        [~,~,keyCode] = KbCheck;
    end
    % If it is for fMRI experiment, it will start with "s",
    % But if it is test time, it will start with "t" key.
    if expt_param.dofmri
        if keyCode(KbName('s'))==1
            break
        elseif keyCode2(KbName('q'))==1
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
    bio_trigger_range = num2str(data.expt_param.Run_Num * 0.2 + 4);
    command = 'python3 labjack.py ';
    full_command = [command bio_trigger_range];
    data.dat.biopac_start_trigger_s = GetSecs;
    
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    unix(full_command)
%     unix('python3 labjack.py 3')
    data.dat.biopac_start_trigger_e = GetSecs;
    data.dat.biopac_start_trigger_dur = data.dat.biopac_start_trigger_e - data.dat.biopac_start_trigger_s;
end

if expt_param.USE_EYELINK
    Eyelink('StartRecording');
    data.dat.eyetracker_starttime = GetSecs; % eyelink timestamp
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
%     ckpt.ckptfile = ckpt_filedir;
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
Screen('TextSize', theWindow, 60);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);
Screen('TextSize', theWindow, fontsize);

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
elseif strcmp(expt_param.run_type, 'caps') % CAPS Run
    data = MPC_trial_caps(screen_param, expt_param, data);
    
else % Resting Run
    data = MPC_trial_resting(screen_param, expt_param, data);
end


%% Shutdown eyelink, Saving Biopack end time
if expt_param.USE_EYELINK
    Eyelink('Message','Run ends');
    eyelink_main(edfFile, 'Shutdown');
    data.dat.eyelink_endtime = GetSecs;
end

if expt_param.USE_BIOPAC %end BIOPAC
    bio_trigger_range = num2str(data.expt_param.Run_Num * 0.2 + 1);
    command = 'python3 labjack.py ';
    full_command = [command bio_trigger_range];
    
    data.dat.biopac_end_trigger_s = GetSecs;
    Screen(theWindow,'FillRect',bgcolor, window_rect);
    Screen('Flip', theWindow);
    unix(full_command)
%     unix('python3 labjack.py 1')

    data.dat.biopac_end_trigger_e = GetSecs;
    data.dat.biopac_end_trigger_dur = data.dat.biopac_end_trigger_e - data.dat.biopac_end_trigger_s;
end


if strcmp(expt_param.run_type, 'caps') | strcmp(expt_param.run_type, 'resting') % CAPS Run

    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('Flip', theWindow);
    Screen('TextSize', theWindow, fontsize);

    waitsec_fromstarttime(GetSecs, 2);
    
    %% Post Rating
    
    if strcmp(expt_param.run_type, 'resting')
        scale = {'overall_alertness' ...
            'overall_resting_valence' 'overall_resting_self' 'overall_resting_vivid' 'overall_resting_time' ...
            'overall_resting_safethreat'};
    elseif strcmp(expt_param.run_type, 'caps')
        scale = {'overall_alertness'};
    end
    
    scale_size = size(scale);

    data.dat.post_rating_start = GetSecs;

    for i = 1:scale_size(2)
        SetMouse(lb1+(rb1-lb1)/2,0,theWindow);
        while true
            [x,~,button] = GetMouse(theWindow);
            [lb, rb, ~] = draw_scale_pls(scale{i}, screen_param.window_info, screen_param.line_parameters, screen_param.color_values);
            if x < lb; x = lb; elseif x > rb; x = rb; end

            rating_types_pls = call_ratingtypes_pls(scale{i});
            DrawFormattedText(theWindow, double(rating_types_pls.prompts{1}), 'center', H*(1/4), white, [], [], [], 2);
            Screen('DrawLine', theWindow, orange, x, H*(1/2)-scale_H/3, x, H*(1/2)+scale_H/3, 6); %rating bar
            Screen('Flip', theWindow);

            if button(1)
                while button(1)
                    [~,~,button] = GetMouse(theWindow);
                end
                eval(['data.dat.post_rating.' scale{i} '= (x-lb)/(rb-lb);']);
                break
            end

            [~,~,keyCode] = KbCheck;
            if keyCode(KbName('q')) == 1
                abort_experiment('manual');
                break
            end
        %     if GetSecs - data.dat.rating_starttime(Trial_num) > 5
        %         break
        %     end
        end

        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        Screen('Flip', theWindow);
        Screen('TextSize', theWindow, fontsize);

        waitsec_fromstarttime(GetSecs, 0.3);

    end
    data.dat.post_rating_end = GetSecs;
    data.dat.post_rating_dur = data.dat.post_rating_end - data.dat.post_rating_start;

end

if strcmp(expt_param.run_type, 'movie_heat')

    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('Flip', theWindow);
    Screen('TextSize', theWindow, fontsize);
    
    lb = lb2;
    rb = rb2;
    
    waitsec_fromstarttime(GetSecs, 2);
    
    %% Post Rating
%     scale_size = size(scale);
    data.dat.post_rating_start = GetSecs;
    
    while true
        [x,y,button] = GetMouse(theWindow);
        Screen('TextSize', theWindow, 25);
        Screen('DrawLine', theWindow, white, lb, H*(9.8/10), rb, H*(9.8/10), 4); % penWidth: 0.125~7.000
        Screen('DrawLine', theWindow, white, lb, H*(9.8/10)-(rb-lb)/2, rb, H*(9.8/10)-(rb-lb)/2, 4);
        Screen('DrawLine', theWindow, white, lb, H*(9.8/10)-(rb-lb)/2, lb, H*(9.8/10), 6);
        Screen('DrawLine', theWindow, white, rb, H*(9.8/10)-(rb-lb)/2, rb, H*(9.8/10), 6);
        Screen('DrawLine', theWindow, white, W/2, H*(9.8/10)-(rb-lb)/2, W/2, H*(9.8/10), 4);
        DrawFormattedText(theWindow, double('긍정'), rb+scale_H*(0.1),H*(9.8/10), white,[],[],[],1.2);
        DrawFormattedText(theWindow, double('부정'), lb-scale_H*(0.7), H*(9.8/10), white,[],[],[],1.2);
        DrawFormattedText(theWindow, double('몰입도'), W*(1/2)-scale_H*(0.3), H*(5.5/10), white,[],[],[],1.2);
        DrawFormattedText(theWindow, double('영화를 볼때 감정과 몰입은 어떠셨나요?'), W*(1/2)-scale_H*(1.5), H*(4.5/10), white,[],[],[],1.2);
        Screen('TextSize', theWindow, fontsize);
        
        if x < lb; x = lb; elseif x > rb; x = rb; end
        if y < H*(9.8/10)-(rb-lb)/2; y = H*(9.8/10)-(rb-lb)/2; elseif y > H*(9.8/10); y = H*(9.8/10); end
        Screen('DrawDots', theWindow, [x, y], 10, orange, [0 0], 1); %x, H*(4/5)-scale_H/3, x, H*(4/5)+scale_H/3
        %Screen('DrawLine', theWindow, orange, x, y, x+scale_H/5, y+scale_H/5, 6); %rqating bar x, H*(4/5)-scale_H/3, x, H*(4/5)+scale_H/3
        Screen('Flip', theWindow);
        
        if button(1)
            while button(1)
                [~,~,button] = GetMouse(theWindow);
            end
            data.dat.post_rating.overal_movie_rating_valence = (x-lb)/(rb-lb);
            data.dat.post_rating.overal_movie_rating_attention = abs(1 - (y - (H*(9.8/10)-(rb-lb)/2))/(H*(9.8/10) - (H*(9.8/10)-(rb-lb)/2)));
            break
        end
        
        [~,~,keyCode] = KbCheck;
        if keyCode(KbName('q')) == 1
            abort_experiment('manual');
            break
        end
    end
    data.dat.post_rating_end = GetSecs;
    data.dat.post_rating_dur = data.dat.post_rating_end - data.dat.post_rating_start;

end


%% Saving Data
data.dat.run_end_time = GetSecs;
data.dat.run_duration_time = data.dat.run_end_time - data.dat.fmri_start_time;

save(data.datafile, 'data', '-append');
save(ckpt_filedir, 'ckpt');

end    