function [data] = MPC_trial_caps(window_info, line_parameters, color_values, Run_num, data)

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


%% Jittering time and random cue & stimulus parameters 
jitter_1 = [3,6,7];
jitter_2 = [6,5,3];
jitter_3 = [4,2,3];


%% Trial starts
trial = 1;

%% Interval wait secs
wait_after_cue = 2.5;
wait_after_jitter_1 = wait_after_cue + jitter_1(jitter_index); %jitter_1 = [3,6,7]
wait_after_stimulus = wait_after_jitter_1 + 12;
wait_after_jitter_2 = wait_after_stimulus + jitter_2(jitter_index); %jitter_2 = [6,5,3];
wait_after_rating = wait_after_jitter_2 + 5;
wait_after_jitter_3 = wait_after_rating + jitter_3(jitter_index); %jitter_3 = [4,2,3];
total_trial_time = 33;
between_trial_time = 1;

%% Adjusting between trial time
waitsec_fromstarttime(data.dat.run_starttime(trial, Run_num), 1)


%% Checking trial start time
data.dat.trial_starttime(trial, Run_num) = GetSecs;
data.dat.between_run_trial_starttime(trial, Run_num) = data.dat.trial_starttime(trial, Run_num) - data.dat.run_starttime(1, Run_num);

data.dat.cue_time(trial, Run_num) =  GetSecs;
data.dat.between_trial_start_cue_time(trial, Run_num) = data.dat.cue_time(trial, Run_num) - data.dat.trial_starttime(trial, Run_num);

data.dat.cue_type(trial, Run_num) = cue_type;
data.dat.cue_prob(trial, Run_num) = cue_prob;
data.dat.jitter_index(trial, Run_num) = jitter_index;
data.dat.intensity_index(trial, Run_num) = intensity_index;

data.dat.stimulus_intensity(trial, Run_num) = NaN;

%%
waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_cue)


%% Jittering1
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

% Adjusting jitter time
% wait_after_jitter_1 = wait_after_cue + jitter_1(jitter_index);
waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_jitter_1)


%% setting for rating
rating_types_pls = call_ratingtypes_pls;

all_start_t = GetSecs;

scale = ('overall_int');
[lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
Screen(theWindow, 'FillRect', bgcolor, window_rect);

start_t = GetSecs;
data.dat.rating_starttime(trial, Run_num) = start_t;

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
    if GetSecs - data.dat.rating_starttime(trial, Run_num) > 5
        break
    end
end


%% Heat pain stimulus -> Continuous rating
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);
main(ip,port,2);

data.dat.stimulus_time(trial, Run_num) = GetSecs;


%% appending rating result
end_t = GetSecs;

data.dat.rating(trial, Run_num) = (x-lb)/(rb-lb);
data.dat.rating_endtime(trial, Run_num) = end_t;
data.dat.rating_duration(trial, Run_num) = end_t - start_t;

Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow);


%% stimulus time adjusting
% wait_after_stimulus = wait_after_jitter_1 + 12;
waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_stimulus)


%% Jittering2
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_jitter_2)

Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow);


%% rating time adjusting
%wait_after_rating = wait_after_jitter_2 + 7;
waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_rating)


%% Jittering3
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

%wait_after_jitter_3 = wait_after_rating + jitter_3(jitter_index);
waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), wait_after_jitter_3)


%% Adjusting total trial time
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

waitsec_fromstarttime(data.dat.trial_starttime(trial, Run_num), total_trial_time)


%% appending trial end time
data.dat.trial_endtime(trial, Run_num) = GetSecs;
data.dat.trial_duration(trial, Run_num) = data.dat.trial_endtime(trial, Run_num) - data.dat.trial_starttime(trial, Run_num);
%save(data.datafile, 'data', '-append');

if trial >1
    data.dat.between_trial_time(trial, Run_num) = data.dat.trial_starttime(trial, Run_num) - data.dat.trial_endtime(trial-1, Run_num);
else
    data.dat.between_trial_time(trial, Run_num) = 0;
end
end