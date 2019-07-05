function varargout = MPC_GUI(varargin)
% MPC_GUI MATLAB code for MPC_GUI.fig
%      MPC_GUI, by itself, creates a new MPC_GUI or raises the existing
%      singleton*.
%
%      H = MPC_GUI returns the handle to a new MPC_GUI312 or the handle to
%      the existing singleton*.
%
%      MPC_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MPC_GUI.M with the given input arguments.
%
%      MPC_GUI('Property','Value',...) creates a new MPC_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MPC_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MPC_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MPC_GUI

% Last Modified by GUIDE v2.5 25-Jun-2019 17:56:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MPC_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MPC_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT




% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
%% Running experiment
if ~exist('basedir', 'var') % In order to make program don't run simultaneously
    %% SETTTING parameters
    addpath(genpath(pwd));
    
    %% Biopack Python setting
    PATH = getenv('PATH');
    setenv('PATH', [PATH ':/Users/sungwoo320/anaconda3/bin:/Users/sungwoo320/anaconda3/condabin']); %For biopack, you need to add your python3 enviroment path
    %setenv('PATH', [PATH ':/Library/Frameworks/Python.framework/Versions/3.7/bin']);
    
    %% Eyelink file name
    expt_param.eyelink_filename = 'F_NAME'; % Eyelink file name should be equal or less than 8

    %% Experiment tag
    expt_param.Run_name = get(handles.run_name_edit, 'String');
    expt_param.Run_Num = str2num(get(handles.run_num_edit, 'String'));
    
    %% Experiment design
    expt_param.Trial_nums = str2num(get(handles.trial_num_edit, 'String'));
    expt_param.Run_nums = str2num(get(handles.run_num_edit, 'String'));
  
    if get(handles.explain_check,'Value'); explain = true; else; explain = false; end
    if get(handles.practice_chack,'Value'); practice = true; else; practice = false; end
    if get(handles.run_check,'Value'); run = true; else; run = false; end
    if get(handles.pathway_check,'Value'); expt_param.Pathway = true; else; expt_param.Pathway = false; end
    if get(handles.biopack_check,'Value'); expt_param.USE_BIOPAC = true; else; expt_param.USE_BIOPAC = false; end
    if get(handles.eyelink_check,'Value'); expt_param.USE_EYELINK = true; else; expt_param.USE_EYELINK = false; end
    if get(handles.fMRI_check,'Value'); expt_param.dofmri = true; else; expt_param.dofmri = false; end

    %% Experiment parameters
    expt_param.heat_intensity_table = get(handles.table1, 'data');
    expt_param.moviefile = get(handles.movie_dir_edit, 'string');
    expt_param.movie_duration = str2num(get(handles.movie_dur_edit, 'String'));
    expt_param.caps_stim_duration = str2num(get(handles.caps_dur_edit, 'string'));
    expt_param.resting_duration = str2num(get(handles.resting_edit, 'string'));
    
    %% Error check for movie directory
    expt_param.run_type = handles.run_type;
    if strcmp(expt_param.run_type,'movie_heat') & strcmp(expt_param.moviefile,'None')
        error('Movie directory is None. You have to select movie!')
    end
    
    %% Run type setting
    if get(handles.nomovie_button, 'Value')
        expt_param.run_type = {'no_movie_heat'};
    elseif get(handles.movie_button, 'Value')
        expt_param.run_type = {'movie_heat'};
    elseif  get(handles.caps_button, 'Value')
        expt_param.run_type = {'caps'};
    elseif   get(handles.resting_button, 'Value')
        expt_param.run_type = {'resting'};
    end
    

    %% Screen setting
    expt_param.screen_mode = handles.screen_mode;
    if get(handles.full_button, 'Value')
        expt_param.screen_mode = get(handles.full_button, 'string');
%     elseif get(handles.semifull_button, 'Value')
%         expt_param.screen_mode = get(handles.semifull_button, 'string');
%     elseif get(handles.middle_button, 'Value')
%         expt_param.screen_mode = get(handles.middle_button, 'string');
%     elseif get(handles.small_button, 'Value')
%         expt_param.screen_mode = get(handles.small_button, 'string');
%     elseif get(handles.test_button, 'Value')
%         expt_param.screen_mode = get(handles.test_button, 'string');
    elseif get(handles.testmode_button, 'Value')
        expt_param.screen_mode = get(handles.testmode_button, 'string');
    end

    %% SETTING pathway ip and port
    global ip port
    ip = '192.168.0.3'; %ip = '115.145.189.133'; %ip = '203.252.54.21';
    port = 20121;

    %% Make Data struct
    basedir = pwd;
    data = MPC_data_save(expt_param, basedir);
    data.expt_param = expt_param;
    
    %% Check experiment start time
    data.dat.experiment_start_time = GetSecs; 

    screen_param = MPC_setscreen(expt_param);
    %% Explain and Practice Experiment
    if explain
        MPC_explain(screen_param, expt_param);
    end

    if practice
        MPC_practice(screen_param);
    end

    %% Start Run
    if run
        data = MPC_run(screen_param, expt_param, data);
    end
    %% Close Experiment
    data = MPC_close(screen_param, data);
end





% --- Executes just before MPC_GUI is made visible.
function MPC_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MPC_GUI (see VARARGIN)

screen_mode = get(handles.testmode_button, 'string');
handles.screen_mode = screen_mode;
run_type = {'no_movie_heat'};
handles.run_type = run_type;

% Choose default command line output for MPC_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MPC_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = MPC_GUI_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

function run_name_edit_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of run_name_edit as text
%        str2double(get(hObject,'String')) returns contents of run_name_edit as a double

% --- Executes during object creation, after setting all properties.
function run_name_edit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sub_num_edit_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of run_numss_edit as text
%        str2double(get(hObject,'String')) returns contents of run_numss_edit as a double

% --- Executes during object creation, after setting all properties.
function sub_num_edit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function trial_num_edit_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of trial_num_edit as text
%        str2double(get(hObject,'String')) returns contents of trial_num_edit as a double

% --- Executes during object creation, after setting all properties.
function trial_num_edit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function run_num_edit_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of run_numss_edit as text
%        str2double(get(hObject,'String')) returns contents of run_numss_edit as a double

% --- Executes during object creation, after setting all properties.
function run_num_edit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in explain_check.
function explain_check_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of explain_check

% --- Executes on button press in practice_chack.
function practice_chack_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of practice_chack

% --- Executes on button press in run_check.
function run_check_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of run_check

% --- Executes on button press in pathway_check.
function pathway_check_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of pathway_check

% --- Executes on button press in biopack_check.
function biopack_check_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of biopack_check

% --- Executes on button press in eyelink_check.
function eyelink_check_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of eyelink_check

% --- Executes on button press in full_button.
function full_button_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of full_button

% --- Executes on button press in semifull_button.
function semifull_button_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of semifull_button

% --- Executes on button press in middle_button.
function middle_button_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of middle_button

% --- Executes on button press in small_button.
function small_button_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of small_button


% --- Executes on button press in test_button.
function test_button_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of test_button


% --- Executes on button press in testmode_button.
function testmode_button_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of testmode_button

function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)

switch(get(eventdata.NewValue, 'Tag'))
    case 'full_button'
        screen_mode = get(handles.full_button, 'string');
    case 'semifull_button'
        screen_mode = get(handles.semifull_button, 'string');
    case 'middle_button'
        screen_mode = get(handles.middle_button, 'string');
    case 'small_button'
        screen_mode = get(handles.small_button, 'string');
    case 'test_button'
        screen_mode = get(handles.test_button, 'string');
    case 'testmode_button'
        screen_mode = get(handles.testmode_button, 'string');
end
handles.screen_mode = screen_mode;

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in fMRI_check.
function fMRI_check_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of fMRI_check

function movie_dur_edit_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of movie_dur_edit as text
%        str2double(get(hObject,'String')) returns contents of movie_dur_edit as a double

% --- Executes during object creation, after setting all properties.
function movie_dur_edit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in find_dir_push.
function find_dir_push_Callback(hObject, eventdata, handles)
[movie_file, movie_path] = uigetfile('*.mp4');

full_path = fullfile(movie_path, movie_file);
set(handles.movie_dir_edit, 'string', full_path);

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

function movie_dir_edit_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of movie_dir_edit as text
%        str2double(get(hObject,'String')) returns contents of movie_dir_edit as a double

% --- Executes during object creation, after setting all properties.
function movie_dir_edit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.movie_dir_edit = hObject;
% Update handles structure
guidata(hObject, handles);

function caps_dur_edit_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of caps_dur_edit as text
%        str2double(get(hObject,'String')) returns contents of caps_dur_edit as a double

% --- Executes during object creation, after setting all properties.
function caps_dur_edit_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in nomovie_button.
function nomovie_button_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of nomovie_button

% --- Executes on button press in movie_button.
function movie_button_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of movie_button

% --- Executes on button press in caps_button.
function caps_button_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of caps_button

% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
switch(get(eventdata.NewValue, 'Tag'))
    case 'nomovie_button'
        run_type = {'no_movie_heat'};
    case 'movie_button'
        run_type = {'movie_heat'};
    case 'caps_button'
        run_type = {'caps'};
    case 'resting_button'
        run_type = {'resting'};
end
handles.run_type = run_type;

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

function resting_edit_Callback(hObject, eventdata, handles)
% hObject    handle to resting_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resting_edit as text
%        str2double(get(hObject,'String')) returns contents of resting_edit as a double


% --- Executes during object creation, after setting all properties.
function resting_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resting_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
