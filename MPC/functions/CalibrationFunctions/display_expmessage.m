function display_expmessage(msg)
% diplay_expmessage("ad;slkja;l�Ҷ�Ҷ� \n���Ӥ��ո�����");
% type each MESSAGE

global theWindow white bgcolor window_rect; % rating scale

EXP_text = double(msg);

% display
Screen(theWindow,'FillRect',bgcolor, window_rect);
DrawFormattedText(theWindow, EXP_text, 'center', 'center', white, [], [], [], 1.5);
Screen('Flip', theWindow);

end