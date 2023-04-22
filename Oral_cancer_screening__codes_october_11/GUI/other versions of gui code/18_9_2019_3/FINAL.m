
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

% Last Modified by GUIDE v2.5 18-Sep-2019 18:02:26

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
    
    %cd('..\..\17EC65R09_Abhishek\Codes');
   
    [filename, pathname] = uigetfile({'*.csv'},'File selector'); % get the image file along with the filename and pathname
   
    if filename==0
       set(handles.pushbutton3,'Enable','on'); % enable all the buttons associated with changing ROI
       set(handles.pushbutton4,'Enable','on');
       set(handles.pushbutton5,'Enable','on');
       set(handles.pushbutton6,'Enable','on');
       f=msgbox('Upload an image'); % displays the message box
       set(handles.pushbutton1,'Enable','on'); % enable pushbutton1 again for uploading an image
       
    end
    handles.filename = filename;
    handles.pathname = pathname;

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

%cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Face Detection\';
%Face_Detection_Keypoint_Cleaned_Code_new

    dir=pathname;
    split_dir=strsplit(dir,'\');
    nameFolds=split_dir{end-1};
    myPath=split_dir(1:end-2);
    rel_path=join(myPath,"\");
    my_folder=split_dir{end-2};
    fprintf('Processing Front View for Patient ID '); disp(nameFolds); % Display Current Patient ID
    folder_name=['A_ROI_Front_' nameFolds];
     %% Face Detection
    %  I/P = Input image (I_F)
    %  O/P = Face Boundary Mask (BW_mask_F)
    %  Function Used = face_detect.m
    
    disp('Face Detection - Started');
      
    fullpath=[pathname,filename];
    disp(filename);
    I_F=xlsread([dir,'\',nameFolds,'.csv']);
    %I_F=xlsread(fullpath);
    I_F_cpy=I_F;
    op_img1=nameFolds(); % Storing Patient ID
    
    %%% take care of this part- directory change
    
    %cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Face Detection';
    %addpath 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Profile Face Detection';
    path=mfilename('fullpath');
    split_path=strsplit(path, '\');
    FINAL_path=split_path(1:end-1);
    FINAL=join(FINAL_path, "\");
    %disp(FINAL);
    addpath FINAL;
    
    [BW_mask_F,mask_F,rt_boundary_col,lt_boundary_col,~,lower_boundary_row]=face_detect_new( I_F,nameFolds,op_img1 ); % Perform Face-Detection
  
    lower_boundary_row=floor(lower_boundary_row);
    I_F=mat2gray(I_F);
    %figure,imshow(I_f) % to show the original image
    face_img=(I_F).*double(BW_mask_F);% Convolving the face detected mask with the original image to obtain the face.
    
    disp('Face Detection - Completed')
    
    x=0.04;
    h=waitbar(x,'4% completed');
    %% Eye Detection
    %  I/P = Detected Face Image (face_img)
    %  O/P = Coordinates of R & L eye canthus.
    %  Function Used = eye_detection_thermal.m
    disp('Eye Canthus Detection - Started');
    
    waitbar(x+0.04,h,'8% completed');
    
    [modified_r_min,mean_eye_brow_row,row_rt_eye,row_lt_eye,col_rt_eye,col_lt_eye ] = eye_detection_thermal( face_img );
    disp('Eye Canthus Detection - Completed')
    
    %x=0.12;
    waitbar(x+0.08,h,'12% completed');
    
    %% Mouth Detection
    %  I/P = Detected Face Image (face_img)
    %  O/P = Column Coordinates of R & L mouth extremes
    %  Function Used = mouth_detection.m
    
    disp('Mouth Endpoint Detection - Started');
    
    %x=0.16;
    waitbar(x+0.12,h,'16% completed');
    
    [req_col_mouth_lt,req_col_mouth_rt,req_row,max_face_row,modified_min_row_nose] = mouth_detection( face_img,modified_r_min,row_lt_eye,row_rt_eye,col_lt_eye,col_rt_eye,mean_eye_brow_row);
    disp('Mouth Endpoint Detection - Completed');
    
    %x=0.2;
    waitbar(x+0.16,h,'20% completed');
    
     %% Nose Detection
    %  I/P = Detected Face Image (face_img)
    %  O/P = Coordinates of R & L nose extremes.
    %  Function Used = nose_detection.m
    
    disp('Nose Detection - Started');
    
    %x=0.24;
    waitbar(x+0.2,h,'24% completed');
    
    [r_lt,c_lt,r_rt,c_rt]=nose_detection( face_img,modified_min_row_nose,mean_eye_brow_row,req_row,col_rt_eye,col_lt_eye,req_col_mouth_lt,req_col_mouth_rt);
    disp('Nose Detection - Completed');
    
    %x=0.28;
    waitbar(x+0.24,h,'28% completed');
    
    %% Mouth Row
    %  I/P = Detected Face Image (face_img)
    %  O/P = Row coordinate of the mouth.
    %  Function Used = mouth_row_detect.m
    
    disp('Mouth Row Detection - Started');
    
    %x=0.32;
    waitbar(x+0.28,h,'32% completed');
    
    [ mouth_row_index_req,lower_lip_row ] = mouth_row_detect( face_img,req_row,col_lt_eye,col_rt_eye,r_rt,row_rt_eye,req_col_mouth_rt,req_col_mouth_lt );
    disp('Mouth Row Detection - Completed');
    
    %x=0.36;
    waitbar(x+0.32,h,'36% completed');
    
    %% Connected Components
    %  I/P = Detected Face Image (face_img)
    %  O/P = Face Image without cloth pixels (face_img)
    %  Function Used = Connected_Components_Face.m
    
    disp('Removing Cloth Pixels...');
    
    %x=0.4;
    waitbar(x+0.36,h,'40% completed');
    
    [ face_img ] = Connected_Components_Face( face_img,op_img1,lower_lip_row );
    disp('Cloth Pixels Removed');
    
    %x=0.44;
    waitbar(x+0.4,h,'44% completed');
    
     %% ====== Start of Hull Mask =====%%%
    % This part of the code removes the mouth reigon of the face as this reigon
    % gives false hotspot
    %  I/P = Modified Face Image (face_img)
    %  O/P = Face Region with a created Hull around mouth region (face_img)
    %  Function Used = Hull_Mask.m
    
    disp('Creating the Hull...');
    
    %x=0.48;
    waitbar(x+0.44,h,'48% completed');
    
    [ face_region,mid_mouth,face_keypt_X,face_keypt_Y ] = Hull_Mask( face_img,req_col_mouth_rt,req_col_mouth_lt,c_rt,c_lt,r_rt,r_lt,mouth_row_index_req,lower_lip_row );
    disp('Hull Mask Obtained');
    
    %x=0.52;
    waitbar(x+0.48,h,'52% completed');
    
    
    % ====== end of Hull Mask =====%%%
    
     %% Lower Eye Regression
    %  I/P = Modified Face Image (face_img) and Face Region (face_region)
    %  O/P = MOdified Face Region with region above eye forced to 0.
    %  Function Used = Lower_Eye_Regression.m
    disp('Removing Region above Eye');
    
    %x=0.56;
    waitbar(x+0.52,h,'56% completed');
    
    [face_region1,Left_Img,Right_Img,Lower_eye_row,cmid ] = Lower_Eye_Regression( face_img,face_region,col_rt_eye,col_lt_eye,row_rt_eye,row_lt_eye,c_rt,c_lt,req_col_mouth_lt,req_col_mouth_rt );
    disp('Removed Region above Eye');
    
    %% ROI Formation
    
    [row,column]=find(face_img>0);
    cmax=max(column);
    cmin=min(column);
    
    [img_size_X,img_size_Y]=size(face_img);
    Left_Img(Lower_eye_row-10:end,cmid:cmax)=face_region(Lower_eye_row-10:end,cmid:cmax); % Splitting the Face Regions into L & R components.
    Left_Img_1=Left_Img;
    Left_Img_1=(Left_Img_1>0); % Creating a binary mask of the Left Face Region.
    
    Labels_L= bwlabel(Left_Img_1);
    stats_L = regionprops(logical(Labels_L), 'Area');
    Ar_L=struct2cell(stats_L);
    Ar_L=cell2mat(Ar_L);
    LabelmaxArea_L=find(Ar_L==max(Ar_L));
    Logical_Left_ROI=[Labels_L==LabelmaxArea_L];
     
    A_ROI_L=I_F_cpy.*double(Logical_Left_ROI); % A_ROI_L is the region of interest for the Left face.
    A_ROI_L=imfill(A_ROI_L,'holes');
    
    Right_Img(Lower_eye_row-10:end,cmin:cmid)=face_region(Lower_eye_row-10:end,cmin:cmid);% Splitting the Face Regions into L & R components.
    Right_Img_1=Right_Img;
    Right_Img_1=(Right_Img_1>0);% Creating a binary mask of the Right Face Region.
    
    Labels_R= bwlabel(Right_Img_1);
    stats_R = regionprops(logical(Labels_R), 'Area');
    Ar_R=struct2cell(stats_R);
    Ar_R=cell2mat(Ar_R);
    LabelmaxArea_R=find(Ar_R==max(Ar_R));
    Logical_Right_ROI=[Labels_R==LabelmaxArea_R];
    
    A_ROI_R=I_F_cpy.*double(Logical_Right_ROI);% A_ROI_R is the region of interest for the Right face.
    A_ROI_R=imfill(A_ROI_R,'holes');
    
    A_ROI_R_img=mat2gray(A_ROI_R);
    A_ROI_L_img=mat2gray(A_ROI_L);
    
    cd(dir);
        if ~exist(folder_name)
            mkdir(folder_name);
            cd(folder_name);
        
        else
            rmdir(folder_name,'s');
            mkdir(folder_name);
            cd(folder_name);
        end
    
    save('A_ROI_Front','A_ROI_R','A_ROI_L');
    
    %%cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Profile Face Detection';
    %%Profile_keypoints_main_submission_gui

    fprintf('Processing Profile View for Patient ID '); disp(nameFolds);
    lt=xlsread([dir,'\',nameFolds,'_lt.csv']);
    rt=xlsread([dir,'\',nameFolds,'_rt.csv']);
        
    csv=lt;
    folder_name2=['Automatic_Profile_ROI_' nameFolds];
    
    maxval=max(max(lt));
    minval=min(min(lt)); 
    range=255/(maxval-minval);
    lt=range.*(lt-minval); 
    lt = uint8(lt); 
    originalimg=lt;
    gamma = 1.2;
    lt=uint8(1.*((double(lt)).^gamma));
    
    %% 2.Thresholding to segment out facial region
    % Global thresholding has been used. Global threshold set to 252.
        mask = imbinarize(lt, 252/255);
        
        % Get the biggest CLuster
        mask = bwareafilt(logical(mask),1);
        %figure,imshow(mask);
        
        % closing operation to remuve small objects
        SE = strel('square',2);
        mask = imclose(mask,SE);
        %figure,imshow(mask);
        
    % coordinates detection start
        
        [slope, constant, neck_col, neck_row]=find_neck(mask);
        
        %%%% remove the part below neck
        
        mask(neck_row:480, :) = 0; 
        %figure,imshow(mask);
        
        %%%% Get the tip row and column
        % ver_proj : Mask after remvoing the redundant part of the mask             
        % Index_ver_pro: column of highest vertical projection
       [tip_row,tip_col,ver_proj,Index_ver_pro]= nose_tip(mask);
       
       %%%% Removing cloth pixels
       % u_b: row of upper boundary
       % l_lo: row of lower boundary
       
       hor_pro = sum(mask,2);
       u_b_ar = find(hor_pro>0);
       u_b = u_b_ar(1);

       l_up=0.8*(tip_row-u_b);
       l_lo=tip_row+l_up;  
       
       if l_lo<480
           %mask(l_lo:480,:)=0; (MASKED)
           mask(floor(l_lo):480,:)=0;
       else
            l_lo=480;
       end
       
      %%% Nose detection for extended lip people

      [tip_row,tip_col,mask_nose] = nose_tip_copy(mask,u_b,l_lo);
      
      %%%%Chin detection

       [chin_col, chin_row]= chin_new(mask,neck_row,neck_col,tip_row,tip_col);
       
       %cd 'D:\anjali';
       
       %%%% get the upper part of the face points(row and column specified by
       %%%% g_row, g_col)
       
       
       
       [e_row, e_col, g_row, g_col] = upper_nose(chin_row, chin_col,tip_row,tip_col,mask,u_b);
       
       
       %%dist is the variable calculated between two points
    %Here it is calculated between chin and nose tip
     dist = round(sqrt(abs(chin_row-tip_row)^2+abs(chin_col-tip_col)^2));
    
    %%%% get the eyecanthus row and column specified by canthus_r,canthus_c
     [canthus_r,canthus_c] = lateral_eyecanthus(mask,g_row,g_col,dist,csv);
    %Here it is calculated between eyecanthus and nose tip
     dist = round(sqrt(abs(g_row-tip_row)^2+abs(g_col-tip_col)^2));
     
    %%%% get the Nose wing row and column specified by nw_row, nw_col
     [nw_row, nw_col] = nose_wing(tip_row,tip_col,mask,dist,csv);
        
    
    %%%% get the ear hotspot row and column specified by ear_row, ear_col
     [ear_row, ear_col,mask_ear_search,mask_temp] = ear_new(mask,tip_row,tip_col,chin_row, chin_col,e_row, e_col,csv,Index_ver_pro);
     

     %%%%%%%%%% mask generation using these points
     [mask,row,col,ROI_L] = modified_mask(tip_row,tip_col,canthus_r,canthus_c,nw_row,nw_col,ear_row,ear_col,chin_row, chin_col,mask,originalimg);
      
     %save()
     %k = boundary(row,col,.1);
     
     %Rescale the mask area to 0-255 intensity
     
     temp=csv.*double(mask);
     maxval=max(max(temp));
     minval=min(min(temp(mask>0)));
     range=255/(maxval-minval);
     temp_1=range.*(temp-minval); 
     lt = uint8(temp_1);
     
     lt=lt.*uint8(mask);
     img_face_lt = lt;
     profile_mask_lt = mask;
    
     
     rt = flip(rt,2) ;
     csv= rt;
     % Scale the Image from 0-255
    maxval=max(max(rt));
    minval=min(min(rt));
    range=255/(maxval-minval);
    rt=range.*(rt-minval); 
    rt = uint8(rt);
    originalimg=rt;
    
    % % % % % gamma correction for mask generation
    gamma = 1.2;
    rt=uint8(1.*((double(rt)).^gamma));
    % % % % % % % % % % % % % % % % % % % % % % % % % 
    
    %% 2.Thresholding to segment out facial region
    
    mask = imbinarize(rt, 252/255);
    % Get the biggest CLuster
    mask = bwareafilt(logical(mask),1);
    % closing operation to remuve small objects
    SE = strel('square',2);
    mask = imclose(mask,SE);
    
    %% cordinates detection start

    [slope, constant, neck_col, neck_row]=find_neck(mask);
    
  
    mask(neck_row:480, :) =0; %%%% remove the parrt below neck
    
    %%%% Get the tip row and column
    % ver_proj : Mask after remvoing the redundant part of the mask             
    % Index_ver_pro: column of highest vertical projection
       
    [tip_row,tip_col,ver_proj,Index_ver_pro]= nose_tip(mask);
    
%%  Removal of Cloth pixels
       hor_pro = sum(mask,2);
       u_b_ar = find(hor_pro>0);
       u_b = u_b_ar(1);

       l_up=0.8*(tip_row-u_b);
       l_lo=tip_row+l_up;
       
       if l_lo<480
           %mask(l_lo:480,:)=0; (MASKED)
           mask(floor(l_lo):480,:)=0;
       else
            l_lo=480;
       end
       
    % Nose detection for extended lip people
    [tip_row,tip_col,mask_nose] = nose_tip_copy(mask,u_b,l_lo);
    
    %figure,imshow(originalimg_marked);

    [chin_col, chin_row]= chin_new(mask,neck_row,neck_col,tip_row,tip_col);
    
     %%%% get the chin row and column
    [e_row, e_col, g_row, g_col] = upper_nose( chin_row, chin_col,tip_row,tip_col,mask);
     %%%% get the upper part of the face points(row and column specified by
     %%%% g_row, g_col)
%%
% %  Rescale the mask area to 0-255 intensity
    temp=csv.*double(mask);
    maxval=max(max(temp));
    minval=min(min(temp(mask>0)));
    range=255/(maxval-minval);
    temp_1=range.*(temp-minval); 
    rt = uint8(temp_1);
    
    %%  
    % dist is the variable calculated between two points
    dist = round(sqrt(abs(chin_row-tip_row)^2+abs(chin_col-tip_col)^2));%Here it is calculated between chin and nose tip
    
    %%%% get the eyecanthus row and column specified by canthus_r,canthus_c
    [canthus_r,canthus_c] = lateral_eyecanthus(mask,g_row,g_col,dist,csv);
    
    dist = round(sqrt(abs(g_row-tip_row)^2+abs(g_col-tip_col)^2));%Here it is calculated between eyecanthus and nose tip
    
    %%%% get the Nose wing row and column specified by nw_row, nw_col
    [nw_row, nw_col]=nose_wing(tip_row,tip_col,mask,dist,csv);
    
    
    %%%% get the ear hotspot row and column specified by ear_row, ear_col
    [ear_row, ear_col,mask_ear_search,mask_temp] = ear_new(mask,tip_row,tip_col,chin_row, chin_col,e_row, e_col,csv,Index_ver_pro);


    %%%%%%%%%% mask generation using these points
    [mask,row,col,ROI_R] = modified_mask(tip_row,tip_col,canthus_r,canthus_c,nw_row,nw_col,ear_row,ear_col,chin_row, chin_col,mask,originalimg);
    
     %save();
     %k = boundary(row,col,.1);
    
     rt=rt.*uint8(mask);
     img_face_rt=rt;
     profile_mask_rt = mask;
     profile_mask_rt = flip(profile_mask_rt,2);
     img_face_rt = flip(img_face_rt,2);
     ROI_R = flip(ROI_R,2);   
     
     
%   clearvars '-except' saving_path database_path  profile_mask_lt profile_mask_rt img_face_lt img_face_rt d isub nameFolds no_dir folder_idx folder_name;


%% saving the plots

 cd(dir);
 if ~exist(folder_name2)
            mkdir(folder_name2);
            cd(folder_name2);
        
        else
            rmdir(folder_name2,'s');
            mkdir(folder_name2);
            cd(folder_name2);
        end
    
save('A_profile_Mask','profile_mask_lt','profile_mask_rt');
save('A_face_mask','img_face_lt','img_face_rt');
              
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
set(handles.extractroi,'Enable','off');
set(handles.pushbutton1,'Enable','on');

answer=questdlg('ROI extracted and saved. Do you wish to make changes in the ROI?', 'Message', 'Yes', 'No, thanks','No, thanks' );
    switch answer
        case 'Yes'
            set(handles.pushbutton3,'Enable','on');
            set(handles.pushbutton4,'Enable','on');
            set(handles.pushbutton5,'Enable','on');
            set(handles.pushbutton6,'Enable','on');
            f=msgbox('Click on the respective Change ROI buttons');
            
        case 'No, thanks'
            %cd(pathname);
            %disp(pathname);
            cd('..\..\..\..\..\..\GUI\Monsij');
            set(handles.pushbutton1,'Enable','on');
            set(handles.pushbutton12,'Enable','on');
            set(handles.pushbutton13,'Enable','on');

            return
       
    end
    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');

    
function [mask,row,col,ROI] = modified_mask(tip_row,tip_col,canthus_r,canthus_c,nw_row,nw_col,ear_row,ear_col,chin_row, chin_col,mask,I1)
chin_col = chin_col +(nw_col - tip_col);

b_e_row = chin_row;
b_e_col = ear_col;

row = zeros(5,1);
col = zeros(5,1);

row(1,1)=canthus_r;
row(2,1)= nw_row;
row(3,1)= ear_row;
row(4,1)= chin_row;
row(5,1)=b_e_row;

col(1,1)=canthus_c;
col(2,1)= nw_col;
col(3,1)= ear_col;
col(4,1)= chin_col;
col(5,1)=b_e_col;

% for generating final mask uncomment this

%mask(:,b_e_col:1:640)=0; (MASKED)
mask(:,floor(b_e_col):1:64)=0;
%mask(b_e_row:1:480,:)=0; (MASKED)
mask(floor(b_e_row):1:480,:)=0;


% % % % % % removing the outer part of the polygon
   
    %%%(nw_row,nw_col) first point
    %%%(chin_row,chin_col) second point
   
    m = (chin_row-nw_row)/(chin_col-nw_col);
    
    k = nw_row - m * nw_col;
    
   
    for row = 1:1:480
     for col =1:1:640
        
       if( row - m*col - k >0)
       mask(row,col)= 0;
       end
        
     end
    end
    
    
    
    %%%(canthus_r,canthus_c) first point
     %%%(nw_row,nw_col) second point

        m = (nw_row-canthus_r)/(nw_col-canthus_c);

        k = canthus_r- m * canthus_c;


        for row = 1:1:480
         for col =1:1:640

           if( row - m*col - k <0)
           mask(row,col)= 0;
           end

         end
        end
        
     %%%(ear_row,ear_col) first point
     %%%(canthus_r,canthus_c) second point

        m = (ear_row-canthus_r)/(ear_col-canthus_c);

        k = canthus_r- m * canthus_c;


        for row = 1:1:480
         for col =1:1:640

           if( row - m*col - k <0)
           mask(row,col)= 0;
           end

         end
        end
        
        
  pos_pentagon = [canthus_c canthus_r ear_col ear_row ear_col chin_row chin_col chin_row nw_col nw_row];
  %pos_pentagon=[canthus_c canthus_r ear_col ear_row ear_col chin_row chin_col chin_row]
  ROI = insertShape(I1,'Polygon',{pos_pentagon},'Color', {'blue'},'Opacity',0.7);

    
function [ch_col, ch_row]= chin_new(mask,neck_row, neck_col,tip_row,tip_col)

mask= edge(mask,'Canny',.48,1);

mask(1:tip_row, :) =  0;

mask(:,neck_col :640) =  0;

dist_min=10000000000;
ch_row=0;
ch_col=0;
  for r=tip_row:1:neck_row
    for c=1:1:neck_col
    
    if mask(r,c)==1
        dist= sqrt(abs(neck_row-r)^2+abs(tip_col-20-c)^2);
        
        if(dist<dist_min)
        dist_min= dist;
        ch_row=r;
        ch_col=c;
        end
    end
    end
 end
 
function[y_cordinate, x_cordinate,BW] = nose_tip_copy(mask,u_b,l_lo)

[row, col] = size(mask);
len = l_lo-u_b;

BW= mask;

%horizontal and vertical projection

horpro1= sum(BW,2); %vertical array
verpro= sum(BW,1);  
[max_ver_pro,Index_ver_pro]=max(verpro);

BW(:,Index_ver_pro:640)=0;
BW(u_b+round(len*0.55):480,:)=0;
horpro2 = sum(BW,2);
[max_hor_pro2,Indexnose]=max(horpro2);

arr=mask(Indexnose,:);

x_cordinate = min(find(arr>0));
y_cordinate = Indexnose;


function [ req_col_mouth_lt,req_col_mouth_rt,req_row,max_face_row,modified_min_row_nose ] =mouth_detection( face_img,modified_r_min,row_lt_eye,row_rt_eye,col_lt_eye,col_rt_eye,mean_eye_brow_row)
%% Documentation
% % Functions called in this fn: Nil
% i/p parameters to the fn:  face_img, 
%                            modified_r_min 
%                            row_lt_eye 
%                            row_rt_eye 
%                            col_lt_eye 
%                            col_rt_eye 
%                            mean_eye_brow_row
% o/p parameters of the fn:  req_col_mouth_lt 
%                            req_col_mouth_rt
%                            req_row
%                            max_face_row

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. modified_r_min :: Row index representing hair line
%                    2. max_face_row :: Project the horizontal maximum of the face from modified_r_min to obtain maximum face row
%                    3. modified_min_row_nose :: Represent the half of nose. 
%                    4. variance :: Store the row-wise variance.
%                    5. cropped_variance :: Reject the latter 25% of variance
%                    6. thresh :: threshold to identify the required peak.
%                    7. local_max :: Locate the first peak satifying the threshold
%                    8. difference :: Compute the successive differences to ID the peak
%                    9. req_row :: Represents the row between the mouth and the nose.
%                   10. window_size :: The window to be scanned using ANOVA
%                   11. p_mouth_rt :: Significance between two columns, using ANOVA for the right image
%                   12. difference_mouth_rt :: r_max is computed to be 40% from the modified r_min of right half
%                   13. counter_rt :: Array Counter 
%                   14. counter_lt :: Row components of the sampled columns
%                   15. col_gradient_lt :: Gradient of the smapled column
%                   16. difference_mouth_lt :: Non zero component of the gradient of the smapled column
%                   17. req_col_mouth_lt :: findpeaks return variables to identify prominent peaks
%                  
%%    Working: Find the req_row, the row between nose and mouth. From the req_row to the max_face_row, select the columns, 
%              w.r.t the window size. Consider two successive columns, continuously and perform the ANOVA analysis. Determine the 
%              significance for each pair of the columns. Identify the first minimum from the significance vector, 
%              from the extremes for both the left and right images. These two columns indicate the corner points of 
%              the mouth.
    [r,c]=find(face_img>0);
    rmin=min(r);
    rmax=max(r);
    column_id_data=face_img(mean_eye_brow_row,:); % column_id_data--> to get a true notion of the face width i.e the width of the face is measured for the mean_eye_brow_row 
    c=find(column_id_data>0);
    cmin=min(c);
    cmax=max(c);
    
    req_dist=cmax-cmin; %req_dist is the width of the face 
    max_face_row=modified_r_min+req_dist; %req_dist added to modified_r_min(row from below the hair) gives height of the face
    if(max_face_row > rmax)
        max_face_row=rmax;
    end
    min_row=row_lt_eye; %row_lt_eye is the row component of the hotspot
    cmid=ceil((cmin+cmax)/2);
    modified_min_row_nose=ceil((1/4)*(max_face_row-min_row)+min_row); % search area for nose
 
    temp=[];
    nose_img=face_img(modified_min_row_nose:max_face_row,col_rt_eye:col_lt_eye); % Nose Image with the above boundaries

    % Determination of the row (req_row) between the nose and mouth
    % Compute the Row-wise variance along the Nose Image
    for i=1:size(nose_img,1)
         temp(i,:)=(gradient(nose_img(i,:)));
         variance(i)=var(temp(i,:));
    end
     
    cropped_variance= variance(1:floor((3/4)*size(variance,2))); % Exclude the later 25% of the search region, to avoid the mid-mouth region
    thresh=0.6*max(cropped_variance); % Threshold to be checked for.
    local_max=find(cropped_variance>=thresh);  % Identification of the first point that crosses the threshold.
    local_max=local_max(1);
    counter_rt=local_max; % This point marks the beginning of our search region, where we want to find the local minimum which is the req_row.
    difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);

    % This first loop is to traverse through the variance vector and identify the next immediate peak
    % Once there is a peak, then we move ont o identify the corresponding
    % valley right after it. When the initial difference, is negative, it
    % means, the first loop wont get executed, and the valley is directly
    % obtained throught the second loop.
      
     while(difference>=0)
         difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
         counter_rt=counter_rt+1;
     end
     while(difference<=0&&counter_rt<size(cropped_variance,2))
         difference=cropped_variance(counter_rt+1)-cropped_variance(counter_rt);
         counter_rt=counter_rt+1;
     end
     
     req_row=counter_rt-1+modified_min_row_nose; % Adding the required offset.

     window_size=21; % Window Size defined for setting a mouth region.
%%     
     set(0,'DefaultFigureVisible','off'); % Turn off Plotting Figures
%     Right Mouth Column 
     p_mouth_rt=[];
    % In order to identify the columns, we tranverse through the window
    % size from the column coordinates of eye canthus, and apply Analysis
    % of Variance for each successive pair fo columns.
    for mouth_col_index_rt=(col_rt_eye-window_size):col_rt_eye
         col_data_1=face_img(req_row:rmax,mouth_col_index_rt);
         col_data_2=face_img(req_row:rmax,mouth_col_index_rt+1);
         y_mouth_rt=[col_data_1 col_data_2]; % Succesive Columns of Interest
         p_mouth_rt(mouth_col_index_rt-(col_rt_eye-window_size)+1)=anova1(y_mouth_rt); % Perform one way ANOVA for the above columns.
    end
    set(0,'DefaultFigureVisible','on'); % Turn on Plotting Figures
         
         counter_rt=1;
         % In order to find the Columns, we have to find the first valley
         % in the 'p' vector. This is done using two loops, the first one
         % to crossover a apeak, if any and the second to traverse until
         % the valley point is obtained.
         difference_mouth_rt=p_mouth_rt(counter_rt+1)-p_mouth_rt(counter_rt); % Difference vector used to identify the inc. or dec. trend of the graph 

         while(difference_mouth_rt>=0&&counter_rt<size(p_mouth_rt,2))
             difference_mouth_rt=p_mouth_rt(counter_rt+1)-p_mouth_rt(counter_rt);
             counter_rt=counter_rt+1;
         end
         while(difference_mouth_rt<=0&&counter_rt<size(p_mouth_rt,2))
             difference_mouth_rt=p_mouth_rt(counter_rt+1)-p_mouth_rt(counter_rt);
             counter_rt=counter_rt+1;
         end
         req_col_mouth_rt=counter_rt-1+(col_rt_eye-window_size); % Computing the effective index, by adding the offset.

                  %% Left Mouth Column
         set(0,'DefaultFigureVisible','off');% Turn off Plotting Figures
    p_mouth_lt=[];
    for mouth_col_index_lt=col_lt_eye:(col_lt_eye+window_size)
         col_data_1=face_img(req_row:rmax,mouth_col_index_lt);
         col_data_2=face_img(req_row:rmax,mouth_col_index_lt+1);
         y_mouth_lt=[col_data_1 col_data_2];
         p_mouth_lt(mouth_col_index_lt-(col_lt_eye)+1)=anova1(y_mouth_lt); 
    end
    set(0,'DefaultFigureVisible','on');
         % In order to find the Columns, we have to find the first valley
         % in the 'p' vector. This is done using two loops, the first one
         % to crossover a apeak, if any and the second to traverse until
         % the valley point is obtained.
         counter_lt=size(p_mouth_lt,2)-1   ;
         difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt);% Difference vector used to identify the inc. or dec. trend of the graph 

         while(difference_mouth_lt<=0&&counter_lt<size(p_mouth_lt,2))
             difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt);
             counter_lt=counter_lt-1;
         end
         while(difference_mouth_lt>=0&&counter_lt<size(p_mouth_lt,2))
             difference_mouth_lt=p_mouth_lt(counter_lt+1)-p_mouth_lt(counter_lt);
             counter_lt=counter_lt-1;
         end
         counter_lt=counter_lt-1;
         req_col_mouth_lt=counter_lt-1+col_lt_eye; % Computing the effective index, by adding the offset.
return

% --- Executes on button press in pushbutton2.
%function pushbutton2_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
set(handles.pushbutton12,'Enable','on');
set(handles.pushbutton13,'Enable','on');
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
set(handles.pushbutton12,'Enable','on');
set(handles.pushbutton13,'Enable','on');

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
set(handles.pushbutton12,'Enable','on');
set(handles.pushbutton13,'Enable','on');

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
set(handles.pushbutton12,'Enable','on');
set(handles.pushbutton13,'Enable','on');
        
    cd(pathname);
    %disp(pathname);
    cd ('..\..\..\..\..\GUI\Monsij');


function [BW_mask_F,mask_F,rt_boundary_col,lt_boundary_col,upper_boundary_row,lower_boundary_row]=face_detect_new( I_F,nameFolds,op_img1 )
     I_F_n=((I_F-min(I_F(:)))/(max(I_F(:))-min(I_F(:))))*255; % Normalizing the Face Image to the range [0,255].
    [level,criterion]=kittlerMinimimErrorThresholding(I_F_n); % Computing threshold using Minimum Error Thresholding Segmentation.
    BW = im2bw(I_F_n/255,level/255); % Obtain the binary version of the face image after thresholding.
    BW=imfill(BW,'holes'); % Fill the holes 
    mask_F=I_F_n.*double(BW); % Convolving the thresholded mask with the original face image, to obtain the Face Mask
    mask_F=mat2gray(mask_F); 
    
    %% Boundary Formation
    Ph=[]; %Horizontal Projection Vector.
    Pv=[]; % Vertical Projection Vector.
    [row,col]=find (mask_F>0);
    % Computing Boundaries of the Face Mask     
    rmin=min(row);
    rmax=max(row);
    cmin=min(col);
    cmax=max(col);%%%%%%%%%%%%rmin and rmax are the first nonzero row and last non zero row
    
    % Finding the horizontal projection  
    for i=1:rmax
       Ph(i)=sum(mask_F(i,:)); % This section is for finding upper row boundary
    end
    
    Fx=gradient(Ph); % Compute the gradient for horizontal projection.
    %  Finding the most  prominent point to detect minimum row of face 
    [pks,locs,w,p]=findpeaks(Fx);  
    face_detect_min_r=locs(1); % Most Prominent Peak Obtained
       
    % Finding the Column Boundaries of the Face
    % Compute Vertical Projection
    for i=cmin:cmax
        Pv(i)=sum(mask_F(:,i));
    end
    
    Fy=gradient(Pv);  % Compute the gradient for vertical projection.
    % Finding the Left face boundary                                     
    Fy_c=imboxfilt(Fy,21);
    th_right=floor((1/2).*max(abs(Fy_c))); % Setting a threshold for the gradient of vertical projection
    c1=find(Fy_c>th_right);
    Fy_c1=imboxfilt(Fy(length(Fy):-1:1),21); % Reversing the vector
    th_left=floor((1/2).*max(abs(Fy_c1))); % Setting a threshold for the gradient of vertical projection
    % Finding the most  prominent point to detect minimum row of face 
    c2=find(abs(Fy_c1)>th_left);
    c2=length(Fy)-c2;
    if isempty(c1)==isempty([])
    c1(1)=cmin;
    end
    if isempty(c2)==isempty([])
    c2(1)=cmax;
    end
    %Boundary points of face
    rt_boundary_col=c1(1);
    lt_boundary_col=c2(1);
    upper_boundary_row=face_detect_min_r;
%     row_traverse=1;
%% FACE BOUNDARY Adjustments
count=1;
while(count==1)
    row_traverse=1;
    while(BW(row_traverse,rt_boundary_col)==0&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
    end
     while(BW(row_traverse,rt_boundary_col)==1&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
        count=1;
     end
     while(BW(row_traverse,rt_boundary_col)==0&&row_traverse~=size(BW,1))%%%%%%
        row_traverse=row_traverse+1;
        count=2;
     end
     if(count==1)
    rt_boundary_col=rt_boundary_col+1;
     end
end

    count=1;
while(count==1)
    row_traverse=1;
    while(BW(row_traverse,lt_boundary_col)==0&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
    end
     while(BW(row_traverse,lt_boundary_col)==1&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
        count=1;
     end
     while(BW(row_traverse,lt_boundary_col)==0&&row_traverse~=size(BW,1))
        row_traverse=row_traverse+1;
        count=2;
     end
     if(count==1)
    lt_boundary_col=lt_boundary_col-1;
     end
end
%% Face Cropping-Initial
% Cropping the face based on te 3 obtained boundaries.
    for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if(j>((rt_boundary_col)) && j<((lt_boundary_col)) && (i>upper_boundary_row))   %FRONTAL
                BW_mask_F(i,j)=mask_F(i,j);
            else
                BW_mask_F(i,j)=0;
            end
        end
    end
%% Harris Corner Detection
xmin1=rmax-ceil(0.3*(rmax-rmin)) ;I_new1=BW_mask_F(xmin1:end,(rt_boundary_col+1):(lt_boundary_col-1)); % Modified Image with updated boundaries
C=corner(I_new1); % Harris Corners Obtained
face_detect_max_r=median(C(:,2)); % Considering the median of all the obtained Harris corners
face_detect_max_r=face_detect_max_r+xmin1; % Addign the offset
lower_boundary_row=face_detect_max_r;
                                          

%% Face Cropping
for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if((j>rt_boundary_col) && j<((lt_boundary_col)) && (i>upper_boundary_row) && (i<lower_boundary_row))   %FRONTAL
                BW_mask_F(i,j)=BW(i,j);
            else
                BW_mask_F(i,j)=0;
            end
        end
end
    BW_mask_F=imfill(BW_mask_F,'holes'); 
return


function  [e_row, e_col, g_row, g_col]= upper_nose( chin_row, chin_col,tip_row,tip_col,mask,u_b)

[row, col] = size(mask);


dist = sqrt(abs(chin_row-tip_row)^2+abs(chin_col-tip_col)^2);

dist = round(dist);

        e_row = tip_row ;
        e_col = tip_col-1;

for r = tip_row-1 :-1: tip_row-abs(tip_row-chin_row)

     c = find_first(r, mask);
      e_row=r; % uncomment to include the corner cases. 
      e_col=c; 
    temp=round(sqrt(abs(r-tip_row)^2+abs(c-tip_col)^2));
    if temp > dist && temp < dist+5
        
        e_row = r;
        e_col = c;
        break;
    end
end
%  e_row = tip_row-abs(tip_row-chin_row);
%  e_col = find_first(e_row, mask);

%     %%%(e_row, c_col) second point
%     %%%(tip_row,tip_col) first point
%     
      m = (tip_row- e_row)/(tip_col-e_col);
      m = -m;
      angle = atand(m);
    
      k = e_row - m * e_col;
     
%%%%%%%%%%%%%%%% shift the mask to center,(240,310)
shift_row = 240 - tip_row;
shift_col = 310 - tip_col;
orgmask = mask;
mask = imtranslate(mask ,[shift_col,shift_row]);
%figure,imshow(mask);
%rotate to make ther nose eye plane perpendicular
mask=imrotate(mask,90-angle,'nearest','crop');
%figure,imshow(mask);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% find the max dist
[row, col] = size(mask);

cmax= 0;rmax=0;
% t=round(abs(dist*cos(angle)));
for r = abs(row/2):-1:abs(row/2)-dist
     
       c = find_first(r, mask);
       if c > cmax
     
       cmax = c;
       rmax = r;
     
       end
     
end

%%% max and cmax are untransformed point eye canthus.

dist = round( sqrt(abs(rmax-240)^2+abs(cmax-310)^2));

mask = orgmask;

g_row=240;
g_col=310;
for r = tip_row-1 :-1: tip_row-dist
       
       c = find_first(r, mask);
       temp=round(sqrt((r-tip_row)^2+(c-tip_col)^2));
       if temp > dist && temp < dist+5
        
        g_row = r;
        g_col = c;
        break;
       end

     

end


















function [ find_r_min_lt_index,mean_eye_brow_row_number,row_rt_plot,row_lt_plot,col_rt_plot,col_lt_plot ] = eye_detection_thermal( face_img )
%% Documentation
%
% Called by funtion: Try_Anova_New_Code.m
% Functions called in this fn: modified_min_det.m
% i/p parameters to the fn: face_img ( The input image )
% o/p parameters of the fn: find_r_min_lt_index
%                           mean_eye_brow_row_number
%                           row_rt_plot
%                           row_lt_plot
%                           col_rt_plot
%                           col_lt_plot

% Variable names:
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. number_of_splits :: Number of sampled columns on each side of the face
%                    2. offset_eye_max :: Offset to detect the maximum row for eye
%                    3. lt_eye :: Left half of the image
%                    4. rt_eye :: Right half of the image
%                    5. find_r_min_lt :: Vector containing the ending of hair pixels on the left face
%                    6. find_r_min_rt :: Vector containing the ending of hair pixels on the right face
%                    7. find_r_min_lt_index :: Variable containing the ending of hair pixels on the left face
%                    8. find_r_min_rt_index :: Variable containing the ending of hair pixels on the right face
%                    9. find_col_lt :: Vector containing the selected columns on the left face
%                   10. find_col_rt :: Vector containing the selected columns on the right face
%                   11. r_eye_lt_region_max :: r_max is computed to be 40% from the modified r_min of left half
%                   12. r_eye_rt_region_max :: r_max is computed to be 40% from the modified r_min of right half
%                   13. count_eye_lt :: Array Counter
%                   14. col_data_lt :: Row components of the sampled columns
%                   15. col_gradient_lt :: Gradient of the smapled column
%                   16. col_gradient_0_lt :: Non zero component of the gradient of the smapled column
%                   17. pks,locs,w,prominence :: findpeaks return variables to identify prominent peaks
%                   18. p_loc_lt :: Identify the location of the prominent peak of the gradient
%                   19. c_lt :: The corresponding location in the face_img
%                   20. eye_brow_row_lt :: ID the location of the eyebrow row for each column
%                   21. eye_brow_value :: The intensity of the eyebrow pixel for each column
%                   22. mean_eye_brow_row_lt :: Mean of the eye_brow points for all the sampled columns
%                   23. diff_lt :: Compute the differences of points from mean
%                   24. eye_brow_new_lt :: Eye brow points after rejecting the spurious points
%                   25. freq_lt :: Number of unique elements in the array
%                   26. eye_brow_top_lt_row :: The identified eyebrow row
%                   27. r_eye_lt_region_max :: Maximum row for eye detection
%                   28. eye_region_lt :: Image containing the eye region
%                   29. row_lt_plot :: Row component of the hotspot
%                   30. col_lt_plot :: Column component of the hotspot
%                   31. mean_row_plot :: Averaged eye row.

%% Constants
number_of_splits=5;
offset_eye_max=65;             % offset to detect the maximum row for eye
[r,c]=find(face_img>0);
cmin=min(c);
cmax=max(c);
cmid=ceil((cmax+cmin)/2);
%% Identifying eyebrows
% Working: Find the hair line pixels and the corresponding vectors. From the sampled columns, find the non zero
%                components of the gradient of each columns. Identify the most prominent peak of each column. Remove the
%                spurious points in the eye_brow_vector. This is done by computing the mean of the eyebrow points and computing
%                the difference of all other points in the vector. The unwritten assumption is that the number of spurious points
%                is less than that of the required points. Based on the difference vector, the maximum of number of +ve and -ve points
%                are computed. In the first case, the spurious points lie above the eye brow. hence reject the points causing negative
%                differences. And amongst the other points, choose the minimum. In the other case, choose the maximum. Thus the eyebrows
%                are detected. Set an offset of 65 pixels to identify the eye region. Determine the maximum in that region which points to
%                the corner of the eye.
% Left Face
[lt_eye,rt_eye,find_r_min_lt,find_r_min_rt,find_r_min_lt_index,find_r_min_rt_index,find_col_lt,find_col_rt,r_eye_lt_region_max,r_eye_rt_region_max] = modified_min_det( face_img ); % this fn is for finding the modified row which is to remove the hair and strt the row of the face from below hair. This fn also returns the search area to locate eye
count_eye_lt=1;
mean_r_eye_region_max=ceil((r_eye_lt_region_max+r_eye_rt_region_max)/2);
if mean_r_eye_region_max<(find_r_min_lt_index+50)
    temp_find_r_min_lt_index=find_r_min_lt_index; %this is just to start searching the eyes a little lower than modified min row
    temp_find_r_min_rt_index=find_r_min_rt_index;  %this is just to start searching the eyes a little lower than modified min row
else    
temp_find_r_min_lt_index=find_r_min_lt_index+50; %this is just to start searching the eyes a little lower than modified min row
temp_find_r_min_rt_index=find_r_min_rt_index+50;  %this is just to start searching the eyes a little lower than modified min row
end
for index=1:size(find_r_min_lt,2)
    c_lt=[];
    col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,find_col_lt(index)-cmid); % Segment only the required region
    col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
    row_0=find(col_gradient_lt~=0); % ID the first non zero number
    col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.
    

    if (index==1 && isempty(col_gradient_0_lt))
        find_col_lt_modify=find_col_lt(index)-5;
        while(isempty(col_gradient_0_lt))
            
            col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,find_col_lt_modify(index)-cmid); % Segment only the required region
            col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
            row_0=find(col_gradient_lt~=0); % ID the first non zero number
            col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.
            find_col_lt_modify=find_col_lt_modify-5;
        end
        
        
    elseif(index~=1 && isempty(col_gradient_0_lt))
        col_data_lt=lt_eye(temp_find_r_min_lt_index:mean_r_eye_region_max,find_col_lt(Prev_index)-cmid); % Segment only the required region
        col_gradient_lt=gradient(col_data_lt); % Compute the Gradient
        row_0=find(col_gradient_lt~=0); % ID the first non zero number
        col_gradient_0_lt=col_gradient_lt(min(row_0):end); % Store in a new array.
    else
        Prev_index=index;
    end
    
    
    
    [pks,locs,w,prominence]=findpeaks(col_gradient_0_lt);
    
    
    p_loc_lt=find(max(prominence)==prominence,1);
    c_lt=min(locs(p_loc_lt));
    eye_brow_row_lt(count_eye_lt)=c_lt;
    eye_brow_row_lt(count_eye_lt)= eye_brow_row_lt(count_eye_lt)+temp_find_r_min_lt_index; % Compute the Offset
    eye_brow_value(count_eye_lt)=lt_eye(eye_brow_row_lt(count_eye_lt),find_col_lt(index)-cmid); % The corresponding intensity
    count_eye_lt=count_eye_lt+1; % Updating the array
end
% Removing Spurious EyeBrow_row points
mean_eye_brow_row_lt=floor(mean(eye_brow_row_lt(1:number_of_splits))); %Compute the mean of the obtained rows
% Compute the differences from mean
for ide=1:number_of_splits
    diff_lt(ide)=eye_brow_row_lt(ide)-mean_eye_brow_row_lt;
end
eye_brow_new_lt=[];
repetition_count_lt=0; % Keep track of repititions while deleting
row_P_lt=find(diff_lt>0); % ID the number of positive differences

if size(row_P_lt,2)>(number_of_splits-size(row_P_lt,2)) % If true, Negative differences are the Spurious Points ( to be deleted )
    row_N_lt=find(diff_lt<=0); % ID the number of negative differences
    freq_lt=unique(diff_lt(row_N_lt)); % ID the unique elements amongst the negative differences that are to be deleted
    eye_brow_new_lt=eye_brow_row_lt;
    for ind=1:size(freq_lt,2)
        eye_brow_new_lt = eye_brow_new_lt(eye_brow_new_lt~=eye_brow_new_lt(row_N_lt(ind)-repetition_count_lt)); % Delete the Spurious Points
        if(ind>0)
            repetition_count_lt=1; % To traverse to correct element in row_N_lt after deletion
        end
    end
    eye_brow_top_lt_row=min(eye_brow_new_lt); % Minimum of the true points gives eye brow row
    
else                                                  % If true, Positive differences are the Spurious Points ( to be deleted )
    eye_brow_new_lt=eye_brow_row_lt;
    freq_lt=unique(diff_lt(row_P_lt));% ID the unique elements amongst the positive differences that are to be deleted
    for ind=1:(size(freq_lt,2))
        eye_brow_new_lt = eye_brow_new_lt(eye_brow_new_lt~=eye_brow_new_lt(row_P_lt(ind)-repetition_count_lt));  % Delete the Spurious Points
        if(ind>0)
            repetition_count_lt=1;% To traverse to correct element in row_P_lt after deletion
        end
    end
    eye_brow_top_lt_row=max(eye_brow_new_lt); % Maximum of the true points gives eye brow row
    
end
% Right Face
count_eye_rt=1;
for index=1:size(find_r_min_rt,2)
    c_rt=[];
    col_data_rt=rt_eye(temp_find_r_min_rt_index:mean_r_eye_region_max,find_col_rt(index)-cmin); % Segment only the required region
    col_gradient_rt=gradient(col_data_rt); % Compute the Gradient
    row_0=find(col_gradient_rt~=0);% ID the first non zero number
    col_gradient_0_rt=col_gradient_rt(min(row_0):end);% Store in a new array.
    if (index==1 && isempty(col_gradient_0_rt))
        while(isempty(col_gradient_0_rt))
            find_col_rt_modify=find_col_rt(index)+5;
            col_data_rt=rt_eye(temp_find_r_min_rt_index:mean_r_eye_region_max,find_col_rt_modify(index)-cmin); % Segment only the required region
            col_gradient_rt=gradient(col_data_rt); % Compute the Gradient
            row_0=find(col_gradient_rt~=0);% ID the first non zero number
            col_gradient_0_rt=col_gradient_rt(min(row_0):end);% Store in a new array.
        end
    elseif(index~=1 && isempty(col_gradient_0_rt))
        col_data_rt=rt_eye(temp_find_r_min_rt_index:mean_r_eye_region_max,find_col_rt(Prev_index)-cmin); % Segment only the required region
        col_gradient_rt=gradient(col_data_rt); % Compute the Gradient
        row_0=find(col_gradient_rt~=0);% ID the first non zero number
        col_gradient_0_rt=col_gradient_rt(min(row_0):end);% Store in a new array.
    else
        Prev_index=index;
    end
    
    
    
    [pks,locs,w,prominence]=findpeaks(col_gradient_0_rt);
    p_loc_rt=find(max(prominence)==prominence,1);
    c_rt=locs(p_loc_rt);
    eye_brow_row_rt(count_eye_rt)=c_rt;
    eye_brow_row_rt(count_eye_rt)= eye_brow_row_rt(count_eye_rt)+temp_find_r_min_rt_index;% Compute the Offset
    eye_brow_value_rt(count_eye_rt)=rt_eye(eye_brow_row_rt(count_eye_rt),find_col_rt(index)-cmin);% The corresponding intensity
    count_eye_rt=count_eye_rt+1; % Update the array
end
% Removing Spurious EyeBrow_row points
mean_eye_brow_row_rt=floor(mean(eye_brow_row_rt(1:number_of_splits)));
% Compute the differences from mean
for ide=1:number_of_splits
    diff_rt(ide)=eye_brow_row_rt(ide)-mean_eye_brow_row_rt;
end

eye_brow_new_rt=[];
row_P_rt=find(diff_rt>0);  % ID the number of positive differences
repetition_count_rt=0; % Keep track of repititions while deleting

if size(row_P_rt,2)>(number_of_splits-size(row_P_rt,2))  % If true, Negative differences are the Spurious Points ( to be deleted )
    row_N_rt=find(diff_rt<=0); % ID the number of negative differences
    freq_rt=unique(diff_rt(row_N_rt)); % ID the unique elements amongst the negative differences that are to be deleted
    eye_brow_new_rt=eye_brow_row_rt;
    for ind=1:size(freq_rt,2)
        eye_brow_new_rt = eye_brow_new_rt(eye_brow_new_rt~=eye_brow_new_rt(row_N_rt(ind)-repetition_count_rt));  % Delete the Spurious Points
        if(ind>0)
            repetition_count_rt=1;  % To traverse to correct element in row_N_lt after deletion
        end
    end
    eye_brow_top_rt_row=min(eye_brow_new_rt); % Minimum of the true points gives eye brow row
else
    freq_rt=unique(diff_rt(row_P_rt)); % ID the unique elements amongst the positive differences that are to be deleted
    eye_brow_new_rt=eye_brow_row_rt;
    for ind=1:size(freq_rt,2)
        eye_brow_new_rt = eye_brow_new_rt(eye_brow_new_rt~=eye_brow_new_rt(row_P_rt(ind)-repetition_count_rt)); % Delete the Spurious Points
        if(ind>0)
            repetition_count_rt=1; % To traverse to correct element in row_N_lt after deletion
        end
    end
    eye_brow_top_rt_row=max(eye_brow_new_rt); % Maximum of the true points gives eye brow row
end

% Select the Eye Region from eyebrows to the pre defined offset
mean_eye_brow_row_number=ceil((eye_brow_top_lt_row+eye_brow_top_rt_row)/2);
r_eye_rt_region_max=mean_eye_brow_row_number+offset_eye_max;
eye_region_rt=rt_eye(mean_eye_brow_row_number:r_eye_rt_region_max,find_col_rt(number_of_splits)-cmin:cmid-cmin);  % Final Right eye Segmented Image.

% Select the Eye Region from eyebrows to the pre defined offset
r_eye_lt_region_max=mean_eye_brow_row_number+offset_eye_max;
eye_region_lt=lt_eye(mean_eye_brow_row_number:r_eye_lt_region_max,1:find_col_lt(number_of_splits)-cmid); % Final Left eye Segmented Image.

%% Finding Eye Hotspots
% ID the hotspots in each of the segmented images
rt_max=sort(eye_region_rt(:),'descend');
rt_max=rt_max(1);
[rt_max_r,rt_max_c]=find(rt_max==eye_region_rt);
lt_max=sort(eye_region_lt(:),'descend');
lt_max=lt_max(1);
[lt_max_r,lt_max_c]=find(lt_max==eye_region_lt);

% Compute the offsets
row_rt_plot=min(rt_max_r+eye_brow_top_rt_row);
row_lt_plot=min(lt_max_r+eye_brow_top_lt_row);
col_rt_plot=min(rt_max_c+find_col_rt(number_of_splits));
col_lt_plot=min(lt_max_c+cmid);

% In order to prevent spurious identification, we perform this check
% check difference between cols. of rt and lt eye. If difference is
% less then threshold that means the lt and rt eye detected pts
% overlaped then consider finding the second maximum pt
idx_lt=2;
idx_rt=2;
diff_col_rtandlt_eye= abs(col_lt_plot-col_rt_plot);
while (diff_col_rtandlt_eye < 40)
    if (col_lt_plot<col_rt_plot | col_lt_plot==col_rt_plot )
        rt_max=sort(eye_region_rt(:),'descend');
        rt_max=rt_max(1);
        [rt_max_r,rt_max_c]=find(rt_max==eye_region_rt);
        lt_max=sort(eye_region_lt(:),'descend');
        lt_max=lt_max(idx_lt);
        idx_lt=idx_lt+1;
        [lt_max_r,lt_max_c]=find(lt_max==eye_region_lt);
        
        % Compute the offsets
        row_rt_plot=min(rt_max_r+eye_brow_top_rt_row);
        row_lt_plot=min(lt_max_r+eye_brow_top_lt_row);
        col_rt_plot=min(rt_max_c+find_col_rt(number_of_splits));
        col_lt_plot=min(lt_max_c+cmid);
    end
    if (col_rt_plot<col_lt_plot)
        rt_max=sort(eye_region_rt(:),'descend');
        rt_max=rt_max(idx_rt);
        idx_rt=idx_rt+1;
        [rt_max_r,rt_max_c]=find(rt_max==eye_region_rt);
        lt_max=sort(eye_region_lt(:),'descend');
        lt_max=lt_max(1);
        [lt_max_r,lt_max_c]=find(lt_max==eye_region_lt);
        
        % Compute the offsets
        row_rt_plot=min(rt_max_r+eye_brow_top_rt_row);
        row_lt_plot=min(lt_max_r+eye_brow_top_lt_row);
        col_rt_plot=min(rt_max_c+find_col_rt(number_of_splits));
        col_lt_plot=min(lt_max_c+cmid);
    end
    diff_col_rtandlt_eye= abs(col_lt_plot-col_rt_plot);
end


% Aligning the rows

mean_row_plot=ceil((row_rt_plot+row_lt_plot)/2);
row_rt_plot=mean_row_plot;
row_lt_plot=mean_row_plot;
return


function [ lt_eye,rt_eye,find_r_min_lt,find_r_min_rt,find_r_min_lt_index,find_r_min_rt_index,find_col_lt,find_col_rt,r_eye_lt_region_max,r_eye_rt_region_max] = modified_min_det( face_img )
%% Documentation
% modified_min_det:-
% Called by funtion          : face_detect.m
% Functions called in this fn: Nil
% i/p parameters to the fn   : face_img ( The input image )
% o/p parameters of the fn   : mean_find_r_min_index ( modified_r_min )
%                              
% Variable names: 
%                    1. reduced_face_img :: First 30% of the face_img
%                    2. red_r :: Vector consisting of rows of Non Zeroes pixels
%                    3. red_c :: Vector consisting of rows of Non Zeroes pixels  
%                    4. reduced_cmin :: Minimum of the red_c vector
%                    5. reduced_cmax :: Maximum of the red_c vector
%                    6. number_of_splits :: Number of column selections on either sides                  
%                    7. offset_eye_max :: Offset to detect the maximum row for eye
%                    8. th_rmin :: Threshold for segmenting hair pixels 
%                    9. c_lt_1 :: Contains data of sampled columns of left face                     
%                   10. c_rt_1 :: Contains data of sampled columns of right face  
%                   11. rt_eye :: Right half of the image
%                   12. lt_eye :: Left half of the image
%                   13. find_c1_rt :: The point satisfying the threshold in a particular column in the right face
%                   14. find_c1_lt :: The point satisfying the threshold in a particular column in the right face
%                   15. find_col_lt :: Vector containing the selected columns on the right face
%                   16. find_col_rt :: Vector containing the selected columns on the left face
%                   17. find_r_min_lt :: Vector containing the ending of hair pixels on the right face
%                   18. find_r_min_rt ::  Vector containing the ending of hair pixels on the right face
%                   19. r_eye_lt_region_max :: r_max is computed to be 40% from the modified r_min of each half
%                   20. r_eye_rt_region_max :: r_max is computed to be 40% from the modified r_min of each half
%                   21. mean_find_r_min_index :: modified_r_min-Avoiding the hair pixels
%% Finding the modified_r_min
     [row,col]=find (face_img>0);
     rmin=min(row);
     cmin=min(col);
     rmax=max(row);
     cmax=max(col);
 
     cmid=ceil((cmax+cmin)/2);
     
     % cmid modification
     reduced_face_img=face_img(rmin:floor((1/3)*(rmax-rmin)+rmin),:);
     [reduce_r,reduce_c]=find(reduced_face_img>0);
     reduced_cmin=min(reduce_c);
     reduced_cmax=max(reduce_c);
     
     % Selecting the Columns for Processing each half image

     number_of_splits=5;            % Number of columns on either side of the face
    
     th_rmin=0.65;                  % Threshold is set for removal of hair
     
     c_lt_1=face_img(:,cmid+40);
     c_lt_2=face_img(:,cmid+45);
     c_lt_3=face_img(:,cmid+50);
     c_lt_4=face_img(:,cmid+55);
     c_lt_5=face_img(:,cmid+60);
     
     c_rt_1=face_img(:,cmid-40);
     c_rt_2=face_img(:,cmid-45);
     c_rt_3=face_img(:,cmid-50);
     c_rt_4=face_img(:,cmid-55);
     c_rt_5=face_img(:,cmid-60);
     
     %Splitting the image into two halfs
     
     rt_eye=face_img(:,(cmin:cmid));        % Right Part of Face
     lt_eye=face_img(:,((cmid+1):cmax));    % Left Part of Face
     
%%   Determining the modified r_min 

    % For Left Face
     
     find_c1_lt=find(c_lt_1>th_rmin);
     if isempty(find_c1_lt)==isempty([])
        find_c1_lt=rmin;
     end   
     find_c1_lt=find_c1_lt(1);
     %
     find_c2_lt=find(c_lt_2>th_rmin);
     if isempty(find_c2_lt)==isempty([])
        find_c2_lt=find_c1_lt;
     end 
     find_c2_lt=find_c2_lt(1);
     %
     find_c3_lt=find(c_lt_3>th_rmin);
     if isempty(find_c3_lt)==isempty([])
       find_c3_lt=find_c2_lt;
     end
     find_c3_lt=find_c3_lt(1);
     %
     find_c4_lt=find(c_lt_4>th_rmin);
     if isempty(find_c4_lt)==isempty([])
       find_c4_lt=find_c3_lt;
     end
     find_c4_lt=find_c4_lt(1);
     %
     find_c5_lt=find(c_lt_5>th_rmin);
     if isempty(find_c5_lt)==isempty([])
       find_c5_lt=find_c4_lt;
     end
     find_c5_lt=find_c5_lt(1);
     
      % Right Face
     find_c1_rt=find(c_rt_1>th_rmin);
     if isempty(find_c1_rt)==isempty([])
        find_c1_rt=rmin;
     end
     find_c1_rt=find_c1_rt(1);
     %
     find_c2_rt=find(c_rt_2>th_rmin);
     if isempty(find_c2_rt)==isempty([])
        find_c2_rt=find_c1_rt;
     end 
     find_c2_rt=find_c2_rt(1);
     %
     find_c3_rt=find(c_rt_3>th_rmin);
     if isempty(find_c3_rt)==isempty([])
       find_c3_rt=find_c2_rt;
     end
     find_c3_rt=find_c3_rt(1);
     %
     find_c4_rt=find(c_rt_4>th_rmin);
     if isempty(find_c4_rt)==isempty([])
       find_c4_rt=find_c3_rt;
     end
     find_c4_rt=find_c4_rt(1);
     %
     find_c5_rt=find(c_rt_5>th_rmin);
     if isempty(find_c5_rt)==isempty([])
       find_c5_rt=find_c4_rt;
     end
     find_c5_rt=find_c5_rt(1);
     
     % Determined Columns for Left Face
     
     col1=cmid+40;
     col2=cmid+45;
     col3=cmid+50;
     col4=cmid+55;
     col5=cmid+60;
     find_col_lt=[col1 col2 col3 col4 col5];
     
     % Determined Columns for Right Face
      
     col1=cmid-40;
     col2=cmid-45;
     col3=cmid-50;
     col4=cmid-55;
     col5=cmid-60;
     find_col_rt=[col1 col2 col3 col4 col5];
      
     % Modified r_min is computed for each half of the face separately by
     % identifying the maximum from the set of points satisfying the
     % threshold
     
     find_r_min_lt=[find_c1_lt find_c2_lt find_c3_lt find_c4_lt find_c5_lt ];
     
     find_r_min_rt=[find_c1_rt find_c2_rt find_c3_rt find_c4_rt find_c5_rt ];

     find_r_min_lt_index=max(find_r_min_lt);
         
     find_r_min_rt_index=max(find_r_min_rt);
     
     % r_max is computed to be 40% from the modified r_min of each half
     
     r_eye_lt_region_max=ceil((rmax-find_r_min_lt_index)*(1/2.5))+find_r_min_lt_index;
      
     r_eye_rt_region_max=ceil((rmax-find_r_min_rt_index)*(1/2.5))+find_r_min_rt_index;

     mean_find_r_min_index=ceil((find_r_min_lt_index+find_r_min_rt_index)/2);
return


% --- Executes on button press in evaluate.


function [r_lt,c_lt,r_rt,c_rt] = nose_detection( face_img,modified_min_row_nose,mean_eye_brow_row,req_row,col_rt_eye,col_lt_eye,req_col_mouth_lt,req_col_mouth_rt)
%% Documentation
% % Functions called in this fn: Nil
% i/p parameters to the fn:  face_img, 
%                            modified_min_row_nose 
%                            mean_eye_brow_row 
%                            req_row 
%                            col_rt_eye 
%                            col_lt_eye 
%                            req_col_mouth_lt
%                            req_col_mouth_rt
% o/p parameters of the fn:  r_lt 
%                            c_lt
%                            r_rt
%                            c_rt

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. modified_min_row_nose :: Specifies the modified upper boundary for Nose Region
%                    2. req_row :: Row between Nose and Mouth.
%                    3. nose_right_img :: Search Region for Right Nose. 
%                    4. nose_left_img :: Search Region for Left Nose.
%                    5. new_nose_right_img :: Search region for Right Nose after gamma correction
%                    6. new_nose_left_img :: Search region for Left Nose after gamma correction
%                    7. the_edge_rt :: Binary Images with marked Edges.
%                    8. r_rt :: Contains row coord. of right nose edges.
%                    9. c_rt :: Contains col coord. of right nose edges.
%                   10. the_edge_lt :: Binary Images with marked Edges.
%                   11. r_lt :: Contains row coord. of left nose edges.
%                   12. c_lt :: Contains col coord. of left nose edges.
%% 
    modified_min_row_nose=floor(0.5*(req_row-modified_min_row_nose))+modified_min_row_nose; % Reduce the search area, redine teh upper boundary
    cmid=ceil((col_rt_eye+col_lt_eye)/2);
    nose_right_img=face_img( modified_min_row_nose:req_row, req_col_mouth_rt:cmid ); % Right Nose search region
    nose_left_img=face_img( modified_min_row_nose:req_row, cmid:req_col_mouth_lt ); % Left Nose Search Region
    c=2;
    g=25;
    % Apply Gamma Correction, for enhancing the contrast.
    new_nose_right_img=c*nose_right_img.^g;
    new_nose_left_img=c*nose_left_img.^g;
    %% Right Nose
    I_rt=new_nose_right_img;
    the_edge_rt = edge(I_rt); % Detect the edges in the nose image. Binary Image obtained.
    count_rt=1;
    % r_rt and c_rt contains the row and column coordinates of all the detected edges. The loop
    % selects the extreme edges in each column.
    for i=1:size(new_nose_right_img,1)
        for j=1:size(new_nose_right_img,2)
            if(the_edge_rt(i,j)>0)
                r_rt(count_rt)=i;
                c_rt(count_rt)=j;
            end
        end
       array_rt=nonzeros(the_edge_rt(i,:));
       if isempty(array_rt)==isempty([]) 
           continue;
       else
           count_rt=count_rt+1;
       end
    end
    
    r_rt=r_rt+modified_min_row_nose; % Identifying indices, with added offsets.
    c_rt=c_rt+req_col_mouth_rt; % Identifying indices, with added offsets.
    %% Left Nose
    I_lt=new_nose_left_img;
    the_edge_lt = edge(I_lt); % Detect the edges in the nose image. Binary Image obtained.
    count_lt=1;
    % r_lt and c_lt contains the row and column coordinates of all the detected edges. The loop
    % selects the extreme edges in each column.
    for i=1:size(new_nose_left_img,1)
       for j=size(new_nose_left_img,2):-1:1
           if(the_edge_lt(i,j)>0)
                r_lt(count_lt)=i;
                c_lt(count_lt)=j;
           end
       end
       array_lt=nonzeros(the_edge_lt(i,:));
       if isempty(array_lt)==isempty([]) 
           continue;
       else
           count_lt=count_lt+1;
       end
    end
    
    r_lt=r_lt+modified_min_row_nose;% Identifying indices, with added offsets.
    c_lt=c_lt+cmid;% Identifying indices, with added offsets.
    
    c_loc_rt=find(min(c_rt)==c_rt); % Least Horizontal Coord gives the Right Nose extreme
    c_loc_lt=find(max(c_lt)==c_lt); % Maximum Horizontal Cood gives the Left Nose extreme
   
    r_lt=max(r_lt(c_loc_lt));
    c_lt=c_lt(c_loc_lt);
    r_rt=max(r_rt(c_loc_rt));
    c_rt=c_rt(c_loc_rt);

return


function [ mouth_row_index_req,lower_lip_row ] = mouth_row_detect( face_img,req_row,col_lt_eye,col_rt_eye,r_rt,row_rt_eye,req_col_mouth_rt,req_col_mouth_lt )
%% Documentation
% % Functions called in this fn: Nil

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. distance_1_3 :: Distance between row coord. of right nose and right eye canthus
%                    2. distance_3_5_eqn1 :: Row between Nose and Mouth.
%                    3. distance_3_5_eqn2 :: Search Region for Right Nose. 
%                    4. row_3_5_eqn1 :: Search Region for Left Nose.
%                    5. row_3_5_eqn2 :: Search region for Right Nose after gamma correction
%                    6. lower_lip_row :: Search region for Left Nose after gamma correction
%                    7. Mouth_Region_Image :: Binary Images with marked Edges.
%                    8. var_mouth :: Contains row coord. of right nose edges.
%                    9. c_rt :: Contains col coord. of right nose edges.
%                   10. the_edge_lt :: Binary Images with marked Edges.
%                   11. r_lt :: Contains row coord. of left nose edges.
%                   12. c_lt :: Contains col coord. of left nose edges.distance_1_2=col_lt_eye-col_rt_eye;
%                   13. distance_1_2 :: Distance bet. the R & L eye canthus
%% Working: The objective is to obtain the row coordinate of the mouth. The intuition is that the row between the lips is of uniform 
% variance and is significantly different from the adjacent rows. In order to restrict the search region, we model a regression parameter 
% to identify the lower lip row based on the distance between the eye and
% nose coordinates. The new search region is has the mouth column boundaries, req_row and lower_lip_row boundaries. Within this region,
% we check for the local minima in variace to obtain the mouth row coord.  

distance_1_2=col_lt_eye-col_rt_eye; % Eye Canthus Distance
distance_1_3=r_rt-row_rt_eye; % Distance between Nose and Eye Canthus.

distance_3_5_eqn1=0.83763*distance_1_2+4.9135; % Regression expression based on Eye Canthus distance.
distance_3_5_eqn2=0.86625*distance_1_3+2.3029; % Regression expression beased on distance between nose and eye.

row_3_5_eqn1=distance_3_5_eqn1+r_rt; % Obtaining the indices, adding offsets
row_3_5_eqn2=distance_3_5_eqn2+r_rt; % Obtaining the indices, adding offsets

lower_lip_row=ceil((row_3_5_eqn1+row_3_5_eqn2)/2); % Average of the regression outputs, yield the lower lip row for the new search region.

Mouth_Region_Image=face_img(req_row:lower_lip_row,req_col_mouth_rt:req_col_mouth_lt); % Search Region for Mouth 
Mouth_Region_Image = adapthisteq(Mouth_Region_Image); % enhance the contrast using CLAHE.

% Compute row-wise variance within the search window.
var_mouth=[];
for mouth_row_index=1:size(Mouth_Region_Image,1)
    var_mouth(mouth_row_index)=var(Mouth_Region_Image(mouth_row_index,:));
end
rev_var_mouth=var_mouth(length(var_mouth):-1:1); % Reversing the variance vector.
choice=1;
mouth_index=1;

% The objective is to reach the valley point. The first while loop skips to
% the peak point, if any and the second loop identifies the valley point.
% In order to ensure that no spurious valley points are identified, another
% check is performed below, in order to check its consistency. 
while(rev_var_mouth(mouth_index)<rev_var_mouth(mouth_index+1))
    mouth_index=mouth_index+1;
end
while(choice==1) % Breaks when a valley point is encountered.
    if(rev_var_mouth(mouth_index)-rev_var_mouth(mouth_index+1)>0)
        mouth_index=mouth_index+1;
    else
        if(rev_var_mouth(mouth_index+1)>rev_var_mouth(mouth_index) && rev_var_mouth(mouth_index+2) > rev_var_mouth(mouth_index))
            choice=0;
            mouth_row_index_req=mouth_index;
            break;
        else
            mouth_index=mouth_index+1;
        end
    end 
end

 mouth_row_index_req=length(var_mouth)-mouth_row_index_req; % Since the variance vector was reversed.
 mouth_row_index_req= mouth_row_index_req+req_row; % Adding the required offset.
return


function [ face_img ] = Connected_Components_Face( face_img,op_img1,lower_lip_row )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
max_face_img=max(face_img(:));
[face_img_max_X,face_img_max_Y]=find(face_img==max_face_img);
face_img_temp=face_img(1:lower_lip_row,:);
face_img_avg = mean( nonzeros(face_img_temp));
tolerance=(max_face_img-face_img_avg);
tolerance=ceil(10*tolerance)/10;
face_img_avg=ceil(10*face_img_avg)/10;
face_img_avg_mat=(face_img>0).*face_img_avg;
dist_face_img_and_faceimgavg=abs(face_img-face_img_avg_mat);
[x_dist_face_img_and_faceimgavg,y_dist_face_img_and_faceimgavg]=find(dist_face_img_and_faceimgavg==min(nonzeros(dist_face_img_and_faceimgavg(:))));

BW_face_img = grayconnected(face_img,x_dist_face_img_and_faceimgavg(1),y_dist_face_img_and_faceimgavg(1),tolerance);

BW_face_img=imfill(BW_face_img,'holes');
face_img=face_img.*(BW_face_img);
% figure, imshow (face_img,[]);

new_face_region=strcat(op_img1,'_face_segmented');
return

function [ face_region,mid_mouth,face_keypt_X,face_keypt_Y ] = Hull_Mask( face_img,req_col_mouth_rt,req_col_mouth_lt,c_rt,c_lt,r_rt,r_lt,mouth_row_index_req,lower_lip_row )
%% Documentation
% % Functions called in this fn: Nil
% i/p parameters to the fn:  face_img, 
%                            req_col_mouth_rt 
%                            req_col_mouth_lt 
%                            c_rt, r_rt 
%                            c_lt, r_lt 
%                            col_lt_eye 
%                            mouth_row_index_req
%                            lower_lip_row
% o/p parameters of the fn:  face_region 
%                            

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. face_keypt_X :: Contains the col coord of Hull pts.
%                    2. face_keypt_Y :: Contains the row coord of Hull pts.
%                    3. BW :: Binary mask of the ROI 
%                    4. face_portion_masked :: Contains only the Hull region around the mouth.
%                    5. face_region :: Contains the req. face image with
%                    the region around the mouth blacked out.
%                  
%%
mid_mouth=ceil((req_col_mouth_rt+req_col_mouth_lt)/2);
[img_size_X,img_size_Y]=size(face_img); % Determining the size of the image
face_keypt_X=[c_rt(1)-20;c_lt(1)+20;req_col_mouth_lt+20;req_col_mouth_rt-20;mid_mouth]; % Column coordinates of the Hull Points
face_keypt_Y=[r_rt-20;r_lt-20;mouth_row_index_req;mouth_row_index_req;lower_lip_row+10]; % Row coordinates of the Hull Points
% face_keypt_X=[c_rt(1);c_lt(1);req_col_mouth_lt;req_col_mouth_rt;mid_mouth]; % Column coordinates of the Hull Points
% face_keypt_Y=[r_rt;r_lt;mouth_row_index_req;mouth_row_index_req;lower_lip_row]; % Row coordinates of the Hull Points

k = convhull(face_keypt_X,face_keypt_Y); % Formation of the convex Hull
BW = poly2mask(face_keypt_X(k),face_keypt_Y(k),img_size_X,img_size_Y); % Computing the Binary ROI for the region marked above.
face_portion_masked = bwconvhull(BW); % Contains only the Hull region around the mouth.
face_portion_masked=~face_portion_masked; 
face_portion_masked=double(face_portion_masked);
face_region = face_img.*face_portion_masked; % Convolving the original image with the marked mask to obtain the required ROI.
% figure;imshow(face_region);
% hold on;
% plot(face_keypt_X(k),face_keypt_Y(k),'r-',face_keypt_X,face_keypt_Y,'b*');title('Convhull of poly2mask')
return

function [ face_region1,Left_Img,Right_Img,Lower_eye_row,cmid ] = Lower_Eye_Regression( face_img,face_region,col_rt_eye,col_lt_eye,row_rt_eye,row_lt_eye,c_rt,c_lt,req_col_mouth_lt,req_col_mouth_rt )
%% Documentation0
% % Functions called in this fn: Nil
% i/p parameters to the fn:  face_img, 
%                            face_region 
%                            col_rt_eye 
%                            col_lt_eye 
%                            row_rt_eye 
%                            row_lt_eye 
%                            c_rt,c_lt,
%                            req_col_mouth_lt,req_col_mouth_rt
% o/p parameters of the fn:  Left_Img 
%                            Right_Img
%                            Lower_eye_row

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. Lower_right_eye :: Lower Eye Row for Right EYE
%                    2. Lower_left_eye :: Lower Eye Row for Left EYE
%                    3. Lower_eye_row :: Mean Lower Eye Row 
%                    4. Eye_dist :: Distance between R & L eye canthus
%                
%% Working: The objective is to remove the region above the eyes, as they 
% are not significant for oral cancer diagnosis. We determine the lower
% region of eye using regression based on the distance between the two eye
% canthus.
Eye_dist=col_lt_eye-col_rt_eye;
Lower_right_eye=0.09291*Eye_dist+6.1139+row_rt_eye; % Regression model for Right Eye
Lower_left_eye=0.1189*Eye_dist+2.6775+row_lt_eye; % Regression model for Left Eye
Lower_eye_row=ceil((Lower_right_eye+Lower_left_eye)/2); % Average of the above parameters.

[row,column]=find(face_img>0);
cmax=max(column);
cmin=min(column);

[img_size_X,img_size_Y]=size(face_img);

% Identifying the middle of the face.
c1mid=ceil((cmax+cmin)/2);  % Overall cmid using extremes of face.
c2mid=ceil((col_lt_eye+col_rt_eye)/2); % cmid using the L &R eye canthus locations
c3mid=ceil((c_rt(1)+c_lt(1))/2); % cmid using the R & L  nose locations
c4mid=ceil((req_col_mouth_lt+req_col_mouth_rt)/2); % cmid using the R & L mouth endpoint locations
cmid=ceil((c1mid+c2mid+c3mid+c4mid)/4); % Average of the above cmid's

face_region1=face_region;
face_region1(1:Lower_eye_row-10,:)=0; % Removing the region above the lower eye row, since they are not required for oral cancer diagnosis.

Left_Img=zeros(img_size_X,img_size_Y); % Computing the Left ROI
Right_Img=zeros(img_size_X,img_size_Y); % Computing the Right ROI


return


function [ optimalThreshold, J ] = kittlerMinimimErrorThresholding( img )
%KITTLERMINIMIMERRORTHRESHOLDING Compute an optimal image threshold.
%   Computes the Minimum Error Threshold as described in
%   
%   'J. Kittler and J. Illingworth, "Minimum Error Thresholding," Pattern
%   Recognition 19, 41-47 (1986)'.
%   
%   The image 'img' is expected to have integer values from 0 to 255.
%   'optimalThreshold' holds the found threshold. 'J' holds the values of
%   the criterion function.

%Initialize the criterion function
J = Inf * ones(255, 1);

%Compute the relative histogram
histogram = double(histc(img(:), 0:255)) / size(img(:), 1);

%Walk through every possible threshold. However, T is interpreted
%differently than in the paper. It is interpreted as the lower boundary of
%the second class of pixels rather than the upper boundary of the first
%class. That is, an intensity of value T is treated as being in the same
%class as higher intensities rather than lower intensities.
for T = 1:255

    %Split the hostogram at the threshold T.
    histogram1 = histogram(1:T);
    histogram2 = histogram((T+1):end);

    %Compute the number of pixels in the two classes.
    P1 = sum(histogram1);
    P2 = sum(histogram2);

    %Only continue if both classes contain at least one pixel.
    if (P1 > 0) && (P2 > 0)

        %Compute the standard deviations of the classes.
        mean1 = sum(histogram1 .* (1:T)') / P1;
        mean2 = sum(histogram2 .* (1:(256-T))') / P2;
        sigma1 = sqrt(sum(histogram1 .* (((1:T)' - mean1) .^2) ) / P1);
        sigma2 = sqrt(sum(histogram2 .* (((1:(256-T))' - mean2) .^2) ) / P2);

        %Only compute the criterion function if both classes contain at
        %least two intensity values.
        if (sigma1 > 0) && (sigma2 > 0)

            %Compute the criterion function.
            J(T) = 1 + 2 * (P1 * log(sigma1) + P2 * log(sigma2)) ...
                     - 2 * (P1 * log(P1) + P2 * log(P2));

        end
    end

end

%Find the minimum of J.
[~, optimalThreshold] = min(J);
optimalThreshold = optimalThreshold - 0.5;
return


% =========================== find_neck.m ====================================== %




function [slope, constant, neck_col, neck_row]=find_neck(org_mask)

 mask=org_mask;
 [rmax,cmax] = size(mask);
 count_min=1000000;


%1. Find the lowest row which has the white pixel in it
    ver_pro = sum(mask,2);
    for i=479:-1:1
      if ver_pro(i)>0 
        lowest_row=i; %lowest row is the last row upto which image is segmented 
        break;
      end
    end
    lowest_col = find_first(lowest_row,mask);
    
    
  c_=lowest_col;
%2. find the line with minimum white pixel count between two points
    for c = 1:5:c_
    % % (lowest_row, c) first point
    
        for f = lowest_row:-5:200%(why 200?, because we want to reduce the space of search)
        % % (f, 640) second point
    
        m = (f-lowest_row)/(640-c);
    
        k = lowest_row - m * c;
    
        mask = org_mask;
        count=0;
%     Count  the Number of white pixels in that line
        for col =c:1:640

           if( mask(round(m*col+k), col)==1)
           count=count+1;
           end

        end
% % 
% Get the slope and constatnt of the line with minimum sum
            if count<count_min && count>0

                count_min = count;
                slope=m;
                constant = k;
                c_start= c;
            end
    
    end
end
% % 
% cordinates where line intersect the face
    for col =c_start:1:640
        row=round(slope*col+constant);
        
       if (mask(row , col)==1)
       break;
       end
        
    end
% %

neck_col=col;
neck_row=round(slope*col+constant);
% mask(neck_row:480,:)=0;  
return



function [col] = find_first(row, mask)
  
 
    if row < size(mask,1)

         arr=mask(row,:);
         col = min(find(arr>0));
         if  size(col,2)==0
             col=640;
         end
    end   
    return

    
    
    function[y_cordinate, x_cordinate,BW,Index_ver_pro] = nose_tip(mask)

[~, col] = size(mask);

BW= mask;

%horizontal and vertical projection

horpro1= sum(BW,2); %vertical array
verpro= sum(BW,1);  
[max_ver_pro,Index_ver_pro]=max(verpro);

BW(:,Index_ver_pro:640)=0;  
horpro2 = sum(BW,2);
[max_hor_pro2,Indexnose]=max(horpro2);

arr=mask(Indexnose,:);

x_cordinate = min(find(arr>0));
y_cordinate = Indexnose;
return



function [canthus_r, canthus_c] = lateral_eyecanthus(mask,g_row,g_col,dist,csv)
 canthus_r=0;
 canthus_c=0;
 
    mask = csv .* double(mask);
    mask(:,g_col+round(dist/2):1:640)=0;
    mask(g_row-round(dist/5):-1:1,:)=0;
    mask(g_row+round(dist/5):1:480,:)=0;
    mew = mask(g_row-round(dist/5):1:g_row+round(dist/5),g_col:1:g_col+round(dist/3));
    
%   B = double(ones(5,5));
  B = fspecial('gaussian');
  mew = conv2(mew,B,'same');
  
  [I,J] = find(mew==max(max(mew)));
%   
%   I_v= std(I);
%   I=mean(I);
%   J_v= std(J);
%   J= mean(J);
%   I=I+I_v;
%   J=J+J_v;
%   
  canthus_r= I+g_row-round(dist/5);
  canthus_c=J+g_col;
 
 return
 
 
 
function [I, J]=nose_wing(tip_row,tip_col,mask,dist,csv)

    nw_row=0; 
    nw_col=0;
    mask(:,tip_col+round(dist):1:640)=0;
    mask(tip_row:-1:1,:)=0;
    mask(tip_row+round(dist/2):1:480,:)=0;
 
    temp = csv.*double(mask);
    
    %%% filter
    B = fspecial('gaussian');
    temp = conv2(temp,B,'same');
    maxval=max(max(temp));
    minval=min(min(temp(mask>0)));
    range=255/(maxval-minval);
    temp_1=range.*(temp-minval); 
    I1 = uint8(temp_1);
    
    [I,J] = find(I1==max(max(I1)));
    I=mean(I);
    J= mean(J);
return



function [ear_row, ear_col,mask,mask_temp] = ear_new(mask,tip_row,tip_col,chin_row, chin_col,e_row, e_col,csv,Index_ver_pro)
ear_row=0;
ear_col=0;

%  dist = round(sqrt(abs(chin_row-e_row)^2+abs(chin_col-e_col)^2));
 dist = round(chin_row-tip_row)/2;

% mask(:,tip_col+(dist/2):-1:1)=0;
% 
% mask(tip_row-.5*dist:-1:1,:)=0;
% 
% mask(tip_row+.5*dist:1:480,:)=0;

%  mask(:,tip_col+dist*2:-1:1)=0;  
 mask(:,Index_ver_pro:-1:1)=0;
 %mask(tip_row-dist:-1:1,:)=0; (MASKED)
 mask(floor(tip_row-dist):-1:1,:)=0;
 %mask(tip_row+dist:1:480,:)=0; (MASKED)
 mask(floor(tip_row+dist):1:480,:)=0;

    temp=csv.*double(mask);

    maxval=max(max(temp));
    minval=min(min(temp(mask>0)));
    range=255/(maxval-minval);
    temp_1=range.*(temp-minval); 
    temp_1= uint8(temp_1);
    %figure,imshow(temp_1);
 
    thres=maxval-(maxval-minval)*(.10);

    mask_temp = temp>thres; %%%mask_temp ear
    mask_temp = bwareafilt(logical(mask_temp),1);
    [I,J] = find(mask_temp==1);

    ear_row = mean(I);
    ear_col = mean(J)-dist/10;
return



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


% --- Executes on slider movement.
%function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider



% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=handles.filename;
pathname=handles.pathname;
p_id=filename(1:4);
alpha=p_id(1:1);
p_id_no=p_id(2:end);
next_p_id_no=p_id_no+1;
if alpha=='T'
   next_p_id=['T' next_p_id_no];

elseif alpha=='P'
   next_p_id=['P' next_p_id_no];

end
disp(next_p_id);
p_id=next_p_id;





% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
