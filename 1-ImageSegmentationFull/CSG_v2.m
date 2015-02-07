function varargout = CSG_v2(varargin)
% CSG_v2 MATLAB code for CSG_v2.fig
%      CSG_v2, by itself, creates a new CSG_v2 or raises the existing
%      singleton*.
%
%      H = CSG_v2 returns the handle to a new CSG_v2 or the handle to
%      the existing singleton*.
%
%      CSG_v2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSG_v2.M with the given input arguments.
%
%      CSG_v2('Property','Value',...) creates a new CSG_v2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CSG_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CSG_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CSG_v2

% Last Modified by GUIDE v2.5 09-Sep-2013 16:09:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CSG_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @CSG_v2_OutputFcn, ...
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


% --- Executes just before CSG_v2 is made visible.
function CSG_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CSG_v2 (see VARARGIN)

% Choose default command line output for CSG_v2
% get(handles.pushbutton5,'Interruptible')
% get(handles.pushbutton6,'Interruptible')

%set(handles.pushbutton5,'ButtonDownFcn', @moveleft )
%set(handles.pushbutton6,'ButtonDownFcn', @moveright )
handles.output = hObject;
handles.figure_field_list=[];
handles.view_mode='View Initial';
handles.figure_field_list=fieldnames(handles);
set(gcf,'Resize','on');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CSG_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CSG_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% function moveleft(hObject, handles)
% global stop_qu
% stop_qu=1;
% while stop_qu
%     something.Key(1)='l';
%     SelectDirection(1,something,hObject,handles)
%     pause(1/3)
% end
% 
% function moveright(hObject, handles)
% global stop_qu
% stop_qu=1;
% while stop_qu
%     something.Key(1)='r';
%     SelectDirection(1,something,hObject,handles)
%     pause(1/3)
% end
% 
% function stoppy(varargin)
% global stop_qu
% stop_qu=0;


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.experiment_number=str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);


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
handles.Stack_number=str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);

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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
handles.edit_cell_number=str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
str=get(hObject,'String');
if strcmp(str,'all')
    handles.edit_start='all';
    set(handles.edit5,'String','');
else
handles.edit_start=str2double(get(hObject,'String'));
end
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
handles.edit_end=str2double(get(hObject,'String'));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function loadit(hObject, eventdata, handles)

        
experiment_number = handles.experiment_number;
Stacknumber = handles.Stack_number;
%global Frame_no ActiveFig number_of_frames Stack Frame_curves cmap Cell_numbers Stackno
%Stackno=Stacknumber;
if experiment_number==1
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment1/ImageStacks/ImageStack%02d',Stacknumber))
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment1/ContourData/Segmentation_attempt_5/ImageStack%02dCurveData',Stacknumber))
    handles.Stack=eval(sprintf('ImageStack%02d',Stacknumber));
    clear(sprintf('ImageStack%02d',Stacknumber))
elseif experiment_number==2
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment2/ImageStacks2/ImageStack%03d',Stacknumber))
    %load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment2/ContourData/ImageStack%03dCurveData',Stacknumber))
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment2/ContourData/attempt2/ImageStack%03dCurveData',Stacknumber))
    handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
    clear(sprintf('ImageStack%03d',Stacknumber))
elseif experiment_number==3
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ImageStacks/ImageStack%03d',Stacknumber))
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ContourData/ImageStack%03dCurveData',Stacknumber))
    handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
    clear(sprintf('ImageStack%03d',Stacknumber))
elseif experiment_number==4
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ImageStacks/ImageStack%03d',Stacknumber))
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ContourData/Attempt2/ImageStack%03dCurveData',Stacknumber))
    handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
    clear(sprintf('ImageStack%03d',Stacknumber))
elseif experiment_number==5
    load(sprintf('/Users/samjefferyes/Desktop/Temp_test_data/ImageStack%03d',Stacknumber))
    load(sprintf('/Users/samjefferyes/Desktop/Temp_test_data/ImageStack%03dCurveData',Stacknumber))
    handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
    clear(sprintf('ImageStack%03d',Stacknumber))
elseif experiment_number>5
    load(sprintf('CSG_folder_info/folder_info_exp_%d',experiment_number))
    out_fn=foldername;
    load(sprintf([out_fn{1} 'ImageStack%03d'],Stacknumber))
    load(sprintf([out_fn{2} 'ImageStack%03dCurveData'],Stacknumber))
    handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
    clear(sprintf('ImageStack%03d',Stacknumber))
end
handles.Frame_curves=Frame_curves;
handles.Cell_numbers=Cell_numbers;
handles.number_of_frames=size(handles.Stack,3);
handles.number_of_cells=max(cell2mat(handles.Cell_numbers));

handles.cmap=jet(handles.number_of_cells);
handles.cmap=handles.cmap(randperm(handles.number_of_cells),:);
warning off

%Initialise
v=1:handles.number_of_cells;
handles.cell_in=mat2cell(v',ones(1,handles.number_of_cells));
%handles.contour_on_off=true(handles.number_of_cells,1);
handles.contour_exceptions=cell(handles.number_of_cells,1);
handles.contour_present_in=cell(handles.number_of_cells,1);
handles.contour_mergers=cell(handles.number_of_cells,1);
for t=1:handles.number_of_cells
    handles.contour_exceptions{t}=[];
    handles.contour_present{t}=[];
    handles.contour_mergers{t}=t;
end


for t=1:handles.number_of_cells
    for k=1:length(handles.Frame_curves)
        if ismember(t,handles.Cell_numbers{k})
            handles.contour_present_in{t}=[handles.contour_present_in{t} k];
        end
    end
end

for j=1:length(handles.Frame_curves)
    for k=1:length(handles.Frame_curves{j})
        handles.Merge_points{j}{k}=[];
    end
end

UpdateManualIn(hObject, handles)
handles=guidata(hObject);
%ActiveFig=handles.axes1;
handles.merge_toggle=0;
handles.temp_merge_code=[];
handles.Frame_no=1;
imshow(handles.Stack(:,:,handles.Frame_no),[])
hold on
for j=1:length(handles.Frame_curves{handles.Frame_no})
    h2=plot(handles.Frame_curves{handles.Frame_no}{j}(:,2),handles.Frame_curves{handles.Frame_no}{j}(:,1),'Color',handles.cmap(handles.Cell_numbers{handles.Frame_no}(j),:));
    set(h2,'LineWidth',1)
end
titletext=sprintf('\\fontsize{16}Stack Number: %d Frame: %d. Cell numbers: ',Stacknumber,handles.Frame_no);
for j=1:length(handles.Frame_curves{handles.Frame_no})
    if j==1
        titletext=[titletext '{'];
    end
    titletext=[titletext '\color[rgb]{' num2str(handles.cmap(handles.Cell_numbers{handles.Frame_no}(j),:)) '}' num2str(handles.Cell_numbers{handles.Frame_no}(j)) ' '];
    if j==length(handles.Frame_curves{handles.Frame_no})
        titletext=[titletext '}'];
    end
end
t=title(titletext);
set(t,'FontWeight','bold')
%pause(1/10)
%hold off
handles.view_mode='View Initial';
set(handles.popupmenu3,'Value',1);
%set(handles.output,'ButtonDownFcn', @ImageClickCallback) 
set(gcf, 'WindowButtonDownFcn', {@getMousePositionOnImage,hObject},'Interruptible','on');  
set(gcf,'KeyPressFcn', @SelectDirectionClicked,'Interruptible','off')
%set(src, 'Pointer', 'crosshair'); % Optional
pan off % Panning will interfere with this code 
guidata(hObject, handles);
%set(ActiveFig,'KeyPressFcn', @SelectDirection)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Cell_code=handles.cell_in;
Cell_num=handles.edit_cell_number;

L=length(Cell_code);

present=0;
previousplace=0;
for i=1:L
    if isa(Cell_code{i},'double')
        if Cellcode{i}(1)<Cell_num
            previousplace=i;
        end
        if ismember(Cell_num,Cellcode{i})
            present=1;
            if ischar(Cellcode{min(i+1,L)})
                remain = Cellcode{i+1};
                while true
                    [str, remain] = strtok(remain, '_');
                    if isempty(str),  break;  end
                    [cellnum,removeframes] = strtok(str, '[');
                    if str2num(cellnum)==cell_num
                        removeframe=num2str(setdiff(str2num(removeframe),A:B));
                    end
                end
            end
        end
    end
end
if present == 0
    'blah'
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
handles.man_in=get(hObject,'String');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
code=handles.temp_merge_code;

U=unique(cell2mat(handles.contour_mergers(code)'));
for i=U(:)'
    handles.contour_mergers{i}=i;
end
for i=code
    handles.contour_mergers{i}=code;
end
UpdateManualIn(hObject, handles)
%guidata(hObject,handles)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global stop_qu
% stop_qu=1;
% while stop_qu
     something.Key(1)='l';
     SelectDirection(1,something,hObject,handles)
%     pause(1/3)
% end
%stoppy

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
str=get(hObject,'String');
if isempty(str)
    handles.temp_merge_code=[];
elseif isa(str,'cell')
    handles.temp_merge_code=str2num(str{1});
else
    handles.temp_merge_code=str2num(str);
end
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
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

%function []=updatefig(i)

    
function SelectDirection(~,b,hObject,handles)


%global Frame_no ActiveFig number_of_frames Stack Frame_curves cmap Cell_numbers Stackno

if strcmp(b.Key(1),'r')||strcmp(b.Key(1),'d')
    handles.Frame_no=handles.Frame_no+1;
elseif strcmp(b.Key(1),'l')||strcmp(b.Key(1),'u')
    handles.Frame_no=handles.Frame_no-1;
end
if handles.Frame_no<1
    handles.Frame_no=1;
elseif handles.Frame_no>handles.number_of_frames
    handles.Frame_no=handles.number_of_frames;
end

    %figure(ActiveFig)
    hold off
    imshow(handles.Stack(:,:,handles.Frame_no),[])
    hold on
    switch handles.view_mode;
        case 'View Initial'
            for j=1:length(handles.Frame_curves{handles.Frame_no})
                h2=plot(handles.axes1, handles.Frame_curves{handles.Frame_no}{j}(:,2),handles.Frame_curves{handles.Frame_no}{j}(:,1),'Color',handles.cmap(handles.Cell_numbers{handles.Frame_no}(j),:));
                %if ~handles.contour_on_off(handles.Cell_numbers{handles.Frame_no}(j)) || ismember(handles.Frame_no,handles.contour_exceptions{handles.Cell_numbers{handles.Frame_no}(j)})
                if ismember(handles.Frame_no,handles.contour_exceptions{handles.Cell_numbers{handles.Frame_no}(j)})
                    set(h2,'LineStyle','--')
                else
                    set(h2,'LineWidth',1)
                end
                if ~isempty(handles.Merge_points{handles.Frame_no}{j})
                    plot(handles.axes1, handles.Merge_points{handles.Frame_no}{j}(1,1),handles.Merge_points{handles.Frame_no}{j}(1,2),'ko','MarkerFaceColor','r');
                end
            end
            titletext=sprintf('\\fontsize{16}Stack Number: %d Frame: %d. Cell numbers: ',handles.Stack_number,handles.Frame_no);
            for j=1:length(handles.Frame_curves{handles.Frame_no})
                if j==1
                    titletext=[titletext '{'];
                end
                titletext=[titletext '\color[rgb]{' num2str(handles.cmap(handles.Cell_numbers{handles.Frame_no}(j),:)) '}' num2str(handles.Cell_numbers{handles.Frame_no}(j)) ' '];
                if j==length(handles.Frame_curves{handles.Frame_no})
                    titletext=[titletext '}'];
                end
            end
        case 'View Output'
            for j=1:length(handles.out_Frame_curves{handles.Frame_no})
                h2=plot(handles.axes1, handles.out_Frame_curves{handles.Frame_no}{j}(:,2),handles.out_Frame_curves{handles.Frame_no}{j}(:,1),'Color',handles.out_cmap(handles.out_Cell_numbers{handles.Frame_no}(j),:));
            end
            titletext=sprintf('\\fontsize{16}Stack Number: %d Frame: %d. Cell numbers: ',handles.Stack_number,handles.Frame_no);
            for j=1:length(handles.out_Frame_curves{handles.Frame_no})
                if j==1
                    titletext=[titletext '{'];
                end
                titletext=[titletext '\color[rgb]{' num2str(handles.out_cmap(handles.out_Cell_numbers{handles.Frame_no}(j),:)) '}' num2str(handles.out_Cell_numbers{handles.Frame_no}(j)) ' '];
                if j==length(handles.out_Frame_curves{handles.Frame_no})
                    titletext=[titletext '}'];
                end
            end
            
    end
    t=title(titletext);
    set(t,'FontWeight','bold')
    UpdateManualIn(hObject, handles)
    %guidata(hObject,handles)
    %pause(1/10)
    %hold off
    %lh = addlistener(dir,PostSet,'EventName',@updatefig(i,dir))
    
function SelectDirectionClicked(a,b)

hObject=a;
handles=guidata(hObject);
%global Frame_no ActiveFig number_of_frames Stack Frame_curves cmap Cell_numbers Stackno

if strcmp(b.Key(1),'r')||strcmp(b.Key(1),'d')
    handles.Frame_no=handles.Frame_no+1;
elseif strcmp(b.Key(1),'l')||strcmp(b.Key(1),'u')
    handles.Frame_no=handles.Frame_no-1;
end
if handles.Frame_no<1
    handles.Frame_no=1;
elseif handles.Frame_no>handles.number_of_frames
    handles.Frame_no=handles.number_of_frames;
end

    %figure(ActiveFig)
    hold off
    imshow(handles.Stack(:,:,handles.Frame_no),[])
    hold on
    switch handles.view_mode;
        case 'View Initial'
            for j=1:length(handles.Frame_curves{handles.Frame_no})
                h2=plot(handles.axes1, handles.Frame_curves{handles.Frame_no}{j}(:,2),handles.Frame_curves{handles.Frame_no}{j}(:,1),'Color',handles.cmap(handles.Cell_numbers{handles.Frame_no}(j),:));
                %if ~handles.contour_on_off(handles.Cell_numbers{handles.Frame_no}(j)) || ismember(handles.Frame_no,handles.contour_exceptions{handles.Cell_numbers{handles.Frame_no}(j)})
                if ismember(handles.Frame_no,handles.contour_exceptions{handles.Cell_numbers{handles.Frame_no}(j)})
                    set(h2,'LineStyle','--')
                else
                    set(h2,'LineWidth',1)
                end
                if ~isempty(handles.Merge_points{handles.Frame_no}{j})
                    plot(handles.axes1, handles.Merge_points{handles.Frame_no}{j}(1,1),handles.Merge_points{handles.Frame_no}{j}(1,2),'ko','MarkerFaceColor','r');
                end
            end
            titletext=sprintf('\\fontsize{16}Stack Number: %d Frame: %d. Cell numbers: ',handles.Stack_number,handles.Frame_no);
            for j=1:length(handles.Frame_curves{handles.Frame_no})
                if j==1
                    titletext=[titletext '{'];
                end
                titletext=[titletext '\color[rgb]{' num2str(handles.cmap(handles.Cell_numbers{handles.Frame_no}(j),:)) '}' num2str(handles.Cell_numbers{handles.Frame_no}(j)) ' '];
                if j==length(handles.Frame_curves{handles.Frame_no})
                    titletext=[titletext '}'];
                end
            end
        case 'View Output'
            for j=1:length(handles.out_Frame_curves{handles.Frame_no})
                h2=plot(handles.axes1, handles.out_Frame_curves{handles.Frame_no}{j}(:,2),handles.out_Frame_curves{handles.Frame_no}{j}(:,1),'Color',handles.out_cmap(handles.out_Cell_numbers{handles.Frame_no}(j),:));
            end
            titletext=sprintf('\\fontsize{16}Stack Number: %d Frame: %d. Cell numbers: ',handles.Stack_number,handles.Frame_no);
            for j=1:length(handles.out_Frame_curves{handles.Frame_no})
                if j==1
                    titletext=[titletext '{'];
                end
                titletext=[titletext '\color[rgb]{' num2str(handles.out_cmap(handles.out_Cell_numbers{handles.Frame_no}(j),:)) '}' num2str(handles.out_Cell_numbers{handles.Frame_no}(j)) ' '];
                if j==length(handles.out_Frame_curves{handles.Frame_no})
                    titletext=[titletext '}'];
                end
            end
            
    end
    t=title(titletext);
    set(t,'FontWeight','bold')
    %UpdateManualIn(hObject, handles)
    guidata(hObject,handles)
    %pause(1/10)
    %hold off
    %lh = addlistener(dir,PostSet,'EventName',@updatefig(i,dir))


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global stop_qu
% stop_qu=1;
% while stop_qu
     something.Key(1)='r';
     SelectDirection(1,something,hObject,handles)
%     pause(1/3)
% end
%stoppy

% function ImageClickCallback( hObject , eventData, handles )
% axesHandle  = get(hObject,'Parent');
%    coordinates = get(axesHandle,'CurrentPoint');
%    coordinates(1,1:2)
   
function getMousePositionOnImage(src, event,hObject)

handles = guidata(src);

cursorPoint = get(handles.axes1, 'CurrentPoint');
selType = get(gcf,'SelectionType');
curX = cursorPoint(1,1);
curY = cursorPoint(1,2);

xLimits = get(handles.axes1, 'xlim');
yLimits = get(handles.axes1, 'ylim');
l_xLimits = get(handles.pushbutton5, 'xlim');
l_yLimits = get(handles.pushbutton5, 'ylim');
r_xLimits = get(handles.pushbutton6, 'xlim');
r_yLimits = get(handles.pushbutton6, 'ylim');

if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
    %disp(['Cursor coordinates are (' num2str(curX) ', ' num2str(curY) ').']);
    incell=false;
    for j=1:length(handles.Frame_curves{handles.Frame_no})
        if inpolygon(curX,curY,handles.Frame_curves{handles.Frame_no}{j}(:,2),handles.Frame_curves{handles.Frame_no}{j}(:,1))
            %disp(['Cursor coordinates in Cell ' num2str(handles.Cell_numbers{handles.Frame_no}(j))  '.']);
            if get(handles.radiobutton2,'Value')
                QueryCell(handles.Frame_no,handles.Cell_numbers{handles.Frame_no}(j),selType,handles,hObject)
            elseif get(handles.radiobutton3,'Value')
                MergePoint(curX,curY,handles.Frame_no,handles.Cell_numbers{handles.Frame_no}(j),selType,handles,hObject)
            elseif get(handles.radiobutton1,'Value')
                MergeToggle(handles.Frame_no,handles.Cell_numbers{handles.Frame_no}(j),selType,handles,hObject)
            else
                CellToggle(handles.Frame_no,handles.Cell_numbers{handles.Frame_no}(j),selType,handles,hObject)
            end
            %handles=guidata(hObject);
            incell=true;
            %disp(['Cursor coordinates in Cell ' num2str(handles.Cell_numbers{handles.Frame_no}(j))  ', which now has exceptions [' handles.contour_exceptions{handles.Cell_numbers{handles.Frame_no}(j)} '].']);
            break
        end
    end
    if ~incell && ~get(handles.radiobutton3,'Value')
        for j=1:length(handles.Frame_curves{handles.Frame_no})
            star=inpolygon(repmat(curX+(-10:10),41,1) ,repmat(curY+(-10:10)',1,41),handles.Frame_curves{handles.Frame_no}{j}(:,2),handles.Frame_curves{handles.Frame_no}{j}(:,1));
            if sum(star(:))
                %disp(['Cursor coordinates in Cell ' num2str(handles.Cell_numbers{handles.Frame_no}(j))  '.']);
                if get(handles.radiobutton2,'Value')
                    QueryCell(handles.Frame_no,handles.Cell_numbers{handles.Frame_no}(j),selType,handles,hObject)
                elseif get(handles.radiobutton1,'Value')
                    MergeToggle(handles.Frame_no,handles.Cell_numbers{handles.Frame_no}(j),selType,handles,hObject)
                else
                    CellToggle(handles.Frame_no,handles.Cell_numbers{handles.Frame_no}(j),selType,handles,hObject)
                end
                %handles=guidata(hObject);
                incell=true;
                %disp(['Cursor coordinates in Cell ' num2str(handles.Cell_numbers{handles.Frame_no}(j))  ', which now has exceptions [' handles.contour_exceptions{handles.Cell_numbers{handles.Frame_no}(j)} '].']);
                break
            end
        end
    end
    if ~incell
        set(handles.text7, 'String','Cursor is outside of cell')
    end
% elseif (curX > min(l_xLimits) && curX < max(l_xLimits) && curY > min(l_yLimits) && curY < max(l_yLimits))
%     moveleft(hObject,handles)
% elseif (curX > min(r_xLimits) && curX < max(r_xLimits) && curY > min(r_yLimits) && curY < max(r_yLimits))
%     moveright(hObject,handles)
else
    set(handles.text7, 'String','Cursor is outside bounds of image.');
end

% for s=1:length(handles.Frame_curves{handles.Frame_no})
%     
% end
%         


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d=isfield(handles,'experiment_number');
if d
    choice = questdlg('Would you like to save your current progress?', 'Save First?','Yes, Save', 'No, Continue to load','Cancel','Yes, Save');
else
    choice='No, Continue to load';
end
% Handle response
switch choice
    case 'Yes, Save'
        savestuff(hObject, eventdata, handles)
        cont = 1;
    case 'No, Continue to load'
        cont = 1;
    case 'Cancel'
        cont = 0;
end

if cont
    %wipe any existing analyis        
%         fieldlist=fieldnames(handles);
%         I=ismember(fieldlist,'output');
%         I2=cumsum(I);
%         I2(logical(I))=0;
%         I2=logical(I2);
%         handles=rmfield(handles,fieldlist(I2));
        fieldlist=fieldnames(handles);
        I=ismember(fieldlist,handles.figure_field_list);
        handles=rmfield(handles,fieldlist(~I));
        guidata(hObject,handles)
    prompt = {'Experiment number','Stack number'};
    dlg_title = 'Load Stack';
    num_lines = 1;
    def = {'',''};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if length(answer)==2
        set(gcf,'Pointer','watch'); drawnow
        handles.experiment_number=str2double(answer{1});
        handles.Stack_number=str2double(answer{2});
        loadit(hObject, eventdata, handles)
        set(gcf,'Pointer','arrow')
    end
end

function CellToggle(Frame_no,Cell_no,clicktype,handles,hObject)
%before_on_off=handles.contour_on_off(Cell_no);
contour_exceps=handles.contour_exceptions{Cell_no};
switch lower(clicktype)
    case 'normal'
        if ismember(Frame_no,contour_exceps)
            %handles.contour_on_off(Cell_no)=true;
            handles.contour_exceptions{Cell_no}=setdiff(contour_exceps,Frame_no);
        else
            handles.contour_exceptions{Cell_no}=union(Frame_no,contour_exceps);
        end
    case 'extend'
        if ismember(Frame_no,contour_exceps)
            %handles.contour_on_off(Cell_no)=true;
            handles.contour_exceptions{Cell_no}=[];
        else
            handles.contour_exceptions{Cell_no}=handles.contour_present_in{Cell_no};
        end
    case 'alt'
        if ismember(Frame_no,contour_exceps)
            %handles.contour_on_off(Cell_no)=true;
            handles.contour_exceptions{Cell_no}=setdiff(contour_exceps,Frame_no:handles.contour_present_in{Cell_no}(end));
        else
            handles.contour_exceptions{Cell_no}=union(Frame_no:handles.contour_present_in{Cell_no}(end),contour_exceps);
        end
    case 'open'
        %disp('Double-click any mouse button')
    otherwise
       set(handles.text7, 'String',selType)
end %switch


somethingelse.Key='n';
set(handles.text7, 'String',['Cursor coordinates in Cell ' num2str(Cell_no)  ', which now has exceptions [' longvec2str(handles.contour_exceptions{Cell_no}) '].']);
SelectDirection(1,somethingelse,hObject,handles)
%guidata(hObject,handles)

function UpdateManualIn(hObject, handles)
cell_list=1:handles.number_of_cells;
manual_input='';
j=1;
while ~isempty(cell_list)
    cell_in_question=cell_list(1);
    relevant_frames=handles.contour_present_in{cell_in_question};
    exception_frames=handles.contour_exceptions{cell_in_question};
    contours_merge_group=handles.contour_mergers{cell_in_question};
    if ~isempty(setdiff(relevant_frames,exception_frames))
        if length(contours_merge_group)==1
            manual_input=[manual_input num2str(cell_in_question) ','];
        else
            manual_input=[manual_input '[' longvec2str(contours_merge_group) '],'];
        end 
        if ~isempty(cell2mat(handles.contour_exceptions(contours_merge_group)'))
            manual_input=[manual_input ' '''];
            for cont=contours_merge_group
                if ~isempty(handles.contour_exceptions{cont})
                    manual_input=[manual_input num2str(cont) '[' longvec2str(handles.contour_exceptions{cont}) ']_' ];
                end
            end
            manual_input=[manual_input ''' ,'];
        end
    end
    cell_list(ismember(cell_list,contours_merge_group))=[];
    j=j+1;
end

if ~isempty(manual_input)
    if strcmp(manual_input(end),',')
        manual_input(end)='';
    end
end
handles.man_in=manual_input;
%guidata(hObject, handles);
set(handles.edit7,'String',handles.man_in);
guidata(hObject, handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
set(handles.radiobutton2,'Value',0)
set(handles.radiobutton3,'Value',0)
handles.merge_toggle=get(hObject,'Value');
guidata(hObject,handles)

function MergeToggle(Frame_no,Cell_no,clicktype,handles,hObject)

% strcell=get(handles.edit6,'String');
% str=strcell{1};
% mergeset=str2num(str);
mergeset=handles.temp_merge_code;
clickedmergeset=handles.contour_mergers{Cell_no};
switch lower(clicktype)
    case 'extend'
        newmergeset=setdiff(mergeset,Cell_no);
    otherwise
        newmergeset=union(clickedmergeset,mergeset);
end
handles.temp_merge_code=newmergeset;
set(handles.edit6,'String',longvec2str(newmergeset));
switch lower(clicktype)
    case 'extend'
        set(handles.text7, 'String',['You have removed Cell ' num2str(Cell_no) ' from your prospective merge list, which is now [' longvec2str(handles.temp_merge_code) ']. To finalise this selection click "Merge".' ]);
    otherwise
        if length(handles.contour_mergers{Cell_no})>1
            set(handles.text7, 'String',['Cell ' num2str(Cell_no) ' is currently merged with [' longvec2str(handles.contour_mergers{Cell_no}) ']. You have added these cells to your prospective merge list: [' longvec2str(handles.temp_merge_code) ']. To finalise this selection click "Merge".' ]);
        else
            set(handles.text7, 'String',['Cell ' num2str(Cell_no) ' is currently merged with nothing else. You have added this cell to your prospective merge list: [' longvec2str(handles.temp_merge_code) ']. To finalise this selection click "Merge".' ]);
        end
end
guidata(hObject,handles)

function str=longvec2str(V)
j=1;
str='';
while length(V)>=j
    str=[str int2str(V(j))];
    i=j;
    if i<length(V)
        while V(i+1)==V(i)+1
            i=i+1;
            if i==length(V)
                break
            end 
        end
    end
    if i==j+1
        str=[str ',' int2str(V(i))];
    elseif i>j
        str=[str ':' int2str(V(i))];
    end
    str=[str ','];
    j=i+1;
end
str=str(1:(end-1));


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savestuff(hObject, eventdata, handles)
% exp_no=handles.experiment_number;
% stack_no=handles.Stack_number;
% input=handles.man_in;
% disp(input)
% [~,~,save_fldr]=eval(['CellContour_CellArray_generator_v2( exp_no,stack_no,' input ')']);
% save(sprintf([ save_fldr 'handledata_exp%d_Stack%d'],experiment_no,stack_no),'handles')


function [ CellArray, CellFrameData, savefoldername ] = CellContour_CellArray_generator_v2(hObject,handles, experiment_number,Stacknumber, varargin )
%experiment_number is the experiment number
%Stack_number is the image stack number to be used
%This code should be used after viewing the segmentation using
%ViewStackSeg_v5.m, and deciding which contours should be extracted for
%further analysis.
%
%input a single number to extract all contours labelled with that number
%
%input a vector of numbers to extract the contours labelled with those
%numbers, merging their data to represent one cell. N.B. if two of the
%numbers appear in the same frame, the contours will be merged using the
%ContourMarge functions (useful if a cell tail has been disconnected from the body of a cell)
%
%input a string to exclude contours within certain frames from being
%extracted. The format should be cellnumber followed by a vector containg
%the frame numbers to be excluded, please use an underscore '_' to delimit
%between successive contour labels and their bad frame lists.
%
%
%Example inputs
% 1/  CellContour_CellArray_generator_v2(1,5,[6 8], '6[43]_8[65:105]');
% 2/  CellContour_CellArray_generator_v2(1,6,[1 3], '1[97]',2);
%
%Run ViewStackSeg_v5(1,5) or ViewStackSeg_v5(1,6) to see if you agree with
%these decisions


if experiment_number==1
    foldername='/Volumes/annelab/sam/Microscope_data/experiment1/CellContourOutput/';
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment1/ContourData/Segmentation_attempt_5/ImageStack%02dCurveData',Stacknumber))
elseif experiment_number==2
    foldername='/Volumes/annelab/sam/Microscope_data/experiment2/CellContourOutput/';
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment2/ContourData/attempt2/ImageStack%03dCurveData',Stacknumber))
elseif experiment_number==3
    foldername='/Volumes/annelab/sam/Microscope_data/experiment3/CellContourOutput/';
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ContourData/ImageStack%03dCurveData',Stacknumber))
elseif experiment_number==4
    foldername='/Volumes/annelab/sam/Microscope_data/experiment3/CellContourOutput/Attempt2/';
    load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ContourData/Attempt2/ImageStack%03dCurveData',Stacknumber))
elseif experiment_number==5
    foldername='/Users/samjefferyes/Desktop/Temp_test_data/';
    load(sprintf('/Users/samjefferyes/Desktop/Temp_test_data/ImageStack%03dCurveData',Stacknumber))
elseif experiment_number>5
    load(sprintf('CSG_folder_info/folder_info_exp_%d',experiment_number))
    out_fn=foldername;
    foldername=out_fn{3};
    load(sprintf([out_fn{2} 'ImageStack%03dCurveData'],Stacknumber))
end




N=length(Frame_curves);
CellArray={};
CellFrameData=struct;

viable_cell_numbers=varargin;
K=length(viable_cell_numbers);
numstrings=0;
for i=1:K
    cell_number=viable_cell_numbers{i};
    if ~ischar(cell_number)
        badcellframes=cell(max(cell_number),1);
        if i<K
            if ischar(viable_cell_numbers{i+1})
                remain = viable_cell_numbers{i+1};
                while true
                    [str, remain] = strtok(remain, '_');
                    if isempty(str),  break;  end
                    [cellnum,removeframes] = strtok(str, '[');
                    eval(['badcellframes{' cellnum '}=' removeframes ';']);
                end
            end
        end
        i2=i-numstrings;
        CellFrameData(i2).Stack_number=Stacknumber;
        CellFrameData(i2).Cell_number=cell_number;
        CellFrameData(i2).Contours={};
        CellFrameData(i2).BadFrames=badcellframes;
        for j=1:N %j is frame number
            cell_numbers_in_frame=intersect(cell_number,Cell_numbers{j});
            for m=cell_numbers_in_frame;
                if ismember(j,badcellframes{m})
                    cell_numbers_in_frame(cell_numbers_in_frame==m)=[];
                end
            end
            if ~isempty(cell_numbers_in_frame)
                if length(cell_numbers_in_frame)>1
                    frame_curve=ContourMerge(j,Frame_curves,Cell_numbers,cell_numbers_in_frame,handles);
                    CellArray{end+1}=frame_curve;
                    CellFrameData(i2).Contours{end+1}=frame_curve;
                else
                    n=cell_numbers_in_frame;
                    frame_curve=Frame_curves{j}{Cell_numbers{j}==n};
                    CellArray{end+1}=frame_curve;
                    CellFrameData(i2).Contours{end+1}=frame_curve;
                end
            end
        end
    else
        numstrings=numstrings+1;
    end
    
    
end

CreateOutputImages(Cell_numbers,CellFrameData,hObject,handles);

save(sprintf([foldername 'CellArray%03d'],Stacknumber),'CellArray')
save(sprintf([foldername 'CellFrameData%03d'],Stacknumber),'CellFrameData')
savefoldername=foldername;



function [ borderpixels ] = ContourMerge( framenumber,Frame_curves,Cell_numbers, cell_number_list,handles )
%CONTOURMERGE Summary of this function goes here
%   Detailed explanation goes here
L=length(cell_number_list);
bw=zeros(1024,1024,L);
%bw1=zeros(1024,1024,L);
tail=0;
for i=1:L
    n= Cell_numbers{framenumber}==cell_number_list(i);
    if ~isempty(handles.Merge_points{framenumber}{n})
        bw_temp=zeros(1024,1024);
        bw_temp(round(handles.Merge_points{framenumber}{n}(1)),round(handles.Merge_points{framenumber}{n}(2)))=1;
        bw_temp=imdilate(bw_temp,strel('disk',6,0));
        bw_temp=logical(bw_temp);
        bw(:,:,i)=bw_temp&roipoly(ones(1024,1024),Frame_curves{framenumber}{n}(:,1),Frame_curves{framenumber}{n}(:,2));
        tail=1;
    else
        bw(:,:,i)=roipoly(ones(1024,1024),Frame_curves{framenumber}{n}(:,1),Frame_curves{framenumber}{n}(:,2));
    end
end
if tail
    BW_all=zeros(1024,1024,L);
    for i=1:L
        n= Cell_numbers{framenumber}==cell_number_list(i);
        BW_all(:,:,i)=roipoly(ones(1024,1024),Frame_curves{framenumber}{n}(:,1),Frame_curves{framenumber}{n}(:,2));
    end
    BW_all=sum(BW_all,3);
end

while size(bw,3)>1
    [~,mFrame]=min(sum(sum(bw)));
    bw_mFrame=bw(:,:,mFrame);
    bw_rest=bw;
    bw_rest(:,:,mFrame)=[];
    bw_rest=sum(bw_rest,3);
    
    intersect=0;
    %eps=0;
    H_mFrame=bw_mFrame;
    while intersect==0;
        %eps=eps+1;
        H_mFrame=imdilate(H_mFrame,strel('disk',1,0));
        nearest_point=H_mFrame&bw_rest;
        intersect=logical(sum(nearest_point(:)));
    end
    
    intersect2=0;
    %eps2=0;
    H_mFrame2=nearest_point;
    while intersect2==0;
        %eps2=eps2+1;
        %H_mFrame2=imdilate(nearest_point,strel('disk',eps2,0));
        H_mFrame2=imdilate(H_mFrame2,strel('disk',1,0));
        nearest_point2=H_mFrame2&bw_mFrame;
        intersect2=logical(sum(nearest_point2(:)));
    end
    
    A=imdilate(nearest_point,strel('disk',3,0))&bw_rest;
    B=imdilate(nearest_point2,strel('disk',3,0))&bw_mFrame;
    piece=bwconvhull(A|B);
    
    
    BW=piece|bw_rest|bw_mFrame;
    BWlabelled=bwlabel(BW);
    %To improve this algorithm add a while loop corresponding to the number of
    %connected components in BW
    clear('bw')
    for i=1:max(BWlabelled(:))
        bw(:,:,i)=BWlabelled==i;
    end
end
%The should be only 1 connected by this stage
if tail
    BW=BW|BW_all;
end
B=bwboundaries(BW,'noholes');

borderpixels=B{1}(:,[2 1]);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'Folder containing image stacks','Folder containing contour data','Destination folder for Contour output'};
dlg_title = 'New Experiment info';
num_lines = 1;
def = {[pwd '/experiment#!/ImageStacks/'],[pwd '/experiment#!/ContourData/'],[pwd '/experiment#!/CellContourOutput/']};
answer = inputdlg(prompt,dlg_title,num_lines,def);

currentfoldername=cd;
folder=[currentfoldername '/CSG_folder_info'];
t=dir('CSG_folder_info/*folder_info_exp_*.mat');
v=zeros(size(t));
for i=1:size(t,1)
    v(i)=str2num(t(i).name(17:(end-4)));
end
M=max(v);
if length(answer)==3
    foldername=answer;
end
for i=1:3
   if ~strcmp(foldername{i}(end),'/')
       foldername{i}(end+1)='/';
   end
end
save(sprintf([folder '/folder_info_exp_%d.mat'],M+1),'foldername')
helpdlg(sprintf('Your new experiment is saved as experiment number: %d',M+1))


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Construct a questdlg with three options
%set(gcf,'Pointer','hand')
d=isfield(handles,'experiment_number');
if d
    choice = questdlg('Would you like to save your current progress?', 'Save First?','Yes, Save', 'No, Continue to load','Cancel','Yes, Save');
else
    choice='No, Continue to load';
    set(gcf, 'WindowButtonDownFcn', {@getMousePositionOnImage,hObject});
    set(gcf,'KeyPressFcn', @SelectDirectionClicked,'Interruptible','off')
    %set(src, 'Pointer', 'crosshair'); % Optional
    pan off % Panning will interfere with this code
end
% Handle response
switch choice
    case 'Yes, Save'
        savestuff(hObject, eventdata, handles)
        cont = 1;
    case 'No, Continue to load'
        cont = 1;
    case 'Cancel'
        cont = 0;
end
if cont
    %Open Saved Analysis
    prompt = {'Experiment number','Stack number'};
    dlg_title = 'Load Saved Analysis';
    num_lines = 1;
    def = {'',''};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if length(answer)==2
        set(gcf,'Pointer','watch'); drawnow
        experiment_number=str2num(answer{1});
        if experiment_number==1
            foldername='/Volumes/annelab/sam/Microscope_data/experiment1/CellContourOutput/';
        elseif experiment_number==2
            foldername='/Volumes/annelab/sam/Microscope_data/experiment2/CellContourOutput/';
        elseif experiment_number==3
            foldername='/Volumes/annelab/sam/Microscope_data/experiment3/CellContourOutput/';
        elseif experiment_number==4
            foldername='/Volumes/annelab/sam/Microscope_data/experiment3/CellContourOutput/Attempt2/';
        elseif experiment_number==5
            foldername='/Users/samjefferyes/Desktop/Temp_test_data/';
        elseif experiment_number>5
            load(sprintf('CSG_folder_info/folder_info_exp_%d',experiment_number))
            out_fn=foldername;
            foldername=out_fn{3};
        end
        
        fieldlist=fieldnames(handles);
        I=ismember(fieldlist,handles.figure_field_list);
        old_handles=rmfield(handles,fieldlist(~I));
        keptfields=fieldlist(I);
        clear('handles')
        guidata(hObject,old_handles)
        load([ foldername 'handledata_exp' answer{1} '_Stack' num2str(str2num(answer{2})) ])
        for i=1:length(keptfields)
           handles.(keptfields{i}) = old_handles.(keptfields{i}); 
        end
        Stacknumber=str2double(answer{2});
        if ~isfield(handles,'Stack')
            if experiment_number==1
                load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment1/ImageStacks/ImageStack%02d',Stacknumber))
                handles.Stack=eval(sprintf('ImageStack%02d',Stacknumber));
                clear(sprintf('ImageStack%02d',Stacknumber))
            elseif experiment_number==2
                load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment2/ImageStacks2/ImageStack%03d',Stacknumber))
                handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
                clear(sprintf('ImageStack%03d',Stacknumber))
            elseif experiment_number==3
                load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ImageStacks/ImageStack%03d',Stacknumber))
                handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
                clear(sprintf('ImageStack%03d',Stacknumber))
            elseif experiment_number==4
                load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ImageStacks/ImageStack%03d',Stacknumber))
                handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
                clear(sprintf('ImageStack%03d',Stacknumber))
            elseif experiment_number==5
                load(sprintf('/Users/samjefferyes/Desktop/Temp_test_data/ImageStack%03d',Stacknumber))
                handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
                clear(sprintf('ImageStack%03d',Stacknumber))
            elseif experiment_number>5
                load(sprintf('CSG_folder_info/folder_info_exp_%d',experiment_number))
                out_fn=foldername;
                load(sprintf([out_fn{1} 'ImageStack%03d'],Stacknumber))
                handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
                clear(sprintf('ImageStack%03d',Stacknumber))
            end
        end
        if ~isfield(handles,'Merge_points')
            for j=1:length(handles.Frame_curves)
                for k=1:length(handles.Frame_curves{j})
                    handles.Merge_points{j}{k}=[];
                end
            end
        end
        somethingelse.Key='n';
        SelectDirection(1,somethingelse,hObject,handles)
        set(gcf,'Pointer','arrow')
    end
    
end
%set(gcf,'Pointer','arrow')


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d=isfield(handles,'experiment_number');
if d
    choice = questdlg('Would you like to save your current progress?', 'Save First?','Yes, Save', 'No, Continue to load','Cancel','Yes, Save');
else
    choice='No, Continue to load';
    %     set(gcf, 'WindowButtonDownFcn', {@getMousePositionOnImage,hObject});
    %     set(gcf,'KeyPressFcn', @SelectDirectionClicked,'Interruptible','off')
    %     set(src, 'Pointer', 'crosshair'); % Optional
    %     pan off % Panning will interfere with this code
end
% Handle response
switch choice
    case 'Yes, Save'
        savestuff(hObject, eventdata, handles)
        cont = 1;
    case 'No, Continue to load'
        cont = 1;
    case 'Cancel'
        cont = 0;
end

if cont
    %wipe any existing analyis        
        fieldlist=fieldnames(handles);
        I=ismember(fieldlist,handles.figure_field_list);
        handles=rmfield(handles,fieldlist(~I));
        guidata(hObject,handles)
    %Open Saved Analysis
    prompt = {'Experiment number','Stack number'};
    dlg_title = 'Load Saved Analysis';
    num_lines = 1;
    def = {'',''};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    if length(answer)==2
        set(gcf,'Pointer','watch'); drawnow
        handles.experiment_number=str2double(answer{1});
        handles.Stack_number=str2double(answer{2});
        experiment_number=str2double(answer{1});
        Stacknumber=str2double(answer{2});
        if experiment_number==1
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment1/ImageStacks/ImageStack%02d',Stacknumber))
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment1/ContourData/Segmentation_attempt_5/ImageStack%02dCurveData',Stacknumber))
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment1/CellContourOutput/CellFrameData%03d',Stacknumber),'CellFrameData')
            handles.Stack=eval(sprintf('ImageStack%02d',Stacknumber));
            clear(sprintf('ImageStack%02d',Stacknumber))
        elseif experiment_number==2
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment2/ImageStacks2/ImageStack%03d',Stacknumber))
            %load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment2/ContourData/ImageStack%03dCurveData',Stacknumber))
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment2/ContourData/attempt2/ImageStack%03dCurveData',Stacknumber))
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment2/CellContourOutput/CellFrameData%03d',Stacknumber),'CellFrameData')
            handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
            clear(sprintf('ImageStack%03d',Stacknumber))
        elseif experiment_number==3
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ImageStacks/ImageStack%03d',Stacknumber))
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ContourData/ImageStack%03dCurveData',Stacknumber))
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/CellContourOutput/CellFrameData%03d',Stacknumber),'CellFrameData')
            handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
            clear(sprintf('ImageStack%03d',Stacknumber))
        elseif experiment_number==4
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ImageStacks/ImageStack%03d',Stacknumber))
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/ContourData/Attempt2/ImageStack%03dCurveData',Stacknumber))
            load(sprintf('/Volumes/annelab/sam/Microscope_data/experiment3/CellContourOutput/Attempt2/CellFrameData%03d',Stacknumber),'CellFrameData')
            handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
            clear(sprintf('ImageStack%03d',Stacknumber))
        elseif experiment_number==5
            load(sprintf('/Users/samjefferyes/Desktop/Temp_test_data/ImageStack%03d',Stacknumber))
            load(sprintf('/Users/samjefferyes/Desktop/Temp_test_data/ImageStack%03dCurveData',Stacknumber))
            load(sprintf('/Users/samjefferyes/Desktop/Temp_test_data/CellFrameData%03d',Stacknumber),'CellFrameData')
            handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
            clear(sprintf('ImageStack%03d',Stacknumber))
        elseif experiment_number>5
            load(sprintf('CSG_folder_info/folder_info_exp_%d',experiment_number))
            out_fn=foldername;
            load(sprintf([out_fn{1} 'ImageStack%03d'],Stacknumber))
            load(sprintf([out_fn{2} 'ImageStack%03dCurveData'],Stacknumber))
            load(sprintf([out_fn{3} 'CellFrameData%03d'],Stacknumber),'CellFrameData')
            handles.Stack=eval(sprintf('ImageStack%03d',Stacknumber));
            clear(sprintf('ImageStack%03d',Stacknumber))
        end
        [f_c,c_n]=LoadOldAnalysis(Cell_numbers,CellFrameData);
        handles.Frame_curves=f_c;
        handles.Cell_numbers=c_n;
        handles.number_of_frames=size(handles.Stack,3);
        handles.number_of_cells=max(cell2mat(handles.Cell_numbers));
        
        handles.cmap=jet(handles.number_of_cells);
        handles.cmap=handles.cmap(randperm(handles.number_of_cells),:);
        warning off
        
        %Initialise
        v=1:handles.number_of_cells;
        handles.cell_in=mat2cell(v',ones(1,handles.number_of_cells));
        %handles.contour_on_off=true(handles.number_of_cells,1);
        handles.contour_exceptions=cell(handles.number_of_cells,1);
        handles.contour_present_in=cell(handles.number_of_cells,1);
        handles.contour_mergers=cell(handles.number_of_cells,1);
        for t=1:handles.number_of_cells
            handles.contour_exceptions{t}=[];
            handles.contour_present{t}=[];
            handles.contour_mergers{t}=t;
        end
        
        
        for t=1:handles.number_of_cells
            for k=1:length(handles.Frame_curves)
                if ismember(t,handles.Cell_numbers{k})
                    handles.contour_present_in{t}=[handles.contour_present_in{t} k];
                end
            end
        end
        
        %if ~isfield(handles,'Merge_points')
            for j=1:length(handles.Frame_curves)
                for k=1:length(handles.Frame_curves{j})
                    handles.Merge_points{j}{k}=[];
                end
            end
        %end
        
        UpdateManualIn(hObject, handles)
        handles=guidata(hObject);
        %ActiveFig=handles.axes1;
        handles.merge_toggle=0;
        handles.temp_merge_code=[];
        handles.Frame_no=1;
        imshow(handles.Stack(:,:,handles.Frame_no),[])
        hold on
        for j=1:length(handles.Frame_curves{handles.Frame_no})
            h2=plot(handles.Frame_curves{handles.Frame_no}{j}(:,2),handles.Frame_curves{handles.Frame_no}{j}(:,1),'Color',handles.cmap(handles.Cell_numbers{handles.Frame_no}(j),:));
            set(h2,'LineWidth',1)
        end
        titletext=sprintf('\\fontsize{16}Stack Number: %d Frame: %d. Cell numbers: ',Stacknumber,handles.Frame_no);
        for j=1:length(handles.Frame_curves{handles.Frame_no})
            if j==1
                titletext=[titletext '{'];
            end
            titletext=[titletext '\color[rgb]{' num2str(handles.cmap(handles.Cell_numbers{handles.Frame_no}(j),:)) '}' num2str(handles.Cell_numbers{handles.Frame_no}(j)) ' '];
            if j==length(handles.Frame_curves{handles.Frame_no})
                titletext=[titletext '}'];
            end
        end
        t=title(titletext);
        set(t,'FontWeight','bold')
        %pause(1/10)
        %hold off
        
        %set(handles.output,'ButtonDownFcn', @ImageClickCallback)
        set(gcf, 'WindowButtonDownFcn', {@getMousePositionOnImage,hObject},'Interruptible','on');
        set(gcf,'KeyPressFcn', @SelectDirectionClicked,'Interruptible','off')
        %set(src, 'Pointer', 'crosshair'); % Optional
        pan off % Panning will interfere with this code
        guidata(hObject, handles);
        set(gcf,'Pointer','arrow');
    end
    
end


%function addfolderlist

function savestuff(hObject, eventdata, handles)

set(gcf,'Pointer','watch'); drawnow
exp_no=handles.experiment_number;
stack_no=handles.Stack_number;
input=handles.man_in;
set(handles.text7, 'String',input)
[~,~,save_fldr]=eval(['CellContour_CellArray_generator_v2(hObject,handles, exp_no,stack_no,' input ')']);
handles=guidata(hObject);
handles=rmfield(handles,'Stack');
save(sprintf([ save_fldr 'handledata_exp%d_Stack%d'],exp_no,stack_no),'handles')
set(handles.text7, 'String',['Save succesful. Output contains ' num2str(handles.out_number_of_cells) ' cells']);
set(gcf,'Pointer','arrow')


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cmap=jet(handles.number_of_cells);
handles.cmap=handles.cmap(randperm(handles.number_of_cells),:);
if isfield(handles,'out_Frame_curves');
    handles.out_cmap=jet(handles.out_number_of_cells);
    handles.out_cmap=handles.out_cmap(randperm(handles.out_number_of_cells),:);
end
somethingelse.Key='n';
% set(gcf,'Pointer','hand')
% pause
% set(gcf,'Pointer','watch')
% pause(3)
% set(gcf,'Pointer','arrow')
SelectDirection(1,somethingelse,hObject,handles)


function [ Frame_curves, Cell_numbers ] = LoadOldAnalysis( orig_cell_numbers, CFD )
%LOADOLDANALYSIS Summary of this function goes here
%   Detailed explanation goes here
L1=length(CFD);
list=true(1,L1);
for i=1:L1
    if isempty(CFD(i).Stack_number)
        list(i)=false;
    end
end
CFD=CFD(list);
L=length(CFD);
F=length(orig_cell_numbers);
next_cell_no_index=ones(L,1);
for i=1:F
    Frame_curves{i}={};
    Cell_numbers{i}=[];
end
for j=1:F
    for i=1:L
        t=CFD(i).BadFrames(CFD(i).Cell_number);
        bf=[];

        for k=1:length(t)
            bf(k)=~ismember(j,t{k});
        end
        viable_cells=CFD(i).Cell_number(logical(bf));
        if ~isempty(intersect(orig_cell_numbers{j},viable_cells)) 
            Frame_curves{j}{end+1}=CFD(i).Contours{next_cell_no_index(i)};
            next_cell_no_index(i)=next_cell_no_index(i)+1;
            Cell_numbers{j}(end+1)=i;
        end
    end
end


function  CreateOutputImages( orig_cell_numbers, CFD, hObject,handles )
%LOADOLDANALYSIS Summary of this function goes here
%   Detailed explanation goes here
L1=length(CFD);
list=true(1,L1);
for i=1:L1
    if isempty(CFD(i).Stack_number)
        list(i)=false;
    end
end
CFD=CFD(list);
L=length(CFD);
F=length(orig_cell_numbers);
next_cell_no_index=ones(L,1);
for i=1:F
    Frame_curves{i}={};
    Cell_numbers{i}=[];
end
for j=1:F
    for i=1:L
        t=CFD(i).BadFrames(CFD(i).Cell_number);
        bf=[];

        for k=1:length(t)
            bf(k)=~ismember(j,t{k});
        end
        viable_cells=CFD(i).Cell_number(logical(bf));
        if ~isempty(intersect(orig_cell_numbers{j},viable_cells)) 
            Frame_curves{j}{end+1}=CFD(i).Contours{next_cell_no_index(i)};
            next_cell_no_index(i)=next_cell_no_index(i)+1;
            Cell_numbers{j}(end+1)=i;
        end
    end
end

handles.out_Frame_curves=Frame_curves;
handles.out_Cell_numbers=Cell_numbers;
handles.out_number_of_frames=size(handles.Stack,3);
handles.out_number_of_cells=max(cell2mat(handles.out_Cell_numbers));

handles.out_cmap=jet(handles.out_number_of_cells);
handles.out_cmap=handles.out_cmap(randperm(handles.out_number_of_cells),:);
guidata(hObject,handles)

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton1,'Value',0)
set(handles.radiobutton3,'Value',0)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2
guidata(hObject,handles)

function QueryCell(Frame_no,Cell_no,selType,handles,hObject)

set(handles.text7, 'String',['Cursor coordinates in Cell ' num2str(Cell_no)  ', which is in Merge Group [' longvec2str(handles.contour_mergers{Cell_no}) '] has exceptions [' longvec2str(handles.contour_exceptions{Cell_no}) '].']);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String', 'All|Short-lived cells|Small regions')


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents=cellstr(get(handles.popupmenu2,'String'));
contents=contents{get(handles.popupmenu2,'Value')};
set(gcf,'Pointer','watch'); drawnow
switch contents
    case 'All'
        if ismember(handles.Frame_no,handles.contour_exceptions{handles.Cell_numbers{handles.Frame_no}(1)})
            for i=1:handles.number_of_cells
                handles.contour_exceptions{i}=[];
            end
        else
            for i=1:handles.number_of_cells
                handles.contour_exceptions{i}=handles.contour_present_in{i};
            end
        end
    case 'Short-lived cells'
        t=0;
        for i=1:handles.number_of_cells
            if length(handles.contour_present_in{i})<5
                if t==0
                    on_or_off=ismember(handles.contour_present_in{i}(1),handles.contour_exceptions{i});
                    t=1;
                end
                if on_or_off
                    handles.contour_exceptions{i}=[];
                else
                    handles.contour_exceptions{i}=handles.contour_present_in{i};
                end
            end
        end
           
    case 'Small regions'
        if ~isfield(handles,'contour_area')
            for j=1:length(handles.Frame_curves)
                for i=1:length(handles.Frame_curves{j})
                    %find(handles.Cell_number==i)
                    handles.contour_area{j}(i)=polyarea(handles.Frame_curves{j}{i}(:,1),handles.Frame_curves{j}{i}(:,2));
                end
            end
        end
        t=0;
        for j=1:length(handles.Frame_curves)
            for i=handles.Cell_numbers{j}
                if handles.contour_area{j}(handles.Cell_numbers{j}==i)<500
                    if t==0
                        on_or_off=ismember(j,handles.contour_exceptions{i});
                        t=1;
                    end
                    if on_or_off
                        handles.contour_exceptions{i}=setdiff(handles.contour_exceptions{i},j);
                    else
                        handles.contour_exceptions{i}=union(handles.contour_exceptions{i},j);
                    end
                end
            end
        end
    otherwise
        
end
somethingelse.Key='n';
SelectDirection(1,somethingelse,hObject,handles)
set(gcf,'Pointer','arrow');


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton1,'Value',0)
set(handles.radiobutton2,'Value',0)
% Hint: get(hObject,'Value') returns toggle state of radiobutton3

function MergePoint(curX,curY,Frame_no,Cell_no,selType,handles,hObject)

switch selType
    case 'extend'
        handles.Merge_points{Frame_no}{handles.Cell_numbers{Frame_no}==Cell_no}=[];
        set(handles.text7, 'String',['Cursor coordinates in Cell ' num2str(Cell_no)  ', Merge Point removed.']);
    otherwise
        handles.Merge_points{Frame_no}{handles.Cell_numbers{Frame_no}==Cell_no}=[curX, curY];
        set(handles.text7, 'String',['Cursor coordinates in Cell ' num2str(Cell_no)  ', which now has Merge Point [' num2str(round(curX)) ',' num2str(round(curY)) '].']);
end

somethingelse.Key='n';
SelectDirection(1,somethingelse,hObject,handles)


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
contents = cellstr(get(hObject,'String')); %returns popupmenu3 contents as cell array
view_mode=contents{get(hObject,'Value')};
handles.view_mode=view_mode;
if strcmp(handles.view_mode(end),'t') && ~isfield(handles,'out_Frame_curves');
    msgbox('Please save your analysis first')
    set(hObject,'Value',1);
    handles.view_mode=contents{1};
end
somethingelse.Key='n';
SelectDirection(1,somethingelse,hObject,handles)

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
