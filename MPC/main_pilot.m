% 
% clc;
% clear;
% close all;

%% SETTTING
basedir = pwd;
SID = 'sungwoo';
SubjNum = 002   ; 
screen_mode = 'Testmode';
GUI_table_data = [40, 45; 41, 46; 42, 47]; % stimulus intensity
 
how_many_trials = 3;
how_many_runs = 1;

Pathway = false;
USE_BIOPAC = false;
USE_EYELINK = false;
dofmri = false;

%% SETTING
addpath(genpath(pwd));
% or, you can load pre-determined information 
global ip port
ip = '192.168.0.3'; %ip = '115.145.189.133'; %ip = '203.252.54.21';
port = 20121;
%%
data = MPC_data_save(SID, SubjNum, basedir);
data.dat.pilot_start_time = GetSecs; 

[window_info, line_parameters, color_values] = MPC_setscreen(screen_mode);
MPC_explain(window_info, line_parameters, color_values);
MPC_practice(window_info, line_parameters, color_values);

for Run_num = 1:how_many_runs
    data = MPC_run(window_info, line_parameters, color_values, how_many_trials, Run_num, Pathway, USE_BIOPAC, USE_EYELINK, dofmri, data, GUI_table_data);
end
  
data = MPC_close(window_info, line_parameters, color_values, data);