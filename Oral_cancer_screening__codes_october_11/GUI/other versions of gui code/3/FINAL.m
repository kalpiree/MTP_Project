
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

% Last Modified by GUIDE v2.5 06-Aug-2019 10:22:13

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





% --- Outputs from this function are returned to the command line.
function varargout = FINAL_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
f=msgbox('Upload image');

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.pushbutton1,'Enable','off');
    set(handles.pushbutton2,'Enable','off');
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    set(handles.pushbutton9,'Enable','off');
    
%load('D:\Documents\face\Monsij\Malignant\P0078\A_Profile_ROI_P0078\A_profile_Mask.mat');
%load('D:\Documents\face\Monsij\Malignant\P0078\A_ROI_Front_P0078\A_ROI_Front.mat');
    [filename, pathname] = uigetfile({'D:\anjali\17EC65R09_Abhishek\Codes\ThermalDatabase\*.csv'},'File selector');
    %assignin('base','save_path',pathname);

    if filename==0
       set(handles.pushbutton3,'Enable','on');
       set(handles.pushbutton4,'Enable','on');
       set(handles.pushbutton5,'Enable','on');
       set(handles.pushbutton6,'Enable','on');
       set(handles.pushbutton9,'Enable','on');
       set(handles.pushbutton2,'Enable','on');
       f=msgbox('Upload an image');
       set(handles.pushbutton1,'Enable','on');
       
    end
    handles.filename = filename;
    handles.pathname = pathname;

    p_id = filename(1:end-4);
    set(handles.edit1,'String',p_id);

    fullpathname = strcat(pathname,filename);

    csvNameRT = filename(1:end-4);
    right= xlsread([pathname,csvNameRT,'_rt.csv']);
    maxval = max(max(right));
    minval = min(min(right));
    range = 1/(maxval - minval);
    right = range .*(right - minval);
    axes(handles.axes1)
    imshow(right);
    imshow(right,[]);



    %set(handles.edit2,'String',fullpathname);
    data = xlsread(fullpathname);
    axes(handles.axes2);
    maxval = max(max(data));
    minval = min(min(data));
    range = 1/(maxval - minval);
    data = range .*(data - minval);
    axes(handles.axes2)
    imshow(data);
    imshow(data,[]);

    csvNameLT = filename(1:end-4);
    left= xlsread([pathname,csvNameLT,'_lt.csv']);
    %disp(left);
    maxval = max(max(left));
    minval = min(min(left));
    range = 1/(maxval - minval);
    left = range .*(left - minval);
    axes(handles.axes3)
    imshow(left);
    imshow(left,[]);


    csvNameUP=filename(1:end-4);
    up=xlsread([pathname,csvNameUP,'_up.csv']);
    %up=xlsread([pathname,'Up view','\Up.csv'])
    maxval = max(max(up));
    minval = min(min(up));
    range = 1/(maxval - minval);
    up = range .*(up - minval);
    axes(handles.axes8)
    imshow(up);
    imshow(up,[]);

    answer=questdlg('Upload completed. Proceed with ROI extraction?', 'Message', 'Yes', 'No, upload another image','Yes' );
    switch answer
        case 'Yes'
            set(handles.extractroi,'Enable','on');
            
            f=msgbox('Click on Extract ROI button');
        case 'No, upload another image'
            set(handles.pushbutton1,'Enable','on');
            return
    end


%% dialog box
guidata(hObject, handles);

function extractroi_Callback(hObject, eventdata, handles)
filename = handles.filename;
pathname = handles.pathname;

%load('Face_Detection_Keypoints_Cleaned_Code_new.mat');
cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Face Detection\';
Face_Detection_Keypoint_Cleaned_Code_new

cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Profile Face Detection';
Profile_keypoints_main_submission_gui

waitbar(x+0.56,h,'60% completed');

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
answer=questdlg('ROI extracted and saved. Do you wish to make changes in the ROI?', 'Message', 'Yes', 'No, thanks','No, thanks' );
    switch answer
        case 'Yes'
            set(handles.pushbutton3,'Enable','on');
            set(handles.pushbutton2,'Enable','on');
            set(handles.pushbutton4,'Enable','on');
            set(handles.pushbutton5,'Enable','on');
            set(handles.pushbutton6,'Enable','on');
            set(handles.pushbutton9,'Enable','on');
            f=msgbox('Click on the respective Change ROI buttons');
            %answer=questdlg('Click on the respective Change ROI buttons','Message','Ok','Ok');
            %switch answer
             %   case 'Ok'
              %      return
            %end
        case 'No, thanks'
            return
    end


%f=msgbox({'ROI extracted and displayed';'Do you wish to make changes in the ROI?'});


%_____________________________


%&&&&&&&&&&&&&&&&&&&&&&&&

%%%%%% Profile LEFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%for i = 1:480
 %%%   for j = 1:640
  %%%      if profile_mask_lt(i,j)==0
      %%%      mat_profile_left(i,j)=0;
   %%%     else
         %%%   mat_profile_left(i,j)=left(i,j);
        %%%end
        
    %%%end
%%%end
%%%axes(handles.axes4)
%%%imshow(mat_profile_left);
%%%%%%% Profile LEFT end %%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%   Profile RIGHT %%%%%%%%%%%%%%%%%%%%%%
%%%for i = 1:480
   %%% for j = 1:640
      %%%  if profile_mask_rt(i,j)==0
         %%%   mat_profile_right(i,j)=0;
        %%%else
           %%% mat_profile_right(i,j)=right(i,j);
        %%%end
        
    %%%end
%%%end
%%%axes(handles.axes4)
%%%imshow(mat_profile_right);

%%%%%%%%% Profile RIGHT end %%%%%%%%%%%%%%%%%%%


%%%%%%%%% Frontal LEFT %%%%%%%%%%%%%%%%%%%%%%%%%
%%%for i = 1:480
   %%% for j = 1:640
      %%%  if A_ROI_L(i,j)==0
         %%%   mat_frontal_left(i,j)=0;
        %%%else
           %%% mat_frontal_left(i,j)=data(i,j);
        %%%end
        
    %%%end
%%%end
%%%axes(handles.axes5)
%%%imshow(mat_frontal_left);

%%%%%%%%% Frontal LEFT end %%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%% Frontal RIGHT %%%%%%%%%%%%%%%%%%%%%%%%
%%%for i = 1:480
   %%% for j = 1:640
      %%%  if A_ROI_R(i,j)==0
         %%%   mat_frontal_right(i,j)=0;
        %%%else
           %%% mat_frontal_right(i,j)=data(i,j);
        %%%end
        
    %%%end
%%%end
%%%axes(handles.axes6)
%%%imshow(mat_frontal_right);

%%%%%%%%% Frontal RIGHT end %%%%%%%%%%%%%%%%%%%%








% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)


% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes4);
fig1 = getimage;
figure;imshow(fig1);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

%cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Face Detection\';

%cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Profile Face Detection';
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
profile_right_re = getimage;
%uiwait;
figure;
%imshow(profile_right_re);
%imshow(profile_right_re,[]);
%set(handles.axes1,'Units','pixels');
%resizePos=get(handles.axes1,'Position');
%myImage=imresize(myImage,[resizePos(3) resizePos(3)]);
%axes(handles.axes1);
%imshow(myImage);
%set(handles.axes1,'Units','normalized');
pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);
%%%disp(p_id);
cd(pathname);
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
%profile_mask_rt=profile_mask_rt_new;
axes(handles.axes4);
imshow(profile_mask_rt_new);
%imwrite(profile_mask_right_new,'C:\Users\Anjali\Desktop\testing2.bmp');
%fig1=getimage;
%figure;
set(handles.pushbutton2,'Enable','on');


answer=questdlg('Do you wish to save and replace the existing Profile Right ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
switch answer
        case 'Yes'
            profile_mask_rt=profile_mask_rt_new;
            axes(handles.axes7);
            profile_mask_lt=getimage;
            folder_name2=['Automatic_Profile_ROI_' p_id];
            cd(folder_name2);
            save('A_profile_Mask','profile_mask_lt','profile_mask_rt');
            f=msgbox('Saved successfully');
        case 'No, keep separate'
            axes(handles.axes7);
            profile_mask_lt_new=getimage;
            folder_name2=['Automatic_Profile_ROI_' p_id];
            cd(folder_name2);
            save('A_profile_Mask_new','profile_mask_lt_new','profile_mask_rt_new');
            
            f=msgbox('Saved successfully');
            
            
end
cd 'C:\Users\Anjali\Desktop\FINAL';





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
%imshow(img_masked);
%imsave;
pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);
%%%disp(p_id);
cd(pathname);
axes(handles.axes5);
imshow(profile_f_right_new);
%imwrite(profile_left_new,'C:\Users\MonsijB\Desktop\testing2.bmp');
answer=questdlg('Do you wish to save and replace the existing Frontal Right ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
switch answer
        case 'Yes'
            A_ROI_R=profile_f_right_new;         
            axes(handles.axes6);
            A_ROI_L=getimage;
            folder_name=['A_ROI_Front_' p_id];
            cd(folder_name);
            save('A_ROI_Front','A_ROI_L','A_ROI_R');
            f=msgbox('Saved successfully');
        case 'No, keep separate'
            A_ROI_R_new=profile_f_right_new;
            axes(handles.axes6);
            
            A_ROI_L_new=getimage;
            folder_name=['A_ROI_Front_' p_id];
            cd(folder_name);
            %A_ROI_L_new=load('A_ROI_Front.mat','A_ROI_L');
            save('A_ROI_Front_new','A_ROI_L_new','A_ROI_R_new');
            f=msgbox('Saved successfully');
end
cd 'C:\Users\Anjali\Desktop\FINAL';



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
%imshow(img_masked);
%imsave;

pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);
%%%disp(p_id);
cd(pathname);
axes(handles.axes6);
imshow(profile_f_left_new);
%imwrite(profile_left_new,'C:\Users\MonsijB\Desktop\testing2.bmp');
answer=questdlg('Do you wish to save and replace the existing Frontal Leftt ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
switch answer
        case 'Yes'
            A_ROI_L=profile_f_left_new;         
            axes(handles.axes5);
            A_ROI_R=getimage;
            folder_name=['A_ROI_Front_' p_id];
            cd(folder_name);
            save('A_ROI_Front','A_ROI_L','A_ROI_R');
            f=msgbox('Saved successfully');
        case 'No, keep separate'
            A_ROI_L_new=profile_f_left_new;
            axes(handles.axes5);
            
            A_ROI_R_new=getimage;
            folder_name=['A_ROI_Front_' p_id];
            cd(folder_name);
            %A_ROI_L_new=load('A_ROI_Front.mat','A_ROI_L');
            save('A_ROI_Front_new','A_ROI_L_new','A_ROI_R_new');
            f=msgbox('Saved successfully');
end
cd 'C:\Users\Anjali\Desktop\FINAL';








% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes3);
profile_left_re = getimage;
figure;

pathname=handles.pathname;
filename=handles.filename;
p_id = filename(1:end-4);
%%%disp(p_id);
cd(pathname);

[xred, yred, BW, xired, yired]=roipoly(profile_left_re);
Coords(:,1,1)= xired;
Coords(:,2,1)= yired;
close;
img_size  = size(profile_left_re);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
profile_left_new = bsxfun(@times,profile_left_re,cast(mask,class(profile_left_re)));
%imshow(img_masked);
%imsave;
axes(handles.axes7);
imshow(profile_left_new);
imshow(profile_left_new,[]);


answer=questdlg('Do you wish to save and replace the existing Profile Left ROI?', 'Message', 'Yes', 'No, keep separate', 'No, keep separate');
switch answer
        case 'Yes'
            profile_mask_lt=profile_left_new;
            axes(handles.axes4);
            profile_mask_rt=getimage;
            folder_name2=['Automatic_Profile_ROI_' p_id];
            cd(folder_name2);
            save('A_profile_Mask','profile_mask_lt','profile_mask_rt');
            f=msgbox('Saved successfully');
        case 'No, keep separate'
            profile_mask_lt_new=profile_left_new;
            axes(handles.axes4);
            profile_mask_rt_new=getimage;
            folder_name2=['Automatic_Profile_ROI_' p_id];
            cd(folder_name2);
            save('A_profile_Mask_new','profile_mask_lt_new','profile_mask_rt_new');
            f=msgbox('Saved successfully');
end
cd 'C:\Users\Anjali\Desktop\FINAL';





function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes8);
up_view = getimage;
figure;
[xred, yred, BW, xired, yired]=roipoly(up_view);
Coords(:,1,1) = xired;
Coords(:,2,1) = yired;
close;
img_size  = size(up_view);
mask = poly2mask(xired,yired,img_size(1,1),img_size(1,2));
up_view_new = bsxfun(@times,up_view,cast(mask,class(up_view)));
%imshow(img_masked);
%imsave;
axes(handles.axes9);
imshow(up_view_new);
%imwrite(profile_right_new,'C:\Users\MonsijB\Desktop\testing2.bmp');
cd 'C:\Users\Anjali\Desktop\FINAL';


% --- Executes on button press in evaluate.
function evaluate_Callback(hObject, eventdata, handles)
% hObject    handle to evaluate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%mask_rt= handles.A_ROI_R;
%mask_lt= handles.A_ROI_L;
%I1= handles.data;
% figure, imshow(I1,[]);
% disp(A_ROI_R);
% figure, imshow(A_ROI_R, []);
% disp(A_ROI_L); 
%cd 'C:\Users\Anjali\Desktop\GUI\RIT_WORK\FINAL_CODES_22_8_2017\Manashi Codes';%(MASKED)
%cd 'D:\anjali\17EC65R09_Abhishek\Codes\ThermalDatabase\'; %(MINE)
%feature_extraction_classification_GUI
cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456';








% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%%%..............................................Started editing from here
%axes(handles.axes2);
%img_new = getimage;
%curr_p_id = get(handles.edit1,'String');
%curr_path = get(handles.edit2,'String');
%curr_path = curr_path(1:end-4);
%pathname_now = strcat('D:\Documents\face\Monsij\Malignant\',curr_p_id,'\');
%pathname_now = strcat(curr_path,'\');
%mkdir pathname_now fresh_images;
%save_path = strcat(pathname_now,'fresh_images\','front.bmp');
%save_path
%imwrite(img_new,save_path);
%mkdir(pathname_now,'fresh_images');
%imwrite(img_new,save_path);

%axes(handles.axes1);
%img_new = getimage;
%save_path = strcat(pathname_now,'fresh_images\','left.bmp');
%imwrite(img_new,save_path);



%axes(handles.axes3);
%img_new = getimage;
%save_path = strcat(pathname_now,'fresh_images\','right.bmp');
%imwrite(img_new,save_path);


%axes(handles.axes4);
%img_new = getimage;
%save_path = strcat(pathname_now,'fresh_images\','profile_left.bmp');
%imwrite(img_new,save_path);


%axes(handles.axes5);
%img_new = getimage;
%save_path = strcat(pathname_now,'fresh_images\','frontal_left.bmp');
%imwrite(img_new,save_path);


%axes(handles.axes6);
%img_new = getimage;
%save_path = strcat(pathname_now,'fresh_images\','frontal_right.bmp');
%imwrite(img_new,save_path);


%axes(handles.axes7);
%img_new = getimage;
%save_path = strcat(pathname_now,'fresh_images\','profile_right.bmp');
%imwrite(img_new,save_path);

%......................................... to here


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


% --- Executes on button press in extractroi.
%%function extractroi_Callback(hObject, eventdata, handles)
% hObject    handle to extractroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
%function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%s = get(0, 'ScreenSize');
%figure1('Position', [0 0 s(3) s(4)]);
%figure('Units','normalized','Position',[0 0 1 1])


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f1=axes(handle.axes4);
imshow(f1);
