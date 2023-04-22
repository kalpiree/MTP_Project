clear all;
clc;
close all;
%% Display your choice
sacle_idx=2:6; % scale_idx is the variable which stores scale of the gabor filters. Here we considered 5 different scales.
disp('Enter your options:');
disp('1: Ground truth region of interest frontal')
disp('2: Ground truth region of interest Age Adjusted frontal')
disp('3: Ground truth region of interest Profile')
disp('4: Ground truth region of interest Age Adjusted Profile')
disp('5: Automated region of interest frontal')
disp('6: Automated region of interest Age Adjusted frontal')
question=('Enter The Above options');
User_Choice=input(question,'s');



if (strcmp(User_Choice,'1')==1)

    disp('Enter your options:');
    disp('E:Feature  Extraction     C: Classification');
    question=('Enter your choice=');
    User_Choice=input(question,'s');
    
    if (strcmp(User_Choice,'E')==1)

            %Ground Truth ROI Feature Extraction
            
            clear;
            idx=1;
            sacle_idx=2:6;
            GT_Gabor_HM_M_Frontal=cell(numel(sacle_idx),1);
            GT_Gabor_HM_P_Frontal=cell(numel(sacle_idx),1);
            GT_Gabor_HM_N_Frontal=cell(numel(sacle_idx),1);

            for sacle_idx=2:6
            GT_ComputeGaborIR_Frontal(sacle_idx);
            %no use%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Gabor_Han&Ma_ArbitraryShape_RBR_1456') ;
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
            cd('..\GaborFeatures_HM_allScale');
            save('GT_Gabor_HM_M_Frontal','GT_Gabor_HM_M_Frontal');
            save('GT_Gabor_HM_P_Frontal','GT_Gabor_HM_P_Frontal');
            save('GT_Gabor_HM_N_Frontal','GT_Gabor_HM_N_Frontal');

   
    elseif (strcmp(User_Choice,'C')==1)
             cd('..\GaborFeatures_HM_allScale');
            %%%% Classification Part of Ground Truth%%%%%%%%
            load('GT_Gabor_HM_M_Frontal','GT_Gabor_HM_M_Frontal');
            load('GT_Gabor_HM_P_Frontal','GT_Gabor_HM_P_Frontal');
            load('GT_Gabor_HM_N_Frontal','GT_Gabor_HM_N_Frontal');
            cd('..\Classification\libsvm-3.20\matlab')

            %%MvsN
            viz_case='GT_Full_MN_Frontal'
            folder_name=['Full_Gabor_MN_Frontal' ];
            save_mat='MN_Full_Parameters_Frontal';
            results_save_dir='GaborResults\GTROI\newcompute\v1';

            [final_accuracy_MN,final_Sensitivity_MN,final_Specificity_MN] = run_Gabor_libsvm_Full(GT_Gabor_HM_M_Frontal,GT_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)
           %%%% PvsN
             viz_case='GT_Full_PN_Frontal' ; 
             folder_name=['Full_Gabor_PN_Frontal' ];
            save_mat='PN_Full_Parameters_Frontal';
            results_save_dir='GaborResults\GTROI\newcompute\v1';
            [final_accuracy_PN,final_Sensitivity_PN,final_Specificity_PN] = run_Gabor_libsvm_Full(GT_Gabor_HM_P_Frontal,GT_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)%%%%%%%%%%upto this
       else
        disp('Invalid Choice!');
    end
%%
%%Ground Truth ROI for Age Adjust
elseif (strcmp(User_Choice,'2')==1)
 
    
    disp('Enter your options:');
    disp('E:Feature  Extraction     C: Classification');
    question=('Enter your choice=');
    User_Choice=input(question,'s');
    
    if (strcmp(User_Choice,'E')==1)
 %Feature  Extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %%%%%%
            clear;
            idx=1;
             sacle_idx=2:6;
            AgeAdjust_GT_Gabor_HM_M_F=cell(numel(sacle_idx),1);
            AgeAdjust_GT_Gabor_HM_P_F=cell(numel(sacle_idx),1);
            AgeAdjust_GT_Gabor_HM_N_F=cell(numel(sacle_idx),1);

            for sacle_idx=2:6
            AgeAdjust_GT_ComputeGaborIR_Frontal(sacle_idx);
            %%%%%%%%%%%%%%%%%%%%%cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Gabor_Han&Ma_ArbitraryShape_RBR_1456') ;
            AgeAdjust_GT_Gabor_HMFeatures_between_lt_and_rt_Frontal(sacle_idx);
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
            save('AgeAdjust_GT_Gabor_HM_M_F','AgeAdjust_GT_Gabor_HM_M_F');
            save('AgeAdjust_GT_Gabor_HM_P_F','AgeAdjust_GT_Gabor_HM_P_F');
            save('AgeAdjust_GT_Gabor_HM_N_F','AgeAdjust_GT_Gabor_HM_N_F');
            
            
elseif (strcmp(User_Choice,'C')==1)
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %%%%%%classification for age adjusted
            cd('..\GaborFeatures_HM_allScale');
   
            load('AgeAdjust_GT_Gabor_HM_M_F','AgeAdjust_GT_Gabor_HM_M_F');
            load('AgeAdjust_GT_Gabor_HM_P_F','AgeAdjust_GT_Gabor_HM_P_F');
            load('AgeAdjust_GT_Gabor_HM_N_F','AgeAdjust_GT_Gabor_HM_N_F');

            cd('..\Classification\libsvm-3.20\matlab');
            viz_case='GT_AgeAdjust_MN_Frontal'
            folder_name=['AgeAdjust_Gabor_MN_Frontal' ];
            save_mat='MN_AgeAdjust_Parameters_Frontal';
            results_save_dir='GaborResults\GTROI\newcompute\v1';

            [final_accuracy_MN,final_Sensitivity_MN,final_Specificity_MN] = run_Gabor_libsvm_AgeAdjust(AgeAdjust_GT_Gabor_HM_M_F,AgeAdjust_GT_Gabor_HM_N_F,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)

             viz_case='AROI_AgeAdjust_PN_Frontal'   
             folder_name=['AgeAdjust_MR8_PN_Frontal' ];
            save_mat='PN_AgeAdjust_Parameters_Frontal';
            results_save_dir='GaborResults\GTROI\newcompute\v1';
            [final_accuracy_PN,final_Sensitivity_PN,final_Specificity_PN] = run_Gabor_libsvm_AgeAdjust(AgeAdjust_GT_Gabor_HM_P_F,AgeAdjust_GT_Gabor_HM_N_F,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)
    else
        disp('Invalid Choice!');
    end


elseif (strcmp(User_Choice,'3')==1)
            %%%%%%%%%%Ground Truth ROI for Profile feature extraction
            disp('Enter your options:');
            disp('E:Feature  Extraction     C: Classification');
            question=('Enter your choice=');
            User_Choice=input(question,'s');
    
      if (strcmp(User_Choice,'E')==1)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            clear;
            idx=1;
             sacle_idx=2:6;
            GT_Gabor_HM_M_Profile=cell(numel(sacle_idx),1);
            GT_Gabor_HM_P_Profile=cell(numel(sacle_idx),1);
            GT_Gabor_HM_N_Profile=cell(numel(sacle_idx),1);

            for sacle_idx=2:6
            GT_ComputeGaborIR_Profile(sacle_idx);
            %%%%cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Gabor_Han&Ma_ArbitraryShape_RBR_1456') ;
            GT_Gabor_HMFeatures_between_lt_and_rt_haralic_Profile(sacle_idx);
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
            cd('..\GaborFeatures_HM_allScale');
            save('GT_Gabor_HM_M_Profile','GT_Gabor_HM_M_Profile');
            save('GT_Gabor_HM_P_Profile','GT_Gabor_HM_P_Profile');
            save('GT_Gabor_HM_N_Profile','GT_Gabor_HM_N_Profile');

          elseif (strcmp(User_Choice,'C')==1)
              %%%%%%%%%%%%%%%%% classification part profile full data
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cd('..\GaborFeatures_HM_allScale');
            
            load('GT_Gabor_HM_M_Profile','GT_Gabor_HM_M_Profile');
            load('GT_Gabor_HM_P_Profile','GT_Gabor_HM_P_Profile');
            load('GT_Gabor_HM_N_Profile','GT_Gabor_HM_N_Profile');

            cd('..\Classification\libsvm-3.20\matlab');
            
            %%%%malignat vs Normal
            viz_case='GT_Full_MN_Profile'
            folder_name=['Full_MR8_MN_Profile' ];
            save_mat='MN_Parameters_Profile';
            results_save_dir='GaborResults\GTROI\newcompute\v1';
             [final_accuracy_MN,final_Sensitivity_MN,final_Specificity_MN] = run_Gabor_libsvm_Full(GT_Gabor_HM_P_Profile,GT_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)
            
             
             %%%Precancerous vs Normal 
             viz_case='GT_Full_PN_profile'   
             folder_name=['Full_MR8_PN_Profile' ];
            save_mat='PN_Parameters_Profile';
            results_save_dir='GaborResults\GTROI\newcompute\v1';

             [final_accuracy_PN,final_Sensitivity_PN,final_Specificity_PN] = run_Gabor_libsvm_Full(GT_Gabor_HM_P_Profile,GT_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)
      else
        disp('Invalid Choice!');
      end
      
      
      
      
elseif (strcmp(User_Choice,'4')==1)
%%Feature extraction for  Ground Truth Profile Age Adjust
disp('Enter your options:');
            disp('E:Feature  Extraction     C: Classification');
            question=('Enter your choice=');
            User_Choice=input(question,'s');
    
      if (strcmp(User_Choice,'E')==1)
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            clear;
            idx=1;
             sacle_idx=2:6;
            AgeAdjust_GT_Gabor_HM_M_Profile=cell(numel(sacle_idx),1);
            AgeAdjust_GT_Gabor_HM_P_Profile=cell(numel(sacle_idx),1);
            AgeAdjust_GT_Gabor_HM_N_Profile=cell(numel(sacle_idx),1);

            for sacle_idx=2:6
            AgeAdjust_GT_ComputeGaborIR_Profile(sacle_idx);
            %%cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Gabor_Han&Ma_ArbitraryShape_RBR_1456') ;
            AgeAdjust_GT_Gabor_HMFeatures_between_lt_and_rt_Profile(sacle_idx);
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
            cd('..\Gabor_HM_AllScale_Feature');
            save('AgeAdjust_GT_Gabor_HM_M_Profile','AgeAdjust_GT_Gabor_HM_M_Profile');
            save('AgeAdjust_GT_Gabor_HM_P_Profile','AgeAdjust_GT_Gabor_HM_P_Profile');
            save('AgeAdjust_GT_Gabor_HM_N_Profile','AgeAdjust_GT_Gabor_HM_N_Profile');

       elseif (strcmp(User_Choice,'C')==1)
           cd('..\GaborFeatures_HM_allScale');
            %%%%%%%%% classification age adjusted profile
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            load('AgeAdjust_GT_Gabor_HM_M_Profile','AgeAdjust_GT_Gabor_HM_M_Profile');
            load('AgeAdjust_GT_Gabor_HM_P_Profile','AgeAdjust_GT_Gabor_HM_P_Profile');
            load('AgeAdjust_GT_Gabor_HM_N_Profile','AgeAdjust_GT_Gabor_HM_N_Profile');

            cd('..\Classification\libsvm-3.20\matlab');
            
            %%%%malignant vs Normal
            viz_case='GT_AgeAdjust_MN_Profile'
            folder_name=['AgeAdjust_Gabor_MN_Profile' ];
            save_mat='MN_Parameters_Profile';
            results_save_dir='GaborResults\GTROI\newcompute\v1';
             [final_accuracy_MN,final_Sensitivity_MN,final_Specificity_MN] = run_Gabor_libsvm_AgeAdjust(AgeAdjust_GT_Gabor_HM_M_Profile,AgeAdjust_GT_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)
            
             %%%% precancerous vs normal
             viz_case='GT_AgeAdjust_PN_profile'   
             folder_name=['AgeAdjust_Gabor_PN_Profile' ];
            save_mat='PN_Parameters_Profile';
            results_save_dir='GaborResults\GTROI\newcompute\v1';

             [final_accuracy_PN,final_Sensitivity_PN,final_Specificity_PN] = run_Gabor_libsvm_AgeAdjust(AgeAdjust_GT_Gabor_HM_P_Profile,AgeAdjust_GT_Gabor_HM_N_Profile,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)
      else
        disp('Invalid Choice!');
      end

      
      
elseif (strcmp(User_Choice,'5')==1)
% %%%%%%%%%Feature Extraction for automated full for frontal image%%%%%%%%%%%%%%%%%%%%%%%% 
            disp('Enter your options:');
            disp('E:Feature  Extraction     C: Classification');
            question=('Enter your choice=');
            User_Choice=input(question,'s');
    
      if (strcmp(User_Choice,'E')==1)
          %Feature  Extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             
            clear;
            idx=1;
              sacle_idx=2:6;
            AROI_Gabor_HM_M_Frontal=cell(numel(sacle_idx),1);
            AROI_Gabor_HM_P_Frontal=cell(numel(sacle_idx),1);
            AROI_Gabor_HM_N_Frontal=cell(numel(sacle_idx),1);

            for sacle_idx=2:6
            AROI_ComputeGaborIR_Frontal(sacle_idx);
            %%%%%cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Gabor_Han&Ma_ArbitraryShape_RBR_1456') ;
            AROI_Gabor_HMFeatures_between_lt_and_rt_Frontal(sacle_idx);
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
            cd('..\Gabor_HM_AllScale_Feature');
            save('AROI_Gabor_HM_M_Frontal','AROI_Gabor_HM_M_Frontal');
            save('AROI_Gabor_HM_P_Frontal','AROI_Gabor_HM_P_Frontal');
            save('AROI_Gabor_HM_N_Frontal','AROI_Gabor_HM_N_Frontal');
 
            
      elseif (strcmp(User_Choice,'C')==1)
            %%%%%%%% Classification for automated full for frontal image%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cd('..\GaborFeatures_HM_allScale');
            load('AROI_Gabor_HM_M_Frontal','AROI_Gabor_HM_M_Frontal');
            load('AROI_Gabor_HM_P_Frontal','AROI_Gabor_HM_P_Frontal');
            load('AROI_Gabor_HM_N_Frontal','AROI_Gabor_HM_N_Frontal');

            cd('..\Classification\libsvm-3.20\matlab');
           
            
            viz_case='AROI_Full_MN_Frontal'
            folder_name=['Full_Gabor_MN_Frontal' ];
            save_mat='MN_Parameters_Frontal';
            results_save_dir='GaborResults\AutomatedROI\newcompute\v1';
            [final_accuracy_MN,final_Sensitivity_MN,final_Specificity_MN] = run_Gabor_libsvm_Full(AROI_Gabor_HM_M_Frontal,AROI_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)

            
            viz_case='AROI_Full_PN_Frontal'   
             folder_name=['Full_Gabor_PN_Frontal' ];
            save_mat='PN_Parameters_Frontal';
            results_save_dir='GaborResults\AutomatedROI\newcompute\v1';
            [final_accuracy_PN,final_Sensitivity_PN,final_Specificity_PN] = run_Gabor_libsvm_Full(AROI_Gabor_HM_P_Frontal,AROI_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)
      
      else
        disp('Invalid Choice!');
      end
%%

elseif (strcmp(User_Choice,'6')==1)
%%%%%%%%% Feature for AROI for Age Adjust

            disp('Enter your options:');
            disp('E:Feature  Extraction     C: Classification');
            question=('Enter your choice=');
            User_Choice=input(question,'s');
    
      if (strcmp(User_Choice,'E')==1)
          
            %Feature  Extraction%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            clear;
            idx=1;
             sacle_idx=2:6;
            AROI_AgeAdjust_Gabor_HM_M_Frontal=cell(numel(sacle_idx),1);
            AROI_AgeAdjust_Gabor_HM_P_Frontal=cell(numel(sacle_idx),1);
            AROI_AgeAdjust_Gabor_HM_N_Frontal=cell(numel(sacle_idx),1);

            for sacle_idx=2:6
            AROI_AgeAdjust_ComputeGaborIR_Frontal(sacle_idx);
            %%%%%%%%%cd('F:\MS\matlab_code\WORK\SPIE_2017\Rahul_da_Texture_Features\Gabor_Han&Ma_ArbitraryShape_RBR_1456') ;
            AROI_AgeAdjust_Gabor_HMFeatures_between_lt_and_rt_Frontal(sacle_idx);
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
            cd('..\Gabor_HM_AllScale_Feature');
            save('AROI_AgeAdjust_Gabor_HM_M_Frontal','AROI_AgeAdjust_Gabor_HM_M_Frontal');
            save('AROI_AgeAdjust_Gabor_HM_P_Frontal','AROI_AgeAdjust_Gabor_HM_P_Frontal');
            save('AROI_AgeAdjust_Gabor_HM_N_Frontal','AROI_AgeAdjust_Gabor_HM_N_Frontal');

       elseif (strcmp(User_Choice,'C')==1)
            %%%%%Classification for age adjust frontal
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cd('..\GaborFeatures_HM_allScale');
            
            load('AROI_AgeAdjust_Gabor_HM_M_Frontal','AROI_AgeAdjust_Gabor_HM_M_Frontal');
            load('AROI_AgeAdjust_Gabor_HM_P_Frontal','AROI_AgeAdjust_Gabor_HM_P_Frontal');
            load('AROI_AgeAdjust_Gabor_HM_N_Frontal','AROI_AgeAdjust_Gabor_HM_N_Frontal');

            cd('..\Classification\libsvm-3.20\matlab');
            
            
            
            viz_case='AROI_AgeAdjust_MN_Frontal'
            folder_name=['AgeAdjust_Gabor_MN_Frontal' ];
            save_mat='MN_AgeAdjust_Parameters_Frontal';
            results_save_dir='GaborResults\AutomatedROI\newcompute\v1';
            [final_accuracy_MN,final_Sensitivity_MN,final_Specificity_MN] = run_Gabor_libsvm_AgeAdjust(AROI_AgeAdjust_Gabor_HM_M_Frontal,AROI_AgeAdjust_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)

             viz_case='AROI_AgeAdjust_PN_Frontal'   
             folder_name=['AgeAdjust_Gabor_PN_Frontal' ];
            save_mat='PN_AgeAdjust_Parameters_Frontal';
            results_save_dir='GaborResults\AutomatedROI\newcompute\v1';
            [final_accuracy_PN,final_Sensitivity_PN,final_Specificity_PN] = run_Gabor_libsvm_AgeAdjust(AROI_AgeAdjust_Gabor_HM_P_Frontal,AROI_AgeAdjust_Gabor_HM_N_Frontal,sacle_idx,viz_case,folder_name,save_mat,results_save_dir)


    else
        disp('Invalid Choice!');
    end

%%

 else
        disp('Invalid Choice!');
    end