% =========================== ComputeMR8_IR_Profile_GT_AgeAdjust.m ====================================== %
% Description  : 
% 
% ================================================================================== %
% Input Parameters :
%                    ROS_idx:
%                   N_Scale: 
%              N_Orientation:
%------------------------------------------------------------------------------------%  
% Output parameter: 
%                  AgeAdjust_GT_MR8_Normal_Profile
%                   GT_MR8_F_normal_lt 
%                   GT_MR8_F_normal_rt
%               AgeAdjust_GT_MR8_Precancer_Profile 
%                  GT_MR8_F_precancer_lt 
%                  GT_MR8_F_precancer_rt
%               AgeAdjust_GT_MR8_Malignant_Profile 
%                   GT_MR8_F_malignant_lt
%                   GT_MR8_F_malignant_rt
%                    
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1: TexturalFeatureExtraction_IGMGD_MR8.m
%  
% Called by :  kernelsize_select_1.m
%------------------------------------------------------------------------------------%
% Reference:    
%
%[1] %%%%
%
%
% Author of the code:  Manashi Chakraborty  
% Date of creation :   
% ------------------------------------------------------------------------------------------------------- %
% Modified on :  
% Modification details:    
% Modified By :   Manashi Chakraborty
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %



%%
function ComputeMR8_IR_Profile_GT_AgeAdjust(ROS_idx,N_Scale,N_Orientation)

            d = dir('..\..\..\ThermalDatabase\Normal_AgeAdjust');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
for folder_idx=1:no_dir
                disp(nameFolds(folder_idx)); 
                 close all;
            %----------------------------------------------------Read lt and rt img-------------------------------------------------------------------------------------------%
                I1_lt = xlsread(['..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
                
                %%%%%%%%%%%%%%
                
                [~, computer] = system('hostname');
                [~, user] = system('whoami');
                [~, alltask] = system(['tasklist /S ', computer, ' /U ', user]);
                excelPID = regexp(alltask, 'EXCEL.EXE\s*(\d+)\s', 'tokens');
                for i = 1 : length(excelPID)
                         killPID = cell2mat(excelPID{i});
                         system(['taskkill /f /pid ', killPID]);
                end
                
                %%%%%%%%%%%%%%
                
                 maxval_lt=max(max(I1_lt));
                 minval_lt=min(min(I1_lt));
                 range_lt=1/(maxval_lt-minval_lt);
                 I1_lt=range_lt.*(I1_lt-minval_lt); %bringing the image to a scale of floating point 0.0-1.0


                 [row_lt,col_lt]=size(I1_lt);
            
                 I1_lt = adapthisteq((I1_lt),'ClipLimit',0.05);
                 
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                I1_rt = xlsread(['..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
                %%%%%%%%%%%%%%
                
                [~, computer] = system('hostname');
                [~, user] = system('whoami');
                [~, alltask] = system(['tasklist /S ', computer, ' /U ', user]);
                excelPID = regexp(alltask, 'EXCEL.EXE\s*(\d+)\s', 'tokens');
                for i = 1 : length(excelPID)
                         killPID = cell2mat(excelPID{i});
                         system(['taskkill /f /pid ', killPID]);
                end
                
                %%%%%%%%%%%%%%
                 maxval_rt=max(max(I1_rt));
                 minval_rt=min(min(I1_rt));
                 range_rt=1/(maxval_rt-minval_rt);
                 I1_rt=range_rt.*(I1_rt-minval_rt); %bringing the image to a scale of floating point 0.0-1.0
                 [row_rt,col_rt]=size(I1_rt);
                 I1_rt = adapthisteq((I1_rt),'ClipLimit',0.05);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                
        
            
            %-------------------------------------------------loading Ground Truth facial mask-------------------------------------------------------------------------------------------%

                folder_name=['..\..\..\ThermalDatabase\Normal_AgeAdjust\', nameFolds{folder_idx}, '\Profile_ROI_' nameFolds{folder_idx}];

                cd(folder_name);
                load('Face_Mask.mat');
              
               mask_P_normal_lt(1:row_lt,1:col_lt)=0;
               col_mask=size(mask_P_normal_lt,2)-size(img_face_lt,2);
               mask_P_normal_lt(:,col_mask+1:size(mask_P_normal_lt,2))=img_face_lt;


               mask_P_normal_rt(1:row_lt,1:col_lt)=0;
               mask_P_normal_rt(:,1:size(img_face_rt,2))=img_face_rt;
            


         
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

               GT_MR8_F_normal_lt = TexturalFeatureExtraction_IGMGD_MR8(I1_lt,logical(mask_P_normal_lt),ROS_idx,N_Scale,N_Orientation);
               GT_MR8_F_normal_rt = TexturalFeatureExtraction_IGMGD_MR8(I1_rt,logical(mask_P_normal_rt),ROS_idx,N_Scale,N_Orientation);
             



              rel_path=['..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx}];
              cd(rel_path);
              folder_name=['AgeAdjust_GT_MR8_Normal_Profile_' nameFolds{folder_idx}];

                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    cd(rel_path);
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
                save('AgeAdjust_GT_MR8_Normal_Profile','GT_MR8_F_normal_lt','GT_MR8_F_normal_rt');
            
            cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

 end
%     case  'Malignant Subjects'  

            d = dir('..\..\..\ThermalDatabase\Malignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1_lt = xlsread(['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
               %%%%%%%%%%%%%%
                
                [~, computer] = system('hostname');
                [~, user] = system('whoami');
                [~, alltask] = system(['tasklist /S ', computer, ' /U ', user]);
                excelPID = regexp(alltask, 'EXCEL.EXE\s*(\d+)\s', 'tokens');
                for i = 1 : length(excelPID)
                         killPID = cell2mat(excelPID{i});
                         system(['taskkill /f /pid ', killPID]);
                end
                
                %%%%%%%%%%%%%%
            maxval_lt=max(max(I1_lt));
            minval_lt=min(min(I1_lt));
            range_lt=1/(maxval_lt-minval_lt);
            I1_lt=range_lt.*(I1_lt-minval_lt); %bringing the image to a scale of floating point 0.0-1.0


            [row_lt,col_lt]=size(I1_lt);
            
            I1_lt = adapthisteq((I1_lt),'ClipLimit',0.05);
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                I1_rt = xlsread(['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
                 %%%%%%%%%%%%%%
                
                [~, computer] = system('hostname');
                [~, user] = system('whoami');
                [~, alltask] = system(['tasklist /S ', computer, ' /U ', user]);
                excelPID = regexp(alltask, 'EXCEL.EXE\s*(\d+)\s', 'tokens');
                for i = 1 : length(excelPID)
                         killPID = cell2mat(excelPID{i});
                         system(['taskkill /f /pid ', killPID]);
                end
                
                %%%%%%%%%%%%%%
                 maxval_rt=max(max(I1_rt));
                 minval_rt=min(min(I1_rt));
                 range_rt=1/(maxval_rt-minval_rt);
                 I1_rt=range_rt.*(I1_rt-minval_rt); %bringing the image to a scale of floating point 0.0-1.0
                 [row_rt,col_rt]=size(I1_rt);
                 I1_rt = adapthisteq((I1_rt),'ClipLimit',0.05);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

            %-------------------------------------------------loading Manual facial mask-------------------------------------------------------------------------------------------%

            folder_name=['..\..\..\ThermalDatabase\Malignant\', nameFolds{folder_idx}, '\Profile_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('Face_Mask.mat');
            mask_P_malignant_lt(1:row_lt,1:col_lt)=0;
            col_mask=size(mask_P_malignant_lt,2)-size(img_face_lt,2);
            mask_P_malignant_lt(:,col_mask+1:size(mask_P_malignant_lt,2))=img_face_lt;


            mask_P_malignant_rt(1:row_lt,1:col_lt)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
            mask_P_malignant_rt(:,1:size(img_face_rt,2))=img_face_rt;
            

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            


            cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

            GT_MR8_F_malignant_lt = TexturalFeatureExtraction_IGMGD_MR8(I1_lt,logical(mask_P_malignant_lt),ROS_idx,N_Scale,N_Orientation);
            GT_MR8_F_malignant_rt = TexturalFeatureExtraction_IGMGD_MR8(I1_rt,logical(mask_P_malignant_rt),ROS_idx,N_Scale,N_Orientation);



            rel_path=['..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AgeAdjust_GT_MR8_Malignant_Profile_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AgeAdjust_GT_MR8_Malignant_Profile','GT_MR8_F_malignant_lt','GT_MR8_F_malignant_rt');

            cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

end     
%         case  'Precancerous Subjects'  

             d = dir('..\..\..\ThermalDatabase\NonMalignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1_lt = xlsread(['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_lt.csv']);
             %%%%%%%%%%%%%%
                
                [~, computer] = system('hostname');
                [~, user] = system('whoami');
                [~, alltask] = system(['tasklist /S ', computer, ' /U ', user]);
                excelPID = regexp(alltask, 'EXCEL.EXE\s*(\d+)\s', 'tokens');
                for i = 1 : length(excelPID)
                         killPID = cell2mat(excelPID{i});
                         system(['taskkill /f /pid ', killPID]);
                end
                
                %%%%%%%%%%%%%%
            maxval_lt=max(max(I1_lt));
            minval_lt=min(min(I1_lt));
            range_lt=1/(maxval_lt-minval_lt);
            I1_lt=range_lt.*(I1_lt-minval_lt); %bringing the image to a scale of floating point 0.0-1.0


            [row_lt,col_lt]=size(I1_lt);
            
            I1_lt = adapthisteq((I1_lt),'ClipLimit',0.05);
            
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                I1_rt = xlsread(['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'_rt.csv']);
                %%%%%%%%%%%%%%
                
                [~, computer] = system('hostname');
                [~, user] = system('whoami');
                [~, alltask] = system(['tasklist /S ', computer, ' /U ', user]);
                excelPID = regexp(alltask, 'EXCEL.EXE\s*(\d+)\s', 'tokens');
                for i = 1 : length(excelPID)
                         killPID = cell2mat(excelPID{i});
                         system(['taskkill /f /pid ', killPID]);
                end
                
                %%%%%%%%%%%%%%
                 maxval_rt=max(max(I1_rt));
                 minval_rt=min(min(I1_rt));
                 range_rt=1/(maxval_rt-minval_rt);
                 I1_rt=range_rt.*(I1_rt-minval_rt); %bringing the image to a scale of floating point 0.0-1.0
                 [row_rt,col_rt]=size(I1_rt);
                 I1_rt = adapthisteq((I1_rt),'ClipLimit',0.05);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            

%             %-------------------------------------------------loading facial mask-------------------------------------------------------------------------------------------%
% 
            folder_name=['..\..\..\ThermalDatabase\NonMalignant\', nameFolds{folder_idx}, '\Profile_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('Face_Mask.mat');
            mask_P_precancer_lt(1:row_lt,1:col_lt)=0;
            col_mask=size(mask_P_precancer_lt,2)-size(img_face_lt,2);
            mask_P_precancer_lt(:,col_mask+1:size(mask_P_precancer_lt,2))=img_face_lt;


            mask_P_precancer_rt(1:row_lt,1:col_lt)=0;
            mask_P_precancer_rt(:,1:size(img_face_rt,2))=img_face_rt;


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

            GT_MR8_F_precancer_lt = TexturalFeatureExtraction_IGMGD_MR8(I1_lt,logical(mask_P_precancer_lt),ROS_idx,N_Scale,N_Orientation);
            GT_MR8_F_precancer_rt = TexturalFeatureExtraction_IGMGD_MR8(I1_rt,logical(mask_P_precancer_rt),ROS_idx,N_Scale,N_Orientation);
 

            rel_path=['..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AgeAdjust_GT_MR8_precancer_Profile_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AgeAdjust_GT_MR8_Precancer_Profile','GT_MR8_F_precancer_lt','GT_MR8_F_precancer_rt');

            cd '..\..\..\..\code repository\Multiresolution\Program For MR8';

end     

end