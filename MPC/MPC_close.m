function data = MPC_close(screen_param, data) 

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

%% Saving experiment end time
data.dat.experiment_end_time = GetSecs;
data.dat.experiment_duration_time = data.dat.experiment_end_time -  data.dat.experiment_start_time;
save(data.datafile, 'data', '-append');


%% Closing screen
while true % To finish run, Push Space
    
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('f')) == 1
        break
    elseif keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end
    
    if keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end
    msgtxt = ['실험이 끝났습니다.\n\n실험을 마치려면, \n\n f 를 눌러주시기 바랍니다.'];
    msgtxt = double(msgtxt); % korean to double
    DrawFormattedText(theWindow, msgtxt, 'center', 'center', white, [], [], [], 2);
    Screen('Flip', theWindow); 
end

ShowCursor;
sca;
Screen('CloseAll');

end