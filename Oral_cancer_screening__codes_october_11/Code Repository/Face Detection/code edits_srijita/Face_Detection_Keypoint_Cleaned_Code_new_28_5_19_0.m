function [A_ROI_R,A_ROI_L]=Face_Detection_Keypoint_Cleaned_Code_new() %(MINE)
%% Face Localization, Keypoint Detection and Automatic ROI formation for Thermal Images - Oral Cancer

% The following code automatically generates the ROI for oral cancer diagnosis by localizing the
% face and detecting the facial Keypoints. Order of execution,
% 1. Face Detection
% 2. Eye Localization
% 3. Mouth Column Detection
% 4. Nose Detection
% 5. Mouth Row Detection
% 6. Remove Cloth Pixels
% 7. ROI Generation


%%
dbstop if error
close all
%clear all
clc

%% Selecting Subject Category and loading database
%disp('Which Category do you choose');
%disp('Normal (N), Malignant (M), Precancerous (P), Age Adjusted Normal (A)');
%question='Enter your choice = ';
%User_Choice=input(question,'s');
%if (strcmp(User_Choice, 'N')==1)
 %   d = dir('..\..\ThermalDatabase\Normal'); % Reading Dir of the Specified Folder
%elseif (strcmp(User_Choice, 'A')==1)
 %   d = dir('..\..\ThermalDatabase\Normal_AgeAdjust'); % Reading Dir of the Specified Folder
%elseif (strcmp(User_Choice, 'M')==1)
 %   d = dir('..\..\ThermalDatabase\Malignant'); % Reading Dir of the Specified Folder
%elseif (strcmp(User_Choice, 'P')==1)
 %   d = dir('..\..\ThermalDatabase\NonMalignant'); % Reading Dir of the Specified Folder
%else
 %   disp('Invalid Choice');
  %  return
%end
d=dir(filename); %(MINE)
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds); 
%no_dir=numel(filename); %(MINE)
%
for folder_idx=no_dir:no_dir 
    
    %fprintf('Processing Patient ID'); disp(filename);(MASKED) % Display Current Patient ID
    
    fprintf('Processing Patient ID '); disp(filename); %(MINE)
    alpha=filename(1:1);
    if (strcmp(alpha, 'T')==1)
        I_F=xlsread(['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
        rel_path=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx}];
        folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
        
    elseif (strcmp(alpha, 'P')==1)
        I_F=xlsread(['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
        rel_path=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx}];
        folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
    else
        disp('Rename filename');
    end
    
    
    
    ........................................................
    % Load the required Thermal Image
    % I_F is the loaded image (from excel file)
   % if (strcmp(User_Choice, 'N')==1)
    %    I_F=xlsread(['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
     %   rel_path=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx}];
      %  folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
        
    %elseif (strcmp(User_Choice, 'A')==1)
     %   I_F=xlsread(['..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
      %  rel_path=['..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx}];
       % folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
    %elseif (strcmp(User_Choice, 'M')==1)
     %   I_F=xlsread(['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
      %  rel_path=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx}];
       % folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
    %elseif (strcmp(User_Choice, 'P')==1)
     %   I_F=xlsread(['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
      %  rel_path=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx}];
       % folder_name=['A_ROI_Front_' nameFolds{folder_idx}];
    %else
     %   disp('Invalid Choice');
    %end
    %% Face Detection
    %  I/P = Input image (I_F)
    %  O/P = Face Boundary Mask (BW_mask_F)
    %  Function Used = face_detect.m
    
    disp('Face Detection - Started');
    %I_F_cpy=I_F;(MASKED) 
    I_F_cpy=I_F; % (MINE)
    op_img1=nameFolds(folder_idx); % Storing Patient ID (MASKED)
    %folder_idx=numel(filename); %(MINE)
    %logical_folder=logical(folder_idx); %(MINE)
    %op_img1=nameFolds(logical_folder); %(MINE)
    %[BW_mask_F,mask_F,rt_boundary_col,lt_boundary_col,~,lower_boundary_row]=face_detect( filename,nameFolds,folder_idx,op_img1 );(MASKED) % Perform Face-Detection
    [BW_mask_F,mask_F,~,~,~,lower_boundary_row]=face_detect_new(I_F,nameFolds,folder_idx,op_img1); 
    %lower_boundary_row=floor(lower_boundary_row);
    %I_F=mat2gray(I_F); (MASKED)
    I_F=mat2gray(I_F);
    %face_img=(I_F).*double(BW_mask_F); (MASKED) % Convolving the face detected mask with the original image to obtain the face.
    face_img=(I_F).*double(BW_mask_F);
    disp('Face Detection - Completed')
    %% Eye Detection
    %  I/P = Detected Face Image (face_img)
    %  O/P = Coordinates of R & L eye canthus.
    %  Function Used = eye_detection_thermal.m
    disp('Eye Canthus Detection - Started');
    [modified_r_min,mean_eye_brow_row,row_rt_eye,row_lt_eye,col_rt_eye,col_lt_eye ] = eye_detection_thermal( face_img );
    disp('Eye Canthus Detection - Completed')
    %% Mouth Detection
    %  I/P = Detected Face Image (face_img)
    %  O/P = Column Coordinates of R & L mouth extremes
    %  Function Used = mouth_detection.m
    
    disp('Mouth Endpoint Detection - Started');
    [req_col_mouth_lt,req_col_mouth_rt,req_row,max_face_row,modified_min_row_nose] = mouth_detection( face_img,modified_r_min,row_lt_eye,row_rt_eye,col_lt_eye,col_rt_eye,mean_eye_brow_row);
    disp('Mouth Endpoint Detection - Completed');
    %% Nose Detection
    %  I/P = Detected Face Image (face_img)
    %  O/P = Coordinates of R & L nose extremes.
    %  Function Used = nose_detection.m
    
    disp('Nose Detection - Started');
    [r_lt,c_lt,r_rt,c_rt]=nose_detection( face_img,modified_min_row_nose,mean_eye_brow_row,req_row,col_rt_eye,col_lt_eye,req_col_mouth_lt,req_col_mouth_rt);
    disp('Nose Detection - Completed');
    %% Mouth Row
    %  I/P = Detected Face Image (face_img)
    %  O/P = Row coordinate of the mouth.
    %  Function Used = mouth_row_detect.m
    
    disp('Mouth Row Detection - Started');
    [ mouth_row_index_req,lower_lip_row ] = mouth_row_detect( face_img,req_row,col_lt_eye,col_rt_eye,r_rt,row_rt_eye,req_col_mouth_rt,req_col_mouth_lt );
    disp('Mouth Row Detection - Completed');
    %% Connected Components
    %  I/P = Detected Face Image (face_img)
    %  O/P = Face Image without cloth pixels (face_img)
    %  Function Used = Connected_Components_Face.m
    
    disp('Removing Cloth Pixels...');
    [ face_img ] = Connected_Components_Face( face_img,op_img1,lower_lip_row );
    disp('Cloth Pixels Removed');
    
    %% ====== Start of Hull Mask =====%%%
    % This part of the code removes the mouth reigon of the face as this reigon
    % gives false hotspot
    %  I/P = Modified Face Image (face_img)
    %  O/P = Face Region with a created Hull around mouth region (face_img)
    %  Function Used = Hull_Mask.m
    
    disp('Creating the Hull...');
    [ face_region,mid_mouth,face_keypt_X,face_keypt_Y ] = Hull_Mask( face_img,req_col_mouth_rt,req_col_mouth_lt,c_rt,c_lt,r_rt,r_lt,mouth_row_index_req,lower_lip_row );
    disp('Hull Mask Obtained');
    
    % ====== end of Hull Mask =====%%%
    %% Lower Eye Regression
    %  I/P = Modified Face Image (face_img) and Face Region (face_region)
    %  O/P = MOdified Face Region with region above eye forced to 0.
    %  Function Used = Lower_Eye_Regression.m
    disp('Removing Region above Eye');
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
    
    cd(rel_path);
    if  ~exist(folder_name)
        mkdir(folder_name);
        cd(folder_name);
    else
        
        rmdir(folder_name,'s');
        mkdir(folder_name);
        cd(folder_name);
    end
    
    
    save('A_ROI_Front','A_ROI_R','A_ROI_L');
    cd '../../../../code repository/Face Detection';
    
    pause(0.01);
    close all;
%end 
end