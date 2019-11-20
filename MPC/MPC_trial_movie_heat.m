function [data, ckpt] = MPC_trial_movie_heat(screen_param, expt_param, Trial_num, data, ckpt, heat_param)
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


%% Saving trial type
data.dat.trial_type(Trial_num) = {'with_movie'};


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
pre_state = [4,5,6];
jitter = [5,4,3];
iti = 3;
iti2 = 1;

wait_after_iti2 = iti2;
wait_after_movie = expt_param.movie_duration;
wait_after_pre_state = wait_after_movie + pre_state(jitter_index);
wait_after_stimulus = wait_after_pre_state + 12;
wait_after_jitter = wait_after_stimulus + jitter(jitter_index);
wait_after_rating = wait_after_jitter + 5;
total_trial_time = wait_after_rating + iti;

%% Adjusting between trial time
if Trial_num > 1
    waitsec_fromstarttime(data.dat.trial_endtime(Trial_num-1), wait_after_iti2)
else
    waitsec_fromstarttime(data.dat.run_starttime(Trial_num), wait_after_iti2)
end


%% Checking trial start time
data.dat.trial_starttime(Trial_num) = GetSecs;
data.dat.between_run_trial_starttime(Trial_num) = data.dat.trial_starttime(Trial_num) - data.dat.run_starttime(1);


%% Data recording
Screen(theWindow, 'FillRect', bgcolor, window_rect);

data.dat.movie_jitter_1_value = pre_state;
data.dat.movie_jitter_2_value = jitter;
data.dat.movie_iti_value = iti;
data.dat.jitter_index(Trial_num) = jitter_index;


%% -------------Setting Pathway------------------
if expt_param.Pathway
    main(ip,port,1, heat_param.program);     % select the program
end

%% Setting Movie parameter
playmode = 1;

data.dat.movie_dir(Trial_num) = {expt_param.moviefile};
data.dat.movie_starttime(Trial_num) = GetSecs;

movie_count = 1;
if not(ckpt.movie_start_point(1) == 999999999) %This means that ckpt.movie_start_point(1) is not empty
    size_ckpt = size(ckpt.movie_start_point);
    for i = 1:size_ckpt(2)
        if ~isnan(ckpt.movie_start_point(i)) %Check how many not NaN in ckpt.movie_start_point
            movie_count = movie_count+1;
        end
    end
end

%% Load movie file
[moviePtr, dura] = Screen('OpenMovie', theWindow, expt_param.moviefile);

%% Decide the point where movie will start
movie_start = (movie_count-1) * expt_param.movie_duration;

%% Error check whether movie_start + movie duration is out of range of movie 
if dura < (movie_start + expt_param.movie_duration)
    movie_start = dura - expt_param.movie_duration -1;
end

%% Save movie start point
data.dat.movie_start_point(Trial_num) = movie_start;

%% Append or Initialize Check point
if not(ckpt.movie_start_point(1) == 999999999)
    ckpt.movie_start_point = [ckpt.movie_start_point data.dat.movie_start_point(Trial_num)];
else 
    ckpt.movie_start_point = data.dat.movie_start_point(Trial_num);
end

%% Playing movie
Screen('SetMovieTimeIndex', moviePtr, movie_start);
Screen('PlayMovie', moviePtr, playmode); %Screen('PlayMovie?')% 0 == Stop playback, 1 == Normal speed forward, -1 == Normal speed backward,

t = GetSecs;

while GetSecs-t < expt_param.movie_duration %(~done) %~KbCheck
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', theWindow, moviePtr);
    Screen('DrawTexture', theWindow, tex);
    Screen('Flip', theWindow);
    Screen('Close', tex);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        %done = 1;
        break;
    end
    % Update display:
    
end

Screen('PlayMovie', moviePtr,0);

%% Close movie
Screen('CloseMovie',moviePtr);
Screen('Flip', theWindow);

%% Saving movie end time
data.dat.movie_endtime(Trial_num) = GetSecs;
data.dat.movie_duration(Trial_num) = data.dat.movie_endtime(Trial_num) - data.dat.movie_starttime(Trial_num);

%% Adjusting movie playing time
waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_after_movie)

%% -------------Ready for Pathway------------------
if expt_param.Pathway
    main(ip,port,2); %ready to pre-start
end



%% Check Jitter time
data.dat.jitter_starttime(Trial_num) = GetSecs;


%% Jittering1
Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('TextSize', theWindow, 60);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);
Screen('TextSize', theWindow, fontsize);

waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_after_pre_state)

%% Check Jitter end time
data.dat.jitter_endtime(Trial_num) = GetSecs;
data.dat.jitter_duration(Trial_num) = data.dat.jitter_endtime(Trial_num) - data.dat.jitter_starttime(Trial_num);


%% Heat pain stimulus
if ~expt_param.Pathway
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    Screen('TextSize', theWindow, 60);
    DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    Screen('TextSize', theWindow, fontsize);
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



%% Check Jitter_2 time
data.dat.jitter_2_starttime(Trial_num) = GetSecs;


%% Jittering2
Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('TextSize', theWindow, 60);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);
Screen('TextSize', theWindow, fontsize);

waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_after_jitter)

Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow);


%% Check Jitter end time
data.dat.jitter_2_endtime(Trial_num) = GetSecs;
data.dat.jitter_2_duration(Trial_num) = data.dat.jitter_2_endtime(Trial_num) - data.dat.jitter_2_starttime(Trial_num);


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
        abort_experiment;
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
%save(data.datafile, 'data', '-append');

if Trial_num >1
    data.dat.between_trial_time(Trial_num) = data.dat.trial_starttime(Trial_num) - data.dat.trial_endtime(Trial_num-1);
else
    data.dat.between_trial_time(Trial_num) = 0;
end

end