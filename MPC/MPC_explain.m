function MPC_explain(screen_param)     
 % (Explain) Continuous & Overall
 % Explain bi-directional scale with visualization 
 
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
 
 
%%
while true % Button
    msgtxt = '지금부터 실험이 시작됩니다.\n\n먼저, 실험을 진행하기에 앞서 평가 척도에 대한 설명을 진행하겠습니다.\n\n참가자는 모든 준비가 완료되면 마우스를 눌러주시기 바랍니다.\n\n Click mouse';
    DrawFormattedText(theWindow, double(msgtxt), 'center', 'center', white, [], [], [], 2);
    Screen('Flip', theWindow);

    [x,~,button] = GetMouse(theWindow);
    [~,~,keyCode] = KbCheck;
    if button(1) == 1
        break
    elseif keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end
end


%% Explain one-directional scale with visualization

waitsec_fromstarttime(GetSecs, 0.5);

while true % Space
    Screen(theWindow, 'FillRect', bgcolor, window_rect);
    overall_rat_scale = imread('gLMS_unidirectional_rating_scale','jpg');
    [s1, s2, s3] = size(overall_rat_scale);
    overall_rat_scale_texture = Screen('MakeTexture', theWindow, overall_rat_scale);
    Screen('DrawTexture', theWindow, overall_rat_scale_texture, [0 0 s2 s1],[0 0 W H]);
    Screen('PutImage', theWindow, overall_rat_scale); %show the overall rating scale
    Screen('Flip', theWindow);

    [x,~,button2] = GetMouse(theWindow);
    [~,~,keyCode] = KbCheck;
    if button2(1) == 1
        break
    elseif keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end  
end

Screen(theWindow, 'FillRect', bgcolor, window_rect);
waitsec_fromstarttime(GetSecs, 0.5);

end
