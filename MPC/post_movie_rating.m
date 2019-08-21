
addpath(genpath(pwd));

%% Saving
basedir = pwd;
savedir = fullfile(basedir, 'Data');

nowtime = clock;
SubjDate = sprintf('%.2d%.2qd%.2d', nowtime(1), nowtime(2), nowtime(3));

data.sub_name = 'MPC_test';
data.datafile = fullfile(savedir, [SubjDate, '_', data.sub_name, '_MPC_post_movie_rating', '.mat']);
data.version = 'MPC_07-30-2019_Cocoanlab';  % month-date-year
data.starttime = datestr(clock, 0);


[movie_file, movie_path] = uigetfile('*.mp4');
movie_dir = fullfile(movie_path, movie_file);

% moviefile = fullfile(pwd, '/Video/2222.mp4');


% if the same file exists, break and retype subject info
if exist(data.datafile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', data.sub_name, SubjDate);
    cont_or_not = input(['\nThe typed Run name and number are already saved.', ...
        '\nWill you go on with your Run name and number that saved before?', ...
        '\n1: Yes, continue with Run name and number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('Breaked.')
    elseif cont_or_not == 1
        save(data.datafile, 'data');
    end
else
    save(data.datafile, 'data');
end

%%
data.dat.post_movie_rating_start_time = GetSecs;

screens = Screen('Screens');
window_num = screens(1);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);

screen_mode = 'Full';

switch screen_mode
    case 'Full'
        %window_rect = [0 0 window_info.width window_info.height]; % full screen
        window_rect = [0 0 1440 900]; % full screen
        fontsize = 32;
    case 'Testmode'
        window_rect = [0 0 1200 600];  % 1920 1080]; full screen for window
        fontsize = 32;
end

% size
W = window_rect(3); % width
H = window_rect(4); % height

lb1 = W*(2/10); % rating scale left bounds 1/6 0.1666
rb1 = W*(8/10); % rating scale right bounds 5/6 0.83333
lb2 = W*(3/10); % rating scale left bounds 1/4 0.25
rb2 = W*(7/10); % rating scale right bounds 3/4 0.75

lb = lb2;
rb = rb2;

scale_W = W*0.1;
scale_H = H*0.1;


anchor_lms = [W/2-0.014*(W/2-lb1) W/2-0.061*(W/2-lb1) W/2-0.172*(W/2-lb1) W/2-0.354*(W/2-lb1) W/2-0.533*(W/2-lb1);
    W/2+0.014*(W/2-lb1) W/2+0.061*(W/2-lb1) W/2+0.172*(W/2-lb1) W/2+0.354*(W/2-lb1) W/2+0.533*(W/2-lb1)];

% color
bgcolor = 50;
white = 255;
red = [158 1 66];
orange = [255 164 0];

% font
font = 'NanumBarunGothic';
Screen('Preference', 'TextEncodingLocale', 'ko_KR.UTF-8');

theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, fontsize);

Screen(theWindow, 'FillRect', bgcolor, window_rect);
Screen('Flip', theWindow);
HideCursor;

scale = ('post_movie_rating');
rating_types_pls = call_ratingtypes_pls('resting');
ratetype = strcmp(rating_types_pls.alltypes, scale);

playmode = 1;

[moviePtr, dura, fps, width, height] = Screen('OpenMovie', theWindow, movie_dir);

scale_movie_w = width*(width/W);
scale_movie_h = height*(height/H)*(1);

Screen('SetMovieTimeIndex', moviePtr, 0);
Screen('PlayMovie', moviePtr, playmode); %Screen('PlayMovie?')% 0 == Stop playback, 1 == Normal speed forward, -1 == Normal speed backward,


while true
    [x,y,button] = GetMouse(theWindow);
    Screen('TextSize', theWindow, 25);
    Screen('DrawLine', theWindow, white, lb, H*(9.8/10), rb, H*(9.8/10), 4); % penWidth: 0.125~7.000
    Screen('DrawLine', theWindow, white, lb, H*(9.8/10)-(rb-lb)/2, rb, H*(9.8/10)-(rb-lb)/2, 4);
    Screen('DrawLine', theWindow, white, lb, H*(9.8/10)-(rb-lb)/2, lb, H*(9.8/10), 6);
    Screen('DrawLine', theWindow, white, rb, H*(9.8/10)-(rb-lb)/2, rb, H*(9.8/10), 6);
    Screen('DrawLine', theWindow, white, W/2, H*(9.8/10)-(rb-lb)/2, W/2, H*(9.8/10), 4);
    DrawFormattedText(theWindow, double('긍정'), rb+scale_H*(0.1),H*(9.8/10), white,[],[],[],1.2);
    DrawFormattedText(theWindow, double('부정'), lb-scale_H*(0.7), H*(9.8/10), white,[],[],[],1.2);
    DrawFormattedText(theWindow, double('몰입도'), W*(1/2)-scale_H*(0.3), H*(6.5/10), white,[],[],[],1.2);
    DrawFormattedText(theWindow, double('준비하세요'), W*(1/2)-scale_H*(0.7), H*(5/10), white,[],[],[],1.2);
    DrawFormattedText(theWindow, double('스캔실에서의 감정과 몰입을 떠올려주세요'), W*(1/2)-scale_H*(2.6), H*(4.5/10), white,[],[],[],1.2);
    Screen('TextSize', theWindow, fontsize);

    if x < lb; x = lb; elseif x > rb; x = rb; end
    if y < H*(9.8/10)-(rb-lb)/2; y = H*(9.8/10)-(rb-lb)/2; elseif y > H*(9.8/10); y = H*(9.8/10); end
    Screen('DrawDots', theWindow, [x, y], 10, orange, [0 0], 1); %x, H*(4/5)-scale_H/3, x, H*(4/5)+scale_H/3
    %Screen('DrawLine', theWindow, orange, x, y, x+scale_H/5, y+scale_H/5, 6); %rqating bar x, H*(4/5)-scale_H/3, x, H*(4/5)+scale_H/3
    Screen('Flip', theWindow);
    
    if button(1)
        while button(1)
            [~,~,button] = GetMouse(theWindow);
        end
        break
    end
 
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end
end

rec_i = 0;
t = GetSecs;
data.dat.continuous_rating_start = t;

while GetSecs-t < 740 %(~done) %~KbCheckq
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', theWindow, moviePtr);
    Screen('DrawTexture', theWindow, tex, [ ], [W/2-scale_movie_w*(4.5/10) H*(0.5/10)-scale_movie_h*(1/10) W/2+scale_movie_w*(4.5/10) H*(1/10)+scale_movie_h*(8/10)]);
    
    [x,y,button] = GetMouse(theWindow);
    Screen('TextSize', theWindow, 25);
    Screen('DrawLine', theWindow, white, lb, H*(9.8/10), rb, H*(9.8/10), 4); % penWidth: 0.125~7.000
    Screen('DrawLine', theWindow, white, lb, H*(9.8/10)-(rb-lb)/2, rb, H*(9.8/10)-(rb-lb)/2, 4);
    Screen('DrawLine', theWindow, white, lb, H*(9.8/10)-(rb-lb)/2, lb, H*(9.8/10), 6);
    Screen('DrawLine', theWindow, white, rb, H*(9.8/10)-(rb-lb)/2, rb, H*(9.8/10), 6);
    Screen('DrawLine', theWindow, white, W/2, H*(9.8/10)-(rb-lb)/2, W/2, H*(9.8/10), 4);
    DrawFormattedText(theWindow, double('긍정'), rb+scale_H*(0.1),H*(9.8/10), white,[],[],[],1.2);
    DrawFormattedText(theWindow, double('부정'), lb-scale_H*(0.7), H*(9.8/10), white,[],[],[],1.2);
    DrawFormattedText(theWindow, double('몰입도'), W*(1/2)-scale_H*(0.3), H*(6.5/10), white,[],[],[],1.2);
    Screen('TextSize', theWindow, fontsize);
    
    if x < lb; x = lb; elseif x > rb; x = rb; end
    if y < H*(9.8/10)-(rb-lb)/2; y = H*(9.8/10)-(rb-lb)/2; elseif y > H*(9.8/10); y = H*(9.8/10); end
    Screen('DrawDots', theWindow, [x, y], 10, orange, [0 0], 1);
    Screen('Flip', theWindow);
    Screen('Close', tex);
    
    rec_i = rec_i + 1;
    
    data.dat.continuous_rating(rec_i,1) = GetSecs;
    data.dat.continuous_rating(rec_i,2) = data.dat.continuous_rating(rec_i,1) - t;
    data.dat.continuous_rating(rec_i,3) = (x-lb)/(rb-lb);
    data.dat.continuous_rating(rec_i,4) = abs(1 - (y - (H*(9.8/10)-(rb-lb)/2))/(H*(9.8/10) - (H*(9.8/10)-(rb-lb)/2)));
    
    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        %done = 1;
        break;
    end
    % Update display:
    
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q')) == 1
        abort_experiment('manual');
        break
    end
    
end

data.dat.continuous_rating_end = GetSecs;
data.dat.continuous_rating_dur = data.dat.continuous_rating_end - data.dat.continuous_rating_start;

Screen('PlayMovie', moviePtr,0);
Screen('CloseMovie',moviePtr);
Screen('Flip', theWindow);
Screen('CloseAll');

save(data.datafile, 'data', '-append');