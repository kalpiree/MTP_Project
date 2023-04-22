% =========================== GT_MN_kmeans_fuzzy.m ====================================== %
% Description  : 
% 1.Classification for Malignant / Non Malignant feature vs normal
%   vector using the Fuzzy kmeans clustering approach first find the optimal
%   clusters (kneepoint detection). 
% 2. Kfold crossvalidation of the data set is done (K = 5) 
% 3. For each fold indices are randommly generated and used for testing as
%    well as training 
% 4. Kmeans clustering is done and reported accuracy  is the average of the Kfolds accuracy 
% 
%
%
% ================================================================================== %
% Input Parameters : MAE128_Front_Malignant    --> Feature Patient
%                    MAE128_Front_Normal,      --> Feature Normal
%                    Flag,                     --> 1/0
%                    
%                    Setting                   --> Valid if Flag==1
%                    
%------------------------------------------------------------------------------------%  
% Output parameter: final_accuracy_fk, final_accuracy_k,       --> Accuracy
%                   no_of_cluster_fcm,no_of_cluster_kmeans,    --> Optimumclusters
%                   indices,center_fcm,                        --> Index and
%                                                                  cente of
%                                                                  fuzzy
%                                                                                                                   
%                   center_kmeans,idx_kmeans,U_fcm            --> Index and
%                                                                  cente of
%                                                                  kmeans
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1: classification
% Called by :  GT_PN_k.mmeans1D_hard_fuzzy
%------------------------------------------------------------------------------------%
% Reference:    
%
%[1] to be written

% Author of the code: Manashi Chakraborty
% Date of creation :    
% ------------------------------------------------------------------------------------------------------- %
% Modified on :   
% Modification details:    
% Modified By :  Manashi Chakraborty
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %

function [final_accuracy_fk,final_accuracy_k,no_of_cluster_fcm,no_of_cluster_kmeans,indices,center_fcm,center_kmeans,idx_kmeans,U_fcm]= GT_MN_kmeans_fuzzy(MAE128_Front_Malignant,MAE128_Front_Normal,Flag,Setting)

%%






options=[2 100 1e-5 0]; %default options for fuzzy c means MATLAB inbuilt function





%%
%==================================load data=====================
% Here we will load MAE for various class of subjects
patient=MAE128_Front_Malignant;
normal=MAE128_Front_Normal;

X=[patient;normal];

no_of_folds=5;
no_of_trials=1;
chck_optimum_clust=20;

no_of_cluster_fcm=find_optimum_clust_fcm(X,chck_optimum_clust,options);
no_of_cluster_kmeans=find_optimum_clust_kmeans(X,chck_optimum_clust);


X=[patient;normal];
Actual_label=[ones(size(patient,1),1);zeros*ones(size(normal,1),1)]; % Patient=1 and Normal=0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if(Flag =='1')
%%%load the precalculated data
    if(strcmp(Setting,'MN_F_FULL')==1)
       load('indices_MN_Front_Full.mat');
         indices=indices_MN;

    
    elseif(strcmp(Setting,'MN_F_AGE')==1)
        load('indices_MN_Front_AgeAdjust.mat');
         indices=indices_MN;
        
    
    elseif(strcmp(Setting,'MN_P_FULL')==1)
         load('indices_MN_Profile_Full.mat');
         indices=indices_MN;
       
    
    elseif(strcmp(Setting,'MN_P_AGE')==1)
        load('indices_MN_Profile_AgeAdjust.mat');
         indices=indices_MN;
    
    
        
     end


else
    
%=============================Cross Validation(Index Generation)   ============================
 %Uncomment the below three lines if you want to generate all new
    %cross-validation index
%      rng('shuffle');
% 
%     data_crossvalind=size(X,1);
%  
%     indices= crossvalind('Kfold',data_crossvalind,no_of_folds);    %generate crossvalidation index afresh

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%
%%


fold_accuracy_fk=zeros(no_of_folds,1);

fold_accuracy_k=zeros(no_of_folds,1);







for fold_no = 1:no_of_folds
test= (indices == fold_no); % idx of elements which will go for testing
train = ~test; % idx of elements which will  go for training
data_test=X(test,:); % test data for current fold_no
Target_test=Actual_label(test);% target test labels for current fold
data_train=X(train,:); % train data for current fold_no
True_Label_train=Actual_label(train);% training labels for current fold
%============================  Training Part %=============================
%=============================

[center,U,~] = fcm(data_train,no_of_cluster_fcm,options);
center_fcm(:,fold_no)=center;
U_fcm{1,fold_no}=U;
%=============================
%=============To store the centre and membership uncomment the following two lines================

%  center=center_fcm(:,fold_no)
%  U= U_fcm{1,fold_no};
 %=============================

[~,idx]=max(U);
[fold_accuracy_fk(fold_no)]=classification(data_test,True_Label_train,Target_test,idx,no_of_cluster_fcm,center);
clear idx
%=============================
[idx,Center] = kmeans(data_train,no_of_cluster_kmeans);
center_kmeans(:,fold_no)=Center;
idx_kmeans{:,fold_no}=idx;
%=============To store the centre and index uncomment the following two lines================
% Center=center_kmeans(:,fold_no);
% idx=idx_kmeans{:,fold_no};
%=============================
[fold_accuracy_k(fold_no)]=classification(data_test,True_Label_train,Target_test,idx,no_of_cluster_kmeans,Center);
clear center,Center;
end


final_accuracy_fk=(sum(fold_accuracy_fk)/fold_no)*100;
final_accuracy_k=(sum(fold_accuracy_k)/fold_no)*100;

end
  













