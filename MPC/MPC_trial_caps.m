function [data] = MPC_trial_caps(screen_param, expt_param, data)

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


%% Adjusting between trial time
caps_tiral_start = GetSecs;
caps_stim_start = caps_tiral_start + 60;
data.dat.caps_stim_start = caps_stim_start;


%% Stimulus will be delivered
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

%% Adjusting Pre-Stimulus time
waitsec_fromstarttime(caps_tiral_start, 60)

%% Stimulus will be delivered
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('자극을 전달하세요'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

%% Adjusting Stimulus delivering time
waitsec_fromstarttime(caps_stim_start, 20)

%% Setting for rating
rating_types_pls = call_ratingtypes_pls;

all_start_t = GetSecs;

scale = ('overall_int');
[lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
Screen(theWindow, 'FillRect', bgcolor, window_rect);

ratetype = strcmp(rating_types_pls.alltypes, scale);

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

%% rating start
while true
    [x,~,button] = GetMouse(theWindow);
    [lb, rb, start_center] = draw_scale_pls(scale, screen_param.window_info, screen_param.line_parameters, screen_param.color_values);
    if x < lb; x = lb; elseif x > rb; x = rb; end
    
    DrawFormattedText(theWindow, double(rating_types_pls.prompts{ratetype}), 'center', H*(1/4), white, [], [], [], 2);
    Screen('DrawLine', theWindow, orange, x, H*(1/2)-scale_H/3, x, H*(1/2)+scale_H/3, 6); %rating bar
    Screen('Flip', theWindow);
    
    rec_i = rec_i + 1;
    
%     if button(1)
%         while button(1)
%             [~,~,button] = GetMouse(theWindow);
%         end
%         break
%     end
    
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end
    
    data.dat.continuous_rating(rec_i,1) = GetSecs;
    data.dat.continuous_rating(rec_i,2) = (x-lb)/(rb-lb);    
    if GetSecs - start_rating > expt_param.caps_stim_duration
        break
    end
end

%% Saving rating and time
continuous_rating_end = GetSecs;
continuous_rating_duration = continuous_rating_end - continuous_rating_start;

data.dat.continuous_rating_end = continuous_rating_end;
data.dat.continuous_rating_duration = continuous_rating_duration;

end