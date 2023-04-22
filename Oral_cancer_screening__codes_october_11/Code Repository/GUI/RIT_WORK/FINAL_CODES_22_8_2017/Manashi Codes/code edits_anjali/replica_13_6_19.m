function varargout = replica(varargin)
% REPLICA MATLAB code for replica.fig
%      REPLICA, by itself, creates a new REPLICA or raises the existing
%      singleton*.
%
%      H = REPLICA returns the handle to a new REPLICA or the handle to
%      the existing singleton*.
%
%      REPLICA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REPLICA.M with the given input arguments.
%       
%      REPLICA('Property','Value',...) creates a new REPLICA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before replica_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to replica_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help replica

% Last Modified by GUIDE v2.5 12-Jun-2019 17:56:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @replica_OpeningFcn, ...
                   'gui_OutputFcn',  @replica_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
   % gui_mainfcn(gui_State, varargin{:});(MASKED)
    gui_mainfcn(gui_State,varargin{:}) %(MINE)
end
% End initialization code - DO NOT EDIT


% --- Executes just before replica is made visible.
function replica_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to replica (see VARARGIN)

% Choose default command line output for replica
handles.output = 'Yes';
% Calling:
% MyMsgbox('Meldung' | {'...'}[,'Title'[,image[,rgb_background]]])
set(hObject, 'Name', ' ');
% if(nargin > 3)
%     for index = 1:2:(nargin-3),
%         if nargin-3==index, break, end
%         switch lower(varargin{index})
%         case 'title'
%             set(hObject, 'Name', varargin{index+1});
%         case 'message'
%             set(handles.text_message, 'String', varargin{index+1});
%             % checck text extend
%             % if greater that text object then enlarge object and figure
%             text_extent = get(handles.text_message,'Extent');
%             text_pos    = get(handles.text_message,'Position');
%             xenlarge = text_extent(3)+20 - text_pos(3);
%             if xenlarge > 0
%                 set(handles.text_message,'Position',text_pos+[0 0 xenlarge 0])
%                 fig_pos = get(hObject,'Position');
%                 set(hObject,'Position',fig_pos+[0 0 xenlarge 0])
%             end
%             text_extent = get(handles.text_message,'Extent');
%             text_pos    = get(handles.text_message,'Position');
%             yenlarge = text_extent(4)+20 - text_pos(4);
%             if yenlarge > 0
%                 set(handles.text_message,'Position',text_pos+[0 0 0 yenlarge])
%                 fig_pos = get(hObject,'Position');
%                 set(hObject,'Position',fig_pos+[0 0 0 yenlarge])
%             end
%         case 'image'
%             set(handles.axes_icon,'Visible', 'on');
%             axes(handles.axes_icon) %#ok<LAXES>
%             image(varargin{index+1})
%             axis off, axis equal
%         case 'color'
%             set(handles.figure1,'Color', varargin{index+1}/255);
%             set(handles.axes_icon,'Color', varargin{index+1}/255);
%             set(handles.text_message,'BackgroundColor', varargin{index+1}/255);
%             set(handles.pushbutton_ok,'BackgroundColor', varargin{index+1}/255);
%             set(handles.text_lb_computing,'BackgroundColor', varargin{index+1}/255);
%         end
%     end
% end

% TRY TO REALIZE COMPARABLE LAYOUT FOR DIFFERENT SCREEN SIZES
% Due to R2013a where hObject is of type double, we use set(..) and get(..)

% Center figure on screen and store origin figure size (GUIfiguresize)
set(hObject,'Units','pixels');    % force for top figure
figuresize = get(hObject,'Position');
handles.GUIfiguresize = figuresize(3:4); % only need [xsize,ysize]
screensize = get(0,'ScreenSize');
xpos = ceil((screensize(3)-figuresize(3))/2); % center horizontally
ypos = ceil((screensize(4)-figuresize(4))/2); % center vertically
set(hObject,'Position',[xpos,ypos,figuresize(3:4)]);

% For all GUI-elements except top figure:
fnames = fieldnames(handles);
for i=2:length(fnames)
    field = handles.(fnames{i});
    % set Units to 'normalized'
    try field.Units;
        if ~strcmp(field.Units,'pixels')  % do some developer help
            fprintf('warning-Units: expected ''pixels'' in tag=%s\n',field.Tag);
        end
        field.Units = 'normalized';
    catch
    end
    % set FontUnits to 'points' and store origin font size (UserData.GUIfontsize)
    try field.FontUnits;
        field.FontUnits = 'points';
        if strcmp(field.Type,'uitable')
            % not yet supported cause UserData can't be used and layout
            % doesn't react completely on FontSize changes
        else
            field.UserData.GUIfontsize = field.FontSize;
        end
    catch
    end
end
set(hObject,'Units','pixels');    % might be changed before

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes replica wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = replica_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % normalize fonts
    fnames = fieldnames(handles);   % get all GUI elements
    d1 = handles.(fnames{1}).Position(3)/handles.GUIfiguresize(1);
    d2 = handles.(fnames{1}).Position(4)/handles.GUIfiguresize(2);
    pixelfactor = min(d1,d2);
    for i=1:length(fnames)
        field = handles.(fnames{i});
        try field.FontSize;
            if strcmp(field.Type,'uitable')
                % not yet supported cause FontSize change does not effect
                % all part of the table
            else
                set(field,'FontSize',pixelfactor*field.UserData.GUIfontsize);
            end
        catch
        end
    end
catch
end


function pid_Callback(hObject, eventdata, handles)
% hObject    handle to pid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pid as text
%        str2double(get(hObject,'String')) returns contents of pid as a double


% --- Executes during object creation, after setting all properties.
function pid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pathname_Callback(hObject, eventdata, handles)
% hObject    handle to pathname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathname as text
%        str2double(get(hObject,'String')) returns contents of pathname as a double


% --- Executes during object creation, after setting all properties.
function pathname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result as text
%        str2double(get(hObject,'String')) returns contents of result as a double


% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in uploadimage.
function uploadimage_Callback(hObject, eventdata, handles)
% hObject    handle to uploadimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile ({'D:\anjali\17EC65R09_Abhishek\Codes\ThermalDatabase\*.csv'}, 'File Selector');
%disp(filename); %(MINE)
image = strcat(pathname, filename);
data = xlsread(image);
axes(handles.axes1);
imshow(data);
imshow(data,[]);
set(handles.pid, 'string', filename);
% set(handles.pathname, 'string', pathname);
handles.filename = filename;
handles.pathname = pathname;
handles.data= data;
csvNameLT = filename(1:end-4);
left= xlsread([pathname,csvNameLT,'_lt.csv']);
%disp(left);
axes(handles.axes7)
imshow(left);
imshow(left,[]);
csvNameRT = filename(1:end-4);
right= xlsread([pathname,csvNameRT,'_rt.csv']);
%right= xlsread([pathname,'Profile views','\Right Profile.csv'])
axes(handles.axes6)
imshow(right);
imshow(right,[]);

% (MINE BELOW)
csvNameUP=filename(1:end-4);
up=xlsread([pathname,csvNameUP,'_up.csv']);
%up=xlsread([pathname,'Up view','\Up.csv'])
axes(handles.axes10)
imshow(up);
imshow(up,[]);

% (TILL HERE)

% csvName = filename(1:end-4);
% csvwrite(([csvName, '.csv']), image);
guidata(hObject, handles);

% --- Executes on button press in extractroi.
function extractroi_Callback(hObject, eventdata, handles)
% hObject    handle to extractroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = handles.filename;
pathname = handles.pathname;
% patientName = filename(1:end-4);
% leftROI = imread([pathname,'Auto_Roi','\LFrontRoi_',patientName,'.jpg']);
% rightROI = imread([pathname,'Auto_Roi','\RFrontRoi_',patientName,'.jpg']);
% axes(handles.axes2)
% imshow(rightROI);
% %%imshow(rightROI,[]);
% axes(handles.axes3)
% imshow(leftROI);
%%imshow(leftROI,[]);
%cd 'C:\Users\Admin-16\Desktop\Face Detection\';
 
%cd 'E:/MATLAB_2018/bin/face_code/Face Detection/';

%addpath 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Face Detection\'; %(MINE)
%Face_Detection_Keypoint_Cleaned_Code_new
%(MASKED)
%[A_ROI_R,A_ROI_L]=Face_Detection_Keypoint_Cleaned_Code_new; %(MINE)

cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Face Detection\'; %(MINE)
Face_Detection_Keypoint_Cleaned_Code_new%(MASKED)

cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Profile Face Detection';
Profile_keypoints_main_submission




%rightROI = imread([pathname,'Auto_ROI','\A_ROI_R.jpg']); (MASKED)

Front_ROI = load([pathname,folder_name,'\A_ROI_Front']);
Front_rightROI=Front_ROI.A_ROI_R;
%FR=Front_ROI.A_ROI_R
%I= imcrop(actual_rightROI,[50 130 348 320]);
FR=imcrop(Front_rightROI,[50 130 348 320]);
axes(handles.axes2)
imshow(FR);
imshow(FR,[]);
Front_leftROI = Front_ROI.A_ROI_L;
%FL=Front_ROI.A_ROI_L
FL= imcrop(Front_leftROI,[200 140 348 320]);
axes(handles.axes3)
imshow(FL);
imshow(FL,[]);

Profile_ROI=load([pathname,folder_name2,'\A_face_mask']);
Profile_rightROI=Profile_ROI.img_face_rt;
%PR=im2uint8(Profile_rightROI);
%PR=Profile_ROI.profile_mask_rt;
%PR=imcrop(Profile_rightROI,[50 130 348 320]);
axes(handles.axes8)
imshow(Profile_rightROI);
imshow(Profile_rightROI,[]);

Profile_leftROI=Profile_ROI.img_face_lt;
%PL=imcrop(Profile_leftROI,[200 140 348 320]);
axes(handles.axes9)
imshow(Profile_leftROI);
imshow(Profile_leftROI,[]);

% V= filename(1:end-4);
% load('C:\Users\Admin-16\Desktop\T001\A_ROI_Front_T001\A_ROI_Front');
%FR= filename(1:end-4);
%pathname
%VR=([pathname,'A_ROI_Front_', FR,'\A_ROI_Front']);
%load (VR);
%handles.A_ROI_R= A_ROI_R;
%IR= imcrop(A_ROI_R,[50 130 348 320]);
%axes(handles.axes2)
%imshow(IR);
%disp(A_ROI_R);
%guidata(hObject,handles)



%FL= filename(1:end-4);
%VL=([pathname,'A_ROI_Front_', FL,'\A_ROI_Front']);
%load (VL);
%handles.A_ROI_L= A_ROI_L;
%IL= imcrop(A_ROI_L,[200 140 348 320]);
%(handles.axes3)
%imshow(IL);














%guidata(hObject,handles)

% load([pathname,'A_ROI_Front_', V,'\A_ROI_Front']);

%(MINE)


% % --- Executes on button press in evaluate.
% function evaluate_Callback(hObject, eventdata, handles)
% % hObject    handle to evaluate (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% I1= handles.data;
% disp(I1);


% --- Executes on button press in radiobutton1.
% function radiobutton1_Callback(hObject, eventdata, handles)
% % hObject    handle to radiobutton1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of radiobutton1
% % if (get(hObject,'Value') == get(hObject,'Max'))
% 	set(handles.text3, 'String', 'Front Right ROI');
%     set(handles.text4, 'String', 'Front Left ROI');
%     set(handles.text2, 'String', 'Front Jaw View');
%     filename = handles.filename;
%     pathname = handles.pathname;
%     patientName = filename(1:end-4);
%     leftROI = imread([pathname,'Auto_Roi','\LFrontRoi_',patientName,'.jpg']);
%     rightROI = imread([pathname,'Auto_Roi','\RFrontRoi_',patientName,'.jpg']);
%     axes(handles.axes2)
%     imshow(rightROI);
%     imshow(rightROI,[]);
%     axes(handles.axes3)
%     imshow(leftROI);
%     imshow(leftROI,[]);

% else
% 	set(handles.text3, 'String', 'Front Right ROI');
%     set(handles.text4, 'String', 'Front Left ROI');
%     filename = handles.filename;
%     pathname = handles.pathname;
%     patientName = filename(1:end-4);
%     leftROI = imread([pathname,'Auto_Roi','\LSideRoi_',patientName,'.jpg']);
%     rightROI = imread([pathname,'Auto_Roi','\RSideRoi_',patientName,'.jpg']);
%     axes(handles.axes2)
%     imshow(rightROI);
%     axes(handles.axes3)
%     imshow(leftROI);
% end



% --- Executes on button press in radiobutton2.
% function radiobutton2_Callback(hObject, eventdata, handles)
% % hObject    handle to radiobutton2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of radiobutton2
% % if (get(hObject,'Value') == get(hObject,'Max'))
% 	set(handles.text3, 'String', 'Side Right ROI');
%     set(handles.text4, 'String', 'Side Left ROI');
%     filename = handles.filename;
%     pathname = handles.pathname;
%     patientName = filename(1:end-4);
%     leftROI = imread([pathname,'Auto_Roi','\LSideRoi_',patientName,'.jpg']);
%     rightROI = imread([pathname,'Auto_Roi','\RSideRoi_',patientName,'.jpg']);
%     axes(handles.axes2)
%     imshow(rightROI);
%     imshow(rightROI,[]);
%     axes(handles.axes3)
%     imshow(leftROI);
%     imshow(leftROI,[]);
% else
% 	set(handles.text3, 'String', 'Side Right ROI');
%     set(handles.text4, 'String', 'Side Left ROI');
%     filename = handles.filename;
%     pathname = handles.pathname;
%     patientName = filename(1:end-4);
%     leftROI = imread([pathname,'Auto_Roi','\LSideRoi_',patientName,'.jpg']);
%     rightROI = imread([pathname,'Auto_Roi','\RSideRoi_',patientName,'.jpg']);
%     axes(handles.axes2)
%     imshow(rightROI);
%     axes(handles.axes3)
%     imshow(leftROI);
% end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data= handles.data;
figure, imshow(data,[]);
guidata(hObject,handles)


% --- Executes on button press in evaluate.
function evaluate_Callback(hObject, eventdata, handles)
% hObject    handle to evaluate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mask_rt= handles.A_ROI_R;
mask_lt= handles.A_ROI_L;
I1= handles.data;
% figure, imshow(I1,[]);
% disp(A_ROI_R);
% figure, imshow(A_ROI_R, []);
% disp(A_ROI_L); 
cd 'E:\FINAL_CODES_22_8_2017\Manashi Codes\rit feature extraction code';%(MASKED)
%cd 'D:\anjali\17EC65R09_Abhishek\Codes\ThermalDatabase\'; %(MINE)
feature_extraction_classification_GUI


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
