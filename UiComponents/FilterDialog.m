function varargout = FilterDialog(varargin)
% FILTERDIALOG MATLAB code for FilterDialog.fig
%      FILTERDIALOG, by itself, creates a new FILTERDIALOG or raises the existing
%      singleton*.
%
%      H = FILTERDIALOG returns the handle to a new FILTERDIALOG or the handle to
%      the existing singleton*.
%
%      FILTERDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERDIALOG.M with the given input arguments.
%
%      FILTERDIALOG('Property','Value',...) creates a new FILTERDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FilterDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FilterDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FilterDialog

% Last Modified by GUIDE v2.5 02-Mar-2015 16:03:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FilterDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @FilterDialog_OutputFcn, ...
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


% --- Executes just before FilterDialog is made visible.
function FilterDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FilterDialog (see VARARGIN)

% Choose default command line output for FilterDialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1)

% UIWAIT makes FilterDialog wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FilterDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
number=-1;
num = get(handles.numInput,'String');
try % we read again the number.
    num=str2num(num);
    number =abs(round(num)); end
varargout{1} = number;
delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(hObject, eventdata, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

num = get(handles.numInput,'String');
try % we read again the number.
    num=str2num(num);
    if isempty(num) || num<1
        mode = struct('WindowStyle','non-modal','Interpreter','tex');
        msg = DialogMessages(10);
        errordlg(msg, 'Error', mode);
        return
    end   
catch
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(10);
    errordlg(msg, 'Error', mode);
    return
end
% if we arrive till here, things were fine.
figure1_CloseRequestFcn(hObject, eventdata, handles);


function numInput_Callback(hObject, eventdata, handles)
% hObject    handle to numInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numInput as text
%        str2double(get(hObject,'String')) returns contents of numInput as a double


% --- Executes during object creation, after setting all properties.
function numInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
h= handles.figure1;
if isequal(get(h, 'waitstatus'), 'waiting')
    uiresume(h)
else
    h= handles.figure1;
    delete(h);
end
