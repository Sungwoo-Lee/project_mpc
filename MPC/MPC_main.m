
clc;
clear;
close all;

%% SETTTING
PATH = getenv('PATH');
setenv('PATH', [PATH ':/Users/sungwoo320/anaconda3/bin:/Users/sungwoo320/anaconda3/condabin']); %For biopack, you need to add your python3 path

basedir = pwd;
Run_name = 'sungwoo';
Run_Num = 003; 
screen_mode = 'Testmode';
%screen_mode = 'Full';

heat_intensity_table = [40, 45; 41, 46; 42, 47]; % stimulus intensity
moviefile = fullfile(pwd, '/Video/1111.mp4');
movie_duration = 20;
caps_stim_duration = 90;

Trial_nums = 3;

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

data = MPC_data_save(Run_name, Run_Num, basedir);
data.dat.pilot_start_time = GetSecs; 

[window_info, line_parameters, color_values] = MPC_setscreen(screen_mode);
MPC_explain(window_info, line_parameters, color_values);
MPC_practice(window_info, line_parameters, color_values);

run_type = {'movie_heat'};
%Stimulus_type = {'no_movie_heat', 'movie_heat', 'CAPS'};

data = MPC_run(window_info, line_parameters, color_values, Trial_nums, run_type, Pathway, USE_BIOPAC, USE_EYELINK, dofmri, data, heat_intensity_table, moviefile, movie_duration, caps_stim_duration);
  
data = MPC_close(window_info, line_parameters, color_values, data);