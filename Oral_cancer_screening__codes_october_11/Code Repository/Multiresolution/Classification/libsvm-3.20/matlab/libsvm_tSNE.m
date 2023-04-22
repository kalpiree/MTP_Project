
function [fold_accuracy1,fold_prob_estimates,fold_Predict_label_test,fold_True_Label_test,fold_train_data,fold_train_label,fold_test_data,fold_test_label]= libsvm(xdata,Target_train,no_of_folds)
group = Target_train;

no_of_trials=1;
fold_train_data=cell(no_of_folds,1);
fold_test_data=cell(no_of_folds,1);
fold_prob_estimates=cell(no_of_folds,1);
fold_Predict_label_test=cell(no_of_folds,1);
data_crossvalind=size(xdata,1);
%   indices= crossvalind('Kfold',data_crossvalind,no_of_folds);
load('F:\MS\matlab_code\WORK\SPIE_2017\Classification\Result_svm_bst\S4\PN_F_reduced_data_svm_bestresult1.mat')
% cval=c;

%%
fold_accuracy=zeros(no_of_folds,1);
trail_accuracy=zeros(no_of_trials,1);

for trail_no=1:no_of_trials
for fold_no = 1:no_of_folds
test= (indices == fold_no); % idx of elements which will go for testing
train = ~test; % idx of elements which will  go for training
data_test=xdata(test,:); % test data for current fold_no
True_Label_test=group(test);% target test labels for current fold
data_train=xdata(train,:); % train data for current fold_no
True_Label_train=group(train);% training labels for current fold
%============================  Grid search for parameter selection %=============================
[data_train,mu_train,sigma_train]=featureNormalize(data_train);
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
%     bestcv = 0;
%     for c_fine = 1:bestc,
%         for g_fine = bestg:2^(bestg+1),
%         cmd = ['-v 5 -c ', num2str(c_fine), ' -g ', num2str(g_fine), ' -t 2 -b 1'];
%         cv = svmtrain(True_Label_train, data_train, cmd);
%             if (cv >= bestcv),
%               bestcv = cv; bestc1 = c_fine; bestg1 = g_fine;
%             end
% %         fprintf('%g %g %g (bestc=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
%         end
%     end
  optns = [' -c ', num2str(bestc), ' -g ',num2str(bestg),' -t 2 -b 1'];
%    load('optns.mat')

%============================  Training Part %=============================
% options=[-c cval  -t 0 -b 1];

model = svmtrain(True_Label_train,data_train,optns);
%============================  Classification Part %=============================
[data_test]=featureNormalize_test(data_test,mu_train,sigma_train);

[Predict_label_test, fold_accuracy, prob_estimates] = svmpredict(True_Label_test,data_test, model, '-b 1');
fold_prob_estimates{fold_no}=prob_estimates;
fold_Predict_label_test{fold_no}=Predict_label_test;
fold_True_Label_test{fold_no}=True_Label_test;
fold_accuracy1(fold_no)=(1-(sum(abs(True_Label_test-Predict_label_test))/numel(True_Label_test)))*100;
fold_train_data{fold_no}=data_train;
fold_train_label{fold_no}=True_Label_train;
fold_test_data{fold_no}=data_test;
fold_test_label{fold_no}=True_Label_test;
end

trail_accuracy(trail_no)=sum(fold_accuracy1)/fold_no;
end
final_accuracy=sum(trail_accuracy)/trail_no;
end




