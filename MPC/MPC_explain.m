function MPC_explain(window_info, line_parameters, color_values)     
 % (Explain) Continuous & Overall
 % Explain bi-directional scale with visualization 
 
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
