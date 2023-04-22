
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

% Last Modified by GUIDE v2.5 23-Jun-2019 13:09:54

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
    set(handles.pushbutton3,'Enable','off');
    set(handles.pushbutton4,'Enable','off');
    set(handles.pushbutton5,'Enable','off');
    set(handles.pushbutton6,'Enable','off');
    
    
%load('D:\Documents\face\Monsij\Malignant\P0078\A_Profile_ROI_P0078\A_profile_Mask.mat');
%load('D:\Documents\face\Monsij\Malignant\P0078\A_ROI_Front_P0078\A_ROI_Front.mat');
    [filename, pathname] = uigetfile({'*.csv'},'File selector');
    %assignin('base','save_path',pathname);

    if filename==0
       set(handles.pushbutton3,'Enable','on');
       set(handles.pushbutton4,'Enable','on');
       set(handles.pushbutton5,'Enable','on');
       set(handles.pushbutton6,'Enable','on');
       f=msgbox('Upload an image');
       set(handles.pushbutton1,'Enable','on');
       
    end
    handles.filename = filename;
   
    handles.pathname = pathname;

    p_id = filename(1:4);
    set(handles.edit1,'String',p_id);
    
    

    csvNameRT = filename(1:4);
    right= xlsread([pathname,csvNameRT,'_rt.csv']);
    maxval = max(max(right));
    minval = min(min(right));
    range = 1/(maxval - minval);
    right = range .*(right - minval);
    axes(handles.axes1)
    imshow(right);
    imshow(right,[]);



  
    csvNameFT=filename(1:4);
    data=xlsread([pathname,csvNameFT,'.csv']);
    axes(handles.axes2);
    maxval = max(max(data));
    minval = min(min(data));
    range = 1/(maxval - minval);
    data = range .*(data - minval);
    axes(handles.axes2)
    imshow(data);
    imshow(data,[]);

    csvNameLT = filename(1:4);
    left= xlsread([pathname,csvNameLT,'_lt.csv']);
    %disp(left);
    maxval = max(max(left));
    minval = min(min(left));
    range = 1/(maxval - minval);
    left = range .*(left - minval);
    axes(handles.axes3)
    imshow(left);
    imshow(left,[]);


    
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
    I_F=xlsread(fullpath);
    I_F_cpy=I_F;
    op_img1=nameFolds(); % Storing Patient ID
    
    %%% take care of this part- directory change
    
    cd 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Face Detection';
    addpath 'D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Profile Face Detection';
    
    
    [BW_mask_F,mask_F,rt_boundary_col,lt_boundary_col,~,lower_boundary_row]=face_detect_new( I_F,nameFolds,op_img1 ); % Perform Face-Detection
  
    lower_boundary_row=floor(lower_boundary_row);
    I_F=mat2gray(I_F);
%     figure,imshow(I_f) % to show the original image
    face_img=(I_F).*double(BW_mask_F);% Convolving the face detected mask with the original image to obtain the face.
    
    disp('Face Detection - Completed')
    
    x=0.04;
    h=waitbar(x,'4% completed');
    %close(h);
    %% Eye Detection
    %  I/P = Detected Face Image (face_img)
    %  O/P = Coordinates of R & L eye canthus.
    %  Function Used = eye_detection_thermal.m
    disp('Eye Canthus Detection - Started');
    
    
    waitbar(x+0.04,h,'8% completed');
    %close(h);
    
    [modified_r_min,mean_eye_brow_row,row_rt_eye,row_lt_eye,col_rt_eye,col_lt_eye ] = eye_detection_thermal( face_img );
    disp('Eye Canthus Detection - Completed')
    
    %x=0.12;
    waitbar(x+0.08,h,'12% completed');
    %close(h);
    
    %% Mouth Detection
    %  I/P = Detected Face Image (face_img)
    %  O/P = Column Coordinates of R & L mouth extremes
    %  Function Used = mouth_detection.m
    
    disp('Mouth Endpoint Detection - Started');
    
    %x=0.16;
    waitbar(x+0.12,h,'16% completed');
    %close(h);
    
    [req_col_mouth_lt,req_col_mouth_rt,req_row,max_face_row,modified_min_row_nose] = mouth_detection( face_img,modified_r_min,row_lt_eye,row_rt_eye,col_lt_eye,col_rt_eye,mean_eye_brow_row);
    disp('Mouth Endpoint Detection - Completed');
    
    %x=0.2;
    waitbar(x+0.16,h,'20% completed');
    %close(h);
    
     %% Nose Detection
    %  I/P = Detected Face Image (face_img)
    %  O/P = Coordinates of R & L nose extremes.
    %  Function Used = nose_detection.m
    
    disp('Nose Detection - Started');
    
    %x=0.24;
    waitbar(x+0.2,h,'24% completed');
    %close(h);
    
    [r_lt,c_lt,r_rt,c_rt]=nose_detection( face_img,modified_min_row_nose,mean_eye_brow_row,req_row,col_rt_eye,col_lt_eye,req_col_mouth_lt,req_col_mouth_rt);
    disp('Nose Detection - Completed');
    
    %x=0.28;
    waitbar(x+0.24,h,'28% completed');
    %close(h);
    
    %% Mouth Row
    %  I/P = Detected Face Image (face_img)
    %  O/P = Row coordinate of the mouth.
    %  Function Used = mouth_row_detect.m
    
    disp('Mouth Row Detection - Started');
    
    %x=0.32;
    waitbar(x+0.28,h,'32% completed');
    %close(h);
    
    [ mouth_row_index_req,lower_lip_row ] = mouth_row_detect( face_img,req_row,col_lt_eye,col_rt_eye,r_rt,row_rt_eye,req_col_mouth_rt,req_col_mouth_lt );
    disp('Mouth Row Detection - Completed');
    
    %x=0.36;
    waitbar(x+0.32,h,'36% completed');
    %close(h);
    
    %% Connected Components
    %  I/P = Detected Face Image (face_img)
    %  O/P = Face Image without cloth pixels (face_img)
    %  Function Used = Connected_Components_Face.m
    
    disp('Removing Cloth Pixels...');
    
    %x=0.4;
    waitbar(x+0.36,h,'40% completed');
    %close(h);
    
    [ face_img ] = Connected_Components_Face( face_img,op_img1,lower_lip_row );
    disp('Cloth Pixels Removed');
    
    %x=0.44;
    waitbar(x+0.4,h,'44% completed');
    %close(h);
    
     %% ====== Start of Hull Mask =====%%%
    % This part of the code removes the mouth reigon of the face as this reigon
    % gives false hotspot
    %  I/P = Modified Face Image (face_img)
    %  O/P = Face Region with a created Hull around mouth region (face_img)
    %  Function Used = Hull_Mask.m
    
    disp('Creating the Hull...');
    
    %x=0.48;
    waitbar(x+0.44,h,'48% completed');
    %close(h);
    
    [ face_region,mid_mouth,face_keypt_X,face_keypt_Y ] = Hull_Mask( face_img,req_col_mouth_rt,req_col_mouth_lt,c_rt,c_lt,r_rt,r_lt,mouth_row_index_req,lower_lip_row );
    disp('Hull Mask Obtained');
    
    %x=0.52;
    waitbar(x+0.48,h,'52% completed');
    %close(h);
    
    
    % ====== end of Hull Mask =====%%%
    
     %% Lower Eye Regression
    %  I/P = Modified Face Image (face_img) and Face Region (face_region)
    %  O/P = MOdified Face Region with region above eye forced to 0.
    %  Function Used = Lower_Eye_Regression.m
    disp('Removing Region above Eye');
    
    %x=0.56;
    waitbar(x+0.52,h,'56% completed');
    %close(h);
    
    [ face_region1,Left_Img,Right_Img,Lower_eye_row,cmid ] = Lower_Eye_Regression( face_img,face_region,col_rt_eye,col_lt_eye,row_rt_eye,row_lt_eye,c_rt,c_lt,req_col_mouth_lt,req_col_mouth_rt );
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
        %   Global thresholding has been used. Global threshold set to 252.
        mask = imbinarize(lt, 252/255);
        
        % Get the biggest CLuster
        mask = bwareafilt(logical(mask),1);
        %figure,imshow(mask);
        
        % closing operation to remuve small objects
        SE = strel('square',2);
        mask = imclose(mask,SE);
        %figure,imshow(mask);
        
% cordinates detection start
        
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
       
       
       %%%% get the upper part of the face points(row and column specified by
       %%%% g_row, g_col)
       [e_row, e_col, g_row, g_col] = uppper_nose(chin_row, chin_col,tip_row,tip_col,mask,u_b);
       
       
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
    [e_row, e_col, g_row, g_col] = uppper_nose( chin_row, chin_col,tip_row,tip_col,mask);
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

 
%if ~exist('output','dir')
 %     mkdir('output');
 %     cd(save_path);
 %else
  %    cd(save_path);
 %end

 cd(dir);
 if ~exist(folder_name2)
            mkdir(folder_name2);
            cd(folder_name2);
        
        else
            rmdir(folder_name2,'s');
            mkdir(folder_name2);
            cd(folder_name2);
        end
    
   % save('A_ROI_Front','A_ROI_R','A_ROI_L');
 
 
 
 %fig1=figure;
 %subplot(1,1,1);
 %imshow(ROI_L);
 
 
 
 %s= [nameFolds,'Masklt.jpg'];
 %saveas(fig1,s,'jpg')
 %fig2=figure;
 %subplot(1,1,1);
 %imshow(ROI_R);
 

 %s= [nameFolds,'Maskrt.jpg'];
 %saveas(fig2,s,'jpg')
 %cd('..\..\');
  %    
   %         cd(rel_path);
    %            if ~exist(folder_name,'dir')
     %               mkdir(folder_name);
      %              cd(folder_name);
       %         else
        %            cd(folder_name);
         %       end
               
               save('A_profile_Mask','profile_mask_lt','profile_mask_rt');
               save('A_face_mask','img_face_lt','img_face_rt');
              
               %close(fig1);
               %close(fig2);
              %d1=dir('..\..\..\GUI\Monsij');
              %addpath('d1');
              %cd 'C:\Users\Anjali\Desktop\GUI\Monsij';
          %  cd('..\..\..\..\Code Repository\Profile Face Detection');
                    

        


    
    
    
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
            set(handles.pushbutton4,'Enable','on');
            set(handles.pushbutton5,'Enable','on');
            set(handles.pushbutton6,'Enable','on');
            f=msgbox('Click on the respective Change ROI buttons');
            %answer=questdlg('Click on the respective Change ROI buttons','Message','Ok','Ok');
            %switch answer
             %   case 'Ok'
              %      return
            %end
        case 'No, thanks'
            return
    end
   
    
    
    









% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)


% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path=mfilename();
disp(path);
close;



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
%imshow(img_masked);
%imsave;


maxval = max(max(profile_mask_rt_new));
minval = min(min(profile_mask_rt_new));
range = 1/(maxval - minval);
profile_mask_rt_new = range*(profile_mask_rt_new - minval);
%profile_mask_rt=profile_mask_rt_new;
axes(handles.axes4);
imshow(profile_mask_rt_new);
%imwrite(profile_left_new,'C:\Users\MonsijB\Desktop\testing2.bmp');

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
cd 'C:\Users\Anjali\Desktop\GUI\Monsij';





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
cd 'C:\Users\Anjali\Desktop\GUI\Monsij';



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
cd 'C:\Users\Anjali\Desktop\GUI\Monsij';








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
cd 'C:\Users\Anjali\Desktop\GUI\Monsij';


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




% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%s = get(0, 'ScreenSize');
%figure1('Position', [0 0 s(3) s(4)]);
%figure('Units','normalized','Position',[0 0 1 1])
