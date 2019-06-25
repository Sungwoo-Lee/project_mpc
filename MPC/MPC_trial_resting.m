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


%% Fixation
while true
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    DrawFormattedText(theWindow, double('resting'), 'center', 'center', white, [], [], [], 1.2);
    Screen('Flip', theWindow);
    
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q')) == 1
        abort_experiment;
        break
    end
  
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