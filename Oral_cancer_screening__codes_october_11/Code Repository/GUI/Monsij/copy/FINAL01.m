
function varargout = FINAL01(varargin)
% FINAL01 MATLAB code for FINAL01.fig
%      FINAL01, by itself, creates a new FINAL01 or raises the existing
%      singleton*.
%
%      H = FINAL01 returns the handle to a new FINAL01 or the handle to
%      the existing singleton*.
% 
%      FINAL01('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL01.M with the given input arguments.
%
%      FINAL01('Property','Value',...) creates a new FINAL01 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FINAL01_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FINAL01_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FINAL01

% Last Modified by GUIDE v2.5 11-May-2020 23:28:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FINAL01_OpeningFcn, ...
                   'gui_OutputFcn',  @FINAL01_OutputFcn, ...
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


% --- Executes just before FINAL01 is made visible.
function FINAL01_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FINAL01 (see VARARGIN)


% Choose default command line output for FINAL01
handles.output = hObject;



% Update handles structure
guidata(hObject, handles);





% --- Outputs from this function are returned to the command line.
function varargout = FINAL01_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
f=msgbox('Upload image');





% Get default command line output from handles structure
varargout{1} = handles.output;
%if (isfield(handles,'closeFigure') && handles.closeFigure)
 %     figure1_CloseRequestFcn(hObject, eventdata, handles)
%end




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    set(handles.pushbutton1,'Enable','off'); %deactivates pushbutton1 (Upload image) after uploading the image
    set(handles.pushbutton3,'Enable','off'); %pushbuttons 3,4,5 and 6 (Change ROI)are kept inactive while the time of image uploading
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton12,'Enable','off');
    set(handles.pushbutton13,'Enable','off');
    set(handles.pushbutton14,'Enable','off');
    set(handles.pushbutton15,'Enable','off');
    set(handles.pushbutton17,'Enable','off');

    %cd('..\..\17EC65R09_Abhishek\Codes');
   
    [filename, pathname] = uigetfile({'*.csv'},'File selector'); % get the image file along with the filename and pathname
   
    if filename==0
       set(handles.pushbutton3,'Enable','on'); % enable all the buttons associated with changing ROI
       set(handles.pushbutton4,'Enable','on');
       set(handles.pushbutton5,'Enable','on');
       set(handles.pushbutton6,'Enable','on');
       set(handles.pushbutton12,'Enable','on');
       set(handles.pushbutton13,'Enable','on');
       set(handles.pushbutton14,'Enable','on');
       set(handles.pushbutton15,'Enable','on');
       set(handles.pushbutton17,'Enable','off');
       f=msgbox('Upload an image'); % displays the message box
       set(handles.pushbutton1,'Enable','on'); % enable pushbutton1 again for uploading an image
       
    end
    handles.filename = filename;
    handles.pathname = pathname;

    
    disp(pathname);
    disp(filename);
    out=regexp(pathname,'\','split');
    disp(out);
    name1=out(end-2);
    
    
    alpha=filename(1:1); % reads the first character of the filename
        
    if (strcmp(alpha, 'T')==1) % first character is 'T' for the control group images
        p_id = filename(1:4); % p_id gives the patient ID
        set(handles.edit1,'String',p_id);
    elseif (strcmp(alpha, 'P')==1) % first character is 'P' for precancerous(folder named as 'nonmalignant')and malignant group
        p_id = filename(1:5); % patient ID for these groups are one character more than control group
        set(handles.edit1,'String',p_id);
    else
        disp('Invalid choice');
        return
    end 
    
    csvNameRT = p_id;
    right= xlsread([pathname,csvNameRT,'_rt.csv']); % reads the .csv file corresponding to right profile view
    maxval = max(max(right));   
    minval = min(min(right));
    range = 1/(maxval - minval);
    right = range .*(right - minval); % normalization of image to make the pixel values to a range between 0 and 1 (from their original range between 0 to 255)
    axes(handles.axes1)
    imshow(right);
    imshow(right,[]); % displays the normalized image in axes 1

    csvNameFT=p_id;
    data=xlsread([pathname,csvNameFT,'.csv']); % reads the .csv file corresponding to front view
    maxval = max(max(data));
    minval = min(min(data));
    range = 1/(maxval - minval);
    data = range .*(data - minval);
    axes(handles.axes2)
    imshow(data);
    imshow(data,[]); % displays the normalized image in axes 2

    csvNameLT =p_id;
    left= xlsread([pathname,csvNameLT,'_lt.csv']); % reads the .csv file corresponding to left profile view
    maxval = max(max(left));
    minval = min(min(left));
    range = 1/(maxval - minval);
    left = range .*(left - minval);
    axes(handles.axes3)
    imshow(left);
    imshow(left,[]); % displays the normalized image in axes 3

    answer=questdlg('Upload completed. Proceed with ROI extraction?', 'Message', 'Yes', 'No, upload another image','Yes' );
    switch answer
        case 'Yes'
            set(handles.extractroi,'Enable','on'); % 'Extract ROI' button is enabled after displaying the images
            f=msgbox('Click on Extract ROI button');
        case 'No, upload another image'
            %cd(pathname);
            %disp(pathname);
            %cd('..\..\..\');
            set(handles.pushbutton1,'Enable','on');
            set(handles.extractroi,'Enable','off');
            return
    end


%% dialog box
guidata(hObject, handles);


function extractroi_Callback(hObject, eventdata, handles)
filename = handles.filename;
pathname = handles.pathname;
cd(pathname);
%disp(pathname);
cd '..\..\..\Code Repository\Face Detection\';
Face_Detection_Keypoint_Cleaned_Code_new

cd(pathname);
cd '..\..\..\Code Repository\Profile Face Detection\';
Profile_keypoints_main_submission_gui

Front_ROI = load([pathname,folder_name,'\A_ROI_Front']);
Profile_ROI=load([pathname,folder_name2,'\A_face_mask']);

Profile_rightROI=Profile_ROI.img_face_rt;
%PR=im2uint8(Profile_rightROI);
%PR=Profile_ROI.profile_mask_rt;
%PR=imcrop(Profile_rightROI,[50 130 348 320]);
axes(handles.axes4)

imshow(Profile_rightROI);
imshow(Profile_rightROI,[]);

waitbar(x+0.66,h,'70% completed');

Front_rightROI=Front_ROI.A_ROI_R;
FR=imcrop(Front_rightROI,[50 130 348 320]);
axes(handles.axes5)
imshow(FR);
imshow(FR,[]);

waitbar(x+0.76,h,'80% completed');

Front_leftROI = Front_ROI.A_ROI_L;
%FL=Front_ROI.A_ROI_L
FL= imcrop(Front_leftROI,[200 140 348 320]);
axes(handles.axes6)
imshow(FL);
imshow(FL,[]);

waitbar(x+0.86,h,'90% completed');

Profile_leftROI=Profile_ROI.img_face_lt;
%PL=imcrop(Profile_leftROI,[200 140 348 320]);
axes(handles.axes7)
imshow(Profile_leftROI);
imshow(Profile_leftROI,[]);

waitbar(x+0.96,h,'100% completed');
close(h);
set(handles.extractroi,'Enable','off');
set(handles.pushbutton1,'Enable','on');

answer=questdlg('ROI extracted and saved. Do you wish to make changes in the ROI?', 'Message', 'Yes', 'No, thanks','No, thanks' );
    switch answer
        case 'Yes'
            set(handles.pushbutton3,'Enable','on');
            set(handles.pushbutton4,'Enable','on');
            set(handles.pushbutton5,'Enable','on');
            set(handles.pushbutton6,'Enable','on');
            set(handles.pushbutton12,'Enable','on');
            set(handles.pushbutton13,'Enable','on');
            set(handles.pushbutton14,'Enable','on');
            set(handles.pushbutton15,'Enable','on');
            f=msgbox('Click on the respective Change/Modify ROI buttons');
            
        case 'No, thanks'
            %cd(pathname);
            %disp(pathname);
            cd('..\..\..\..\..\..\GUI\Monsij');
            set(handles.pushbutton1,'Enable','on');
            set(handles.pushbutton17,'Enable','on');
            %set(handles.pushbutton12,'Enable','on');
            %set(handles.pushbutton13,'Enable','on');

            return
       
    end
    cd(pathname);
    %disp(pathname);
    set(handles.pushbutton17,'Enable','on');
    cd ('..\..\..\..\..\GUI\Monsij');



function FINAL_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
close(hObject);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
%cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Face Detection\';
%cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Profile Face Detection';
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
profile_right_re = getimage; % displays the image in axes 1
%uiwait;
figure; % displays the image in axes 1

[xred, yred, BW, xired, yired]=roipoly(profile_right_re);
Coords(:,1,1) = xired;
Coords(:,2,1) = yired;
close;
img_size  = size(profile_right_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_mask_rt_new= bsxfun(@times,profile_right_re,cast(mask,class(profile_right_re)));

maxval = max(max(profile_mask_rt_new));
minval = min(min(profile_mask_rt_new));
range = 1/(maxval - minval);
profile_mask_rt_new = range*(profile_mask_rt_new - minval);

pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);

cd(pathname);
axes(handles.axes4);
imshow(profile_mask_rt_new);

%answer=questdlg('Save changes?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
%switch answer
%case 'Yes'
profile_mask_rt=profile_mask_rt_new;
axes(handles.axes7);
profile_mask_lt=getimage;
axes(handles.axes7);

folder_name2=['Manual_Profile_ROI_' p_id];
%cd(folder_name2);
if ~exist(folder_name2)
    mkdir(folder_name2);
    cd(folder_name2);
else
    rmdir(folder_name2,'s');
    mkdir(folder_name2);
    cd(folder_name2);
end
save('M_profile_Mask','profile_mask_lt','profile_mask_rt');
f=msgbox('Saved successfully');

%set(handles.pushbutton12,'Enable','on');
%set(handles.pushbutton13,'Enable','on');
        %case 'No, keep separate'
            %axes(handles.axes7);
            %profile_mask_lt_new=getimage;
            %folder_name2=['Automatic_Profile_ROI_' p_id];
            %cd(folder_name2);
            %save('A_profile_Mask_new','profile_mask_lt_new','profile_mask_rt_new');
            %f=msgbox('Saved successfully');
%end
    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');



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
profile_f_right_new = bsxfun(@times,profile_front_re,cast(mask,class(profile_front_re)));

pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);

cd(pathname);
axes(handles.axes5);
imshow(profile_f_right_new);
%answer=questdlg('Do you wish to save and replace the existing Frontal Right ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
%switch answer
%case 'Yes'
A_ROI_R=profile_f_right_new;         
axes(handles.axes6);
A_ROI_L=getimage;
folder_name=['M_ROI_Front_' p_id];
if ~exist(folder_name)
    mkdir(folder_name);
    cd(folder_name);
else
    rmdir(folder_name,'s');
    mkdir(folder_name);
    cd(folder_name);
end
save('M_ROI_Front','A_ROI_L','A_ROI_R');
f=msgbox('Saved successfully');

%set(handles.pushbutton12,'Enable','on');
%set(handles.pushbutton13,'Enable','on');

    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');


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
profile_f_left_new = bsxfun(@times,profile_front_re,cast(mask,class(profile_front_re)));

pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);
cd(pathname);
axes(handles.axes6);
imshow(profile_f_left_new);
%answer=questdlg('Do you wish to save and replace the existing Frontal Leftt ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
%switch answer
%        case 'Yes'
A_ROI_L=profile_f_left_new;         
axes(handles.axes5);
A_ROI_R=getimage;
folder_name=['M_ROI_Front_' p_id];
if ~exist(folder_name)
    mkdir(folder_name);
    cd(folder_name);
else
    rmdir(folder_name,'s');
    mkdir(folder_name);
    cd(folder_name);
end
save('M_ROI_Front','A_ROI_L','A_ROI_R');
f=msgbox('Saved successfully');

%set(handles.pushbutton12,'Enable','on');
%set(handles.pushbutton13,'Enable','on');

    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');


    

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



% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%s = get(0, 'ScreenSize');
%figure1('Position', [0 0 s(3) s(4)]);
%figure('Units','normalized','Position',[0 0 1 1])



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double





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




% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes5);
profile_front_re = getimage;
figure;
[xred, yred, BW, xired, yired]=roipoly(profile_front_re);
Coords(:,1,1) = xired;
Coords(:,2,1) = yired;
close;
img_size  = size(profile_front_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_f_right_new = bsxfun(@times,profile_front_re,cast(mask,class(profile_front_re)));

pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);

cd(pathname);
axes(handles.axes5);
imshow(profile_f_right_new);
%answer=questdlg('Do you wish to save and replace the existing Frontal Right ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
%switch answer
%case 'Yes'
A_ROI_R=profile_f_right_new;         
axes(handles.axes6);
A_ROI_L=getimage;
folder_name=['M_ROI_Front_' p_id];
if ~exist(folder_name)
    mkdir(folder_name);
    cd(folder_name);
else
    rmdir(folder_name,'s');
    mkdir(folder_name);
    cd(folder_name);
end
save('M_ROI_Front','A_ROI_L','A_ROI_R');
f=msgbox('Saved successfully');

%set(handles.pushbutton12,'Enable','on');
%set(handles.pushbutton13,'Enable','on');

    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes4);
profile_right_re = getimage; % displays the image in axes 1
figure; % displays the image in axes 1

[xred, yred, BW, xired, yired]=roipoly(profile_right_re);
Coords(:,1,1) = xired;
Coords(:,2,1) = yired;
close;
img_size  = size(profile_right_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_mask_rt_new= bsxfun(@times,profile_right_re,cast(mask,class(profile_right_re)));


pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);

cd(pathname);
axes(handles.axes4);
imshow(profile_mask_rt_new);

%answer=questdlg('Save changes?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
%switch answer
%case 'Yes'
profile_mask_rt=profile_mask_rt_new;
axes(handles.axes7);
profile_mask_lt=getimage;
axes(handles.axes7);

folder_name2=['Manual_Profile_ROI_' p_id];
%cd(folder_name2);
if ~exist(folder_name2)
    mkdir(folder_name2);
    cd(folder_name2);
else
    rmdir(folder_name2,'s');
    mkdir(folder_name2);
    cd(folder_name2);
end
save('M_profile_Mask','profile_mask_lt','profile_mask_rt');
f=msgbox('Saved successfully');

%set(handles.pushbutton12,'Enable','on');
%set(handles.pushbutton13,'Enable','on');
        %case 'No, keep separate'
            %axes(handles.axes7);
            %profile_mask_lt_new=getimage;
            %folder_name2=['Automatic_Profile_ROI_' p_id];
            %cd(folder_name2);
            %save('A_profile_Mask_new','profile_mask_lt_new','profile_mask_rt_new');
            %f=msgbox('Saved successfully');
%end
    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes6);
profile_front_re = getimage;
figure;
[xred, yred, BW, xired, yired]=roipoly(profile_front_re);
Coords(:,1,1) = xired;
Coords(:,2,1) = yired;
close;
img_size  = size(profile_front_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_f_left_new = bsxfun(@times,profile_front_re,cast(mask,class(profile_front_re)));

pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);
cd(pathname);
axes(handles.axes6);
imshow(profile_f_left_new);
%answer=questdlg('Do you wish to save and replace the existing Frontal Leftt ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
%switch answer
%        case 'Yes'
A_ROI_L=profile_f_left_new;         
axes(handles.axes5);
A_ROI_R=getimage;
folder_name=['M_ROI_Front_' p_id];
if ~exist(folder_name)
    mkdir(folder_name);
    cd(folder_name);
else
    rmdir(folder_name,'s');
    mkdir(folder_name);
    cd(folder_name);
end
save('M_ROI_Front','A_ROI_L','A_ROI_R');
f=msgbox('Saved successfully');

%set(handles.pushbutton12,'Enable','on');
%set(handles.pushbutton13,'Enable','on');

    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes3);
profile_left_re = getimage;
figure;


[xred, yred, BW, xired, yired]=roipoly(profile_left_re);
Coords(:,1,1)= xired;
Coords(:,2,1)= yired;
close;

img_size  = size(profile_left_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_left_new = bsxfun(@times,profile_left_re,cast(mask,class(profile_left_re)));
pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);
cd(pathname);
axes(handles.axes7);
imshow(profile_left_new);


%answer=questdlg('Do you wish to save and replace the existing Profile Left ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
%switch answer
 %       case 'Yes'
profile_mask_lt=profile_left_new;
axes(handles.axes4);
profile_mask_rt=getimage;
folder_name2=['Manual_Profile_ROI_' p_id];
if ~exist(folder_name2)
    mkdir(folder_name2);
    cd(folder_name2);
else
    rmdir(folder_name2,'s');
    mkdir(folder_name2);
    cd(folder_name2);
end
save('M_profile_Mask','profile_mask_lt','profile_mask_rt');
f=msgbox('Saved successfully');

%set(handles.pushbutton12,'Enable','on');
%set(handles.pushbutton13,'Enable','on');
        
    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes7);
profile_left_re = getimage;
figure;


[xred, yred, BW, xired, yired]=roipoly(profile_left_re);
Coords(:,1,1)= xired;
Coords(:,2,1)= yired;
close;

img_size  = size(profile_left_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_left_new = bsxfun(@times,profile_left_re,cast(mask,class(profile_left_re)));
pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);
cd(pathname);
axes(handles.axes7);
imshow(profile_left_new);


%answer=questdlg('Do you wish to save and replace the existing Profile Left ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
%switch answer
 %       case 'Yes'
profile_mask_lt=profile_left_new;
axes(handles.axes4);
profile_mask_rt=getimage;
folder_name2=['Manual_Profile_ROI_' p_id];
if ~exist(folder_name2)
    mkdir(folder_name2);
    cd(folder_name2);
else
    rmdir(folder_name2,'s');
    mkdir(folder_name2);
    cd(folder_name2);
end
save('M_profile_Mask','profile_mask_lt','profile_mask_rt');
f=msgbox('Saved successfully');

%set(handles.pushbutton12,'Enable','on');
%set(handles.pushbutton13,'Enable','on');
        
    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.filename = filename;
   pathname=handles.pathname;

   cd('..\..\18EC65R07_Srijita\Codes\Code Repository\Multiresolution\Classification\libsvm-3.20\matlab\GaborResults\AutomatedROI\AROI_Full_Gabor_MN_Frontal');
   load('MN_Parameters_Frontal.mat','save_Predict_label_test');
   N=40;
   r=randperm(N);
   for i=1:N
    R=r(i);
    end
   Q=save_Predict_label_test{5,1}(R,1); 
  set(handles.edit3,'String',Q);
    
    