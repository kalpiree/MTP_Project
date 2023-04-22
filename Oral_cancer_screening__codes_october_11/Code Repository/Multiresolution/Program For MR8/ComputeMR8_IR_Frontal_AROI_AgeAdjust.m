%%
function ComputeMR8_IR_Frontal_AROI(ROS_idx,N_Scale,N_Orientation)

            d = dir('..\..\..\ThermalDatabase\Normal_AgeAdjust');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
for folder_idx=1:no_dir
                disp(nameFolds(folder_idx)); 
                 close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
                I1 = xlsread(['..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);

                 maxval=max(max(I1));
                 minval=min(min(I1));
                 range=1/(maxval-minval);
                 I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


                 [row,col]=size(I1);
            
                 I1 = adapthisteq((I1),'ClipLimit',0.05);

            
            %-------------------------------------------------loading Ground Truth facial mask-------------------------------------------------------------------------------------------%

                folder_name=['..\..\..\ThermalDatabase\Normal_AgeAdjust\', nameFolds{folder_idx}, '\A_ROI_Front_' nameFolds{folder_idx}];

                cd(folder_name);
                load('A_ROI_Front.mat');
              
               mask_F_normal_lt(1:row,1:col)=0;
               col_mask=size(mask_F_normal_lt,2)-size(A_ROI_L,2);
               mask_F_normal_lt(:,col_mask+1:size(mask_F_normal_lt,2))=A_ROI_L;


               mask_F_normal_rt(1:row,1:col)=0;
               mask_F_normal_rt(:,1:size(A_ROI_R,2))=A_ROI_R;
            

            %-------------------------------------------------loading Automated facial mask-------------------------------------------------------------------------------------------%



                 cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

                AROI_MR8_F_normal_lt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(A_ROI_L),ROS_idx,N_Scale,N_Orientation);
               AROI_MR8_F_normal_rt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(A_ROI_R),ROS_idx,N_Scale,N_Orientation);




              rel_path=['..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx}];
              cd(rel_path);
              folder_name=['AgeAdjust_AROI_MR8_Normal_Front_' nameFolds{folder_idx}];

                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                  
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
                save('AgeAdjust_AROI_MR8_Normal_Front','AROI_MR8_F_normal_lt','AROI_MR8_F_normal_rt');
            
             cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

 end

            d = dir('..\..\..\ThermalDatabase\Malignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;

            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);


            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


            [row,col]=size(I1);
            
            I1 = adapthisteq((I1),'ClipLimit',0.05);

            %-------------------------------------------------loading Manual facial mask-------------------------------------------------------------------------------------------%

            folder_name=['..\..\..\ThermalDatabase\Malignant\', nameFolds{folder_idx}, '\A_ROI_Front_' nameFolds{folder_idx}];

            cd(folder_name);
            load('A_ROI_Front.mat');
            mask_F_malignant_lt(1:row,1:col)=0;
            col_mask=size(mask_F_malignant_lt,2)-size(A_ROI_L,2);
            mask_F_malignant_lt(:,col_mask+1:size(mask_F_malignant_lt,2))=A_ROI_L;


            mask_F_malignant_rt(1:row,1:col)=0;
            mask_F_malignant_rt(:,1:size(A_ROI_R,2))=A_ROI_R;

            %-------------------------------------------------loading Automated facial mask-------------------------------------------------------------------------------------------%
            

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            


             cd '..\..\..\..\code repository\Multiresolution\Program For MR8';


             AROI_MR8_F_malignant_lt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(A_ROI_L),ROS_idx,N_Scale,N_Orientation);
             AROI_MR8_F_malignant_rt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(A_ROI_R),ROS_idx,N_Scale,N_Orientation);


            rel_path=['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AgeAdjust_AROI_MR8_Malignant_Front_' nameFolds{folder_idx}];
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AgeAdjust_AROI_MR8_Malignant_Front','AROI_MR8_F_malignant_lt','AROI_MR8_F_malignant_rt');

             cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

end     

             d = dir('..\..\..\ThermalDatabase\NonMalignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);

            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


            [row,col]=size(I1);
            
            I1 = adapthisteq((I1),'ClipLimit',0.05);
            

%             %-------------------------------------------------loading facial mask-------------------------------------------------------------------------------------------%
% 
            folder_name=['..\..\..\ThermalDatabase\NonMalignant\', nameFolds{folder_idx}, '\A_ROI_Front_' nameFolds{folder_idx}];

            cd(folder_name);
            load('A_ROI_Front.mat');
            mask_F_precancer_lt(1:row,1:col)=0;
            col_mask=size(mask_F_precancer_lt,2)-size(A_ROI_L,2);
            mask_F_precancer_lt(:,col_mask+1:size(mask_F_precancer_lt,2))=A_ROI_L;


            mask_F_precancer_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
            mask_F_precancer_rt(:,1:size(A_ROI_R,2))=A_ROI_R;

             %-------------------------------------------------loading Automated facial mask-------------------------------------------------------------------------------------------%
%             

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

             cd '..\..\..\..\code repository\Multiresolution\Program For MR8';
% 
%          
            
             AROI_MR8_F_precancer_lt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(A_ROI_L),ROS_idx,N_Scale,N_Orientation);
             AROI_MR8_F_precancer_rt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(A_ROI_R),ROS_idx,N_Scale,N_Orientation);
%   
            rel_path=['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AgeAdjust_AROI_MR8_precancer_Front_' nameFolds{folder_idx}];
          
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AgeAdjust_AROI_MR8_Precancer_Front','AROI_MR8_F_precancer_lt','AROI_MR8_F_precancer_rt');

             cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

end     

end