
function [final_accuracy,indices,model]= libsvm(xdata,Target_train,optns,no_of_folds)
group = Target_train;

no_of_trials=1;

data_crossvalind=size(xdata,1);
indices= crossvalind('Kfold',data_crossvalind,no_of_folds);
% load indices.mat;
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
%============================  Training Part %=============================
% options=[-c cval  -t 0 -b 1];
model = svmtrain(True_Label_train,data_train,optns);
%============================  Classification Part %=============================
[Predict_label_test, fold_accuracy, prob_estimates] = svmpredict(True_Label_test,data_test, model, '-b 1');
fold_accuracy1(fold_no)=(1-(sum(abs(True_Label_test-Predict_label_test))/numel(True_Label_test)))*100;
end

trail_accuracy(trail_no)=sum(fold_accuracy1)/fold_no;
end
final_accuracy=sum(trail_accuracy)/trail_no;
end




