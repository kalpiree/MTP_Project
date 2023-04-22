%% Main Code for Face Detection
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
% d = dir('E:\ThermalDatabase\Normal'); % Reading Dir of the Specified Folder
d = dir('E:\ThermalDatabase\Malignant'); % Reading Dir of the Specified Folder
% d = dir('E:\ThermalDatabase\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%
% Result_ratio_Malig=[];
% for folder_idx=1:93
% %% Normal  
% %     direc=['E:\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
%     direc=['E:\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
% %     direc=['E:\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];
% 
%   Save_Direc=['E:\ThermalDatabase\Normal\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];    
% 
%      load(direc);
%      load(Save_Direc);
%      
%      detected_left_col=lt_boundary_col;
%      detected_top_row=upper_boundary_row;
%      detected_bottom_row=lower_boundary_row;
%      detected_right_col=rt_boundary_col;
%      
%      if(detected_left_col==0)
%          detected_left_col=1;
%      end
%      if(detected_top_row==0)
%          detected_top_row=1;
%      end
%      if(detected_bottom_row==0)
%          detected_bottom_row=1;
%      end
%      if(detected_right_col==0)
%          detected_right_col=1;
%      end
%      detected_mask=[];
%      ground_truth_mask=[];
%     
%      
%      detected_mask(1:480,1:640)=0;
%      ground_truth_mask(1:480,1:640)=0;
%      
%      detected_mask(detected_top_row:detected_bottom_row,detected_right_col:detected_left_col)=1;
%      ground_truth_mask(ground_top_row:ground_bottom_row,ground_right_col:ground_left_col)=1;
%      
%      
%      %% E1 Metric = Classification error rate
%      Product_mask=(xor(detected_mask(1:480,1:640),ground_truth_mask(1:480,1:640)));
%         
%      E1_Normal(folder_idx)=nnz(Product_mask);
%      
%      E1_Normal(folder_idx)=E1_Normal(folder_idx)/(480*640);
%      
%      %% E2 Metric = FPR & FNR
%      
%      
%      TP=nnz(and(detected_mask(1:480,1:640),ground_truth_mask(1:480,1:640)));
%      FP=nnz(and(detected_mask(1:480,1:640),not(ground_truth_mask(1:480,1:640))));
%      FN=nnz(and(not(detected_mask(1:480,1:640)),ground_truth_mask(1:480,1:640)));
%      TN=nnz(and(not(detected_mask(1:480,1:640)),not(ground_truth_mask(1:480,1:640))));
%      
%      Total_Positive=nnz(ground_truth_mask(1:480,1:640));
%      Total_Negative=nnz(not(ground_truth_mask(1:480,1:640)));
%      
%      FPR=FP/Total_Negative;
%      FNR=FN/Total_Positive;
%      
%      E2_Normal(folder_idx)=(FPR+FNR)/2;
%      
%      
%      %% IOU Metric
%      intersection_top_row=[];
%      intersection_bottom_row=[];
%      intersection_left_col=[];
%      intersection_right_col=[];
%      
%      union_top_row=[];
%      union_bottom_row=[];
%      union_left_col=[];
%      union_right_col=[];
%      
%      if(detected_left_col < ground_left_col)
%          intersection_left_col=detected_left_col;
%          union_left_col=ground_left_col;
%      else
%          intersection_left_col=ground_left_col;
%          union_left_col=detected_left_col;
%      end
%      
%      if(detected_right_col < ground_right_col)
%          intersection_right_col=ground_right_col;
%          union_right_col=detected_right_col;
%      else
%          intersection_right_col=detected_right_col;
%          union_right_col=ground_right_col;
%      end
%      
%      if(detected_top_row > ground_top_row)
%          intersection_top_row=detected_top_row;
%          union_top_row=ground_top_row;
%      else
%          intersection_top_row=ground_top_row;
%          union_top_row=detected_top_row;
%      end
%      
%      if(detected_bottom_row > ground_bottom_row)
%          intersection_bottom_row=ground_bottom_row;
%          union_bottom_row=detected_bottom_row;
%      else
%          intersection_bottom_row=detected_bottom_row;
%          union_bottom_row=ground_bottom_row;
%      end
%      
%      area_intersection=(intersection_bottom_row-intersection_top_row)*(intersection_left_col-intersection_right_col);
%      area_union=(union_bottom_row-union_top_row)*(union_left_col-union_right_col);
%      
%      width_detected=(detected_left_col-detected_right_col);
%      height_detected=(detected_bottom_row-detected_top_row);
%      
%      if(width_detected>0 && height_detected>0)
%         area_detected=height_detected*width_detected;
%         area_ground=(ground_bottom_row-ground_top_row)*(ground_left_col-ground_right_col);
%         Result_ratio_Normal(folder_idx)=(area_intersection)/(area_union);
%         Dice_ratio_Normal(folder_idx)=2*(area_intersection)/(area_detected+area_ground);
%      else
%          Result_ratio_Normal(folder_idx)=0;
%          Dice_ratio_Normal(folder_idx)=0;
%      end
% end
% % Result_ratio_Normal=Result_ratio_Normal.*(Result_ratio_Normal>0);
% Dice_ratio_Normal=Dice_ratio_Normal.*(Dice_ratio_Normal>0);
% 
%% Malignant
% Fetch the Index Numbers of the Malignant Patients
d = dir('E:\ThermalDatabase\Malignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:93
%      direc=['E:\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
%    direc=['E:\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
%    direc=['E:\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
   direc=['E:\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
%    direc=['E:\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];

Save_Direc=['E:\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];

    load(direc);
    load(Save_Direc);
    detected_left_col=lt_boundary_col;
     detected_top_row=upper_boundary_row;
     detected_bottom_row=lower_boundary_row;
     detected_right_col=rt_boundary_col;
     
     if(detected_left_col==0)
         detected_left_col=1;
     end
     if(detected_top_row==0)
         detected_top_row=1;
     end
     if(detected_bottom_row==0)
         detected_bottom_row=1;
     end
     if(detected_right_col==0)
         detected_right_col=1;
     end
     detected_mask=[];
     ground_truth_mask=[];
    
     
     detected_mask(1:480,1:640)=0;
     ground_truth_mask(1:480,1:640)=0;
     
     detected_mask(detected_top_row:detected_bottom_row,detected_right_col:detected_left_col)=1;
     ground_truth_mask(ground_top_row:ground_bottom_row,ground_right_col:ground_left_col)=1;
     
     
     %% E1 Metric = Classification error rate
     Product_mask=(xor(detected_mask(1:480,1:640),ground_truth_mask(1:480,1:640)));
        
     E1_Malignant(folder_idx)=nnz(Product_mask);
     
     E1_Malignant(folder_idx)=E1_Malignant(folder_idx)/(480*640);
     
     %% E2 Metric = FPR & FNR
     
     
     TP=nnz(and(detected_mask(1:480,1:640),ground_truth_mask(1:480,1:640)));
     FP=nnz(and(detected_mask(1:480,1:640),not(ground_truth_mask(1:480,1:640))));
     FN=nnz(and(not(detected_mask(1:480,1:640)),ground_truth_mask(1:480,1:640)));
     TN=nnz(and(not(detected_mask(1:480,1:640)),not(ground_truth_mask(1:480,1:640))));
     
     Total_Positive=nnz(ground_truth_mask(1:480,1:640));
     Total_Negative=nnz(not(ground_truth_mask(1:480,1:640)));
     
     FPR=FP/Total_Negative;
     FNR=FN/Total_Positive;
     
     E2_Malignant(folder_idx)=(FPR+FNR)/2;
     
     
     %% IOU Metric
     intersection_top_row=[];
     intersection_bottom_row=[];
     intersection_left_col=[];
     intersection_right_col=[];
     
     union_top_row=[];
     union_bottom_row=[];
     union_left_col=[];
     union_right_col=[];
     
     if(detected_left_col < ground_left_col)
         intersection_left_col=detected_left_col;
         union_left_col=ground_left_col;
     else
         intersection_left_col=ground_left_col;
         union_left_col=detected_left_col;
     end
     
     if(detected_right_col < ground_right_col)
         intersection_right_col=ground_right_col;
         union_right_col=detected_right_col;
     else
         intersection_right_col=detected_right_col;
         union_right_col=ground_right_col;
     end
     
     if(detected_top_row > ground_top_row)
         intersection_top_row=detected_top_row;
         union_top_row=ground_top_row;
     else
         intersection_top_row=ground_top_row;
         union_top_row=detected_top_row;
     end
     
     if(detected_bottom_row > ground_bottom_row)
         intersection_bottom_row=ground_bottom_row;
         union_bottom_row=detected_bottom_row;
     else
         intersection_bottom_row=detected_bottom_row;
         union_bottom_row=ground_bottom_row;
     end
     
     area_intersection=(intersection_bottom_row-intersection_top_row)*(intersection_left_col-intersection_right_col);
     area_union=(union_bottom_row-union_top_row)*(union_left_col-union_right_col);
     
     width_detected=(detected_left_col-detected_right_col);
     height_detected=(detected_bottom_row-detected_top_row);
     
     if(width_detected>0 && height_detected>0)
        area_detected=height_detected*width_detected;
        area_ground=(ground_bottom_row-ground_top_row)*(ground_left_col-ground_right_col);
        Result_ratio_Malignant(folder_idx)=(area_intersection)/(area_union);
        Dice_ratio_Malignant(folder_idx)=2*(area_intersection)/(area_detected+area_ground);
     else
         Dice_ratio_Malignant(folder_idx)=0;
     end
end
% Result_ratio_Malignant=Result_ratio_Malignant.*(Result_ratio_Malignant>0);
% Dice_ratio_Malignant=Dice_ratio_Malignant.*(Dice_ratio_Malignant>0);
% 
% %% Non-Malignant
%     %% Fetch the Index Numbers of the Malignant Patients
% d = dir('E:\ThermalDatabase\NonMalignant'); % Reading Dir of the Specified Folder
% isub = [d(:).isdir]; %# returns logical vector
% nameFolds = {d(isub).name}';
% nameFolds=nameFolds(3:end);
% no_dir=numel(nameFolds);
% 
% for folder_idx=1:79
% %% Non-Malignant
% 
% %    direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
%    direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
% %    direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
% %    direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
% %    direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];
% 
% Save_Direc=['E:\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];

%     load(direc);
%     load(Save_Direc);
% 
%      detected_left_col=lt_boundary_col;
%      detected_top_row=upper_boundary_row;
%      detected_bottom_row=lower_boundary_row;
%      detected_right_col=rt_boundary_col;
%      
%      if(detected_left_col==0)
%          detected_left_col=1;
%      end
%      if(detected_top_row==0)
%          detected_top_row=1;
%      end
%      if(detected_bottom_row==0)
%          detected_bottom_row=1;
%      end
%      if(detected_right_col==0)
%          detected_right_col=1;
%      end
%      detected_mask=[];
%      ground_truth_mask=[];
%     
%      
%      detected_mask(1:480,1:640)=0;
%      ground_truth_mask(1:480,1:640)=0;
%      
%      detected_mask(detected_top_row:detected_bottom_row,detected_right_col:detected_left_col)=1;
%      ground_truth_mask(ground_top_row:ground_bottom_row,ground_right_col:ground_left_col)=1;
%      
%      
%      %% E1 Metric = Classification error rate
%      Product_mask=(xor(detected_mask(1:480,1:640),ground_truth_mask(1:480,1:640)));
%         
%      E1_NonMalignant(folder_idx)=nnz(Product_mask);
%      
%      E1_NonMalignant(folder_idx)=E1_NonMalignant(folder_idx)/(480*640);
%      
%      %% E2 Metric = FPR & FNR
%      
%      
%      TP=nnz(and(detected_mask(1:480,1:640),ground_truth_mask(1:480,1:640)));
%      FP=nnz(and(detected_mask(1:480,1:640),not(ground_truth_mask(1:480,1:640))));
%      FN=nnz(and(not(detected_mask(1:480,1:640)),ground_truth_mask(1:480,1:640)));
%      TN=nnz(and(not(detected_mask(1:480,1:640)),not(ground_truth_mask(1:480,1:640))));
%      
%      Total_Positive=nnz(ground_truth_mask(1:480,1:640));
%      Total_Negative=nnz(not(ground_truth_mask(1:480,1:640)));
%      
%      FPR=FP/Total_Negative;
%      FNR=FN/Total_Positive;
%      
%      E2_NonMalig(folder_idx)=(FPR+FNR)/2;
%      
%      
%      %% IOU Metric
%      intersection_top_row=[];
%      intersection_bottom_row=[];
%      intersection_left_col=[];
%      intersection_right_col=[];
%      
%      union_top_row=[];
%      union_bottom_row=[];
%      union_left_col=[];
%      union_right_col=[];
%      
%      if(detected_left_col < ground_left_col)
%          intersection_left_col=detected_left_col;
%          union_left_col=ground_left_col;
%      else
%          intersection_left_col=ground_left_col;
%          union_left_col=detected_left_col;
%      end
%      
%      if(detected_right_col < ground_right_col)
%          intersection_right_col=ground_right_col;
%          union_right_col=detected_right_col;
%      else
%          intersection_right_col=detected_right_col;
%          union_right_col=ground_right_col;
%      end
%      
%      if(detected_top_row > ground_top_row)
%          intersection_top_row=detected_top_row;
%          union_top_row=ground_top_row;
%      else
%          intersection_top_row=ground_top_row;
%          union_top_row=detected_top_row;
%      end
%      
%      if(detected_bottom_row > ground_bottom_row)
%          intersection_bottom_row=ground_bottom_row;
%          union_bottom_row=detected_bottom_row;
%      else
%          intersection_bottom_row=detected_bottom_row;
%          union_bottom_row=ground_bottom_row;
%      end
%      
%      area_intersection=(intersection_bottom_row-intersection_top_row)*(intersection_left_col-intersection_right_col);
%      area_union=(union_bottom_row-union_top_row)*(union_left_col-union_right_col);
%      
%      width_detected=(detected_left_col-detected_right_col);
%      height_detected=(detected_bottom_row-detected_top_row);
%      
%      if(width_detected>0 && height_detected>0)
%         area_detected=height_detected*width_detected;
%         area_ground=(ground_bottom_row-ground_top_row)*(ground_left_col-ground_right_col);
%         Result_ratio_NonMalignant(folder_idx)=(area_intersection)/(area_union);
%         Dice_ratio_NonMalignant(folder_idx)=2*(area_intersection)/(area_detected+area_ground);
%      else
%         Dice_ratio_NonMalignant(folder_idx)=0;
%      end
% end
% Result_ratio_NonMalignant=Result_ratio_NonMalignant.*(Result_ratio_NonMalignant>0);
% Dice_ratio_NonMalignant=Dice_ratio_NonMalignant.*(Dice_ratio_NonMalignant>0);
% 
% 
% IOU_Overall=[Result_ratio_Normal, Result_ratio_NonMalignant, Result_ratio_Malignant];
% E1_Overall=[E1_Malignant, E1_NonMalignant, E1_Normal];
% E2_Overall=[E2_Malignant, E2_NonMalig, E2_Normal];
% Dice_Overall=[Dice_ratio_Malignant, Dice_ratio_NonMalignant, Dice_ratio_Normal];
% 
% mean(IOU_Overall)
% std(IOU_Overall)
% 
% mean(E1_Overall)
% std(E1_Overall)
% 
% mean(E2_Overall)
% std(E2_Overall)
% 
% mean(Dice_Overall)
% std(Dice_Overall)