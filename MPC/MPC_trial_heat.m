function [data, ckpt] = MPC_trial_heat(screen_param, expt_param, Trial_num, data, ckpt, heat_param)
global ip port;

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


%% Saving trial type and movie parameters
data.dat.trial_type(Trial_num) = {'no_movie'};
data.dat.movie_dir(Trial_num) = {nan};
data.dat.movie_start_point(Trial_num) = nan;

data.dat.movie_starttime(Trial_num) = nan;
data.dat.movie_endtime(Trial_num) = nan;
data.dat.movie_duration(Trial_num) = nan;

if not(ckpt.movie_start_point(1) == 999999999) % it means that ckpt.movie_start_point is not empty
    ckpt.movie_start_point = [ckpt.movie_start_point data.dat.movie_start_point(Trial_num)];
else 
    ckpt.movie_start_point = data.dat.movie_start_point(Trial_num);
end


%% Random generation for stimulus parameters and jittering
rng('shuffle')
jitter_index_rand = rand();
intensity_index_rand = rand();

if jitter_index_rand < 0.333
    jitter_index = 1;
elseif jitter_index_rand < 0.666
    jitter_index = 2;
else
    jitter_index = 3;
end


%% Wait secs parameters
jitter = [3,4,5];
pre_state = [6,5,4];
iti = 1;

wait_after_iti = iti;
wait_pre_state = pre_state(jitter_index);
wait_after_stimulus = wait_pre_state + 12;
wait_after_jitter = wait_after_stimulus + jitter(jitter_index);
wait_after_rating = wait_after_jitter + 5;
total_trial_time = wait_after_rating + 3;


%% Adjusting between trial time
if Trial_num > 1
    waitsec_fromstarttime(data.dat.trial_endtime(Trial_num-1), wait_after_iti)
else
    waitsec_fromstarttime(data.dat.run_starttime(Trial_num), wait_after_iti)
end


%% Checking trial start time
data.dat.trial_starttime(Trial_num) = GetSecs;
data.dat.between_run_trial_starttime(Trial_num) = data.dat.trial_starttime(Trial_num) - data.dat.run_starttime(1);


%% Data recording
Screen(theWindow, 'FillRect', bgcolor, window_rect);

data.dat.nomovie_jitter_value = jitter;
data.dat.nomovie_iti_value = pre_state;
data.dat.jitter_index(Trial_num) = jitter_index;


%% -------------Setting Pathway------------------
if expt_param.Pathway
    main(ip,port,1, heat_param.program);     % select the program
end
waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_pre_state-2) 

%% -------------Ready for Pathway------------------
if expt_param.Pathway
    main(ip,port,2); %ready to pre-start
end
waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_pre_state) % Because of wait_pathway_setup-2, this will be 2 seconds

%% Heat pain stimulus
if ~expt_param.Pathway
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double(num2str(heat_param.intensity)), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
end


%% Check stimulus start time
data.dat.stimulus_starttime(Trial_num) = GetSecs;

%% ------------- start to trigger thermal stimulus------------------
if expt_param.Pathway
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('TextSize', theWindow, 60);
    DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    Screen('TextSize', theWindow, fontsize);
    main(ip,port,2);
end


%% Check stimulus time
data.dat.stimulus_time(Trial_num) = GetSecs;


%% stimulus time adjusting
waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_after_stimulus)


%% Check stimulus end time
data.dat.stimulus_endtime(Trial_num) = GetSecs;
data.dat.stimulus_duration(Trial_num) = data.dat.stimulus_endtime(Trial_num) - data.dat.stimulus_time(Trial_num);



%% Check Jitter time
data.dat.jitter_starttime(Trial_num) = GetSecs;

%% Jittering
Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('TextSize', theWindow, 60);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);
Screen('TextSize', theWindow, fontsize);

waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_after_jitter)

Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow);

%% Check Jitter end time
data.dat.jitter_endtime(Trial_num) = GetSecs;
data.dat.jitter_duration(Trial_num) = data.dat.jitter_endtime(Trial_num) - data.dat.jitter_starttime(Trial_num);

%% Setting for rating
rating_types_pls = call_ratingtypes_pls('temp');

all_start_t = GetSecs;

scale = ('overall_int');
[lb, rb, start_center] = draw_scale_pls(scale, screen_param.window_info, screen_param.line_parameters, screen_param.color_values);
Screen(theWindow, 'FillRect', bgcolor, window_rect);

start_t = GetSecs;
data.dat.rating_starttime(Trial_num) = start_t;

ratetype = strcmp(rating_types_pls.alltypes, scale);

%% Initial mouse position
if start_center
    SetMouse(W/2,H/2); % set mouse at the center
else
    SetMouse(lb,H/2); % set mouse at the left
end

%% Rating start
while true
    [x,~,button] = GetMouse(theWindow);
    [lb, rb, start_center] = draw_scale_pls(scale, screen_param.window_info, screen_param.line_parameters, screen_param.color_values);
    if x < lb; x = lb; elseif x > rb; x = rb; end
    
    DrawFormattedText(theWindow, double(rating_types_pls.prompts{ratetype}), 'center', H*(1/4), white, [], [], [], 2);
    Screen('DrawLine', theWindow, orange, x, H*(1/2)-scale_H/3, x, H*(1/2)+scale_H/3, 6); %rating bar
    Screen('Flip', theWindow);
    
    if button(1)
        while button(1)
            [~,~,button] = GetMouse(theWindow);
        end
        break
    end
    
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end
    if GetSecs - data.dat.rating_starttime(Trial_num) > 5
        break
    end
end

%% saving rating result
end_t = GetSecs;

data.dat.rating(Trial_num) = (x-lb)/(rb-lb);
data.dat.rating_endtime(Trial_num) = end_t;
data.dat.rating_duration(Trial_num) = end_t - start_t;

Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow);

%% rating time adjusting
waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_after_rating)

%% Adjusting total trial time
Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('TextSize', theWindow, 60);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);
Screen('TextSize', theWindow, fontsize);

waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), total_trial_time)

%% saving trial end time
data.dat.trial_endtime(Trial_num) = GetSecs;
data.dat.trial_duration(Trial_num) = data.dat.trial_endtime(Trial_num) - data.dat.trial_starttime(Trial_num);

if Trial_num >1
    data.dat.between_trial_time(Trial_num) = data.dat.trial_starttime(Trial_num) - data.dat.trial_endtime(Trial_num-1);
else
    data.dat.between_trial_time(Trial_num) = 0;
end
end