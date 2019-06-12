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


%% Adjusting between trial time

caps_stim_duration = 90;
caps_stim_start = GetSecs;
data.dat.caps_stim_start = caps_stim_start;

%% Jittering1
Screen(theWindow, 'FillRect', bgcolor, window_rect);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);

% Adjusting jitter time
waitsec_fromstarttime(caps_stim_start, 4)


%% setting for rating
rating_types_pls = call_ratingtypes_pls;

all_start_t = GetSecs;

scale = ('overall_int');
[lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
Screen(theWindow, 'FillRect', bgcolor, window_rect);

ratetype = strcmp(rating_types_pls.alltypes, scale);

% Initial position
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
    [lb, rb, start_center] = draw_scale_pls(scale, window_info, line_parameters, color_values);
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
    if GetSecs - start_rating > caps_stim_duration
        break
    end
end

continuous_rating_end = GetSecs;
continuous_rating_duration = continuous_rating_end - continuous_rating_start;

data.dat.continuous_rating_end = continuous_rating_end;
data.dat.continuous_rating_duration = continuous_rating_duration;

% %% Heat pain stimulus -> Continuous rating
% Screen(theWindow, 'FillRect', bgcolor, window_rect);
% DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
% Screen('Flip', theWindow);
% 
% % waitsec_fromstarttime(caps_stim_start, 23)
% 
% 
% Screen(theWindow, 'FillRect', bgcolor, window_rect);
% Screen('Flip', theWindow);

end