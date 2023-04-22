function[correctness]= classificationND(data_test,train_labels,Target_test,idx,no_of_cluster,Center)
rng('default');
cluster=cell(1,no_of_cluster); %cell (j) contains index of training data belonging to cluster (j)
label_of_cluster=zeros(no_of_cluster,1);% Each one of the cluster will get a label based on majority class voting

for cluster_idx=1:no_of_cluster %finds the label of each cluster
    
    cluster{cluster_idx}=find(idx==cluster_idx);
    labels_in_cluster=train_labels(cluster{cluster_idx}); %Labels of member belonging to current cluster
    belong_patients=sum(labels_in_cluster);                %No. of patients in current cluster
    belong_Normal=numel(cluster{cluster_idx})-belong_patients;  %No. of normal subjects in current cluster
    label_of_cluster(cluster_idx)=(belong_patients>belong_Normal);
end

%============================  Testing Part %=============================
predicted_class_label=numel(Target_test); %Predict the class label of test set
total_test_cases=numel(Target_test);


for which_element_testdata=1:total_test_cases
    test_pt=repmat(data_test(which_element_testdata,:),no_of_cluster,1); % test_idx is the current test point
    dist_testpt_Center=sum(abs(test_pt-Center),2);
    [~,which_cluster]=min(dist_testpt_Center);
    predicted_class_label(which_element_testdata)=label_of_cluster(which_cluster);
end
misclassify=sum(abs(Target_test'-predicted_class_label))/total_test_cases;
correctness=1-misclassify;


end
