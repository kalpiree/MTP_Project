% =========================== Run_ErrorHistogram.m ====================================== %
% Description  : This code is the main code which contains the functions
% for feature extraction and classification codes for haralick feature.
%

% ================================================================================== %
%

% Author of the code: Manashi Chakraborty
% Date of creation :
% ------------------------------------------------------------------------------------------------------- %
% Modified on :
% Modification details:
% Modified By :  Manashi Chakraborty
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %



clear;
clc;
close all;


%% Enter your choice

disp('Enter your options:');
disp('1: Extraction and Classification for Front Face Full DB')
disp('2: Extraction and Classification for Front Face AgeAdjusted DB ')
disp('3: Extraction and Classification for Profile Face Full DB ')
disp('4: Extraction and Classification for Profile Face AgeAdjusted DB')
question=('Enter either 1, 2, 3 or 4?=?');
User_Choice=input(question,'s');


%========================GroundTruth ROI Frontal for Full Database=======================
if (strcmp(User_Choice,'1')==1)
    
    %========================Feature Extraction Starts=======================
    
                GT_Malignant_Texture_Frontal_Face_thermal; %Feature Extraction: Malignant
    
                GT_Precancer_Texture_Frontal_Face_thermal; %Feature Extraction: Precancer
    
                GT_Normal_Texture_Frontal_Face_thermal;    %Feature Extraction: Normal
    
                GT_Front_HaralickFeatureConcate; % Concatinate features
                GT_MN_pvalue_AUC_FrontalFace; % Significant features for MN
                GT_PN_pvalue_AUC_FrontalFace; % Significant features for PN
    
    
    %========================Feature Extraction Ends=======================
    
    %========================Classification Starts=======================
    
    cd('..\Classification\Cluster Prototype Classification\');
    load('..\..\HaralickFeatures\SignifantFeatures\GT_Significant_Haralick_MalignantNormal_Frontal.mat');
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='MN_F_FULL';
    %~~~~~~~~~~~~~~~~~~~~~~~~Malignnat versus Normal~~~~~~~~~~~~~~~~~~~
    
    [final_accuracy_fk,final_accuracy_k,no_of_cluster_fcm,no_of_cluster_kmeans,indices,center_fcm,center_kmeans,idx_kmeans,U_fcm]=kmeans_fuzzy_MN(GT_SignificantMalignant_Frontal_LTandRT_append,GT_SignificantNormal_Frontal_LTandRT_append,Flag,Setting);
    save('..\Haralick Results\HaralicResult_MN_F_Full','final_accuracy_fk','final_accuracy_k','no_of_cluster_fcm','no_of_cluster_kmeans','indices','center_fcm','center_kmeans','idx_kmeans','U_fcm');
    
    
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='PN_F_FULL';
    %~~~~~~~~~~~~~~~~~~~~~~~~Precancerous versus Normal~~~~~~~~~~~~~~~~~~~
    
    load('..\..\HaralickFeatures\SignifantFeatures\GT_Significant_Haralick_PrecancerousNormal_Frontal.mat');
    [final_accuracy_fk,final_accuracy_k,no_of_cluster_fcm,no_of_cluster_kmeans,indices,center_fcm,center_kmeans,idx_kmeans,U_fcm]=kmeans_fuzzy_PN(GT_SignificantPrecancerous_Frontal_LTandRT_append,GT_SignificantNormal_Frontal_LTandRT_append,Flag,Setting);
    save('..\Haralick Results\HaralicResult_PN_F_Full','final_accuracy_fk','final_accuracy_k','no_of_cluster_fcm','no_of_cluster_kmeans','indices','center_fcm','center_kmeans','idx_kmeans','U_fcm');
    
    %========================Classification Ends=======================
    
    
    %========================GroundTruth ROI Frontal for Age Adjusted Database=======================
elseif (strcmp(User_Choice,'2')==1)
    
    %========================Feature Extraction Starts=======================
    
                GT_Malignant_Texture_Frontal_Face_thermal;
    
                GT_Precancer_Texture_Frontal_Face_thermal;
    
                AgeAdjust_GT_Normal_Texture_Frontal_Face_thermal;
    
                GT_Front_HaralickFeatureConcate_AgeAdjust;
    
                AgeAdjust_GT_MN_pvalue_AUC_FrontalFace;
                AgeAdjust_GT_PN_pvalue_AUC_FrontalFace;
    %             ========================Feature Extraction Ends=======================
    
    %========================Classification Starts=======================
    
    
    cd('..\Classification\Cluster Prototype Classification\');
    load('..\..\HaralickFeatures\SignifantFeatures\AgeAdjust_GT_Significant_Haralick_MalignantNormal_Frontal.mat');
    GT_SignificantNormal_Frontal_LTandRT_append = SMOTE_vik(GT_SignificantNormal_Frontal_LTandRT_append,2,5);
    
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='MN_F_AGE';
    %~~~~~~~~~~~~~~~~~~~~~~~~Malignant versus Normal~~~~~~~~~~~~~~~~~~~
    
    [final_accuracy_fk,final_accuracy_k,no_of_cluster_fcm,no_of_cluster_kmeans,indices,center_fcm,center_kmeans,idx_kmeans,U_fcm]=kmeans_fuzzy_MN(GT_SignificantMalignant_Frontal_LTandRT_append,GT_SignificantNormal_Frontal_LTandRT_append,Flag,Setting);
    save('..\Haralick Results\HaralicResult_MN_F_AgeAdjust','final_accuracy_fk','final_accuracy_k','no_of_cluster_fcm','no_of_cluster_kmeans','indices','center_fcm','center_kmeans','idx_kmeans','U_fcm');
    
    
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='PN_F_AGE';
    
    load('..\..\HaralickFeatures\SignifantFeatures\AgeAdjust_GT_Significant_Haralick_PrecancerousNormal_Frontal.mat');
    %SMOTE technique to generate linear samples of normal age adjust samples
    GT_SignificantNormal_Frontal_LTandRT_append = SMOTE_vik(GT_SignificantNormal_Frontal_LTandRT_append,2,5);
    %~~~~~~~~~~~~~~~~~~~~~~~~Precancerous versus Normal~~~~~~~~~~~~~~~~~~~
    
    [final_accuracy_fk,final_accuracy_k,no_of_cluster_fcm,no_of_cluster_kmeans,indices,center_fcm,center_kmeans,idx_kmeans,U_fcm]=kmeans_fuzzy_PN(GT_SignificantPrecancerous_Frontal_LTandRT_append,GT_SignificantNormal_Frontal_LTandRT_append,Flag,Setting);
    
    save('..\Haralick Results\HaralicResult_PN_F_AgeAdjust','final_accuracy_fk','final_accuracy_k','no_of_cluster_fcm','no_of_cluster_kmeans','indices','center_fcm','center_kmeans','idx_kmeans','U_fcm');
    
    %========================Classification Starts=======================
    
    %========================GroundTruth ROI Profile for Full Database=======================
elseif (strcmp(User_Choice,'3')==1)
    
    %========================Feature Extraction Starts=======================
    
                GT_Malignant_Texture_Profile_Face_thermal;
    
                GT_Precancer_Texture_Profile_Face_thermal;
    
                GT_Normal_Texture_Profile_Face_thermal;
    
                GT_Profile_HaralickFeatureConcate;
    
                GT_MN_pvalue_AUC_ProfileFace;
                GT_PN_pvalue_AUC_ProfileFace;
%     
    %========================Feature Extraction Ends=======================
    
    %========================Classification Starts=======================
    
    
    cd('..\Classification\Cluster Prototype Classification\');
    load('..\..\HaralickFeatures\SignifantFeatures\GT_Significant_Haralick_MalignantNormal_Profile.mat');
    
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='MN_P_FULL';
    %~~~~~~~~~~~~~~~~~~~~~~~~Malignant versus Normal~~~~~~~~~~~~~~~~~~~
    
    [final_accuracy_fk,final_accuracy_k,no_of_cluster_fcm,no_of_cluster_kmeans,indices,center_fcm,center_kmeans,idx_kmeans,U_fcm]=kmeans_fuzzy_MN(GT_SignificantMalignant_Profile_LTandRT_append,GT_SignificantNormal_Profile_LTandRT_append,Flag,Setting);
    
    save('..\Haralick Results\HaralicResult_MN_P_Full','final_accuracy_fk','final_accuracy_k','no_of_cluster_fcm','no_of_cluster_kmeans','indices','center_fcm','center_kmeans','idx_kmeans','U_fcm');
    
    %   Classification Ground Truth for full data. View: Profile Face
    
    
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='PN_P_FULL';
    load('..\..\HaralickFeatures\SignifantFeatures\GT_Significant_Haralick_PrecancerousNormal_Profile.mat');
    
    %~~~~~~~~~~~~~~~~~~~~~~~~Precancerous versus Normal~~~~~~~~~~~~~~~~~~~
    [final_accuracy_fk,final_accuracy_k,no_of_cluster_fcm,no_of_cluster_kmeans,indices,center_fcm,center_kmeans,idx_kmeans,U_fcm]=kmeans_fuzzy_PN(GT_SignificantPrecancerous_Profile_LTandRT_append,GT_SignificantNormal_Profile_LTandRT_append,Flag,Setting);
    
    save('..\Haralick Results\HaralicResult_PN_P_Full','final_accuracy_fk','final_accuracy_k','no_of_cluster_fcm','no_of_cluster_kmeans','indices','center_fcm','center_kmeans','idx_kmeans','U_fcm');
    
    %========================Classification Ends=======================
    
    %========================GroundTruth ROI Profile for AgeAdjusted Database=======================
elseif (strcmp(User_Choice,'4')==1)
    
    %========================Feature Extraction Starts=======================
    
                GT_Malignant_Texture_Profile_Face_thermal;
    
                GT_Precancer_Texture_Profile_Face_thermal;
    
                 AgeAdjust_GT_Normal_Texture_Profile_Face_thermal;
    
                 GT_Profile_HaralickFeatureConcate_AgeAdjust;
    
    
                AgeAdjust_GT_MN_pvalue_AUC_ProfileFace;
%                 AgeAdjust_GT_PN_pvalue_AUC_ProfileFace;
    %========================Feature Extraction Ends=======================
    
    
    %========================Classification Starts=======================
    
    cd('..\Classification\Cluster Prototype Classification\');
    load('..\..\HaralickFeatures\SignifantFeatures\AgeAdjust_GT_Significant_Haralick_MalignantNormal_Profile.mat');
    GT_SignificantNormal_Profile_LTandRT_append = SMOTE_vik(GT_SignificantNormal_Profile_LTandRT_append,2,5);
    
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='MN_P_AGE';
    %          %~~~~~~~~~~~~~~~~~~~~~~~~Malignant versus Normal~~~~~~~~~~~~~~~~~~~
    %
    [final_accuracy_fk,final_accuracy_k,no_of_cluster_fcm,no_of_cluster_kmeans,indices,center_fcm,center_kmeans,idx_kmeans,U_fcm]=kmeans_fuzzy_MN(GT_SignificantMalignant_Profile_LTandRT_append,GT_SignificantNormal_Profile_LTandRT_append,Flag,Setting);
    
    
      save('..\Haralick Results\HaralicResult_MN_P_AgeAdjust','final_accuracy_fk','final_accuracy_k','no_of_cluster_fcm','no_of_cluster_kmeans','indices','center_fcm','center_kmeans','idx_kmeans','U_fcm');
    
    
    
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='PN_P_AGE';
    %~~~~~~~~~~~~~~~~~~~~~~~~Precancerous versus Normal~~~~~~~~~~~~~~~~~~~
    
    load('..\..\HaralickFeatures\SignifantFeatures\AgeAdjust_GT_Significant_Haralick_PrecancerousNormal_Profile.mat');
    %SMOTE technique to generate linear samples of normal age adjust samples
    
    GT_SignificantNormal_Profile_LTandRT_append = SMOTE_vik(GT_SignificantNormal_Profile_LTandRT_append,2,5);
    [final_accuracy_fk,final_accuracy_k,no_of_cluster_fcm,no_of_cluster_kmeans,indices,center_fcm,center_kmeans,idx_kmeans,U_fcm]=kmeans_fuzzy_PN(GT_SignificantPrecancerous_Profile_LTandRT_append,GT_SignificantNormal_Profile_LTandRT_append,Flag,Setting);
    
    
    
    
    save('..\Haralick Results\HaralicResult_PN_P_AgeAdjust','final_accuracy_fk','final_accuracy_k','no_of_cluster_fcm','no_of_cluster_kmeans','indices','center_fcm','center_kmeans','idx_kmeans','U_fcm');
    
    %========================Classification Ends=======================
    
else
    disp('Invalid Choice!');
end

