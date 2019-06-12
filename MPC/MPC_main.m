
clc;
clear;
close all;

%% SETTTING

basedir = pwd;
SID = 'sungwoo';
SubjNum = 005   ; 
screen_mode = 'Testmode';
%screen_mode = 'Full';

heat_intensity_table = [40, 45; 41, 46; 42, 47]; % stimulus intensity
 
Trial_nums = 6;
Run_nums = 1;

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


data = MPC_data_save(SID, SubjNum, basedir);
data.dat.pilot_start_time = GetSecs; 

[window_info, line_parameters, color_values] = MPC_setscreen(screen_mode);
MPC_explain(window_info, line_parameters, color_values);
MPC_practice(window_info, line_parameters, color_values);

Stimulus_type = {'movie_heat'};
%Stimulus_type = {'no_movie_heat', 'movie_heat', 'CAPS'};

for Run_num = 1:Run_nums
    data = MPC_run(window_info, line_parameters, color_values, Trial_nums, Run_num, Stimulus_type, Pathway, USE_BIOPAC, USE_EYELINK, dofmri, data, heat_intensity_table);
end
  
data = MPC_close(window_info, line_parameters, color_values, data);