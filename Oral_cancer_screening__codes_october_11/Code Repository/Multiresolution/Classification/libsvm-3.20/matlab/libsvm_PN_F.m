
function [final_accuracy,indices,optns,model]= libsvm(xdata,Target_train,no_of_folds)
group = Target_train;

no_of_trials=1;

data_crossvalind=size(xdata,1);
%  indices= crossvalind('Kfold',data_crossvalind,no_of_folds);
%load('F:\MS\matlab_code\WORK\SPIE_2017\Classification\Result_svm_bst\S2\PN_P_svm_reduced_data_bstresult_correct2.mat')
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
        for d = 2:10,
        cmd = ['-v 5 -c ', num2str(2^log2c), ' -d ', num2str(d), ' -t 1 -b 1'];
        cv = svmtrain(True_Label_train, data_train, cmd);
            if (cv >= bestcv),
              bestcv = cv; bestc = 2^log2c; bestd = d;
            end
        fprintf('%g %g %g (bestc=%g, g=%g, rate=%g)\n', log2c, d, cv, bestc, bestd, bestcv);
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
  optns = [' -c ', num2str(bestc), ' -g ',num2str(bestd),' -t 1 -b 1'];
%    load('optns.mat')

%============================  Training Part %=============================
% options=[-c cval  -t 0 -b 1];

model = svmtrain(True_Label_train,data_train,optns);
%============================  Classification Part %=============================
[data_test]=featureNormalize_test(data_test,mu_train,sigma_train);

[Predict_label_test, fold_accuracy, prob_estimates] = svmpredict(True_Label_test,data_test, model, '-b 1');
fold_accuracy1(fold_no)=(1-(sum(abs(True_Label_test-Predict_label_test))/numel(True_Label_test)))*100;
end

trail_accuracy(trail_no)=sum(fold_accuracy1)/fold_no;
end
final_accuracy=sum(trail_accuracy)/trail_no;
end




