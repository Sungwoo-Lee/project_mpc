clc;
clear;
close all;

%% SETTTING
addpath(genpath(pwd));
PATH = getenv('PATH');
setenv('PATH', [PATH ':/Users/sungwoo320/anaconda3/bin:/Users/sungwoo320/anaconda3/condabin']); %For biopack, you need to add your python3 path
%setenv('PATH', [PATH ':/Library/Frameworks/Python.framework/Versions/3.7/bin']);

basedir = pwd;
Run_name = 'sungwoo';
Run_Num = 002;f
screen_mode = 'Testmode'; %{'Testmode','Full'}
eyelink_filename = 'F_NAME'; % Eyelink file name should be equal or less than 8

heat_intensity_table = [40, 45; 41, 46; 42, 47]; % stimulus intensity
moviefile = fullfile(pwd, '/Video/1111.mp4');
movie_duration = 20;
caps_stim_duration = 90;

Trial_nums = 12;
run_type = {'movie_heat'}; % {'no_movie_heat', 'movie_heat', 'CAPS'}

Pathway = false;
USE_BIOPAC = false;
USE_EYELINK = false;
dofmri = false;


%% SETTING
% or, you can load pre-determined information 
global ip port
ip = '192.168.0.3'; %ip = '115.145.189.133'; %ip = '203.252.54.21';
port = 20121;


%% Start experiment
data = MPC_data_save(Run_name, Run_Num, basedir);
data.dat.experiment_start_time = GetSecs; 

[window_info, line_parameters, color_values] = MPC_setscreen(screen_mode);

MPC_explain(window_info, line_parameters, color_values);

MPC_practice(window_info, line_parameters, color_values);

data = MPC_run(window_info, line_parameters, color_values, Trial_nums, run_type, Pathway, USE_BIOPAC, USE_EYELINK, eyelink_filename, dofmri, data, heat_intensity_table, moviefile, movie_duration, caps_stim_duration);
  
data = MPC_close(window_info, line_parameters, color_values, data);