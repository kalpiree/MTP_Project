% =========================== run_Gabor_libsvm.m ====================================== %
% Description  : Classification framework for entire dataset

%
% Read .csv file--->make an array of image intensity(0-1)---> load the
% mask's ---> calculate gabor features--->store them.
%
%
%
% ================================================================================== %
% Input Parameters :Feature_Patient,Feature_Normal,scales,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting
%
%------------------------------------------------------------------------------------%
% Output parameter: final_accuracy
%
%------------------------------------------------------------------------------------%
% Subroutine  called :
%   #1: libsvm_scaleselect
%------------------------------------------------------------------------------------%
% Reference:
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






function [final_accuracy,avg_sen,avg_spc,counter]= run_Gabor_libsvm_Full(Feature_Patient,Feature_Normal,scales,viz_case,folder_name,save_mat,results_save_dir,Flag,Setting,nameFolds)
no_of_folds=5; % Number of folds for cross validation
%====== Gabor features of patient and normal subjects ===================%
Patient=Feature_Patient;
Normal=Feature_Normal;
%======================================================================%
[row,~]=size(Normal);


%===================Concatenating Features======================%
xdata_allscale=cell(row,1);
for idx_row=1:row
    xdata_allscale{idx_row,1} =[Patient{idx_row,1};Normal{idx_row,1}];
end
%======================================================================%

%============True labels of the classes==============%
Target_train=[ones(size(Patient{idx_row,1},1),1);zeros(size(Normal{idx_row,1},1),1)];
%======================================================================%

[final_accuracy,indices,optns,save_optns,save_prob_estimates,model,save_idx_validate,save_True_Label_test,save_Predict_label_test,save_best_kernel_model,save_bst_kernel_idx,save_data_test,save_data_train,save_data_validate,avg_sen,avg_spc,counter]=libsvm_scaleselect_26_8_19(xdata_allscale,Target_train,no_of_folds,scales,viz_case,Flag,Setting,nameFolds)
%=================Saving Results========================%

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

%======================================================================%
end