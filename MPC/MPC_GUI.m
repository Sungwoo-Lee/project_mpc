function varargout = MPC_GUI(varargin)
% MPC_GUI MATLAB code for MPC_GUI.fig
%      MPC_GUI, by itself, creates a new MPC_GUI or raises the existing
%      singleton*.
%
%      H = MPC_GUI returns the handle to a new MPC_GUI or the handle to
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

% Last Modified by GUIDE v2.5 13-Jun-2019 14:33:22

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
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function run_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to run_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of run_name_edit as text
%        str2double(get(hObject,'String')) returns contents of run_name_edit as a double


% --- Executes during object creation, after setting all properties.
function run_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to run_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sub_num_edit_Callback(hObject, eventdata, handles)
% hObject    handle to run_numss_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of run_numss_edit as text
%        str2double(get(hObject,'String')) returns contents of run_numss_edit as a double


% --- Executes during object creation, after setting all properties.
function sub_num_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to run_numss_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trial_num_edit_Callback(hObject, eventdata, handles)
% hObject    handle to trial_num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trial_num_edit as text
%        str2double(get(hObject,'String')) returns contents of trial_num_edit as a double


% --- Executes during object creation, after setting all properties.
function trial_num_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_num_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function run_num_edit_Callback(hObject, eventdata, handles)
% hObject    handle to run_numss_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of run_numss_edit as text
%        str2double(get(hObject,'String')) returns contents of run_numss_edit as a double


% --- Executes during object creation, after setting all properties.
function run_num_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to run_numss_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in explain_check.
function explain_check_Callback(hObject, eventdata, handles)
% hObject    handle to explain_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of explain_check


% --- Executes on button press in practice_chack.
function practice_chack_Callback(hObject, eventdata, handles)
% hObject    handle to practice_chack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of practice_chack


% --- Executes on button press in run_check.
function run_check_Callback(hObject, eventdata, handles)
% hObject    handle to run_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of run_check


% --- Executes on button press in pathway_check.
function pathway_check_Callback(hObject, eventdata, handles)
% hObject    handle to pathway_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pathway_check


% --- Executes on button press in biopack_check.
function biopack_check_Callback(hObject, eventdata, handles)
% hObject    handle to biopack_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of biopack_check



% --- Executes on button press in eyelink_check.
function eyelink_check_Callback(hObject, eventdata, handles)
% hObject    handle to eyelink_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eyelink_check


% --- Executes on button press in full_button.
function full_button_Callback(hObject, eventdata, handles)
% hObject    handle to full_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user    data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of full_button


% --- Executes on button press in semifull_button.
function semifull_button_Callback(hObject, eventdata, handles)
% hObject    handle to semifull_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of semifull_button


% --- Executes on button press in middle_button.
function middle_button_Callback(hObject, eventdata, handles)
% hObject    handle to middle_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of middle_button


% --- Executes on button press in small_button.
function small_button_Callback(hObject, eventdata, handles)
% hObject    handle to small_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of small_button


% --- Executes on button press in test_button.
function test_button_Callback(hObject, eventdata, handles)
% hObject    handle to test_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of test_button


% --- Executes on button press in testmode_button.
function testmode_button_Callback(hObject, eventdata, handles)
% hObject    handle to testmode_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of testmode_button


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Running experiment
if ~exist('basedir', 'var') % In order to make program don't run simultaneously
    %% SETTTING parameters
    PATH = getenv('PATH');
    setenv('PATH', [PATH ':/Users/sungwoo320/anaconda3/bin:/Users/sungwoo320/anaconda3/condabin']); %For biopack, you need to add your python3 path
    
    basedir = pwd;
    Run_name = get(handles.run_name_edit, 'String');
    Run_Num = str2num(get(handles.run_num_edit, 'String'));
    screen_mode = handles.screen_mode;

    %how_many_trials = str2num(get(handles.trial_num_edit, 'String'));
    %how_many_runs = str2num(get(handles.run_numss_edit, 'String'));

    Trial_nums = str2num(get(handles.trial_num_edit, 'String'));
    Run_nums = str2num(get(handles.run_num_edit, 'String'));

    heat_intensity_table = get(handles.table1, 'data');
    moviefile = get(handles.movie_dir_edit, 'string');
    caps_stim_duration = str2num(get(handles.caps_dur_edit, 'string'));

    run_type = handles.run_type;
    %Stimulus_type = {'no_movie_heat', 'movie_heat', 'CAPS'};

    if strcmp(run_type,'movie_heat') & strcmp(moviefile,'None')
        error('Movie directory is None. You have to select movie!')
    end
    movie_duration = str2num(get(handles.movie_dur_edit, 'String'));

    if get(handles.explain_check,'Value'); explain = true; else; explain = false; end
    if get(handles.practice_chack,'Value'); practice = true; else; practice = false; end
    if get(handles.run_check,'Value'); run = true; else; run = false; end
    if get(handles.pathway_check,'Value'); Pathway = true; else; Pathway = false; end
    if get(handles.biopack_check,'Value'); USE_BIOPAC = true; else; USE_BIOPAC = false; end
    if get(handles.eyelink_check,'Value'); USE_EYELINK = true; else; USE_EYELINK = false; end
    if get(handles.fMRI_check,'Value'); dofmri = true; else; dofmri = false; end

    if get(handles.full_button, 'Value')
        screen_mode = get(handles.full_button, 'string');
    elseif get(handles.semifull_button, 'Value')
        screen_mode = get(handles.semifull_button, 'string');
    elseif get(handles.middle_button, 'Value')
        screen_mode = get(handles.middle_button, 'string');
    elseif get(handles.small_button, 'Value')
        screen_mode = get(handles.small_button, 'string');
    elseif get(handles.test_button, 'Value')
        screen_mode = get(handles.test_button, 'string');
    elseif get(handles.testmode_button, 'Value')
        screen_mode = get(handles.testmode_button, 'string');
    end


    %% SETTING pathway ip and port
    addpath(genpath(pwd));
    % or, you can load pre-determined information 
    global ip port
    ip = '192.168.0.3'; %ip = '115.145.189.133'; %ip = '203.252.54.21';
    port = 20121;


    %% Running experiment
    data = MPC_data_save(Run_name, Run_Num, basedir);
    data.dat.pilot_start_time = GetSecs; 

    [window_info, line_parameters, color_values] = MPC_setscreen(screen_mode);

    if explain
    MPC_explain(window_info, line_parameters, color_values);
    end

    if practice
    MPC_practice(window_info, line_parameters, color_values);
    end


    %% Setting Stimulus type list

    data = MPC_run(window_info, line_parameters, color_values, Trial_nums, run_type, Pathway, USE_BIOPAC, USE_EYELINK, dofmri, data, heat_intensity_table, moviefile, movie_duration, caps_stim_duration);


    %% Close the experiment
    data = MPC_close(window_info, line_parameters, color_values, data);

end

function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
% hObject    handle to fMRI_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fMRI_check



function movie_dur_edit_Callback(hObject, eventdata, handles)
% hObject    handle to movie_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_dur_edit as text
%        str2double(get(hObject,'String')) returns contents of movie_dur_edit as a double


% --- Executes during object creation, after setting all properties.
function movie_dur_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in find_dir_push.
function find_dir_push_Callback(hObject, eventdata, handles)
% hObject    handle to find_dir_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[movie_file, movie_path] = uigetfile('*.mp4');

full_path = fullfile(movie_path, movie_file);
set(handles.movie_dir_edit, 'string', full_path);

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


function movie_dir_edit_Callback(hObject, eventdata, handles)
% hObject    handle to movie_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movie_dir_edit as text
%        str2double(get(hObject,'String')) returns contents of movie_dir_edit as a double


% --- Executes during object creation, after setting all properties.
function movie_dir_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.movie_dir_edit = hObject;
% Update handles structure
guidata(hObject, handles);



function caps_dur_edit_Callback(hObject, eventdata, handles)
% hObject    handle to caps_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of caps_dur_edit as text
%        str2double(get(hObject,'String')) returns contents of caps_dur_edit as a double


% --- Executes during object creation, after setting all properties.
function caps_dur_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to caps_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in nomovie_button.
function nomovie_button_Callback(hObject, eventdata, handles)
% hObject    handle to nomovie_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nomovie_button


% --- Executes on button press in movie_button.
function movie_button_Callback(hObject, eventdata, handles)
% hObject    handle to movie_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of movie_button


% --- Executes on button press in caps_button.
function caps_button_Callback(hObject, eventdata, handles)
% hObject    handle to caps_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of caps_button

% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch(get(eventdata.NewValue, 'Tag'))
    case 'nomovie_button'
        run_type = {'no_movie_heat'};
    case 'movie_button'
        run_type = {'movie_heat'};
    case 'caps_button'
        run_type = {'caps'};
end
handles.run_type = run_type;

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
