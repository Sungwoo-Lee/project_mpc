function [data, ckpt] = MPC_trial_movie_heat(window_info, line_parameters, color_values, Trial_num, Pathway, data, ckpt, heat_intensity_table, moviefile, movie_duration)
global ip port;

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


%% SETUP: load the pathway program
PathPrg = load_PathProgram('MPC');


%% Saving trial type
data.dat.trial_type(Trial_num) = {'with_movie'};


%% Set intensity variable
low_intensity = transpose(heat_intensity_table(:,1));
high_intensity = transpose(heat_intensity_table(:,2));


%% Convert stimulus intensity to Pathway program decimal
size_Path = size(PathPrg);
size_low_intensity = size(low_intensity);
size_high_intensity = size(high_intensity);

low_intensity_program=[];
high_intensity_program = [];

for i = 1:size_low_intensity(2)
for j = 1:size_Path(1)
    if PathPrg{j,1} == low_intensity(1,i)
        low_intensity_program = [low_intensity_program; PathPrg{j,4}];
    end
end
end

for i = 1:size_high_intensity(2)
for j = 1:size_Path(1)
    if PathPrg{j,1} == high_intensity(1,i)
        high_intensity_program = [high_intensity_program; PathPrg{j,4}];
    end
end
end


%% Random generation for stimulus parameters and jittering
rng('shuffle')
prob_rand = rand();
jitter_index_rand = rand();
intensity_index_rand = rand();

if jitter_index_rand < 0.333
    jitter_index = 1;
elseif jitter_index_rand < 0.666
    jitter_index = 2;
else
    jitter_index = 3;
end

if intensity_index_rand < 0.333
    intensity_index = 1;
elseif intensity_index_rand < 0.666
    intensity_index = 2;
else
    intensity_index = 3;
end


%% Wait secs parameters
pre_state = [4,5,6];
jitter = [5,4,3];
iti = 3;

wait_after_movie = 20;
wait_after_pre_state = wait_after_movie + pre_state(jitter_index);
wait_after_stimulus = wait_after_pre_state + 12;
wait_after_jitter = wait_after_stimulus + jitter(jitter_index);
wait_after_rating = wait_after_jitter + 5;
total_trial_time = wait_after_rating + iti;
%between_trial_time = 1;

%% Checking trial start time
data.dat.trial_starttime(Trial_num) = GetSecs;
data.dat.between_run_trial_starttime(Trial_num) = data.dat.trial_starttime(Trial_num) - data.dat.run_starttime(1);


%% Adjusting between trial time
if Trial_num > 1
    waitsec_fromstarttime(data.dat.trial_endtime(Trial_num-1), 1)
else
    waitsec_fromstarttime(data.dat.run_starttime(Trial_num), 1)
end


%% Data recording
Screen(theWindow, 'FillRect', bgcolor, window_rect);

data.dat.movie_jitter_1_value = pre_state;
data.dat.movie_jitter_2_value = jitter;
data.dat.movie_iti_value = iti;

data.dat.stim_prob(Trial_num) = prob_rand;
data.dat.jitter_index(Trial_num) = jitter_index;
data.dat.intensity_index(Trial_num) = intensity_index;


%% Setting stimulus intensity
if prob_rand > 0.5
    intensity_program = high_intensity_program(intensity_index);
    stimulus_intensity = high_intensity(intensity_index);
else
    intensity_program = low_intensity_program(intensity_index);
    stimulus_intensity = low_intensity(intensity_index);
end
data.dat.stimulus_intensity(Trial_num) = stimulus_intensity;


%% -------------Setting Pathway------------------
if Pathway
    main(ip,port,1, intensity_program);     % select the program
end

%% Setting Movie parameter
playmode = 1;

data.dat.movie_dir(Trial_num) = {moviefile};
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
[moviePtr, dura] = Screen('OpenMovie', theWindow, moviefile);

%% Decide the point where movie will start
movie_start = (movie_count-1) * movie_duration;

%% Error check whether movie_start + movie duration is out of range of movie 
if dura < (movie_start + movie_duration)
    movie_start = dura - movie_duration -1;
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

while GetSecs-t < movie_duration %(~done) %~KbCheck
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
if Pathway
    main(ip,port,2); %ready to pre-start
end

%% Jittering1
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_after_pre_state)


%% Heat pain stimulus
if ~Pathway
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    if prob_rand > 0.5
        DrawFormattedText(theWindow, double('High Stimulus'), 'center', 'center', white, [], [], [], 1.2);
    else
        DrawFormattedText(theWindow, double('Low Stimulus'), 'center', 'center', white, [], [], [], 1.2);
    end
    Screen('Flip', theWindow);
end

%% ------------- start to trigger thermal stimulus------------------
if Pathway
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    main(ip,port,2);
end

%% Check stimulus time
data.dat.stimulus_time(Trial_num) = GetSecs;


%% stimulus time adjusting
waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_after_stimulus)


%% Jittering2
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_after_jitter)

Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow);


%% Setting for rating
rating_types_pls = call_ratingtypes_pls;

all_start_t = GetSecs;

scale = ('overall_int');
[lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
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
    [lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
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
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

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