% =========================== Profile_keypoints.m ====================================== %
% Description  : 
% In this code we generate the keypoints used for the segmentation
% purpose. keypoints are eye canthus, nose wing , ear hotspot , chin corner etc 
% ================================================================================== %
% Input Parameters :
%                    I  = Input image
%------------------------------------------------------------------------------------%  
% Output parameter:  
%                    Cordinates of keypoints shown in figure
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1:  kittlerMinimimErrorThresholding.m
%   #2:  find_neck.m
%   #3:  nose_tip.m  ,,,modified_mask
%   #4:  chin.m
%   #5:  uppper_nose.m
%   #6:  ear.m
%   #7:  modified_mask 
% 
% Called by : ~~~~
%------------------------------------------------------------------------------------%
% Reference:    
%~~~~~~~~~~~~
%~~~~~~~~~~~~
% Author of the code:  Ankit Tiwari  
% Date of creation :    10-05-2018
% ------------------------------------------------------------------------------------------------------- %
% Modified on :    02-03-2020
% Modification details: 1. Removal of cloth pixel is added
%                       2. Function nose_tip_copy added
%                       4. Function Chin detection is modified
%                       5. Function Ear detection is modified
% Modified By :  Srijita Saha Roy
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
        clear;
        clc;
        close all; 

dbstop if error
close all
clear all
clc

%% Selecting Subject Category and loading database
disp('Which Category do you choose');
disp('Normal (N), Malignant (M), Precancerous (P), Age Adjusted Normal (A)');
question='Enter your choice = ';
User_Choice=input(question,'s');
if (strcmp(User_Choice, 'N')==1)
    d = dir('..\..\ThermalDatabase\Normal'); % Reading Dir of the Specified Folder
elseif (strcmp(User_Choice, 'A')==1)
    d = dir('..\..\ThermalDatabase\Normal_AgeAdjust'); % Reading Dir of the Specified Folder
elseif (strcmp(User_Choice, 'M')==1)
    d = dir('..\..\ThermalDatabase\Malignant'); % Reading Dir of the Specified Folder
elseif (strcmp(User_Choice, 'P')==1)
    d = dir('..\..\ThermalDatabase\NonMalignant'); % Reading Dir of the Specified Folder
else
    disp('Invalid Choice');
    return
end
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%
for folder_idx=no_dir:no_dir
    
dbstop if error
close all

    fprintf('Processing Patient ID'); disp(nameFolds(folder_idx)); % Display Current Patient ID
    % Load the required Thermal Image
    % I1 and I2 are the loaded Left and Right profile image respectively (from csv file)
    if (strcmp(User_Choice, 'N')==1)
        I1=xlsread(['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
        I2=xlsread(['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
        rel_path=['..\..\ThermalDatabase\Normal\',nameFolds{folder_idx}];
        save_path=['output\Normal'];
        folder_name=['Automatic_Profile_ROI_' nameFolds{folder_idx}];
        csv=I1;
    elseif (strcmp(User_Choice, 'A')==1)
        I1=xlsread(['..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
        I2=xlsread(['..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
        rel_path=['..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx}];
        save_path=['output\Normal_AgeAdjust'];
        folder_name=['Automatic_Profile_ROI_' nameFolds{folder_idx}];
        csv=I1;
    elseif (strcmp(User_Choice, 'M')==1)
        I1=xlsread(['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
        I2=xlsread(['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
        rel_path=['..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx}];
        save_path=['output\Malignant'];
        folder_name=['Automatic_Profile_ROI_' nameFolds{folder_idx}];
        csv=I1;
    elseif (strcmp(User_Choice, 'P')==1)
        I1=xlsread(['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
        I2=xlsread(['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
        rel_path=['..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx}];
        save_path=['output\NonMalignant'];
        folder_name=['Automatic_Profile_ROI_' nameFolds{folder_idx}];
        csv=I1;
    else
        disp('Invalid Choice');
    end
        
        % Scale the Image from 0-255
        maxval=max(max(I1));
        minval=min(min(I1));
        range=255/(maxval-minval);
        I1=range.*(I1-minval); 
        I1 = uint8(I1); 
        originalimg=I1;
        %figure,imshow(originalimg);

        % % % % % gamma correction for mask generation
        gamma = 1.2;
        I1=uint8(1.*((double(I1)).^gamma));
        %figure,imshow(I1);
        
        %% 2.Thresholding to segment out facial region
        %   Global thresholding has been used. Global threshold set to 252.
        mask = imbinarize(I1, 252/255);
        
        % Get the biggest CLuster
        mask = bwareafilt(logical(mask),1);
        %figure,imshow(mask);
        
        % closing operation to remove small objects
        SE = strel('square',2);
        mask = imclose(mask,SE);
        %figure,imshow(mask);
        
% cordinates detection start
        
        [slope, constant, neck_col, neck_row]=find_neck(mask);
 
        %%%% remove the part below neck
        
        mask(neck_row:480, :) = 0; 
        figure,imshow(mask);
        
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
           mask(l_lo:480,:)=0;
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
%%   
    %%dist is the variable calculated between two points
    %Here it is calculated between chin and nose tip
     dist = round(sqrt(abs(chin_row-tip_row)^2+abs(chin_col-tip_col)^2));
    
    %%%% get the eyecanthus row and column specified by canthus_r,canthus_c
     [canthus_r,canthus_c] = lateral_eyecanthus_1(mask,g_row,g_col,dist,csv);
    %Here it is calculated between eyecanthus and nose tip
     dist = round(sqrt(abs(g_row-tip_row)^2+abs(g_col-tip_col)^2));
     
    %%%% get the Nose wing row and column specified by nw_row, nw_col
     [nw_row, nw_col] = nose_wing_1(tip_row,tip_col,mask,dist,csv);
        
    
    %%%% get the ear hotspot row and column specified by ear_row, ear_col
     [ear_row, ear_col,mask_ear_search,mask_temp] = ear_new_1(mask,tip_row,tip_col,chin_row, chin_col,e_row, e_col,csv,Index_ver_pro);
     

     %%%%%%%%%% mask generation using these points
     [mask,row,col,ROI_L] = modified_mask(tip_row,tip_col,canthus_r,canthus_c,nw_row,nw_col,ear_row,ear_col,chin_row, chin_col,mask,originalimg);
      
     save()
     k = boundary(row,col,.1);
     
    %Rescale the mask area to 0-255 intensity
     
     temp=csv.*double(mask);
     maxval=max(max(temp));
     minval=min(min(temp(mask>0)));
     range=255/(maxval-minval);
     temp_1=range.*(temp-minval); 
     I1 = uint8(temp_1);

    
%%
     I1=I1.*uint8(mask);
     img_face_lt = I1;
     profile_mask_lt = mask;
    


%      clearvars '-except' I2  profile_mask_lt  img_face_lt d isub nameFolds no_dir folder_idx ;

    % % % % % % % % % % % % % % % % % % % % % % % % % 
    % Flip the right image to make it left
    % By rotating the image by 180 degrees
    % 
    % 
    I2 = flip(I2,2) ;
    csv= I2;
%%

    % Scale the Image from 0-255
    maxval=max(max(I2));
    minval=min(min(I2));
    range=255/(maxval-minval);
    I2=range.*(I2-minval); 
    I2 = uint8(I2);
    originalimg=I2;

    %%

    % % % % % gamma correction for mask generation
    gamma = 1.2;
    I2=uint8(1.*((double(I2)).^gamma));
    % % % % % % % % % % % % % % % % % % % % % % % % % 


    %% 2.Thresholding to segment out facial region
    
    mask = imbinarize(I2, 252/255);
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
           mask(l_lo:480,:)=0;
       else
            l_lo=480;
       end
       
    % Nose detection for extended lip people
    [tip_row,tip_col,mask_nose] = nose_tip_copy(mask,u_b,l_lo);
    
%   figure,imshow(originalimg_marked);

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
    I2 = uint8(temp_1);
%%   
    % dist is the variable calculated between two points
    dist = round(sqrt(abs(chin_row-tip_row)^2+abs(chin_col-tip_col)^2));%Here it is calculated between chin and nose tip
    
    %%%% get the eyecanthus row and column specified by canthus_r,canthus_c
    [canthus_r,canthus_c] = lateral_eyecanthus_1(mask,g_row,g_col,dist,csv);
    
    dist = round(sqrt(abs(g_row-tip_row)^2+abs(g_col-tip_col)^2));%Here it is calculated between eyecanthus and nose tip
    
    %%%% get the Nose wing row and column specified by nw_row, nw_col
    [nw_row, nw_col]=nose_wing_1(tip_row,tip_col,mask,dist,csv);
    
    
    %%%% get the ear hotspot row and column specified by ear_row, ear_col
    [ear_row, ear_col,mask_ear_search,mask_temp] = ear_new_1(mask,tip_row,tip_col,chin_row, chin_col,e_row, e_col,csv,Index_ver_pro);


    %%%%%%%%%% mask generation using these points
    [mask,row,col,ROI_R] = modified_mask(tip_row,tip_col,canthus_r,canthus_c,nw_row,nw_col,ear_row,ear_col,chin_row, chin_col,mask,originalimg);
    
    %k = boundary(row,col,.1);
    
     I2=I2.*uint8(mask);
     img_face_rt=I2;
     profile_mask_rt = mask;
     profile_mask_rt = flip(profile_mask_rt,2);
     img_face_rt = flip(img_face_rt,2);
      ROI_R = flip(ROI_R,2);    
%   clearvars '-except' saving_path database_path  profile_mask_lt profile_mask_rt img_face_lt img_face_rt d isub nameFolds no_dir folder_idx folder_name;
%% saving the plots

 
if ~exist('output','dir')
      mkdir('output');
      cd(save_path);
 else
      cd(save_path);
 end

 fig1=figure;
 subplot(1,1,1);
 imshow(ROI_L);

 
 s= [nameFolds{folder_idx},'Masklt.jpg'];
 saveas(fig1,s,'jpg');

 fig2=figure;
 subplot(1,1,1);
 imshow(ROI_R);
 %imwrite('ROI_R',ROI_R);
 
 s= [nameFolds{folder_idx},'Maskrt.jpg'];
 saveas(fig2,s,'jpg');

 cd('..\..\');
   
            cd(rel_path);
                if ~exist(folder_name,'dir')
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd(folder_name);
                end
                
               save('A_profile_Mask','profile_mask_lt','profile_mask_rt');
               save('A_face_mask','img_face_lt','img_face_rt');
               
               

             
            cd('..\..\..\..\Code Repository\Profile Face Detection');
        end            



