function [data] = MPC_trial_resting(screen_param, expt_param, data)
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


%% Check resting start time
resting_start = GetSecs;
data.dat.resting_start = resting_start;



%% Setting for rating
all_start_t = GetSecs;

scale = ('resting_int');
[lb, rb, start_center] = draw_scale_pls(scale, screen_param.window_info, screen_param.line_parameters, screen_param.color_values);
Screen(theWindow, 'FillRect', bgcolor, window_rect);


%% Initial mouse position
if start_center
    SetMouse(W/2,H/2); % set mouse at the center
else
    SetMouse(lb,H/2); % set mouse at the left
end

start_rating = GetSecs;

rec_i = 0;

continuous_rating_start = GetSecs;
data.dat.continuous_rating_start = continuous_rating_start;


%% Fixation
while true
    [x,~,button] = GetMouse(theWindow);
    [lb, rb, start_center] = draw_scale_pls(scale, screen_param.window_info, screen_param.line_parameters, screen_param.color_values);
    if x < lb; x = lb; elseif x > rb; x = rb; end
    
    rating_types_pls = call_ratingtypes_pls('resting');
    Screen('TextSize', theWindow, 60);
    DrawFormattedText(theWindow, double(rating_types_pls.prompts{1}), 'center', H*(1/4), white, [], [], [], 2);
    Screen('TextSize', theWindow, fontsize);
    Screen('DrawLine', theWindow, orange, x, H*(1/2)-scale_H/3, x, H*(1/2)+scale_H/3, 6); %rating bar
    Screen('Flip', theWindow);
    data.dat.caps_stim_deliver = GetSecs;
    
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q')) == 1
        abort_experiment;
        break
    end
    
    rec_i = rec_i + 1;
    
    data.dat.continuous_rating(rec_i,1) = GetSecs;
    data.dat.continuous_rating(rec_i,2) = (x-lb)/(rb-lb);   
  
    if GetSecs - resting_start > expt_param.resting_duration
        break
    end
end

%% Adjusting Resting time
waitsec_fromstarttime(resting_start, expt_param.resting_duration)

%% Check resting finished time
data.dat.resting_end = GetSecs;
data.dat.resting_duration = data.dat.resting_end - data.dat.resting_start;


end