% =========================== Run_Gabor.m ====================================== %
% Description  : This code is the main code which contains the functions
% for feature extraction and classification codes for gabor feature.
%

% ================================================================================== %
%

% Author of the code: Manashi Chakraborty
% Date of creation :
% ------------------------------------------------------------------------------------------------------- %
% Modified on : 06-05-2019
% Modification details: 1.Sensitivity and specificity has been included with
%                         classfication accuracy in function
%                         run_Gabor_libsvm_Full_26_8_19.
%                       2.improve_imbalance function added to improve
%                       imbalance between classes.
% Modified By :  Abhishek Prajapati
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
%%
clear all;
clc;
close all;


sacle_idx=2:6; % scale_idx is the variable which stores scale of the gabor filters. Here we considered 5 different scales.

%%
%--------------------- Display your choice---------------%

disp('Enter your options:');
disp('1: Ground truth region of interest frontal')
disp('2: Ground truth region of interest Age Adjusted frontal')
disp('3: Ground truth region of interest Profile')
disp('4: Ground truth region of interest Age Adjusted Profile')
disp('5: Automated region of interest frontal')
disp('6: Automated region of interest Age Adjusted frontal')
disp('7: Automated region of interest Profile');
question=('Enter The Above options: ');
User_Choice=input(question,'s');


%========================Case: Front Face Full DB========================
if (strcmp(User_Choice,'1')==1)
    
    %-------------------------------------------------------------------------------------------------------
    %      %========================Start of Feature extraction%========================
    
    clear;
    idx=1;
    sacle_idx=2:6;        % scale_idx is the variable which stores scale of the gabor filters. Here we considered 5 different scales.
    
    %-------------------------------------------------------------------------------------------------------
    GT_Gabor_HM_M_Frontal=cell(numel(sacle_idx),1); % preallocate space to store gabor features of various scales for frontal faces of malignant subjects
    GT_Gabor_HM_P_Frontal=cell(numel(sacle_idx),1); % preallocate space to store gabor features of various scales for frontal faces of precancerous subjects
    GT_Gabor_HM_N_Frontal=cell(numel(sacle_idx),1); % preallocate space to store gabor features of various scales for frontal faces of normal subjects
    
    %---For each scale, gabor features are calculated for each half of the face. Features from each half of face is appended and saved.---%
    for sacle_idx=2:6
        
        %------starting of making folders for data analysis-------%
        
        d1 = dir('..\..\..\ThermalDatabase\Malignant');%%% d stores a structure of 6 fields
           
        isub = [d1(:).isdir]; %# returns logical vector (1 by folders with sub directory)
        nameFolds1 = {d1(isub).name}'; 
        nameFolds1 = nameFolds1(3:end);
        no_dir = numel(nameFolds1);
        
        d2 = dir('..\..\..\ThermalDatabase\Normal');%%% d stores a structure of 6 fields
           
        isub = [d2(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds2 = {d2(isub).name}'; 
        nameFolds2 = nameFolds2(3:end);
        no_dir = numel(nameFolds2);
        
        d3 = dir('..\..\..\ThermalDatabase\NonMalignant');%%% d stores a structure of 6 fields
           
        isub = [d3(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds3 = {d3(isub).name}'; 
        nameFolds3=nameFolds3(3:end);
        no_dir=numel(nameFolds3);
    
        nameFolds_MN = [nameFolds1;nameFolds2];
        nameFolds_PN = [nameFolds3;nameFolds2];% All nametags of the patients are present here
         GT_ComputeGaborIR_Frontal(sacle_idx);
         GT_Gabor_HMFeatures_between_lt_and_rt_Frontal(sacle_idx);
        cd('..\Classification\libsvm-3.20\matlab')
        load(['..\..\..\GaborFeatures_HM_allScale\GT_Gabor_HM_Malignant_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\GT_Gabor_HM_Normal_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\GT_Gabor_HM_Precancer_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
        
        GT_Gabor_HM_M_Frontal{idx,1}=GT_Malignant_Gabor_HM_append_LT_RT_Frontface;
        GT_Gabor_HM_P_Frontal{idx,1}=GT_Precancer_Gabor_HM_append_LT_RT_Frontface;
        GT_Gabor_HM_N_Frontal{idx,1}=GT_Normal_Gabor_HM_append_LT_RT_Frontface;
        idx=idx+1;
        cd('..\..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
    end
    
    % ========================-End of Feature extraction%========================
    %========================- Save the features ========================%
    cd('..\GaborFeatures_HM_allScale');
    save('GT_Gabor_HM_M_Frontal','GT_Gabor_HM_M_Frontal');
    save('GT_Gabor_HM_P_Frontal','GT_Gabor_HM_P_Frontal');
    save('GT_Gabor_HM_N_Frontal','GT_Gabor_HM_N_Frontal');
    %================================================================%
    
    %-------------------------------------------------------------------------------------------------------
    %========================Classification Starts=======================
    cd('D:\anjali\17EC65R09_Abhishek\Codes\ThermalDatabase\Malignant\P0099\GT_Gabor_Han&Ma_Malignant_Front_P0099');
    load('GT_Gabor_H&M_Malignant_Front','GT_Gabor_H&M_Malignant_Front');
%     GT_Gabor_HM_M_Frontal = improve_imbalance(GT_Gabor_HM_M_Frontal);
    %load('GT_Gabor_HM_P_Frontal','GT_Gabor_HM_P_Frontal');
%     GT_Gabor_HM_P_Frontal = improve_imbalance(GT_Gabor_HM_P_Frontal);
    %load('GT_Gabor_HM_N_Frontal','GT_Gabor_HM_N_Frontal');
    cd('..\Classification\libsvm-3.20\matlab')
    
    %=================Malignant vs Normal==================%
    viz_case='GT_Full_MN_Frontal'
    folder_name=['Full_Gabor_MN_Frontal'];
    save_mat='MN_Full_Parameters_Frontal';
    results_save_dir='GaborResults\GTROI';
    sacle_idx=2:6;
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='GT_MN_FULL';
    
      [final_accuracy_MN,sensivity_MN,specificity_MN] = run_Gabor_libsvm_Full_26_8_19(GT_Gabor_HM_M_Frontal,GT_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting,nameFolds_MN)

  
    cd('../../../');
    %======================================================%
    
    %=================Precancer vs Normal ==================%    
    viz_case='GT_Full_PN_Frontal' ;
    folder_name=['Full_Gabor_PN_Frontal' ];
    save_mat='PN_Full_Parameters_Frontal';      
    results_save_dir='GaborResults\GTROI';
    
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    Setting='GT_PN_FULL';
    
    %---------------------
    
      [final_accuracy_PN,sensitivity_PN,specificity_PN] = run_Gabor_libsvm_Full_26_8_19(GT_Gabor_HM_P_Frontal,GT_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting,nameFolds_PN)

    
    
    %%-------------Precancer vs Normal classification end----------%%
    
    %========================Classification Ends=======================

    
    %%
    
    %========================Case: Front Face Age Adjusted DB========================
elseif (strcmp(User_Choice,'2')==1)
    
    
    %-------------------------------------------------------------------------------------------------------
    %========================Start of Feature extraction%========================
    
    clear;
    idx=1;
    sacle_idx=2:6;
        AgeAdjust_GT_Gabor_HM_M_F=cell(numel(sacle_idx),1);
        AgeAdjust_GT_Gabor_HM_P_F=cell(numel(sacle_idx),1);
        AgeAdjust_GT_Gabor_HM_N_F=cell(numel(sacle_idx),1);
    
        %----------for each scale gabor features are calculated, appended and saved.--------------%
        for sacle_idx=2:6
%             AgeAdjust_GT_ComputeGaborIR_Frontal(sacle_idx);
%             AgeAdjust_GT_Gabor_HMFeatures_between_lt_and_rt_Frontal(sacle_idx);
            cd('..\Classification\libsvm-3.20\matlab')
            load(['..\..\..\GaborFeatures_HM_allScale\AgeAdjust_GT_Gabor_HM_Malignant_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
            load(['..\..\..\GaborFeatures_HM_allScale\AgeAdjust_GT_Gabor_HM_Normal_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
            load(['..\..\..\GaborFeatures_HM_allScale\AgeAdjust_GT_Gabor_HM_Precancer_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
            AgeAdjust_GT_Gabor_HM_M_F{idx,1}=GT_Malignant_Gabor_HM_append_LT_RT_Frontface;
            AgeAdjust_GT_Gabor_HM_P_F{idx,1}=GT_Precancer_Gabor_HM_append_LT_RT_Frontface;
            AgeAdjust_GT_Gabor_HM_N_F{idx,1}=GT_Normal_Gabor_HM_append_LT_RT_Frontface;
            idx=idx+1;
            cd('..\..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
        end
        cd('..\GaborFeatures_HM_allScale');
        %========================-End of Feature extraction%========================
    
    
        %========================- Save the features ========================%
        save('AgeAdjust_GT_Gabor_HM_M_F','AgeAdjust_GT_Gabor_HM_M_F');
        save('AgeAdjust_GT_Gabor_HM_P_F','AgeAdjust_GT_Gabor_HM_P_F');
        save('AgeAdjust_GT_Gabor_HM_N_F','AgeAdjust_GT_Gabor_HM_N_F');
    %================================================%
    
    %-------------------------------------------------------------------------------------------------------
    
    %========================Classification Starts=======================
    cd('..\GaborFeatures_HM_allScale');
    
    load('AgeAdjust_GT_Gabor_HM_M_F','AgeAdjust_GT_Gabor_HM_M_F');
    load('AgeAdjust_GT_Gabor_HM_P_F','AgeAdjust_GT_Gabor_HM_P_F');
    load('AgeAdjust_GT_Gabor_HM_N_F','AgeAdjust_GT_Gabor_HM_N_F');
    
    cd('..\Classification\libsvm-3.20\matlab');
    
    %=================Malignant vs Normal==================%
    viz_case='GT_AgeAdjust_MN_Frontal'
    folder_name=['AgeAdjust_Gabor_MN_Frontal' ];
    save_mat='MN_AgeAdjust_Parameters_Frontal';
    results_save_dir='GaborResults\GTROI';
    
    sacle_idx=2:6;
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='GT_MN_AGE';
    
    
    
     [final_accuracy_MN,sensivity_MN,specificity_MN]= run_Gabor_libsvm_AgeAdjust_26_8_19(AgeAdjust_GT_Gabor_HM_M_F,AgeAdjust_GT_Gabor_HM_N_F,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    
     cd('../../../');
    %======================================================%
    
    %=================Precancer vs Normal ==================%
    viz_case='GT_AgeAdjust_PN_Frontal'
    folder_name=['AgeAdjust_Gabor_PN_Frontal' ];
    save_mat='PN_AgeAdjust_Parameters_Frontal';
    results_save_dir='GaborResults\GTROI';
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='GT_PN_AGE';
    
    
    
    [final_accuracy_PN,sensitivity_PN,specificity_PN] = run_Gabor_libsvm_AgeAdjust_26_8_19(AgeAdjust_GT_Gabor_HM_P_F,AgeAdjust_GT_Gabor_HM_N_F,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    
    %======================================================%
    %========================Classification Ends=======================
    
    
    %========================Case: Profile Face Full DB========================
    elseif (strcmp(User_Choice,'3')==1)
    %-------------------------------------------------------------------------------------------------------
    %========================Start of Feature extraction%========================
    
    
    clear;
    idx=1;
    sacle_idx=2:6;% scale_idx is the variable which stores scale of the gabor filters. Here we considered 5 different scales.
    GT_Gabor_HM_M_Profile=cell(numel(sacle_idx),1);
    GT_Gabor_HM_P_Profile=cell(numel(sacle_idx),1);
    GT_Gabor_HM_N_Profile=cell(numel(sacle_idx),1);
    %---For each scale, gabor features are calculated for each half of the face. Features from each half of face is appended and saved.---%
    for sacle_idx=2:6
        %------starting of making folders for data analysis-------%
        
        d1 = dir('..\..\..\ThermalDatabase\Malignant');%%% d stores a structure of 6 fields
           
        isub = [d1(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds1 = {d1(isub).name}'; 
        nameFolds1 = nameFolds1(3:end);
        no_dir = numel(nameFolds1);
        
        d2 = dir('..\..\..\ThermalDatabase\Normal');%%% d stores a structure of 6 fields
           
        isub = [d2(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds2 = {d2(isub).name}'; 
        nameFolds2 = nameFolds2(3:end);
        no_dir = numel(nameFolds2);
        
        d3 = dir('..\..\..\ThermalDatabase\NonMalignant');%%% d stores a structure of 6 fields
           
        isub = [d3(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds3 = {d3(isub).name}'; 
        nameFolds3=nameFolds3(3:end);
        no_dir=numel(nameFolds3);
    
        nameFolds_MN = [nameFolds1;nameFolds2];
        nameFolds_PN = [nameFolds3;nameFolds2];% All nametags of the patients are present here
        
%         GT_ComputeGaborIR_Profile(sacle_idx);
%         GT_Gabor_HMFeatures_between_lt_and_rt_haralic_Profile(sacle_idx);
        cd('..\Classification\libsvm-3.20\matlab')
        load(['..\..\..\GaborFeatures_HM_allScale\GT_Gabor_HM_Malignant_Profile_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\GT_Gabor_HM_Normal_Profile_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\GT_Gabor_HM_Precancer_Profile_face_scale_',num2str(sacle_idx),'.mat']);
        GT_Gabor_HM_M_Profile{idx,1}=GT_Malignant_Gabor_HM_append_LT_RT_Profileface;
        GT_Gabor_HM_P_Profile{idx,1}=GT_Precancer_Gabor_HM_append_LT_RT_Profileface;
        GT_Gabor_HM_N_Profile{idx,1}=GT_Normal_Gabor_HM_append_LT_RT_Profileface;
        idx=idx+1;
        cd('..\..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
    end
    
    %========================End of Feature extraction%========================
    
    %========================- Save the features ========================%
    
    cd('..\GaborFeatures_HM_allScale');
    save('GT_Gabor_HM_M_Profile','GT_Gabor_HM_M_Profile');
    save('GT_Gabor_HM_P_Profile','GT_Gabor_HM_P_Profile');
    save('GT_Gabor_HM_N_Profile','GT_Gabor_HM_N_Profile');
    %================================================%
    %-------------------------------------------------------------------------------------------------------
    %========================Classification Starts=======================
    cd('..\GaborFeatures_HM_allScale');
    load('GT_Gabor_HM_M_Profile','GT_Gabor_HM_M_Profile');
%      GT_Gabor_HM_M_Profile = improve_imbalance(GT_Gabor_HM_M_Profile);
    load('GT_Gabor_HM_P_Profile','GT_Gabor_HM_P_Profile');
%      GT_Gabor_HM_P_Profile = improve_imbalance(GT_Gabor_HM_P_Profile);
    load('GT_Gabor_HM_N_Profile','GT_Gabor_HM_N_Profile');
    
    cd('..\Classification\libsvm-3.20\matlab');
    
    %=================Malignant vs Normal==================%
    viz_case='GT_Full_MN_Profile'
    folder_name=['Full_Gabor_MN_Profile' ];
    save_mat='MN_Parameters_Profile';
    results_save_dir='GaborResults\GTROI';
    
    sacle_idx=2:6;
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='PROFILE_GT_MN_FULL';
    
    
    
    
    [final_accuracy_MN,sensivity_MN,specificity_MN] = run_Gabor_libsvm_Full_26_8_19(GT_Gabor_HM_M_Profile,GT_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting,nameFolds_MN)
    cd('../../../');
    
    %=================Precancer vs Normal ==================%
    viz_case='GT_Full_PN_profile'
    folder_name=['Full_Gabor_PN_Profile' ];
    save_mat='PN_Parameters_Profile';
    results_save_dir='GaborResults\GTROI';
    
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='PROFILE_GT_PN_FULL';
    
    
    
    [final_accuracy_PN,sensitivity_PN,specificity_PN] = run_Gabor_libsvm_Full_26_8_19(GT_Gabor_HM_P_Profile,GT_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting,nameFolds_PN)
    
    

    
    %========================Classification Ends=======================
    
    
    
    
    
elseif (strcmp(User_Choice,'4')==1)
    %========================Start of Feature extraction%========================
    
    
    clear;
    idx=1;
    sacle_idx=2:6;    % scale_idx is the variable which stores scale of the gabor filters. Here we considered 5 different scales.
    AgeAdjust_GT_Gabor_HM_M_Profile=cell(numel(sacle_idx),1);
    AgeAdjust_GT_Gabor_HM_P_Profile=cell(numel(sacle_idx),1);
    AgeAdjust_GT_Gabor_HM_N_Profile=cell(numel(sacle_idx),1);
    %---for each scale gabor features are calculated, appended and saved.---%
    for sacle_idx=2:6
%         AgeAdjust_GT_ComputeGaborIR_Profile(sacle_idx);
%         AgeAdjust_GT_Gabor_HMFeatures_between_lt_and_rt_Profile(sacle_idx);
        cd('..\Classification\libsvm-3.20\matlab')
        load(['..\..\..\GaborFeatures_HM_allScale\AgeAdjust_GT_Gabor_HM_Malignant_Profile_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\AgeAdjust_GT_Gabor_HM_Normal_Profile_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\AgeAdjust_GT_Gabor_HM_Precancer_Profile_face_scale_',num2str(sacle_idx),'.mat']);
        AgeAdjust_GT_Gabor_HM_M_Profile{idx,1}=GT_Malignant_Gabor_HM_append_LT_RT_Profileface;
        AgeAdjust_GT_Gabor_HM_P_Profile{idx,1}=GT_Precancer_Gabor_HM_append_LT_RT_Profileface;
        AgeAdjust_GT_Gabor_HM_N_Profile{idx,1}=GT_Normal_Gabor_HM_append_LT_RT_Profileface;
        idx=idx+1;
        cd('..\..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
    end
    cd('..\GaborFeatures_HM_allScale');
    %========================End of Feature extraction%========================
    
    %========================- Save the features ========================%
    
    save('AgeAdjust_GT_Gabor_HM_M_Profile','AgeAdjust_GT_Gabor_HM_M_Profile');
    save('AgeAdjust_GT_Gabor_HM_P_Profile','AgeAdjust_GT_Gabor_HM_P_Profile');
    save('AgeAdjust_GT_Gabor_HM_N_Profile','AgeAdjust_GT_Gabor_HM_N_Profile');
    %================================================%
    %========================Classification Starts=======================
    
    cd('..\GaborFeatures_HM_allScale');
    load('AgeAdjust_GT_Gabor_HM_M_Profile','AgeAdjust_GT_Gabor_HM_M_Profile');
    load('AgeAdjust_GT_Gabor_HM_P_Profile','AgeAdjust_GT_Gabor_HM_P_Profile');
    load('AgeAdjust_GT_Gabor_HM_N_Profile','AgeAdjust_GT_Gabor_HM_N_Profile');
    
    cd('..\Classification\libsvm-3.20\matlab');
    
    %=================Malignant vs Normal==================%
    viz_case='GT_AgeAdjust_MN_Profile'
    folder_name=['AgeAdjust_Gabor_MN_Profile' ];
    save_mat='MN_Parameters_Profile';
    results_save_dir='GaborResults\GTROI';
    sacle_idx=2:6;
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    Setting='PROFILE_GT_MN_AGE';
    
    %---------------------
    
    [final_accuracy_MN,sensitivity_MN,specificity_MN] = run_Gabor_libsvm_AgeAdjust_26_8_19(AgeAdjust_GT_Gabor_HM_M_Profile,AgeAdjust_GT_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting)
    cd('../../../');
    
    %=================Precancer vs Normal ==================%
    viz_case='GT_AgeAdjust_PN_profile'
    folder_name=['AgeAdjust_Gabor_PN_Profile' ];
    save_mat='PN_Parameters_Profile';
    results_save_dir='GaborResults\GTROI';
    
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    Setting='PROFILE_GT_PN_AGE';
    
    %---------------------
    
    [final_accuracy_PN,sensitivity_PN,specificity_PN] = run_Gabor_libsvm_AgeAdjust_26_8_19(AgeAdjust_GT_Gabor_HM_P_Profile,AgeAdjust_GT_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting)
    
    
    %========================Classification Ends=======================
    
    
    
    
    
elseif (strcmp(User_Choice,'5')==1)
    
    %========================Start of Feature extraction%========================
    % All nametags of the patients are present here
    d1 = dir('..\..\..\ThermalDatabase\Malignant');%%% d stores a structure of 6 fields
           
        isub = [d1(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds1 = {d1(isub).name}'; 
        nameFolds1 = nameFolds1(3:end);
        no_dir = numel(nameFolds1);
        
        d2 = dir('..\..\..\ThermalDatabase\Normal');%%% d stores a structure of 6 fields
           
        isub = [d2(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds2 = {d2(isub).name}'; 
        nameFolds2 = nameFolds2(3:end);
        no_dir = numel(nameFolds2);
        
        d3 = dir('..\..\..\ThermalDatabase\NonMalignant');%%% d stores a structure of 6 fields
           
        isub = [d3(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds3 = {d3(isub).name}'; 
        nameFolds3=nameFolds3(3:end);
        no_dir=numel(nameFolds3);
    
        nameFolds_MN = [nameFolds1;nameFolds2];
        nameFolds_PN = [nameFolds3;nameFolds2];% All nametags of the patients are present here
    idx=1;
    sacle_idx=2:6;      % scale_idx is the variable which stores scale of the gabor filters. Here we considered 5 different scales.
    AROI_Gabor_HM_M_Frontal=cell(numel(sacle_idx),1);
    AROI_Gabor_HM_P_Frontal=cell(numel(sacle_idx),1);
    AROI_Gabor_HM_N_Frontal=cell(numel(sacle_idx),1);
    %---for each scale gabor features are calculated, appended and saved.---%
    for sacle_idx=2:6
  
         
%           AROI_ComputeGaborIR_Frontal(sacle_idx)
%           AROI_Gabor_HMFeatures_between_lt_and_rt_Frontal(sacle_idx);
        cd('..\Classification\libsvm-3.20\matlab')
        load(['..\..\..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Malignant_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Normal_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Precancer_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
        AROI_Gabor_HM_M_Frontal{idx,1}=AROI_Malignant_Gabor_HM_append_LT_RT_Frontface;
        AROI_Gabor_HM_P_Frontal{idx,1}=AROI_Precancer_Gabor_HM_append_LT_RT_Frontface;
        AROI_Gabor_HM_N_Frontal{idx,1}=AROI_Normal_Gabor_HM_append_LT_RT_Frontface;
        idx=idx+1;
        cd('..\..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
    end
    %========================End of Feature extraction%========================
    %========================- Save the features ========================%
    
    cd('..\GaborFeatures_HM_allScale');
    save('AROI_Gabor_HM_M_Frontal','AROI_Gabor_HM_M_Frontal');
    save('AROI_Gabor_HM_P_Frontal','AROI_Gabor_HM_P_Frontal');
    save('AROI_Gabor_HM_N_Frontal','AROI_Gabor_HM_N_Frontal');
    %================================================%
    
    %========================Classification Starts=======================
    
    
    cd('..\GaborFeatures_HM_allScale');
    size_M=size(AROI_Gabor_HM_M_Frontal{1,1},1);
    size_P=size(AROI_Gabor_HM_P_Frontal{1,1},1);
    size_N=size(AROI_Gabor_HM_N_Frontal{1,1},1);
    ro_NM=size_N/size_M;
    ro_NP=size_N/size_P;
    load('AROI_Gabor_HM_M_Frontal','AROI_Gabor_HM_M_Frontal');
     AROI_Gabor_HM_M_Frontal = improve_imbalance(AROI_Gabor_HM_M_Frontal,ro_NM);
    load('AROI_Gabor_HM_P_Frontal','AROI_Gabor_HM_P_Frontal');
      AROI_Gabor_HM_P_Frontal = improve_imbalance(AROI_Gabor_HM_P_Frontal,ro_NP);
    load('AROI_Gabor_HM_N_Frontal','AROI_Gabor_HM_N_Frontal');
    
    cd('..\Classification\libsvm-3.20\matlab');
    
    %=================Malignant vs Normal==================%
    viz_case='AROI_Full_MN_Frontal'
    folder_name=['AROI_Full_Gabor_MN_Frontal' ];
    save_mat='MN_Parameters_Frontal';
    results_save_dir='GaborResults\AutomatedROI';
    sacle_idx=2:6;
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='AROI_MN_FULL';
    


 [final_accuracy_MN,sensivity_MN,specificity_MN] = run_Gabor_libsvm_Full_26_8_19(AROI_Gabor_HM_M_Frontal,AROI_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting,nameFolds_MN)
    cd('../../../');
    
    
    %=================Precancer vs Normal ==================%
    viz_case='AROI_Full_PN_Frontal'
    folder_name=['AROI_Full_Gabor_PN_Frontal' ];
    save_mat='PN_Parameters_Frontal';
    results_save_dir='GaborResults\AutomatedROI';
    
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='AROI_PN_FULL';
    
    %---------------------
    

       [final_accuracy_PN,sensitivity_PN,specificity_PN] = run_Gabor_libsvm_Full_26_8_19(AROI_Gabor_HM_P_Frontal,AROI_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting,nameFolds_PN)
    
    %========================Classification Ends=======================
    
    
elseif (strcmp(User_Choice,'6')==1)
    
    %========================Start of Feature extraction%========================
    
    
    clear;
    idx=1;
    sacle_idx=2:6;
    AROI_AgeAdjust_Gabor_HM_M_Frontal=cell(numel(sacle_idx),1);
    AROI_AgeAdjust_Gabor_HM_P_Frontal=cell(numel(sacle_idx),1);
    AROI_AgeAdjust_Gabor_HM_N_Frontal=cell(numel(sacle_idx),1);
    %---for each scale gabor features are calculated, appended and saved.---%
    for sacle_idx=2:6
%       AROI_AgeAdjust_ComputeGaborIR_Frontal(sacle_idx);
%       AROI_AgeAdjust_Gabor_HMFeatures_between_lt_and_rt_Frontal(sacle_idx);
        cd('..\Classification\libsvm-3.20\matlab')
        load(['..\..\..\GaborFeatures_HM_allScale\AROI_AgeAdjust_Gabor_HM_Malignant_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\AROI_AgeAdjust_Gabor_HM_Normal_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\AROI_AgeAdjust_Gabor_HM_Precancer_Frontal_face_scale_',num2str(sacle_idx),'.mat']);
        AROI_AgeAdjust_Gabor_HM_M_Frontal{idx,1}=AROI_Malignant_Gabor_HM_append_LT_RT_Frontface;
        AROI_AgeAdjust_Gabor_HM_P_Frontal{idx,1}=AROI_Precancer_Gabor_HM_append_LT_RT_Frontface;
        AROI_AgeAdjust_Gabor_HM_N_Frontal{idx,1}=AROI_Normal_Gabor_HM_append_LT_RT_Frontface;
        idx=idx+1;
        cd('..\..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
        
    end
    %========================End of Feature extraction%========================
    %========================- Save the features ========================%
    cd('..\GaborFeatures_HM_allScale');
    save('AROI_AgeAdjust_Gabor_HM_M_Frontal','AROI_AgeAdjust_Gabor_HM_M_Frontal');
    save('AROI_AgeAdjust_Gabor_HM_P_Frontal','AROI_AgeAdjust_Gabor_HM_P_Frontal');
    save('AROI_AgeAdjust_Gabor_HM_N_Frontal','AROI_AgeAdjust_Gabor_HM_N_Frontal');
    %================================================%
    %========================Classification Starts=======================
    
    cd('..\GaborFeatures_HM_allScale');
    load('AROI_AgeAdjust_Gabor_HM_M_Frontal','AROI_AgeAdjust_Gabor_HM_M_Frontal');
    load('AROI_AgeAdjust_Gabor_HM_P_Frontal','AROI_AgeAdjust_Gabor_HM_P_Frontal');
    load('AROI_AgeAdjust_Gabor_HM_N_Frontal','AROI_AgeAdjust_Gabor_HM_N_Frontal');
    
    cd('..\Classification\libsvm-3.20\matlab');
    
    
    %=================Malignant vs Normal==================%
    viz_case='AROI_AgeAdjust_MN_Frontal'
    folder_name=['AROI_AgeAdjust_Gabor_MN_Frontal' ];
    save_mat='MN_AgeAdjust_Parameters_Frontal';
    results_save_dir='GaborResults\AutomatedROI';
    
    sacle_idx=2:6;
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='AROI_MN_AGE';
    
    %---------------------
    
    cd(' D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
    [final_accuracy_MN] = run_Gabor_libsvm_AgeAdjust_26_8_19(AROI_AgeAdjust_Gabor_HM_M_Frontal,AROI_AgeAdjust_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting)
    cd('../../../');
    
    %=================Precancer vs Normal ==================%
    viz_case ='AROI_AgeAdjust_PN_Frontal'
    folder_name=['AROI_AgeAdjust_Gabor_PN_Frontal' ];
    save_mat='PN_AgeAdjust_Parameters_Frontal';
    results_save_dir='GaborResults\AutomatedROI';
    Flag='1'; %put Flag=0 if want to compute crossvalidation index all over again
    
    Setting='AROI_PN_AGE';
    
    %---------------------
    
    [final_accuracy_PN] = run_Gabor_libsvm_AgeAdjust_26_8_19(AROI_AgeAdjust_Gabor_HM_P_Frontal,AROI_AgeAdjust_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting)
    
    %========================Classification Ends=======================
    
elseif (strcmp(User_Choice,'7')==1)
    %-------------------------------------------------------------------------------------------------------
    %========================Start of Feature extraction%========================
    
    disp('false');
    clear;
    idx=1;
    sacle_idx=2:6;        % scale_idx is the variable which stores scale of the gabor filters. Here we considered 5 different scales.
    AROI_Gabor_HM_M_Profile=cell(numel(sacle_idx),1);
    AROI_Gabor_HM_P_Profile=cell(numel(sacle_idx),1);
    AROI_Gabor_HM_N_Profile=cell(numel(sacle_idx),1);
    %---For each scale, gabor features are calculated for each half of the face. Features from each half of face is appended and saved.---%
  
    for sacle_idx=2:6
        %------starting of making folders for data analysis-------%
        
        d1 = dir('..\..\..\ThermalDatabase\Malignant');%%% d stores a structure of 6 fields
           
        isub = [d1(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds1 = {d1(isub).name}'; 
        nameFolds1 = nameFolds1(3:end);
        no_dir = numel(nameFolds1);
        
        d2 = dir('..\..\..\ThermalDatabase\Normal');%%% d stores a structure of 6 fields
           
        isub = [d2(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds2 = {d2(isub).name}'; 
        nameFolds2 = nameFolds2(3:end);
        no_dir = numel(nameFolds2);
        
        d3 = dir('..\..\..\ThermalDatabase\NonMalignant');%%% d stores a structure of 6 fields
           
        isub = [d3(:).isdir]; %# returns logical vector (1 by folders with sub diectory )
        nameFolds3 = {d3(isub).name}'; 
        nameFolds3=nameFolds3(3:end);
        no_dir=numel(nameFolds3);
    
        nameFolds_MN = [nameFolds1;nameFolds2];
        nameFolds_PN = [nameFolds3;nameFolds2];% All nametags of the patients are present here
%           AROI_ComputeGaborIR_Profile(sacle_idx);
%           AROI_Gabor_HMFeatures_between_lt_and_rt_haralic_Profile(sacle_idx);
        cd('..\Classification\libsvm-3.20\matlab')
        load(['..\..\..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Malignant_Profile_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Normal_Profile_face_scale_',num2str(sacle_idx),'.mat']);
        load(['..\..\..\GaborFeatures_HM_allScale\AROI_Gabor_HM_Precancer_Profile_face_scale_',num2str(sacle_idx),'.mat']);
        AROI_Gabor_HM_M_Profile{idx,1}=AROI_Malignant_Gabor_HM_append_LT_RT_Profileface;
        AROI_Gabor_HM_P_Profile{idx,1}=AROI_Precancer_Gabor_HM_append_LT_RT_Profileface;
        AROI_Gabor_HM_N_Profile{idx,1}=AROI_Normal_Gabor_HM_append_LT_RT_Profileface;
        idx=idx+1;
        cd('..\..\..\..\..\code repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
    end
    
    %========================End of Feature extraction%========================
    
    %========================- Save the features ========================%
    
    cd('..\GaborFeatures_HM_allScale');
    save('AROI_Gabor_HM_M_Profile','AROI_Gabor_HM_M_Profile');
    save('AROI_Gabor_HM_P_Profile','AROI_Gabor_HM_P_Profile');
    save('AROI_Gabor_HM_N_Profile','AROI_Gabor_HM_N_Profile');
    %================================================%
    %-------------------------------------------------------------------------------------------------------
    %========================Classification Starts=======================
    cd('..\GaborFeatures_HM_allScale');
    size_M=size(AROI_Gabor_HM_M_Profile{1,1},1);
    size_P=size(AROI_Gabor_HM_P_Profile{1,1},1);
    size_N=size(AROI_Gabor_HM_N_Profile{1,1},1);
    ro_NM=size_N/size_M; % Ratio of imbalance 
    ro_NP=size_N/size_P; % Ratio of imbalance 
    load('AROI_Gabor_HM_M_Profile','AROI_Gabor_HM_M_Profile');
     AROI_Gabor_HM_M_Profile = improve_imbalance(AROI_Gabor_HM_M_Profile,ro_NM); % To counter the imbalance between the classes
    load('AROI_Gabor_HM_P_Profile','AROI_Gabor_HM_P_Profile');
     AROI_Gabor_HM_P_Profile = improve_imbalance(AROI_Gabor_HM_P_Profile,ro_NP); % To counter the imbalance between the classes
    load('AROI_Gabor_HM_N_Profile','AROI_Gabor_HM_N_Profile');
    
    cd('..\Classification\libsvm-3.20\matlab');
    
    %=================Malignant vs Normal==================%
    viz_case='AROI_Full_MN_Profile'
    folder_name=['Full_Gabor_MN_Profile' ];
    save_mat='MN_Parameters_Profile';
    results_save_dir='GaborResults\GTROI';
    
    sacle_idx=2:6;
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='PROFILE_AROI_MN_FULL';
    
    
    cd(' D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Multiresolution\Gabor_Han&Ma_ArbitraryShape_RBR_1456');
    addpath('  D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Multiresolution\Classification\libsvm-3.20\matlab');
    [final_accuracy_MN,sensivity_MN,specificity_MN] = run_Gabor_libsvm_Full_26_8_19(AROI_Gabor_HM_M_Profile,AROI_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting,nameFolds_MN)
    cd('../../../');
    
    %=================Precancer vs Normal ==================%
    viz_case='AROI_Full_PN_profile'
    folder_name=['AROI_Full_Gabor_PN_Profile' ];
    save_mat='PN_Parameters_Profile';
    results_save_dir='GaborResults\AutomatedROI';
    
    Flag='0'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='PROFILE_AROI_PN_FULL';
    
    
    

   [final_accuracy_PN,sensitivity_PN,specificity_PN] = run_Gabor_libsvm_Full_26_8_19(AROI_Gabor_HM_M_Profile,AROI_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting,nameFolds_PN)
    
    
    %========================Classification Ends=======================
    
  
    
    
else
    disp('Invalid Choice!');
    
end