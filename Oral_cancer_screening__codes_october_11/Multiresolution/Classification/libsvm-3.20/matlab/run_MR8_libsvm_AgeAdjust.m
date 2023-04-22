
function[final_accuracy]= run_MR8_libsvm_AgeAdjust(Feature_Patient,Feature_Normal,ROS_idx,N_Scale,N_Orientation,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting)

% no_of_folds=5;
no_of_folds=5;

Patient=Feature_Patient;
Normal1=Feature_Normal;
[~,~,z]=size(Normal1)
for idx_z=1:z
    Normal(:,:,idx_z) = SMOTE_vik(Normal1(:,:,idx_z),2,5);
end
xdata_allkernel =[Patient;Normal];
Target_train=[ones(size(Patient,1),1);zeros(size(Normal,1),1)];


[final_accuracy,indices,optns,save_optns,save_prob_estimates,model,save_idx_validate,save_True_Label_test,save_Predict_label_test,save_best_kernel_model,save_bst_kernel_idx,save_data_test,save_data_train,save_data_validate]=libsvm_kernelselect(xdata_allkernel,Target_train,no_of_folds,ROS_idx,N_Scale,N_Orientation,viz_case,Flag,Setting)
clc;
rel_path=[results_save_dir];
cd(rel_path);


if ~exist(folder_name)
    mkdir(folder_name);
    cd(folder_name);
else
    
    rmdir(folder_name,'s');
    mkdir(folder_name);
    cd(folder_name);
end
save(save_mat,'final_accuracy','model','indices','optns','save_optns','save_idx_validate','save_prob_estimates','save_True_Label_test','save_Predict_label_test','save_best_kernel_model','save_bst_kernel_idx','save_data_test','save_data_train','save_data_validate');


end