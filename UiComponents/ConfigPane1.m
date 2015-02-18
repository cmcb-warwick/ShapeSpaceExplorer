function varargout = ConfigPane1(varargin)
% CONFIGPANE1 MATLAB code for ConfigPane1.fig
%      CONFIGPANE1, by itself, creates a new CONFIGPANE1 or raises the existing
%      singleton*.
%
%      H = CONFIGPANE1 returns the handle to a new CONFIGPANE1 or the handle to
%      the existing singleton*.
%
%      CONFIGPANE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGPANE1.M with the given input arguments.
%
%      CONFIGPANE1('Property','Value',...) creates a new CONFIGPANE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConfigPane1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConfigPane1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConfigPane1

% Last Modified by GUIDE v2.5 18-Feb-2015 09:11:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConfigPane1_OpeningFcn, ...
                   'gui_OutputFcn',  @ConfigPane1_OutputFcn, ...
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


% --- Executes just before ConfigPane1 is made visible.
function ConfigPane1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConfigPane1 (see VARARGIN)

% Choose default command line output for ConfigPane1
handles.output = hObject;
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1)
set(handles.edit1, 'String','...') 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ConfigPane1 wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ConfigPane1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
struc.folder = get(handles.edit1, 'String');
global jCBList;
struc.files= getValuesFromArrayList(jCBList.getCheckedValues());
varargout{1}=struc;
h= handles.figure1;
delete(h);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder =uigetdir(matlabroot,'Select Video Directory');
set(handles.edit1, 'String',folder)  
dir_struct = dir(folder);
dir_struct =filterFiles(dir_struct, '.dv');
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = sorted_index;

jList = java.util.ArrayList;% any java.util.List will be ok
for i =1:length(sorted_index)
    jList.add(sorted_index(i)-1, char(sorted_names(i)));
end
global jCBList;
jCBList = com.mathworks.mwswing.checkboxlist.CheckBoxList(jList);
jScrollPane = com.mathworks.mwswing.MJScrollPane(jCBList);
javacomponent(jScrollPane,[16,50,346,150],gcf);
set(jCBList, 'ValueChangedCallback', @ValueChangedCheckbox);
jCBModel= jCBList.getCheckModel;
jCBModel.checkAll;
set(handles.pushbutton2, 'enable', 'on'); 


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global jCBList;
files=jCBList.getCheckedValues();
files =getValuesFromArrayList(files);
if length(files)<1 % empty lenth is one.
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(3);
    errordlg(msg, 'Error', mode);
else
    figure1_CloseRequestFcn(hObject, eventdata, handles)
end


function ValueChangedCheckbox(hObject, eventdata, handles)


% remove hiden files and folders
function dir_struct =filterFiles(dir_struct, fileSuff)
idx=[];
suffLen=length(fileSuff);
for i=1:length(dir_struct)
    st = dir_struct(i);
    nameLen = length(st.name);
    if nameLen<=suffLen, continue; end
    if st.isdir, continue; end
    suff = st.name((nameLen-suffLen+1):end);
    if strcmp(fileSuff, suff)
        idx(end+1)=i;
    end
end
dir_struct = dir_struct(idx);


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


function array =getValuesFromArrayList(arrayList)
array ={};
i=1;
iter=arrayList.iterator();
    while (iter.hasNext())
        tmp = iter.next();
        array{i}=tmp;
        i=i+1;
    end
