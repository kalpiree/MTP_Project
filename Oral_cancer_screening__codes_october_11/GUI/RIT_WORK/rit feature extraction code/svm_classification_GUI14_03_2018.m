clear ;
close;
clc;
% % (1) Load the features  which was extracted for all patients which has to be trained
% % from the directory where it was stored
%cd('E:\MTech work\code repository\Multiresolution\GaborFeatures_HM_allScale');
% % % % % % % % % % % % % % % % % % % % % % 
cd('D:\anjali\17EC65R09_Abhishek\Codes\Code Repository\Multiresolution\GaborFeatures_HM_allScale');

%(2)Load the features to train of malignant and normal 
% 

load('GT_Gabor_HM_M_Frontal','GT_Gabor_HM_M_Frontal');
load('GT_Gabor_HM_N_Frontal','GT_Gabor_HM_N_Frontal');


%%%%%(3)
% Go to the Parent Directory  
% and arrange the data in according to its classes

%cd('C:\Users\A N K I T 16EC\Desktop\rit feature extraction code');
cd('D:\anjali\GUI\RIT_WORK\rit feature extraction code');

scale_idx=[2,3,4,5,6];
scales = numel(scale_idx);

% % % % % % % % 

% [final_accuracy]= svm_classification_GUI(GT_Gabor_HM_M_Frontal,GT_Gabor_HM_N_Frontal,scales);
% 
% function [final_accuracy]= svm_classification_GUI(Feature_Patient,Feature_Normal,scales)
% 
% %%% target train specifies the labels of the data


Patient=GT_Gabor_HM_M_Frontal;
Normal=GT_Gabor_HM_N_Frontal;
[row,col]=size(Normal);
xdata_allscale=cell(row,1);


for idx_row=1:row
xdata_allscale{idx_row,1} =[Patient{idx_row,1};Normal{idx_row,1}];
end
Target_train=[ones(size(Patient{idx_row,1},1),1);zeros(size(Normal{idx_row,1},1),1)];

%%%Target_train is the  the original labels of the data
%%%xdata_allscale is the (scale * 1 size matrix) cell containing all the data

group = Target_train;

% data which has to be predicted

test_data;
test_label;
% % % % % % % % % % % % % % % % % 


 for scale_idx=1:scales
 
    data_train=cell2mat(xdata_allscale(scale_idx,1));
    
    [data_train,min_data_train{scale_idx,1},max_data_train{scale_idx,1}]=minmax_featureNormalize(data_train);
 %%============================  Grid search for parameter selection %=============================
  %%%%%%%%%%%%%%%%%%%%%%%%%
         bestcv = 0;
            for log2c = 1:10
                for log2g = -10:10
                    cmd = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g), ' -t 2 -b 1'];
                    cv = svmtrain(Target_train, data_train, cmd);
                        if (cv >= bestcv)
                          bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
                        end
                    fprintf('%g %g %g (bestc=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
                end
            end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    optns = [' -c ', num2str(bestc), ' -g ',num2str(bestg),' -t 2 -b 1'];

 
 
    %============================%Training Part%=============================
    %%%%%%%%%%%%%%%%%%%%%%%%%
   
    model(scale_idx) = svmtrain(Target_train,data_train,optns);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
 
 
 
 end

%%%test for each scale
for scale_idx = 1:scales 

    [Predict_label_test, fold_accuracy, prob_estimates] = svmpredict(test_label,test_data, model(1,scale_idx), '-b 1');

end


%%%find the majority of the labels and that is the output












