
function [Final_accuracy,indices,optns,save_optns,save_prob_estimates,model,save_idx_validate,save_True_Label_test,save_Predict_label_test,save_best_kernel_model,save_bst_kernel_idx,save_data_test,save_data_train,save_data_validate,avg_sen,avg_spc,counter]= libsvm_scaleselect(xdata_allscale,Target_train,no_of_folds,scales,viz_case,Flag,Setting,nameFolds)
group = Target_train;
Total_true_label=group;
no_of_folds=1;


data_crossvalind=size(xdata_allscale{1,1},1);
%-------------------------------------------



if(Flag =='1')
    %%%load the precalculated data
    if(strcmp(Setting,'GT_MN_FULL')==1)
        load('Full_Gabor_MN_Frontal\MN_Full_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
    elseif(strcmp(Setting,'GT_PN_FULL')==1)
        load('Full_Gabor_PN_Frontal\PN_Full_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
    elseif(strcmp(Setting,'GT_MN_AGE')==1)
        load('AgeAdjust_Gabor_MN_Frontal\MN_AgeAdjust_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        
    elseif(strcmp(Setting,'GT_PN_AGE')==1)
        load('AgeAdjust_Gabor_PN_Frontal\PN_AgeAdjust_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        
        
    elseif(strcmp(Setting,'PROFILE_GT_MN_FULL')==1)
        load('Full_Gabor_MN_Profile\MN_Parameters_Profile.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        
    elseif(strcmp(Setting,'PROFILE_GT_PN_FULL')==1)
        load('Full_Gabor_PN_Profile\PN_Parameters_Profile.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        
    elseif(strcmp(Setting,'PROFILE_GT_MN_AGE')==1)
        load('AgeAdjust_Gabor_MN_Profile\MN_Parameters_Profile.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
    elseif(strcmp(Setting,'PROFILE_GT_PN_AGE')==1)
        load('AgeAdjust_Gabor_PN_Profile\PN_Parameters_Profile.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        
    elseif(strcmp(Setting,'AROI_MN_FULL')==1)
        load('AROI_Full_Gabor_MN_Frontal\MN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
    elseif(strcmp(Setting,'AROI_PN_FULL')==1)
        load('AROI_Full_Gabor_PN_Frontal\PN_Parameters_Frontal.mat');
        clear model; clear optns; clear save_best_kernel_model; clear save_bst_kernel_idx; clear save_data_test; clear save_data_train; clear save_data_validate; clear save_Predict_label_test; clear save_prob_estimates; clear save_True_Label_test;
        
        
        
     elseif(strcmp(Setting,'AROI_MN_AGE')==1)
        load('AROI_AgeAdjust_Gabor_MN_Frontal\MN_AgeAdjust_Parameters_Frontal.mat');
        clear model;
        
        
    elseif(strcmp(Setting,'AROI_PN_AGE')==1)
        load('AROI_AgeAdjust_Gabor_PN_Frontal\PN_AgeAdjust_Parameters_Frontal.mat');
        clear model;
        
        
    end
    
    
else
%     rng('shuffle');
%     indices= crossvalind('Kfold',data_crossvalind,no_of_folds);    %generate crossvalidation index afresh
      indices = (1:214);
end





%%

min_data_train=cell(numel(scales),1);
max_data_train=cell(numel(scales),1);
save_prob_estimates=cell((no_of_folds),1);
save_True_Label_test=cell((no_of_folds),1);
% save_idx_validate=cell(numel(scales),no_of_folds,1);
save_Predict_label_test=cell((no_of_folds),1);
save_best_kernel_model=cell((no_of_folds),1);
fold_test_accuracy=zeros(no_of_folds,1);

size_predict=size(group,1);
counter = zeros(1,size_predict);% Final counter showing the count of right classification for each subject 
 for j=1:1:3
    
for fold_no = 1:1
     test= ((indices > 75 & indices < 107) | (indices > 165 & indices < 215)); % idx of elements which will go for testing
     train = ~test; % idx of elements which will  go for training
     True_Label_test=group(test);% target test labels for current fold
    for scale_idx=1:numel(scales)
        mat_xdata_allscale=cell2mat(xdata_allscale(scale_idx,1));
        data_train_total=mat_xdata_allscale(train,:); % train data for current fold_no
        True_Label_train_total=group(train);% training labels for current fold
        rand_no_gen = randperm(size(data_train_total,1));  % index for partinoning training and validation data
        if(Flag =='0')
            idx_validate=rand_no_gen(1:floor(size(data_train_total,1)/4));
            save_idx_validate{scale_idx,fold_no,1}=idx_validate;
        else
            idx_validate=cell2mat(save_idx_validate(scale_idx,fold_no));
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        data_validate=data_train_total(idx_validate,:);
        data_train_idx=1:size(data_train_total,1);
        data_train_idx(idx_validate)=[];
        data_train=data_train_total(data_train_idx,:);
        True_Label_validate=True_Label_train_total(idx_validate,:);
        True_Label_train=True_Label_train_total(data_train_idx,:);
        
        %%%%%%%%%%%%%%%%%%%%%%%%
        
%         [data_train,min_data_train{scale_idx,1},max_data_train{scale_idx,1}]=minmax_featureNormalize(data_train);
        [data_train,mean_data{scale_idx,1},std_data{scale_idx,1}] = zscore_featureNormalize(data_train);
        save_data_train{scale_idx,fold_no}=data_train;
        %============================  Grid search for parameter selection %=============================
        %%%%%%%%%%%%%%%%%%%%%%%%
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
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        optns = [' -c ', num2str(bestc), ' -g ',num2str(bestg),' -t 2 -b 1'];
        save_optns{scale_idx,fold_no}=optns;
        %%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        
        
        
        %============================  Training Part %=============================
        %%%%%%%%%%%%%%%%%%%%%%%%%
        model(scale_idx) = svmtrain(True_Label_train,data_train,optns);
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %============================  Validation Part %=============================
        min_data_train1=min_data_train{scale_idx,1};
        max_data_train1=max_data_train{scale_idx,1};
%         [data_validate]=minmax_featureNormalize_test(data_validate,min_data_train1,max_data_train1);
        [data_validate] = zscore_featureNormalize_test(data_validate,mean_data{scale_idx,1},std_data{scale_idx,1});
        %data_validate= cell2mat(save_data_validate(scale_idx,fold_no));
        
        save_data_validate{scale_idx,fold_no}=data_validate;
        [Predict_label_validate, fold_accuracy_validate, prob_estimates_validate] = svmpredict(True_Label_validate,data_validate, model(scale_idx), '-b 1');
        fold_accuracy_validate1(scale_idx)=(1-(sum(abs(True_Label_validate-Predict_label_validate))/numel(True_Label_validate)))*100;
         Predict_label_validate = prob_estimates_validate>0.5;
    end
    % %============================  Testing Part %=============================
    %
    bst_kernel_idx=find(fold_accuracy_validate1==max(fold_accuracy_validate1));
    bst_kernel_idx=bst_kernel_idx(1);
    save_bst_kernel_idx(fold_no)=bst_kernel_idx;
    best_kernel_model=model(bst_kernel_idx);
    save_best_kernel_model{fold_no,1}=best_kernel_model;
    min_data_train1=min_data_train{bst_kernel_idx,1};
    max_data_train1=max_data_train{bst_kernel_idx,1};
    mat_data_test=xdata_allscale{bst_kernel_idx,1};
    data_test=mat_data_test(test,:); % test data for current fold_no
%     [data_test]=minmax_featureNormalize_test(data_test,min_data_train1,max_data_train1);
    [data_test] = zscore_featureNormalize_test(data_test,mean_data{bst_kernel_idx,1},std_data{bst_kernel_idx,1});
    save_data_test{fold_no,1}=data_test;
    
    [Predict_label_test, fold_accuracy, prob_estimates] = svmpredict(True_Label_test,data_test, best_kernel_model, '-b 1');
    save_Predict_label_test{fold_no,1}=Predict_label_test;
    save_prob_estimates{fold_no,1}=prob_estimates;
    save_True_Label_test{fold_no,1}=True_Label_test;
%     FN=sum(Predict_label_test==0 & True_Label_test==1);
%     FP=sum(Predict_label_test==1 & True_Label_test==0);
%     TN=sum(Predict_label_test==0 & True_Label_test==0);
%     TP=sum(Predict_label_test==1 & True_Label_test==1);
%     sensitivity(fold_no)=TP/(TP+FN);
%     specificity(fold_no)=TN/(TN+FP);
    
    fold_test_accuracy(fold_no)=(1-(sum(abs(True_Label_test-Predict_label_test))/numel(True_Label_test)))*100;
    validate_accuracy_varyROS(:,:,fold_no)=[fold_accuracy_validate1;scales];
    predict(test)=Predict_label_test;% this is the predicted label
    probability_data(test)= prob_estimates(:,1);% this is the predicted prob
end
    final_accuracy(j)=sum(fold_test_accuracy)/fold_no;
    [Operating_point] = ROC_AUC(predict,probability_data,Total_true_label);
    Sensitivity(j)=Operating_point(1);
    Specificity(j)=1-Operating_point(2);
    distance(j)=Operating_point(3);

     for i=1:1:size_predict
        if predict(i)==group(i)
         counter(i)=counter(i)+1;
        end
     end 

 end


 Final_accuracy=sum(final_accuracy)/3;
 avg_sen=sum(Sensitivity)/3;
 avg_spc=sum(Specificity)/3;
 avg_distance = sum(distance)/3;

 end




