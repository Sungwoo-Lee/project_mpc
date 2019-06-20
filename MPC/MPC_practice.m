function MPC_practice(screen_param)     

%Assign variables
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

Screen(theWindow, 'FillRect', bgcolor, window_rect);

% one-directional
x = W*(1/4);
y = H*(1/2);
SetMouse(x,y)  

while true % To finish practice, push button
    msgtxt = '참가자는 충분히 평가 방법을 연습한 후 \n\n 연습이 끝나면 버튼을 눌러주시기 바랍니다.';
    DrawFormattedText(theWindow, double(msgtxt), 'center', H*(1/4), white, [], [], [], 2);
    Screen('DrawLine', theWindow, white, lb2, H*(1/2), rb2, H*(1/2), 4); %rating scale
    % penWidth: 0.125~7.000
    Screen('DrawLine', theWindow, white, lb2, H*(1/2)-scale_H/3, lb2, H*(1/2)+scale_H/3, 6);
    Screen('DrawLine', theWindow, white, rb2, H*(1/2)-scale_H/3, rb2, H*(1/2)+scale_H/3, 6);
    Screen('DrawLine', theWindow, orange, x, H*(1/2)-scale_H/3, x, H*(1/2)+scale_H/3, 6); %rating bar
    Screen('Flip', theWindow);

    [x,~,button] = GetMouse(theWindow);
    if x < lb2; x = lb2; elseif x > rb2; x = rb2; end
    [~,~,keyCode] = KbCheck;
    if button(1) == 1
        break
    elseif keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end

end

Screen(theWindow, 'FillRect', bgcolor, window_rect);

% if ~run
%     abort_experiment('manual');
% end

end