function [data, ckpt] = MPC_trial_heat(window_info, line_parameters, color_values, Trial_num, Pathway, data, ckpt, heat_intensity_table)
global ip port;

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


%% SETUP: load the pathway program
PathPrg = load_PathProgram('SEMIC');


%% Saving trial type
data.dat.trial_type(Trial_num) = string('no_movie');
data.dat.movie_dir(Trial_num) = {nan};
data.dat.movie_start_point(Trial_num) = nan;

data.dat.movie_starttime(Trial_num) = nan;
data.dat.movie_endtime(Trial_num) = nan;
data.dat.movie_duration(Trial_num) = nan;

if not(ckpt.movie_start_point(1) == 999999999)
    ckpt.movie_start_point = [ckpt.movie_start_point data.dat.movie_start_point(Trial_num)];
else 
    ckpt.movie_start_point = data.dat.movie_start_point(Trial_num);
end


%% Jittering time and random cue & stimulus parameters 
low_intensity = transpose(heat_intensity_table(:,1));
high_intensity = transpose(heat_intensity_table(:,2));


%% Convert stimulus intensity to Pathway program decimal
size_Path = size(PathPrg);
size_low_intensity = size(low_intensity);
size_high_intensity = size(high_intensity);

low_intensity_program = [];
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


%% Trial starts

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


%% Interval wait secs
jitter = [3,4,5];
iti = [5,4,3];

wait_pathway_setup_1 = 1.5;
wait_pathway_setup_2 = wait_pathway_setup_1 + 1.5;
wait_after_stimulus = wait_pathway_setup_2 + 12;
wait_after_jitter = wait_after_stimulus + jitter(jitter_index);
wait_after_rating = wait_after_jitter + 5;
total_trial_time = wait_after_rating + iti(jitter_index);
between_trial_time = 1;


%% Adjusting between trial time
if Trial_num > 1
    waitsec_fromstarttime(data.dat.trial_endtime(Trial_num-1), between_trial_time)
else
    waitsec_fromstarttime(data.dat.run_starttime(Trial_num), 1)
end


%% Checking trial start time
data.dat.trial_starttime(Trial_num) = GetSecs;
data.dat.between_run_trial_starttime(Trial_num) = data.dat.trial_starttime(Trial_num) - data.dat.run_starttime(1);


%% Data recording
Screen(theWindow, 'FillRect', bgcolor, window_rect);

data.dat.nomovie_jitter_value = jitter;
data.dat.nomovie_iti_value = iti;
data.dat.high_intensity_value = high_intensity;
data.dat.low_intensity_value = low_intensity;

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
    waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_pathway_setup_1)
end
%     %% Jittering1
%     Screen(theWindow, 'FillRect', bgcolor, window_rect);
%     DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
%     Screen('Flip', theWindow);
%
% -------------Ready for Pathway------------------
if Pathway
    main(ip,port,2); %ready to pre-start
    waitsec_fromstarttime(data.dat.trial_starttime(Trial_num), wait_pathway_setup_2)
end

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

% ------------- start to trigger thermal stimulus------------------
if Pathway
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    main(ip,port,2);
end

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


%% setting for rating
rating_types_pls = call_ratingtypes_pls;

all_start_t = GetSecs;

scale = ('overall_int');
[lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
Screen(theWindow, 'FillRect', bgcolor, window_rect);

start_t = GetSecs;
data.dat.rating_starttime(Trial_num) = start_t;

ratetype = strcmp(rating_types_pls.alltypes, scale);

% Initial position
if start_center
    SetMouse(W/2,H/2); % set mouse at the center
else
    SetMouse(lb,H/2); % set mouse at the left
end


%% rating start
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