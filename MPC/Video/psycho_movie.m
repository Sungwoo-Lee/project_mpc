clear;

Screen('Clear');
Screen('CloseAll');

window_num = 0;
testmode=1;

if testmode
    window_rect = [0 0 1400 600]; % in the test mode, use a little smaller screen [but, wide resoultions]    
    Screen('Preference', 'SkipSyncTests', 1);
    fontsize = 32;
else
    screens = Screen('Screens');
    window_num = screens(end); % the last window
    Screen('Preference', 'SkipSyncTests', 1);
    window_info = Screen('Resolution', window_num);
    window_rect = [0 0 1920 1080];
    %window_rect = [0 0 window_info.width window_info.height]; % full screen
    fontsize = 32;
    HideCursor();
end

bgcolor = 80;

%% START: Screen
theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8'); % text encoding


%%
moviefile = fullfile(pwd, '1280.mp4');

playmode = 1;

starttime = GetSecs;
movie_start = 5;
movie_duration = 10;

[moviePtr, dura] = Screen('OpenMovie', theWindow, moviefile);

Screen('SetMovieTimeIndex', moviePtr, movie_start);
Screen('PlayMovie', moviePtr, playmode); %Screen('PlayMovie?')% 0 == Stop playback, 1 == Normal speed forward, -1 == Normal speed backward,

t = GetSecs; 

while GetSecs-t < movie_duration %(~done) %~KbCheck
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', theWindow, moviePtr);
    Screen('DrawTexture', theWindow, tex);
    Screen('Flip', theWindow);
    Screen('Close', tex);
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        %done = 1;
        break;
    end
    % Update display:
    
end

Screen('PlayMovie', moviePtr,0);
Screen('CloseMovie',moviePtr);
Screen('Flip', theWindow);
sca;
endtime = GetSecs;