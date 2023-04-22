function varargout = FINAL(varargin)
% FINAL MATLAB code for FINAL.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FINAL_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FINAL_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FINAL

% Last Modified by GUIDE v2.5 26-Dec-2018 16:45:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FINAL_OpeningFcn, ...
                   'gui_OutputFcn',  @FINAL_OutputFcn, ...
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


% --- Executes just before FINAL is made visible.
function FINAL_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FINAL (see VARARGIN)

% Choose default command line output for FINAL
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FINAL wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FINAL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%load('D:\Documents\face\Monsij\Malignant\P0078\A_Profile_ROI_P0078\A_profile_Mask.mat');
%load('D:\Documents\face\Monsij\Malignant\P0078\A_ROI_Front_P0078\A_ROI_Front.mat');

[filename pathname] = uigetfile({'*.csv'},'File Selector');
%assignin('base','save_path',pathname);
p_id = filename(1:end-4);
set(handles.edit1,'String',p_id);

set(handles.edit2,'String',pathname);
filename2 =filename(1:end-4);
fullpathname = strcat(pathname,filename);
%set(handles.edit2,'String',fullpathname);
mat_front = xlsread(fullpathname);
maxval = max(max(mat_front));
minval = min(min(mat_front));
range = 1/(maxval - minval);
mat_front = range .*(mat_front - minval);
axes(handles.axes2);
imshow(mat_front);

csvNameLT = filename(1:end-4);
mat_left= xlsread([pathname,csvNameLT,'_lt.csv']);
%disp(left);
maxval = max(max(mat_left));
minval = min(min(mat_left));
range = 1/(maxval - minval);
mat_left = range .*(mat_left - minval);
axes(handles.axes1)
imshow(mat_left);


csvNameRT = filename(1:end-4);
mat_right= xlsread([pathname,csvNameRT,'_rt.csv']);
%disp(left);
maxval = max(max(mat_right));
minval = min(min(mat_right));
range = 1/(maxval - minval);
mat_right = range .*(mat_right - minval);
axes(handles.axes3)
imshow(mat_right);

curr_pidname = get(handles.edit2,'String');
%pathname_p = strcat('D:\Documents\face\Monsij\Malignant\' ,filename2,'\A_Profile_ROI_' , filename2,'\A_profile_Mask.mat');
pathname_p = strcat(curr_pidname ,'Automatic_Profile_ROI_' , filename2,'\A_profile_Mask.mat');
load(pathname_p);
%pathname_f = strcat('D:\Documents\face\Monsij\Malignant\',filename2,'\A_ROI_Front_',filename2,'\A_ROI_Front.mat');
pathname_f = strcat(curr_pidname,'Automatic_Profile_ROI_',filename2,'\A_profile_Mask.mat');

load(pathname_f);
%data_left = profile_mask_lt;
%assignin('base','profile_left',data_left);

%%%%%% Profile LEFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:480
    for j = 1:640
        if profile_mask_lt(i,j)==0
            mat_profile_left(i,j)=0;
        else
            mat_profile_left(i,j)=mat_left(i,j);
        end
        
    end
end
axes(handles.axes4)
imshow(mat_profile_left);
%%%% Profile LEFT end %%%%%%%%%%%%%%%%%%%%%%%


%%%%   Profile RIGHT %%%%%%%%%%%%%%%%%%%%%%
for i = 1:480
    for j = 1:640
        if profile_mask_rt(i,j)==0
            mat_profile_right(i,j)=0;
        else
            mat_profile_right(i,j)=mat_right(i,j);
        end
        
    end
end
axes(handles.axes7)
imshow(mat_profile_right);

%%%%%% Profile RIGHT end %%%%%%%%%%%%%%%%%%%


%%%%%% Frontal LEFT %%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:480
    for j = 1:640
        if A_ROI_L(i,j)==0
            mat_frontal_left(i,j)=0;
        else
            mat_frontal_left(i,j)=mat_front(i,j);
        end
        
    end
end
axes(handles.axes5)
imshow(mat_frontal_left);

%%%%%% Frontal LEFT end %%%%%%%%%%%%%%%%%%%%%%


%%%%%% Frontal RIGHT %%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:480
    for j = 1:640
        if A_ROI_R(i,j)==0
            mat_frontal_right(i,j)=0;
        else
            mat_frontal_right(i,j)=mat_front(i,j);
        end
        
    end
end
axes(handles.axes6)
imshow(mat_frontal_right);

%%%%%% Frontal RIGHT end %%%%%%%%%%%%%%%%%%%%








% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
profile_left_re = getimage;
figure;
[xred, yred, BW, xired, yired]=roipoly(profile_left_re);
Coords(:,1,1) = xired;
Coords(:,2,1) = yired;
close;
img_size  = size(profile_left_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_left_new = bsxfun(@times,profile_left_re,cast(mask,class(profile_left_re)));
%imshow(img_masked);
%imsave;
axes(handles.axes4);
imshow(profile_left_new);
%imwrite(profile_left_new,'C:\Users\MonsijB\Desktop\testing2.bmp');











% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
profile_front_re = getimage;
figure;
[xred, yred, BW, xired, yired]=roipoly(profile_front_re);
Coords(:,1,1) = xired;
Coords(:,2,1) = yired;
close;
img_size  = size(profile_front_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_f_left_new = bsxfun(@times,profile_front_re,cast(mask,class(profile_front_re)));
%imshow(img_masked);
%imsave;
axes(handles.axes5);
imshow(profile_f_left_new);
%imwrite(profile_left_new,'C:\Users\MonsijB\Desktop\testing2.bmp');















% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
profile_front_re = getimage;
figure;
[xred, yred, BW, xired, yired]=roipoly(profile_front_re);
Coords(:,1,1) = xired;
Coords(:,2,1) = yired;
close;
img_size  = size(profile_front_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_f_right_new = bsxfun(@times,profile_front_re,cast(mask,class(profile_front_re)));
%imshow(img_masked);
%imsave;
axes(handles.axes6);
imshow(profile_f_right_new);
%imwrite(profile_left_new,'C:\Users\MonsijB\Desktop\testing2.bmp');















% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes3);
profile_right_re = getimage;
figure;
[xred, yred, BW, xired, yired]=roipoly(profile_right_re);
Coords(:,1,1) = xired;
Coords(:,2,1) = yired;
close;
img_size  = size(profile_right_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_right_new = bsxfun(@times,profile_right_re,cast(mask,class(profile_right_re)));
%imshow(img_masked);
%imsave;
axes(handles.axes7);
imshow(profile_right_new);
%imwrite(profile_right_new,'C:\Users\MonsijB\Desktop\testing2.bmp');














% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes2);
img_new = getimage;
curr_p_id = get(handles.edit1,'String');
curr_path = get(handles.edit2,'String');
%curr_path = curr_path(1:end-4);
%pathname_now = strcat('D:\Documents\face\Monsij\Malignant\',curr_p_id,'\');
pathname_now = strcat(curr_path,'\');
%mkdir pathname_now fresh_images;
save_path = strcat(pathname_now,'fresh_images\','front.bmp');
%save_path
%imwrite(img_new,save_path);
mkdir(pathname_now,'fresh_images');
imwrite(img_new,save_path);

axes(handles.axes1);
img_new = getimage;
save_path = strcat(pathname_now,'fresh_images\','left.bmp');
imwrite(img_new,save_path);



axes(handles.axes3);
img_new = getimage;
save_path = strcat(pathname_now,'fresh_images\','right.bmp');
imwrite(img_new,save_path);


axes(handles.axes4);
img_new = getimage;
save_path = strcat(pathname_now,'fresh_images\','profile_left.bmp');
imwrite(img_new,save_path);


axes(handles.axes5);
img_new = getimage;
save_path = strcat(pathname_now,'fresh_images\','frontal_left.bmp');
imwrite(img_new,save_path);


axes(handles.axes6);
img_new = getimage;
save_path = strcat(pathname_now,'fresh_images\','frontal_right.bmp');
imwrite(img_new,save_path);


axes(handles.axes7);
img_new = getimage;
save_path = strcat(pathname_now,'fresh_images\','profile_right.bmp');
imwrite(img_new,save_path);


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
