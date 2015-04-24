function varargout = ShapeFeatures(varargin)
% SHAPEFEATURES MATLAB code for ShapeFeatures.fig
%      SHAPEFEATURES, by itself, creates a new SHAPEFEATURES or raises the existing
%      singleton*.
%
%      H = SHAPEFEATURES returns the handle to a new SHAPEFEATURES or the handle to
%      the existing singleton*.
%
%      SHAPEFEATURES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHAPEFEATURES.M with the given input arguments.
%
%      SHAPEFEATURES('Property','Value',...) creates a new SHAPEFEATURES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ShapeFeatures_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ShapeFeatures_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ShapeFeatures

% Last Modified by GUIDE v2.5 09-Mar-2015 17:53:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ShapeFeatures_OpeningFcn, ...
                   'gui_OutputFcn',  @ShapeFeatures_OutputFcn, ...
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


% --- Executes just before ShapeFeatures is made visible.
function ShapeFeatures_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ShapeFeatures (see VARARGIN)

% Choose default command line output for ShapeFeatures
handles.output = hObject;
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1)
set(handles.edit1, 'String','...')
features={'Area', 'Circularity', 'ConvexArea' ,'Dist_max', 'Dist_min', ...
              'Dist_ratio','Eccentricity' 'EquivDiameter', 'Extent', 'Irregularity',...
              'Irregularity2', 'MajorAxisLength', 'MinorAxisLength', 'Orientation',...
              'Perimeter', 'Solidity', 'Symmetry'};
jList = java.util.ArrayList;% any java.util.List will be ok
for i =1:length(features)
    jList.add(i-1, char(features(i)));
end
jCBList = com.mathworks.mwswing.checkboxlist.CheckBoxList(jList);
jScrollPane = com.mathworks.mwswing.MJScrollPane(jCBList);
javacomponent(jScrollPane,[16,70,335,80],gcf);
jCBModel= jCBList.getCheckModel;
jCBModel.checkAll;
handles.jCBList=jCBList;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ShapeFeatures wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ShapeFeatures_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout={-1};
if handles.cancel==1,   % if cancel
    delete(handles.figure1);
    return;
end
struc.anaFolder = get(handles.edit1, 'String');

jCBList=handles.jCBList;
struc.props= getValuesFromArrayList(jCBList.getCheckedValues());
varargout{1}=struc;
delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder =uigetdir(matlabroot,'Select Analysis Directory');
set(handles.edit1, 'String',folder)  
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
folderAna =get(handles.edit1, 'String');

if strcmp(folderAna,'...')==1
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(12);
    errordlg(msg, 'Error', mode);
    return;
end
if  ~exist(folderAna, 'dir')
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(5);
    errordlg(msg, 'Error', mode);
    return;
end
handles.cancel=0;
guidata(handles.figure1,handles);
if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    uiresume(handles.figure1)
else
    delete(handles.figure1);
end








% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.cancel=1;
guidata(handles.figure1,handles);
h= handles.figure1;
if isequal(get(h, 'waitstatus'), 'waiting')
    uiresume(h)
else
    h= handles.figure1;
    delete(h);
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder =uigetdir(matlabroot,'Select OOSE Directory');
set(handles.edit2, 'String',folder)  
set(handles.pushbutton2, 'enable', 'on'); 


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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
