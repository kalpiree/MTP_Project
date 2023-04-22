


clear ;
clc;
close all;
dbstop if error;




%%


disp('Enter your options: ');
disp('1: Ground truth region of interest frontal')
disp('2: Ground truth region of interest Age Adjusted frontal')
disp('3: Ground truth region of interest Profile')
disp('4: Ground truth region of interest Age Adjusted Profile')
disp('5: Automated region of interest frontal')
disp('6: Automated region of interest Age Adjusted frontal')
question=('Enter The Above options: ');
User_Choice=input(question,'s');
if (strcmp(User_Choice,'1')==1)
    %%%%----------Feature Extraction for frontal full database----------%%
    %========================================================%
    clear;
    kernel_idx=1;
    for ROS_idx=5:2:65
        N_Scale=3;
        N_Orientation=6;
        disp(ROS_idx);
        %%%----------------Compute the MR8 features-------------------------------%%%
        ComputeMR8_IR_Frontal_GT(ROS_idx,N_Scale,N_Orientation);
        GT_MR8_Features_between_lt_and_rt_Frontal(ROS_idx)
        load(['..\MR8Features\Full_GT_MR8_Normal_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\Full_GT_MR8_Malignant_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\Full_GT_MR8_NonMalignant_Front_face_ROS_',num2str(ROS_idx),'.mat']);
        GT_Full_Malignant_allKernel(:,:,kernel_idx)=GT_Malignant_MR8_append_LT_RT_Frontface;
        GT_Full_Normal_allKernel(:,:,kernel_idx)=GT_Normal_MR8_append_LT_RT_Frontface;
        GT_Full_NonMalignant_allKernel(:,:,kernel_idx)=GT_NMalignant_MR8_append_LT_RT_Frontface;
        kernel_idx=kernel_idx+1;
    end
    %-----------------end of feature extraction----------------------------%
    %----------save the extracted features----------------------------------%
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    save('GT_Full_Malignant_allKernel','GT_Full_Malignant_allKernel');
    save('GT_Full_Normal_allKernel','GT_Full_Normal_allKernel');
    save('GT_Full_NonMalignant_allKernel','GT_Full_NonMalignant_allKernel');
    cd('..\..\..\..\Program For MR8');

    %     %-----------------------------------------------------------------------%
    
    %========================================================%
    %-------------------Classification ground truth ROI-------------%
    
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    load('GT_Full_Malignant_allKernel','GT_Full_Malignant_allKernel');
    load('GT_Full_Normal_allKernel','GT_Full_Normal_allKernel');
    load('GT_Full_NonMalignant_allKernel','GT_Full_NonMalignant_allKernel');
    cd('..\');
    ROS_idx=5:2:65;
    N_Scale=3;
    N_Orientation=6;
    
    %%-----------------Classification Malignant features vs Normal features------------------------------%%
    viz_case='GT_Full_MN_Frontal'
    folder_name=['Full_MR8_MN_Frontal'];
    save_mat='MN_Parameters_Frontal';
    results_save_dir='MR8Results\GTROI\';
    
    %--------Flag, Setting
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    Setting='GT_MN_FULL';
    %---------------------
    
    [Full_final_accuracy_MN] = run_MR8_libsvm_Full(GT_Full_Malignant_allKernel,GT_Full_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
        cd('../../../');

    
    %%-----------------Classification Non Malignant features vs Normal features------------------------------%%
    viz_case='GT_Full_PN_Frontal'
    folder_name=['Full_MR8_PN_Frontal'];
    save_mat='PN_Parameters_Frontal';
    results_save_dir='MR8Results\GTROI\';
    
    %-------%%% Flag, Setting
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    
    Setting='GT_PN_FULL';
    %---------------------
    
    
    [Full_final_accuracy_PN] = run_MR8_libsvm_Full(GT_Full_NonMalignant_allKernel,GT_Full_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    
    %-------------------------END OF CLASSIFICATION---------------------------%
    
elseif (strcmp(User_Choice,'2')==1)
    
    %------Saving Ground Truth Kernel for Entire Database--ProfileFace-------%
    clear;
    kernel_idx=1;
    for ROS_idx=5:2:65
        N_Scale=3;
        N_Orientation=6;
        disp(ROS_idx);
        ComputeMR8_IR_Profile_GT(ROS_idx,N_Scale,N_Orientation);
        GT_MR8_Features_between_lt_and_rt_Profile(ROS_idx)
        load(['..\MR8Features\Full_GT_MR8_Normal_Profile_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\Full_GT_MR8_Malignant_Profile_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\Full_GT_MR8_NonMalignant_Profile_face_ROS_',num2str(ROS_idx),'.mat']);
        GT_Profile_Full_Malignant_allKernel(:,:,kernel_idx)=GT_Malignant_MR8_append_LT_RT_Profileface;
        GT_Profile_Full_Normal_allKernel(:,:,kernel_idx)=GT_Normal_MR8_append_LT_RT_Profileface;
        GT_Profile_Full_NonMalignant_allKernel(:,:,kernel_idx)=GT_NMalignant_MR8_append_LT_RT_Profileface;
        kernel_idx=kernel_idx+1;
        
        %---------------End of feature extraction--------------------------------%
        %---------------Saving the kernel----------------------------------------%
    end
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    save('GT_Profile_Full_Malignant_allKernel','GT_Profile_Full_Malignant_allKernel');
    save('GT_Profile_Full_Normal_allKernel','GT_Profile_Full_Normal_allKernel');
    save('GT_Profile_Full_NonMalignant_allKernel','GT_Profile_Full_NonMalignant_allKernel');
    cd('..\..\..\..\Program For MR8');

    %%-----------------------------------------------------------------------%%
    
    %----Classification Ground Truth Kernel for Entire Database--Profile Face---%%
    
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    ROS_idx=5:2:65;
    N_Scale=3;
    N_Orientation=6;
    load('GT_Profile_Full_Malignant_allKernel','GT_Profile_Full_Malignant_allKernel');
    load('GT_Profile_Full_Normal_allKernel','GT_Profile_Full_Normal_allKernel');
    load('GT_Profile_Full_NonMalignant_allKernel','GT_Profile_Full_NonMalignant_allKernel');
    cd('..\');
    %%-----------------Classification Malignant features vs Normal features------------------------------%%
    viz_case='GT_Full_MN_Profile'
    folder_name=['Full_MR8_MN_Profile'];
    save_mat='MN_Parameters_Profile';
    results_save_dir='MR8Results\GTROI\';
    
    
    %--------Flag, Setting
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='PROFILE_GT_MN_FULL';
    %---------------------
    
    
    [Profile_final_accuracy_MN] = run_MR8_libsvm_Full(GT_Profile_Full_Malignant_allKernel,GT_Profile_Full_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    
     cd('../../../');

    %%-----------------Classification Non Malignant features vs Normal features------------------------------%%
    viz_case='GT_Full_PN_Profile';
    folder_name=['Full_MR8_PN_Profile'];
    save_mat='PN_Parameters_Profile';
    results_save_dir='MR8Results\GTROI\';
    
    
    %--------Flag, Setting
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    Setting='PROFILE_GT_PN_FULL';
    %---------------------
    
    [Profile_final_accuracy_PN] = run_MR8_libsvm_Full(GT_Profile_Full_NonMalignant_allKernel,GT_Profile_Full_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting)

    %-------------------------END OF CLASSIFICATION---------------------------%
    
elseif (strcmp(User_Choice,'3')==1)
    %%-------------Feature extraction for GT age adjusted frontal-----------%%
    
    clear;
    kernel_idx=1;
    for ROS_idx=5:2:65
        N_Scale=3;
        N_Orientation=6;
        disp(ROS_idx);
        
        ComputeMR8_IR_Frontal_GT_AgeAdjust(ROS_idx,N_Scale,N_Orientation);
        AgeAdjust_GT_MR8_Features_between_lt_and_rt_Frontal(ROS_idx)
        load(['..\MR8Features\AgeAdjust_GT_MR8_Normal_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\AgeAdjust_GT_MR8_Malignant_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\AgeAdjust_GT_MR8_NonMalignant_Front_face_ROS_',num2str(ROS_idx),'.mat']);
        GT_AgeAdjust_Malignant_allKernel(:,:,kernel_idx)=GT_Malignant_MR8_append_LT_RT_Frontface;
        GT_AgeAdjust_Normal_allKernel(:,:,kernel_idx)=GT_Normal_MR8_append_LT_RT_Frontface;
        GT_AgeAdjust_NonMalignant_allKernel(:,:,kernel_idx)=GT_NMalignant_MR8_append_LT_RT_Frontface;
        kernel_idx=kernel_idx+1;
        
        %---------------End of feature extraction--------------------------------%
        %---------------Saving the kernel----------------------------------------%
        
    end
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    save('GT_AgeAdjust_Malignant_allKernel','GT_AgeAdjust_Malignant_allKernel');
    save('GT_AgeAdjust_Normal_allKernel','GT_AgeAdjust_Normal_allKernel');
    save('GT_AgeAdjust_NonMalignant_allKernel','GT_AgeAdjust_NonMalignant_allKernel');
        cd('..\..\..\..\Program For MR8');

    %-------------------------------------------------------------------------%
    %%-----------------Classification Age Adjust ground truth ROI------%%
    
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    ROS_idx=5:2:65;
    
    load('GT_AgeAdjust_Malignant_allKernel','GT_AgeAdjust_Malignant_allKernel');
    load('GT_AgeAdjust_Normal_allKernel','GT_AgeAdjust_Normal_allKernel');
    load('GT_AgeAdjust_NonMalignant_allKernel','GT_AgeAdjust_NonMalignant_allKernel');
    cd('..\');
    ROS_idx=5:2:65;
    N_Scale=3;
    N_Orientation=6;
    
    %%-----------------Classification Malignant features vs Normal features------------------------------%%
    viz_case='AgeAdjust_Full_MN_Frontal'
    folder_name=['AgeAdjust_MR8_MN_Frontal'];
    save_mat='MN_Parameters_Frontal';
    results_save_dir='MR8Results\GTROI\';
    
    %--------Flag, Setting
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='GT_MN_AGE';
    %---------------------
    
    [AgeAdjust_final_accuracy_MN] = run_MR8_libsvm_AgeAdjust(GT_AgeAdjust_Malignant_allKernel,GT_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
        cd('../../../');

    %%-----------------Classification Non Malignant features vs Normal features------------------------------%%
    viz_case='GT_AgeAdjust_Full_PN_Frontal'
    folder_name=['GT_AgeAdjust_MR8_PN_Frontal'];
    save_mat='PN_Parameters_Frontal';
    results_save_dir='MR8Results\GTROI\';
    
    %--------Flag, Setting
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='GT_PN_AGE';
    %---------------------
    
    [AgeAdjust_final_accuracy_PN] = run_MR8_libsvm_AgeAdjust(GT_AgeAdjust_NonMalignant_allKernel,GT_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    
    %---------------------ENDOFCLASSIFICATION---------------------------%
    
    
    
    %%-----------------    Classification Age Adjust profile ground truth ROI    ------%%
elseif (strcmp(User_Choice,'4')==1)
    
    %------------feature extraction for Age Adjust Database--Profile Face-----%
    clear;
    kernel_idx=1;
    for ROS_idx=5:2:65
        N_Scale=3;
        N_Orientation=6;
        disp(ROS_idx);
        ComputeMR8_IR_Profile_GT_AgeAdjust(ROS_idx,N_Scale,N_Orientation);
        AgeAdjust_GT_MR8_Features_between_lt_and_rt_Profile(ROS_idx)
        load(['..\MR8Features\AgeAdjust_GT_MR8_Normal_Profile_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\AgeAdjust_GT_MR8_Malignant_Profile_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\AgeAdjust_GT_MR8_NonMalignant_Profile_face_ROS_',num2str(ROS_idx),'.mat']);
        GT_Profile_AgeAdjust_Malignant_allKernel(:,:,kernel_idx)=GT_Malignant_MR8_append_LT_RT_Profileface;
        GT_Profile_AgeAdjust_Normal_allKernel(:,:,kernel_idx)=GT_Normal_MR8_append_LT_RT_Profileface;
        GT_Profile_AgeAdjust_NonMalignant_allKernel(:,:,kernel_idx)=GT_NMalignant_MR8_append_LT_RT_Profileface;
        kernel_idx=kernel_idx+1;
        
        %---------------End of feature extraction--------------------------------%
        %---------------Saving the kernel----------------------------------------%
        
    end
    cd('..\Classification\libsvm-3.20\matlab/newcomputedMR8Features_allKernel');
    save('GT_Profile_AgeAdjust_Malignant_allKernel','GT_Profile_AgeAdjust_Malignant_allKernel');
    save('GT_Profile_AgeAdjust_Normal_allKernel','GT_Profile_AgeAdjust_Normal_allKernel');
    save('GT_Profile_AgeAdjust_NonMalignant_allKernel','GT_Profile_AgeAdjust_NonMalignant_allKernel');
        cd('..\..\..\..\Program For MR8');

    %-------------------------------------------------------------------------%
    
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    
    ROS_idx=5:2:65;
    N_Scale=3;
    N_Orientation=6;
    load('GT_Profile_AgeAdjust_Malignant_allKernel','GT_Profile_AgeAdjust_Malignant_allKernel');
    load('GT_Profile_AgeAdjust_Normal_allKernel','GT_Profile_AgeAdjust_Normal_allKernel');
    load('GT_Profile_AgeAdjust_NonMalignant_allKernel','GT_Profile_AgeAdjust_NonMalignant_allKernel');
    cd('..\');
    
    %%-----------------Classification Malignant features vs Normal features------------------------------%%
    viz_case='GT_AgeAdjust_MN_Profile'
    folder_name=['AgeAdjust_MR8_MN_Profile' ];
    save_mat='MN_Parameters_Profile';
    results_save_dir='MR8Results\GTROI\';
    
    %--------Flag, Setting
    Flag='1'; %put Flag=0 if want to compute crossvalidation index all over again
    
    Setting='PROFILE_GT_MN_AGE';
    %---------------------
    
    [AgeAdjust_Profile_final_accuracy_MN] = run_MR8_libsvm_AgeAdjust(GT_Profile_AgeAdjust_Malignant_allKernel,GT_Profile_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
     cd('../../../');

    %%-----------------Classification Non Malignant features vs Normal features------------------------------%%
    
    viz_case='GT_AgeAdjust_PN_Profile';
    folder_name=['AgeAdjust_MR8_PN_Profile' ];
    save_mat='PN_Parameters_Profile';
    results_save_dir='MR8Results\GTROI\';
    
    %--------Flag, Setting
    
    Flag='1'; %put Flag=0 if want to compute crossvalidation index all over again
    Setting='PROFILE_GT_PN_AGE';
    %---------------------
    
    
    [AgeAdjust_Profile_final_accuracy_PN] = run_MR8_libsvm_AgeAdjust(GT_Profile_AgeAdjust_NonMalignant_allKernel,GT_Profile_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    
    
    %---------------------ENDOFCLASSIFICATION---------------------------%
    
elseif (strcmp(User_Choice,'5')==1)
    %%--------------------Feature extraction for AROI frontal-----------------------------%%
  %%--------------------Feature extraction for AROI frontal-----------------------------%%
    clear;
    kernel_idx=1;
    for ROS_idx=5:2:65
        N_Scale=3;
        N_Orientation=6;
        disp(ROS_idx);
        ComputeMR8_IR_Frontal_AROI(ROS_idx,N_Scale,N_Orientation);
        AROI_MR8_Features_between_lt_and_rt_Frontal(ROS_idx)
        load(['..\MR8Features\Full_AROI_MR8_Normal_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\Full_AROI_MR8_Malignant_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\Full_AROI_MR8_NonMalignant_Front_face_ROS_',num2str(ROS_idx),'.mat']);
        AROI_Full_Malignant_allKernel(:,:,kernel_idx)=AROI_Malignant_MR8_append_LT_RT_Frontface;
        AROI_Full_Normal_allKernel(:,:,kernel_idx)=AROI_Normal_MR8_append_LT_RT_Frontface;
        AROI_Full_NonMalignant_allKernel(:,:,kernel_idx)=AROI_NMalignant_MR8_append_LT_RT_Frontface;
        kernel_idx=kernel_idx+1;
        
        %---------------End of feature extraction--------------------------------%
        %---------------Saving the kernel----------------------------------------%
        
    end
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    
    save('AROI_Full_Malignant_allKernel','AROI_Full_Malignant_allKernel');
    save('AROI_Full_Normal_allKernel','AROI_Full_Normal_allKernel');
    save('AROI_Full_NonMalignant_allKernel','AROI_Full_NonMalignant_allKernel');
        cd('..\..\..\..\Program For MR8');

    %-------------------------------------------------------------------------%
    %----------------------Classification of automated roi--------------------%
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    load('AROI_Full_Malignant_allKernel','AROI_Full_Malignant_allKernel');
    load('AROI_Full_Normal_allKernel','AROI_Full_Normal_allKernel');
    load('AROI_Full_NonMalignant_allKernel','AROI_Full_NonMalignant_allKernel');
    cd('..\');
    ROS_idx=5:2:65;
    N_Scale=3;
    N_Orientation=6;
    %%-----------------Classification Malignant features vs Normal features------------------------------%%
    viz_case='AROI_Full_MN'
    folder_name=['Full_MR8_MN_Frontal'  ];
    save_mat='MN_Parameters_Frontal';
    results_save_dir='MR8Results\AutomatedROI\';
    
    %--------Flag, Setting
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='AROI_MN_FULL';
    %---------------------
    
    [Full_final_accuracy_MN] = run_MR8_libsvm_Full(AROI_Full_Malignant_allKernel,AROI_Full_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    cd('../../../');

    %%-----------------Classification Non Malignant features vs Normal features------------------------------%%
    viz_case='AROI_Full_PN'
    folder_name=['Full_MR8_PN_Frontal'];
    save_mat='PN_Parameters_Frontal';
    results_save_dir='MR8Results\AutomatedROI\';
    
    %--------%%% Flag, Setting
    Flag='1'; %put Flag=0 if want to compute crossvalidation index all over again
    
    Setting='AROI_PN_FULL';
    %---------------------
    
    [Full_final_accuracy_PN] = run_MR8_libsvm_Full(AROI_Full_NonMalignant_allKernel,AROI_Full_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    
    %-------------------------END OF CLASSIFICATION---------------------------%
elseif (strcmp(User_Choice,'6')==1)
    %%------------Feature extraction AROI age adjusted frontal-----------------------%%
    
    clear;
    kernel_idx=1;
    for ROS_idx=5:2:65%%%%%%%%%%%%%%%%%%%%%age adjust aroi%%%%%%%%%%%%%%%%%%%%
        N_Scale=3;
        N_Orientation=6;
        disp(ROS_idx);
       
        ComputeMR8_IR_Frontal_AROI_AgeAdjust(ROS_idx,N_Scale,N_Orientation);
        AgeAdjust_AROI_MR8_Features_between_lt_and_rt_Frontal(ROS_idx)
        load(['..\MR8Features\AgeAdjust_AROI_MR8_Normal_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\AgeAdjust_AROI_MR8_Malignant_Frontal_face_ROS_',num2str(ROS_idx),'.mat']);
        load(['..\MR8Features\AgeAdjust_AROI_MR8_NonMalignant_Front_face_ROS_',num2str(ROS_idx),'.mat']);
        AROI_AgeAdjust_Malignant_allKernel(:,:,kernel_idx)=AROI_Malignant_MR8_append_LT_RT_Frontface;
        AROI_AgeAdjust_Normal_allKernel(:,:,kernel_idx)=AROI_Normal_MR8_append_LT_RT_Frontface;
        AROI_AgeAdjust_NonMalignant_allKernel(:,:,kernel_idx)=AROI_NMalignant_MR8_append_LT_RT_Frontface;
        kernel_idx=kernel_idx+1;
        
        %---------------End of feature extraction--------------------------------%
        %---------------Saving the kernel----------------------------------------%
        
    end
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    save('AROI_AgeAdjust_Malignant_allKernel','AROI_AgeAdjust_Malignant_allKernel');
    save('AROI_AgeAdjust_Normal_allKernel','AROI_AgeAdjust_Normal_allKernel');
    save('AROI_AgeAdjust_NonMalignant_allKernel','AROI_AgeAdjust_NonMalignant_allKernel');
    cd('..\..\..\..\Program For MR8');

    %-----------------------------------------------------------------------%
    
    %-----------------Classification age adjusted automated roi--------------%
    cd('..\Classification\libsvm-3.20\matlab\newcomputedMR8Features_allKernel');
    
    load('AROI_AgeAdjust_Malignant_allKernel','AROI_AgeAdjust_Malignant_allKernel');
    load('AROI_AgeAdjust_Normal_allKernel','AROI_AgeAdjust_Normal_allKernel');
    load('AROI_AgeAdjust_NonMalignant_allKernel','AROI_AgeAdjust_NonMalignant_allKernel');
    cd('..\');
    ROS_idx=5:2:65;
    N_Scale=3;
    N_Orientation=6;
    
    %%-----------------Classification Malignant features vs Normal features------------------------------%%
    viz_case='AROI_AgeAdjust_MN'
    folder_name=['AROI_AgeAdjust_MR8_MN_Frontal' ];
    save_mat='MN_Parameters_Frontal';
    results_save_dir='MR8Results\AutomatedROI\';
    
    %--------Flag, Setting
    Flag='1'; %put Flag=0 if want to compute cr9ossvalidation index all over again
    
    Setting='AROI_MN_AGE';
    %---------------------
    
    [AgeAdjust_final_accuracy_MN] = run_MR8_libsvm_AgeAdjust(AROI_AgeAdjust_Malignant_allKernel,AROI_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    cd('../../../');
   
    %%-----------------Classification Non Malignant features vs Normal features------------------------------%%
    viz_case='AROI_Full_PN'
    folder_name=['AROI_AgeAdjust_MR8_PN_Frontal'  ];
    save_mat='PN_Parameters_Frontal';
    results_save_dir='MR8Results\AutomatedROI\';
    
    %--------%%% Flag, Setting
    Flag='1'; %put Flag=0 if want to compute crossvalidation index all over again
    
    Setting='AROI_PN_AGE';
    %---------------------
    
    
    [AgeAdjust_final_accuracy_PN] = run_MR8_libsvm_AgeAdjust(AROI_AgeAdjust_NonMalignant_allKernel,AROI_AgeAdjust_Normal_allKernel,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting);
    
    
    %-------------------------END OF CLASSIFICATION---------------------------%
    
    
    
    
    
else
    disp('Invalid Choice!');
end



