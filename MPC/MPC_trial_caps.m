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
caps_trial_start = GetSecs;
caps_wait_stim = 60;
caps_stim_deliver = 20;
caps_stim_remove = caps_stim_deliver + 20;

data.dat.caps_trial_start = caps_trial_start;

%% Stimulus will be delivered
Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('TextSize', theWindow, 60);
DrawFormattedText(theWindow, double('+'), 'center', 'center', white, [], [], [], 1.2);
Screen('Flip', theWindow);
Screen('TextSize', theWindow, fontsize);


%% Adjusting Pre-Stimulus time
waitsec_fromstarttime(data.dat.caps_trial_start, caps_wait_stim)
data.dat.caps_wait_stim = GetSecs - caps_trial_start;

%% Setting for rating
all_start_t = GetSecs;

scale = ('overall_int');
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


%% rating start
while true
    [x,~,button] = GetMouse(theWindow);
    [lb, rb, start_center] = draw_scale_pls(scale, screen_param.window_info, screen_param.line_parameters, screen_param.color_values);
    if x < lb; x = lb; elseif x > rb; x = rb; end
    
    if GetSecs - continuous_rating_start < caps_stim_deliver
        rating_types_pls = call_ratingtypes_pls('deliver');
        DrawFormattedText(theWindow, double(rating_types_pls.prompts{1}), 'center', H*(1/4), white, [], [], [], 2);
        DrawFormattedText(theWindow, double('자극을 전달하세요'), 'center', H*(4/10), red, [], [], [], 2);
        Screen('DrawLine', theWindow, orange, x, H*(1/2)-scale_H/3, x, H*(1/2)+scale_H/3, 6); %rating bar
        Screen('Flip', theWindow);
        data.dat.caps_stim_deliver = GetSecs;

        
    elseif GetSecs - continuous_rating_start < caps_stim_remove
        rating_types_pls = call_ratingtypes_pls('remove');
        DrawFormattedText(theWindow, double(rating_types_pls.prompts{1}), 'center', H*(1/4), white, [], [], [], 2);
        DrawFormattedText(theWindow, double('자극을 제거하세요'), 'center', H*(4/10), orange, [], [], [], 2);
        Screen('DrawLine', theWindow, orange, x, H*(1/2)-scale_H/3, x, H*(1/2)+scale_H/3, 6); %rating bar
        Screen('Flip', theWindow);
        data.dat.caps_stim_remove = GetSecs;
        
    else
        rating_types_pls = call_ratingtypes_pls('continue');
        DrawFormattedText(theWindow, double(rating_types_pls.prompts{1}), 'center', H*(1/4), white, [], [], [], 2);
        Screen('DrawLine', theWindow, orange, x, H*(1/2)-scale_H/3, x, H*(1/2)+scale_H/3, 6); %rating bar
        Screen('Flip', theWindow);
    end
    
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
    if GetSecs - data.dat.caps_trial_start > expt_param.caps_duration
        break
    end
end


%% Saving rating and time
continuous_rating_end = GetSecs;
continuous_rating_duration = continuous_rating_end - continuous_rating_start;

data.dat.caps_stim_deliver_dur = data.dat.caps_stim_deliver - continuous_rating_start;
data.dat.caps_stim_removie_dur = data.dat.caps_stim_remove - data.dat.caps_stim_deliver;

data.dat.continuous_rating_end = continuous_rating_end;
data.dat.continuous_rating_duration = continuous_rating_duration;

end