function pathway_test(ip, port, type, reg)
%%
% This fucntion is only for stimulating 50 thermal degree before
% participants experiece thermal pain. It needs two inputs, 1) IP adress
% and 2) port.
%
% See this, ------------------------------------------------
% Matlab: Program name : Program code (parameter, 8bit)
% ---------------------------------------------------------
%   23  : SEMIC_50     :   00011001
%
% writen by Suhwan Gim
%%

global theWindow W H; % window property
global window_rect lb rb tb bb scale_H; % rating scale
global bgcolor;
global fontsize;


Screen(theWindow,'FillRect',bgcolor, window_rect);

msg=double('�̵��� ���е带 Ȯ���� ���� �׽�Ʈ�� �����ϰڽ��ϴ� (space)');
display_expmessage(msg);

while (1)
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q'))==1
        break
    elseif keyCode(KbName('space'))== 1
        break
    end
end

Screen('Flip', theWindow);

switch type
    case 'basic'
        for i = 1:4
            msg = strcat('�����ڴ� ���е带 �ش� ��ġ�� �̵������ּ��� (Space):  ', num2str(i));
            while (1)
                [~,~,keyCode] = KbCheck;
                if keyCode(KbName('space'))==1
                    break;
                elseif keyCode(KbName('q'))==1
                    abort_experiment;
                end
                display_expmessage(msg);
            end
            msg='��ø� ��ٷ� �ּ���';
            display_expmessage(msg);
            
            if ~isempty(msg)
                %disp('Please wait a second');
                main(ip, port, 1, 76);
                WaitSecs(0.5);
                clc;
                
                %disp('Ready to start');
                main(ip, port, 2);
                WaitSecs(2);
                clc;
                
                %disp('Start');
                main(ip, port, 2);
                
                sTime=GetSecs;         %      
                msg='';
                display_expmessage(msg);
                
                disp('Done');
            end
            while GetSecs - sTime <14.5 
                % pause
            end
        end
        msg=double('�������� ���̽�ƽ ������ �����ϰڽ��ϴ� (space)');
        
    case 'MRI'
        if ~isempty(msg)
            PathPrg = load_PathProgram('SEMIC');
            % Find the highest themal degree based on the calibration procedure
            for iii=1:length(PathPrg) %find degree
                if reg.FinalLMH_5Level(5) == PathPrg{iii,1}
                    degree = bin2dec(PathPrg{iii,2});
                else
                    % do nothing
                end
            end
            msg='��ø� ��ٷ� �ּ���';
            display_expmessage(msg);

            main(ip, port, 1, degree);
            WaitSecs(0.5);
            clc;
            
            %disp('Ready to start');
            main(ip, port, 2);
            WaitSecs(2);
            clc;
            
            %disp('Start');
            main(ip, port, 2);
            WaitSecs(0.5);
            clc;
            %disp('Done');
            
            sTime=GetSecs;         %
            msg='';
            display_expmessage(msg);
        end
        while GetSecs - sTime <14.5 
            % pause
        end
        msg=double('Ȯ���Ͽ����ϴ�.\n�������δ� ô�� Ȯ���� �ϰڽ��ϴ� (space)');
end

while (1)
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q'))==1
        break
    elseif keyCode(KbName('space'))== 1
        break
    end
    display_expmessage(msg);
end


end
