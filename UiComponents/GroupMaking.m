function varargout = GroupMaking(varargin)
% GROUPMAKING MATLAB code for GroupMaking.fig
%      GROUPMAKING, by itself, creates a new GROUPMAKING or raises the existing
%      singleton*.
%
%      H = GROUPMAKING returns the handle to a new GROUPMAKING or the handle to
%      the existing singleton*.
%
%      GROUPMAKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GROUPMAKING.M with the given input arguments.
%
%      GROUPMAKING('Property','Value',...) creates a new GROUPMAKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GroupMaking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GroupMaking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GroupMaking

% Last Modified by GUIDE v2.5 02-Apr-2015 11:07:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GroupMaking_OpeningFcn, ...
                   'gui_OutputFcn',  @GroupMaking_OutputFcn, ...
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


% --- Executes just before GroupMaking is made visible.
function GroupMaking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GroupMaking (see VARARGIN)

% Choose default command line output for GroupMaking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1);
handles.maxTrack=999;
handles.cNumber=1;

import com.mathworks.mwswing.checkboxtree.*
jRoot = DefaultCheckBoxNode('Groups');
jTree = com.mathworks.mwswing.MJTree(jRoot);
jScrollPane = com.mathworks.mwswing.MJScrollPane(jTree);
javacomponent(jScrollPane,[16,50,419,100],handles.figure1);
handles.scroll = jScrollPane;
handles.root = jRoot;
if ~isempty(varargin), handles.maxTrack=varargin{1}; end
guidata(handles.figure1,handles);
% UIWAIT makes GroupMaking wait for user response (see UIRESUME)
uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = GroupMaking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout={'new'};
delete(handles.figure1);

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


% --- Executes on button press in saveGroup.
function saveGroup_Callback(hObject, eventdata, handles)
% hObject    handle to saveGroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.edit1, handles.edit2.
groupName = get(handles.edit1, 'String');
if isempty(strtrim(groupName)) || strcmp('...',groupName)==1
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(15);
    errordlg(msg, 'Error', mode);
    return;
end
tracks = get(handles.edit2, 'String');
comma=logical(sum(find(tracks == ',')));
line=logical(sum(find(tracks == '-')));
numTracks=[];
if comma==1
   numTracks =getNumbersFromInput(tracks,handles.maxTrack);
elseif line==1
    numTracks=getNumberFromRange(tracks, handles.maxTrack);
else % single number
    num = round(str2num(tracks));
    if ~ isValidNumber(tracks,num, handles.maxTrack), return; end
    numTracks(1)=num;
    
end
 % if we arrive here. 
if ~isempty(numTracks)
    str.id = handles.cNumber;
    handles.cNumber = handles.cNumber+1;
    str.tracks=numTracks;
    str.name = groupName;
    handles.groups{str.id}=str;
    guidata(handles.figure1,handles);
end
setEditsFields('...', '...', handles);
s = size(handles.groups)
array ={}
for i=1:s(2)
    str = handles.groups{i};
    if ~isempty(str)
        array{end+1}=str.name;
    end
end




function  setEditsFields(string1, string2, handles)
set(handles.edit1, 'String', string1); 
set(handles.edit2, 'String', string2);

function numbers =getNumbersFromInput(tracks,maxTrack)
numbers=[];
tokens = tokenizeString(tracks, ',');
   s=size(tokens);
   for i=1:s(2)
       num = round(str2num(tokens{i}));
       if ~ isValidNumber(tokens{i},num, maxTrack), 
           numbers=[]; return; 
       end
       numbers(end+1)=num;
   end
   numbers = sort(numbers);
   
   
function numbers= getNumberFromRange(tracks, maxTrack)
numbers =[];
tokens = tokenizeString(tracks, '-');
s = size(tokens);
if isempty(tokens)  || ~(s(2)==2)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(16);
    errordlg(msg, 'Error', mode);
    return; 
end
num1 = round(str2num(tokens{1}));
num2 = round(str2num(tokens{2}));
if ~(num1<=num2)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = notValidRange(tokens{1}, tokens{2});
    errordlg(msg, 'Error', mode);
    return; 
end
if isValidNumber(tokens{1}, num1, maxTrack) && ...
   isValidNumber(tokens{2}, num2, maxTrack) 
   for i =num1:num2
       numbers(end+1)=i; 
   end
end

function tokens = tokenizeString(str, del)
remain =str;
tokens={};
while (~isempty(remain))
    [token, remain] = strtok(str, del);
    str = remain;
    if ~isempty(token), tokens{end+1}=token;end
end



function b =isValidNumber(sNum, num, maxTrack)
b=1;
if isempty(num) || ~isnumeric(num), b=0;
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = notValidNumberFor(sNum, maxTrack);
    errordlg(msg, 'Error', mode);
    b=0;
   return;
end
if  num<1 || num > maxTrack
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = notValidNumberFor(sNum, maxTrack);
    errordlg(msg, 'Error', mode);
    b=0;
   return;
end





function msg = notValidNumberFor(num, maxNum)
if isempty(num), num =' '; end
msg =[ 'The input: "' num '" is not a valid number.' char(10) ...
       'Please enter integer numbers betwen 1 and ' num2str(maxNum) '.'];
 

function msg = notValidRange(num1, num2)
if isempty(num1), num1 =' '; end
if isempty(num2), num2 =' '; end
msg =[ 'The range from: "' num1 '" to ' num2 ' is not a valid range.' char(10) ...
       'Please enter a sensible range, such as 1-3'];
% --- Executes on button press in doAnalysis.
function doAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to doAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
    delete(h);
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
