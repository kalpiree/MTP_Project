
function [final_accuracy,indices,optns,save_optns,save_prob_estimates,model,save_idx_validate,save_True_Label_test,save_Predict_label_test,save_best_kernel_model,save_bst_kernel_idx,save_data_test,save_data_train,save_data_validate]= libsvm_kernelselect(xdata_allkernel,Target_train,no_of_folds,ROS_idx,N_Scale,N_Orientation,viz_case,Flag,Setting)

group = Target_train;



data_crossvalind=size(xdata_allkernel,1);



if(Flag =='1')
    %%%load the precalculated data
    if(strcmp(Setting,'GT_MN_FULL')==1)
        load('Full_MR8_MN_Frontal\MN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
    elseif(strcmp(Setting,'GT_PN_FULL')==1)
        load('Full_MR8_PN_Frontal\PN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
    elseif(strcmp(Setting,'GT_MN_AGE')==1)
        load('AgeAdjust_MR8_MN_Frontal\MN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
    elseif(strcmp(Setting,'GT_PN_AGE')==1)
        load('AgeAdjust_MR8_PN_Frontal\PN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        
    elseif(strcmp(Setting,'PROFILE_GT_MN_FULL')==1)
        load('Full_MR8_MN_Profile\MN_Parameters_Profile.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
    elseif(strcmp(Setting,'PROFILE_GT_PN_FULL')==1)
        load('Full_MR8_PN_Profile\PN_Parameters_Profile.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
    elseif(strcmp(Setting,'PROFILE_GT_MN_AGE')==1)
        load('AgeAdjust_MR8_MN_Profile\MN_Parameters_Profile.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
    elseif(strcmp(Setting,'PROFILE_GT_PN_AGE')==1)
        load('AgeAdjust_MR8_PN_Profile\PN_Parameters_Profile.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        %%%%%%%%not calculated AROI MN FULL
    elseif(strcmp(Setting,'AROI_MN_FULL')==1)
        load('AROI_Full_MR8_MN_Frontal\MN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        %%%%%%%%not calculated AROI PN FULL
    elseif(strcmp(Setting,'AROI_PN_FULL')==1)
        load('AROI_Full_MR8_PN_Frontal\PN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
    elseif(strcmp(Setting,'AROI_MN_AGE')==1)
        load('AROI_AgeAdjust_MR8_MN_Frontal\MN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
    elseif(strcmp(Setting,'AROI_PN_AGE')==1)
        load('AROI_AgeAdjust_MR8_PN_Frontal\PN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        
        
    end
    
    
else
    rng('shuffle');
    indices= crossvalind('Kfold',data_crossvalind,no_of_folds);    %generate crossvalidation index afresh
    
end








%indices= crossvalind('Kfold',data_crossvalind,no_of_folds);


%%
fold_accuracy=zeros(no_of_folds,1);
[~,~,no_of_kernel]=size(xdata_allkernel);
save_prob_estimates=cell(numel(no_of_folds),1);
save_True_Label_test=cell(numel(no_of_folds),1);
% save_idx_validate=cell(no_of_kernel,no_of_folds,1);
save_Predict_label_test=cell(numel(no_of_folds),1);
save_best_kernel_model=cell(numel(no_of_folds),1);

for fold_no = 1:no_of_folds
    test= (indices == fold_no); % idx of elements which will go for testing
    train = ~test; % idx of elements which will  go for training
    True_Label_test=group(test);% target test labels for current fold
    for kernel_idx=1:no_of_kernel
        data_train_total=xdata_allkernel(train,:,kernel_idx); % train data for current fold_no
        True_Label_train_total=group(train);% training labels for current fold
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        rand_no_gen = randperm(size(data_train_total,1));  %index for partinoning training and validation data
        if(Flag =='0')
        idx_validate=rand_no_gen(1:floor(size(data_train_total,1)/4));
        save_idx_validate{kernel_idx,fold_no,1}=idx_validate;
        else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        idx_validate=save_idx_validate{kernel_idx,fold_no,1};
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        data_validate=data_train_total(idx_validate,:);
        data_train_idx=1:size(data_train_total,1);
        data_train_idx(idx_validate)=[];
        data_train=data_train_total(data_train_idx,:);
        True_Label_validate=True_Label_train_total(idx_validate,:);
        True_Label_train=True_Label_train_total(data_train_idx,:);
        [data_train,min_data_train(kernel_idx,:),max_data_train(kernel_idx,:)]=minmax_featureNormalize(data_train);
        save_data_train{kernel_idx,fold_no}=data_train;
        
        %============================  Grid search for parameter selection %=============================
        bestcv = 0;
        for log2c = 1:10,
            for log2g = -10:10,
                cmd = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g), ' -t 2 -b 1'];
                cv = svmtrain(True_Label_train, data_train, cmd);
                if (cv >= bestcv),
                    bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
                end
                fprintf('%g %g %g (bestc=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
            end
        end
        
        optns = [' -c ', num2str(bestc), ' -g ',num2str(bestg),' -t 2 -b 1'];
        
           save_optns{kernel_idx,fold_no}=optns;
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %============================  Training Part %=============================
        
        model(kernel_idx) = svmtrain(True_Label_train,data_train,optns);
        %============================  Validation Part %=============================
        [data_validate]=minmax_featureNormalize_test(data_validate,min_data_train(kernel_idx,:),max_data_train(kernel_idx,:));
        save_data_validate{kernel_idx,fold_no}=data_validate;
        [Predict_label_validate, fold_accuracy_validate, prob_estimates_validate] = svmpredict(True_Label_validate,data_validate, model(kernel_idx), '-b 1');
        fold_accuracy_validate1(kernel_idx)=(1-(sum(abs(True_Label_validate-Predict_label_validate))/numel(True_Label_validate)))*100;
    end
    % %============================  Testing Part %=============================
    %
    bst_kernel_idx=find(fold_accuracy_validate1==max(fold_accuracy_validate1));
    bst_kernel_idx=bst_kernel_idx(1);
    
    save_bst_kernel_idx(fold_no)=bst_kernel_idx;
   
    best_kernel_model=model(bst_kernel_idx);
    
    save_best_kernel_model{fold_no,1}=best_kernel_model;
   
    min_data_train=min_data_train(bst_kernel_idx,:);
    max_data_train=max_data_train(bst_kernel_idx,:);
    data_test=xdata_allkernel(test,:,bst_kernel_idx); % test data for current fold_no
    [data_test]=minmax_featureNormalize_test(data_test,min_data_train,max_data_train);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    save_data_test{fold_no,1}=data_test;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Load parameters to check if result are reproducable%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % best_kernel_model=save_best_kernel_model{fold_no,1};
    % data_test=save_data_test{fold_no,1};
    % True_Label_test=save_True_Label_test{fold_no,1};
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Predict_label_test, fold_accuracy, prob_estimates] = svmpredict(True_Label_test,data_test, best_kernel_model, '-b 1');
    save_Predict_label_test{fold_no,1}=Predict_label_test;
    save_prob_estimates{fold_no,1}=prob_estimates;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    save_True_Label_test{fold_no,1}=True_Label_test;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    FN=(True_Label_test~=Predict_label_test & True_Label_test==1);
    FP=(True_Label_test~=Predict_label_test & True_Label_test==0);
    TN=(True_Label_test==Predict_label_test & True_Label_test==0);
    TP=(True_Label_test==Predict_label_test & True_Label_test==1);
    
    fold_test_accuracy(fold_no)=(1-(sum(abs(True_Label_test-Predict_label_test))/numel(True_Label_test)))*100;
    Scale=repmat(N_Scale,[1 no_of_kernel]);
    Orient=repmat(N_Orientation,[1 no_of_kernel]);
    validate_accuracy_varyROS(:,:,fold_no)=[fold_accuracy_validate1;ROS_idx;Scale;Orient];
end
%%%%%%%%%%%%%Save Results%%%%%%%%%%%%%%%
%save(['F:\MS\matlab_code\WORK\SPIE_2017\Classification\libsvm-3.20\matlab\MR8Results\visualiseonly\tsne\SelectROS\',viz_case,'_Param_all_kernels'],'validate_accuracy_varyROS','fold_test_accuracy');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

final_accuracy=sum(fold_test_accuracy)/fold_no;


end




