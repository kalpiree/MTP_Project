clc;
clear;
% function feature_extraction_GUI(I1,mask_F_normal_lt,mask_F_normal_rt )
%%%input to the function
I1= imread('P002.jpg');
load('Face_Mask.mat');
mask_F_normal_lt=img_face_lt;
mask_F_normal_rt=img_face_rt;
%
scale_idx=[2:6];
scales = numel(scale_idx);

%%% I1 is  the input image
%%% Masks consist of left and right half of mask

%%% feature extraction and classification

%%feature extraction
            %%%%%%%bringing the image to a scale of floating point 0.0-1.0
            for scale_idx=2:6
            
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); 
           
            I1 = adapthisteq((I1));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            GT_gabor_F_normal_lt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_normal_lt),scale_idx); %%%%%% Input : Image , Mask , Scale Idx
            GT_gabor_F_normal_rt = TexturalFeatureExtraction_RIGabor_HanAndMa(I1,logical(mask_F_normal_rt),scale_idx); %%%%%% Input : Image , Mask , Scale Idx
            
            Test_data = [GT_gabor_F_normal_lt GT_gabor_F_normal_rt];
              
            cd('C:\Users\A N K I T 16EC\Desktop\rit feature extraction code\temp_data');
            
            save(['Test_data',num2str(scale_idx),'.mat'],'Test_data');
         
            cd('../'); 
            
            end


%test for each scale

cd('C:\Users\A N K I T 16EC\Desktop\rit feature extraction code\temp_data');

load('model.mat');


cd('../'); 


for scale_idx = 2:6 
    
    
    % data which has to be predicted
    cd('C:\Users\A N K I T 16EC\Desktop\rit feature extraction code\temp_data');
    test_data = load(['Test_data', num2str(scale_idx),'.mat']);
    test_data = test_data.Test_data;
    test_data = double( test_data);
    test_label = double(0);
    cd('../'); 
    %

    [Predict_label_test, fold_accuracy, prob_estimates] = svmpredict(test_label,test_data, model(1,(scale_idx-1)), '-b 1');

%    if  Predicted_label_test is 1 then it is Malignat
%    else it is normal
    
end


%%%find the majority of the labels and that is the output

    