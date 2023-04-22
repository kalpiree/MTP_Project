% =========================== Run_ErrorHistogram.m ====================================== %
% Description  : This code is the main code which contains the functions
% for feature extraction and classification codes for error histogram.
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

            GT_Histogram_Frontal_Face_Malignant; 
       
            GT_Histogram_Frontal_Face_Precancer;
        
            GT_Histogram_Frontal_Face_Normal;
         
            GT_Front_FeatureConcate;
%   %========================Feature Extraction Ends=======================

  %========================Classification Starts=======================
            cd('SPIE 2016 Classification');
            load('..\ErrorHistogram\GT_Full_ErrorHistogram_Malignant_Frontal_face.mat');
            load('..\ErrorHistogram\GT_Full_ErrorHistogram_Normal_Frontal_face.mat');
            load('..\ErrorHistogram\GT_Full_ErrorHistogram_NonMalignant_Frontal_face.mat');
            MAE128_Front_Normal=MAE128_Front_Normal';%%%Transpose operation
            MAE128_Front_Malignant=MAE128_Front_Malignant';
            MAE128_Front_NonMalignant=MAE128_Front_NonMalignant';
           
   %~~~~~~~~~~~~~~~~~~~~~~~~Malignant versus Normal~~~~~~~~~~~~~~~~~~~
              Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again

   
              Setting='MN_F_FULL';

             [MN_final_accuracy_fk_1D,MN_final_accuracy_k_1D,no_of_cluster_fcm_MN,no_of_cluster_kmeans_MN,indices_MN,center_fcm_MN,center_kmeans_MN,idx_kmeans_MN,U_fcm_MN]= GT_MN_kmeans_fuzzy(MAE128_Front_Malignant,MAE128_Front_Normal,Flag,Setting);
            save ('Error Histogram Results\MN_F_Full','MN_final_accuracy_fk_1D','MN_final_accuracy_k_1D','no_of_cluster_fcm_MN','no_of_cluster_kmeans_MN','indices_MN','center_fcm_MN','center_kmeans_MN','idx_kmeans_MN','U_fcm_MN')
            

            %*************************
          
 %~~~~~~~~~~~~~~~~~~~~~~~~Precancerous versus Normal~~~~~~~~~~~~~~~~~~~             
            Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
 
  
            Setting='PN_F_FULL';  
            
            [PN_final_accuracy_fk_1D,PN_final_accuracy_k_1D,no_of_cluster_fcm_PN,no_of_cluster_kmeans_PN,indices_PN,center_fcm_PN,center_kmeans_PN,idx_kmeans_PN,U_fcm_PN]= GT_PN_kmeans_fuzzy(MAE128_Front_NonMalignant,MAE128_Front_Normal,Flag,Setting);
            save ('Error Histogram Results\PN_F_Full','PN_final_accuracy_fk_1D','PN_final_accuracy_k_1D','no_of_cluster_fcm_PN','no_of_cluster_kmeans_PN','indices_PN','center_fcm_PN','center_kmeans_PN','idx_kmeans_PN','U_fcm_PN')
            %********************************

  %========================Classification Ends=======================

 %========================GroundTruth ROI Frontal for Age Adjusted Database=======================

 elseif (strcmp(User_Choice,'2')==1)
  %========================Feature Extraction Starts=======================

  
            GT_Histogram_Frontal_Face_Malignant; %calculate features
        
            GT_Histogram_Frontal_Face_Precancer;
            
            GT_Histogram_Frontal_Face_Normal_AgeAdjust;
            
            GT_Front_FeatureConcate_AgeAdjust;
  
            
            
            % Ground Truth Age Adjust Classification
  %========================Feature Extraction Ends=======================
  
  %========================Classification Starts=======================

            cd('SPIE 2016 Classification');
            load('..\ErrorHistogram\AgeAdjust_GT_ErrorHistogram_Malignant_Frontal_face.mat');
            load('..\ErrorHistogram\AgeAdjust_GT_ErrorHistogram_Normal_Frontal_face.mat');
            load('..\ErrorHistogram\AgeAdjust_GT_ErrorHistogram_NonMalignant_Frontal_face.mat');
            MAE128_Front_Normal=MAE128_Front_Normal';
            MAE128_Front_Malignant=MAE128_Front_Malignant';
            MAE128_Front_NonMalignant=MAE128_Front_NonMalignant';
            MAE128_Front_Normal = SMOTE_vik(MAE128_Front_Normal,2,5);

         
   %~~~~~~~~~~~~~~~~~~~~~~~~Malignant versus Normal~~~~~~~~~~~~~~~~~~~
             Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
 
            
             Setting='MN_F_AGE';
             
            [MN_final_accuracy_fk_1D,MN_final_accuracy_k_1D,no_of_cluster_fcm_MN,no_of_cluster_kmeans_MN,indices_MN,center_fcm_MN,center_kmeans_MN,idx_kmeans_MN,U_fcm_MN]= GT_MN_kmeans_fuzzy(MAE128_Front_Malignant,MAE128_Front_Normal,Flag,Setting);

            save('Error Histogram Results\MN_F_Age','MN_final_accuracy_fk_1D','MN_final_accuracy_k_1D','no_of_cluster_fcm_MN','no_of_cluster_kmeans_MN','indices_MN','center_fcm_MN','center_kmeans_MN','idx_kmeans_MN','U_fcm_MN');
            
        
          
 %~~~~~~~~~~~~~~~~~~~~~~~~Precancerous versus Normal~~~~~~~~~~~~~~~~~~~
            Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
 
            Setting='PN_F_AGE';

            [PN_final_accuracy_fk_1D,PN_final_accuracy_k_1D,no_of_cluster_fcm_PN,no_of_cluster_kmeans_PN,indices_PN,center_fcm_PN,center_kmeans_PN,idx_kmeans_PN,U_fcm_PN]= GT_PN_kmeans_fuzzy(MAE128_Front_NonMalignant,MAE128_Front_Normal,Flag,Setting);
          
            save('Error Histogram Results\PN_F_Age','PN_final_accuracy_fk_1D','PN_final_accuracy_k_1D','no_of_cluster_fcm_PN','no_of_cluster_kmeans_PN','indices_PN','center_fcm_PN','center_kmeans_PN','idx_kmeans_PN','U_fcm_PN')

 %========================Classification Ends=======================

 %========================GroundTruth ROI Profile for Full Database=======================

elseif (strcmp(User_Choice,'3')==1)
  %========================Feature Extraction Starts=======================

                GT_Histogram_Profile_Face_Malignant; 
            
                GT_Histogram_Profile_Face_Precancer;
               
                GT_Histogram_Profile_Face_Normal;
             
                GT_Profile_FeatureConcate;
  %========================Feature Extraction Ends=======================

  %========================Classification Starts=======================

                cd('SPIE 2016 Classification');
                load('..\ErrorHistogram\GT_Full_ErrorHistogram_Malignant_Profile_face.mat');
                load('..\ErrorHistogram\GT_Full_ErrorHistogram_Normal_Profile_face.mat');
                load('..\ErrorHistogram\GT_Full_ErrorHistogram_NonMalignant_Profile_face.mat');
                MAE128_Profile_Normal=MAE128_Profile_Normal';
                MAE128_Profile_Malignant=MAE128_Profile_Malignant';
                MAE128_Profile_NonMalignant=MAE128_Profile_NonMalignant';
                
               
                
                
            
  %~~~~~~~~~~~~~~~~~~~~~~~~Malignant versus Normal~~~~~~~~~~~~~~~~~~~
                Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again

  
                Setting='MN_P_FULL';
                
                [MN_final_accuracy_fk_1D,MN_final_accuracy_k_1D,no_of_cluster_fcm_MN,no_of_cluster_kmeans_MN,indices_MN,center_fcm_MN,center_kmeans_MN,idx_kmeans_MN,U_fcm_MN]= GT_MN_kmeans_fuzzy(MAE128_Profile_Malignant,MAE128_Profile_Normal,Flag,Setting);
            
               save('Error Histogram Results\MN_P_Full','MN_final_accuracy_fk_1D','MN_final_accuracy_k_1D','no_of_cluster_fcm_MN','no_of_cluster_kmeans_MN','indices_MN','center_fcm_MN','center_kmeans_MN','idx_kmeans_MN','U_fcm_MN');
%~~~~~~~~~~~~~~~~~~~~~~~~Precancerous versus Normal~~~~~~~~~~~~~~~~~~~

                Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again

                Setting='PN_P_FULL';
          
                [PN_final_accuracy_fk_1D,PN_final_accuracy_k_1D,no_of_cluster_fcm_PN,no_of_cluster_kmeans_PN,indices_PN,center_fcm_PN,center_kmeans_PN,idx_kmeans_PN,U_fcm_PN]= GT_PN_kmeans_fuzzy(MAE128_Profile_NonMalignant,MAE128_Profile_Normal,Flag,Setting);
               
                save('Error Histogram Results\PN_P_Full','PN_final_accuracy_fk_1D','PN_final_accuracy_k_1D','no_of_cluster_fcm_PN','no_of_cluster_kmeans_PN','indices_PN','center_fcm_PN','center_kmeans_PN','idx_kmeans_PN','U_fcm_PN')
  %========================Classification Ends=======================
  
  %========================GroundTruth ROI Profile for AgeAdjusted Database=======================
                
 elseif (strcmp(User_Choice,'4')==1)
 %========================Feature Extraction Starts=======================

           
               GT_Histogram_Profile_Face_Malignant; %calculate features
              
               GT_Histogram_Profile_Face_Precancer;
              
               GT_Histogram_Profile_Face_Normal_AgeAdjust
             
               GT_Profile_FeatureConcate_AgeAdjust;
                 
 %========================Feature Extraction Ends=======================
   
  %========================Classification Starts=======================

                cd('SPIE 2016 Classification');
                load('..\ErrorHistogram\AgeAdjust_GT_ErrorHistogram_Malignant_Profile_face.mat');
                load('..\ErrorHistogram\AgeAdjust_GT_ErrorHistogram_Normal_Profile_face.mat');
                load('..\ErrorHistogram\AgeAdjust_GT_ErrorHistogram_NonMalignant_Profile_face.mat');
                MAE128_Profile_Normal=MAE128_Profile_Normal';
                MAE128_Profile_Malignant=MAE128_Profile_Malignant';
                MAE128_Profile_NonMalignant=MAE128_Profile_NonMalignant';
                MAE128_Profile_Normal = SMOTE_vik(MAE128_Profile_Normal,2,5);

               
              
                
              %~~~~~~~~~~~~~~~~~~~~~~~~Malignant versus Normal~~~~~~~~~~~~~~~~~~~
                Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again

                Setting='MN_P_AGE';
                
                
                [MN_final_accuracy_fk_1D,MN_final_accuracy_k_1D,no_of_cluster_fcm_MN,no_of_cluster_kmeans_MN,indices_MN,center_fcm_MN,center_kmeans_MN,idx_kmeans_MN,U_fcm_MN]= GT_MN_kmeans_fuzzy(MAE128_Profile_Malignant,MAE128_Profile_Normal,Flag,Setting);
               

                save('Error Histogram Results\MN_P_Age','MN_final_accuracy_fk_1D','MN_final_accuracy_k_1D','no_of_cluster_fcm_MN','no_of_cluster_kmeans_MN','indices_MN','center_fcm_MN','center_kmeans_MN','idx_kmeans_MN','U_fcm_MN');

            
                
             %~~~~~~~~~~~~~~~~~~~~~~~~Precancerous versus Normal~~~~~~~~~~~~~~~~~~~
                Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
                Setting='PN_P_AGE';

            
                [PN_final_accuracy_fk_1D,PN_final_accuracy_k_1D,no_of_cluster_fcm_PN,no_of_cluster_kmeans_PN,indices_PN,center_fcm_PN,center_kmeans_PN,idx_kmeans_PN,U_fcm_PN]= GT_PN_kmeans_fuzzy(MAE128_Profile_NonMalignant,MAE128_Profile_Normal,Flag,Setting);
               
                save('Error Histogram Results\PN_P_Age','PN_final_accuracy_fk_1D','PN_final_accuracy_k_1D','no_of_cluster_fcm_PN','no_of_cluster_kmeans_PN','indices_PN','center_fcm_PN','center_kmeans_PN','idx_kmeans_PN','U_fcm_PN')
                 
               
   %========================Classification Ends=======================
            

 else
        disp('Invalid Choice');
 end