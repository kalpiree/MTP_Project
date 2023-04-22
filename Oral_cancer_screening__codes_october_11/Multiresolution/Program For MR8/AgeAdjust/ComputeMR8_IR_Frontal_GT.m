% =========================== ComputeMR8_IR_Frontal_GT.m ====================================== %
% Description  : 
% 
% ================================================================================== %
% Input Parameters :
%                    ROS_idx:
%                    N_Scale: 
%              N_Orientation:
%------------------------------------------------------------------------------------%  
% Output parameter: 
%                AgeAdjust_GT_MR8_Normal_Front 
%                   GT_MR8_F_normal_lt
%                   GT_MR8_F_normal_rt 
%                 AgeAdjust_GT_MR8_Precancer_Front 
%                   GT_MR8_F_precancer_lt 
%                   GT_MR8_F_precancer_rt 
%                 AgeAdjust_GT_MR8_Malignant_Front
%                   GT_MR8_F_malignant_lt
%                   GT_MR8_F_malignant_rt
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
function ComputeMR8_IR_Frontal_GT(ROS_idx,N_Scale,N_Orientation)
% clear;
% clc;
% close all;
% choice=choosedialog
% switch(choice)
%    case 'Normal Subjects' 
            d = dir('..\..\..\..\ThermalDatabase\Normal_AgeAdjust');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
for folder_idx=1:no_dir
                disp(nameFolds(folder_idx)); 
                 close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
                I1 = xlsread(['..\..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx},'\Jpeg\',nameFolds{folder_idx},'.csv']);
%             I1 = adapthisteq(I1);
%             [row col]=size(I1);
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=255/(maxval-minval);
%             I1=range.*(I1-minval);
%             figure, imshow(I1,[]);

                 maxval=max(max(I1));
                 minval=min(min(I1));
                 range=1/(maxval-minval);
                 I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


                 [row,col]=size(I1);
            
                 I1 = adapthisteq((I1),'ClipLimit',0.05);
            
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=1/(maxval-minval);
%             I1=range.*(I1-minval);
            
            %-------------------------------------------------loading Ground Truth facial mask-------------------------------------------------------------------------------------------%

                folder_name=['..\..\..\..\ThermalDatabase\Normal_AgeAdjust\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

                cd(folder_name);
                load('Face_Mask.mat');
              
               mask_F_normal_lt(1:row,1:col)=0;
               col_mask=size(mask_F_normal_lt,2)-size(img_face_lt,2);
               mask_F_normal_lt(:,col_mask+1:size(mask_F_normal_lt,2))=img_face_lt;


               mask_F_normal_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
               mask_F_normal_rt(:,1:size(img_face_rt,2))=img_face_rt;
            
%              figure, imshow(I1,[]);
%            figure, imshow(mask_F_normal_lt);
%            figure, imshow(mask_F_normal_rt);

            %-------------------------------------------------loading Automated facial mask-------------------------------------------------------------------------------------------%
%             
%             folder_name=['..\..\..\ThermalDatabase_OOC\Normal\', nameFolds{folder_idx}, '\A_ROI_Front_' nameFolds{folder_idx}];
% 
%             cd(folder_name);
%             load('A_ROI_Front.mat');
%             
%             mask_F_normal_lt(1:row,1:col)=0;
%             col_mask=size(mask_F_normal_lt,2)-size(A_ROI_L,2);
%             mask_F_normal_lt(:,col_mask+1:size(mask_F_normal_lt,2))=A_ROI_L;
% 
%             mask_F_normal_rt(1:row,1:col)=0;
%             % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
%             mask_F_normal_rt(:,1:size(A_ROI_R,2))=A_ROI_R;
%             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                cd '..\..\..\..\code repository\Multiresolution\Program For MR8\AgeAdjust';

               GT_MR8_F_normal_lt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_normal_lt),ROS_idx,N_Scale,N_Orientation);
               GT_MR8_F_normal_rt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_normal_rt),ROS_idx,N_Scale,N_Orientation);
%              R1=1; P1=8; R2=3; P2=8;
%              mapping=getmapnew(P1,'u2');
%               MR8_F_normal_lt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_lt),I1,R1,P1, R2, P2, mapping );
%              MR8_F_normal_rt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_rt),I1, R1,P1, R2, P2, mapping);




              rel_path=['..\..\..\..\ThermalDatabase\Normal_AgeAdjust\',nameFolds{folder_idx}];
              cd(rel_path);
              folder_name=['AgeAdjust_GT_MR8_Normal_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
%                 if ~exist(folder_name)
%                     mkdir(folder_name);
%                     cd(folder_name);
%                 else
%                     cd(folder_name);
%                 end
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
                save('AgeAdjust_GT_MR8_Normal_Front','GT_MR8_F_normal_lt','GT_MR8_F_normal_rt');
            
            cd '..\..\..\..\code repository\Multiresolution\Program For MR8\AgeAdjust';

 end
%     case  'Malignant Subjects'  

            d = dir('..\..\..\..\ThermalDatabase\Malignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%             I1 = adapthisteq(I1);

%             [row,col]=size(I1);
% 
%             [row col]=size(I1);
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=255/(maxval-minval);
%             I1=range.*(I1-minval);
% %             figure, imshow(I1,[]);

            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


            [row,col]=size(I1);
            
            I1 = adapthisteq((I1),'ClipLimit',0.05);
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=1/(maxval-minval);
%             I1=range.*(I1-minval);
            %-------------------------------------------------loading Manual facial mask-------------------------------------------------------------------------------------------%

            folder_name=['..\..\..\..\ThermalDatabase\Malignant\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('Face_Mask.mat');
            mask_F_malignant_lt(1:row,1:col)=0;
            col_mask=size(mask_F_malignant_lt,2)-size(img_face_lt,2);
            mask_F_malignant_lt(:,col_mask+1:size(mask_F_malignant_lt,2))=img_face_lt;


            mask_F_malignant_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
            mask_F_malignant_rt(:,1:size(img_face_rt,2))=img_face_rt;
            
%             figure, imshow(I1,[]);
%            figure, imshow(mask_F_malignant_lt);
%            figure, imshow(mask_F_malignant_rt)
            %-------------------------------------------------loading Automated facial mask-------------------------------------------------------------------------------------------%
            
%             folder_name=['..\..\..\ThermalDatabase_OOC\Malignant\', nameFolds{folder_idx}, '\A_ROI_Front_' nameFolds{folder_idx}];
% 
%             cd(folder_name);
%             load('A_ROI_Front.mat');
%             
%             mask_F_malignant_lt(1:row,1:col)=0;
%             col_mask=size(mask_F_malignant_lt,2)-size(A_ROI_L,2);
%             mask_F_malignant_lt(:,col_mask+1:size(mask_F_malignant_lt,2))=A_ROI_L;
% 
%             mask_F_malignant_rt(1:row,1:col)=0;
%             % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
%             mask_F_malignant_rt(:,1:size(A_ROI_R,2))=A_ROI_R;
%             
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            
            


            cd '..\..\..\..\code repository\Multiresolution\Program For MR8\AgeAdjust';

            GT_MR8_F_malignant_lt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_malignant_lt),ROS_idx,N_Scale,N_Orientation);
            GT_MR8_F_malignant_rt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_malignant_rt),ROS_idx,N_Scale,N_Orientation);

%             R1=1; P1=8; R2=3; P2=8;
%              mapping=getmapnew(P1,'u2');
%               MR8_F_normal_lt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_lt),I1,R1,P1, R2, P2, mapping );
%              MR8_F_normal_rt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_rt),I1, R1,P1, R2, P2, mapping);


            rel_path=['..\..\..\..\ThermalDatabase\Malignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AgeAdjust_GT_MR8_Malignant_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AgeAdjust_GT_MR8_Malignant_Front','GT_MR8_F_malignant_lt','GT_MR8_F_malignant_rt');

            cd '..\..\..\..\code repository\Multiresolution\Program For MR8\AgeAdjust';

end     
%         case  'Precancerous Subjects'  

             d = dir('..\..\..\..\ThermalDatabase\NonMalignant');
           
            isub = [d(:).isdir]; %# returns logical vector
            nameFolds = {d(isub).name}';
            nameFolds=nameFolds(3:end);
            no_dir=numel(nameFolds);
for folder_idx=1:no_dir
            disp(nameFolds(folder_idx)); 
            close all;
            %----------------------------------------------------Read Frontal img-------------------------------------------------------------------------------------------%
            I1 = xlsread(['..\..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%             I1 = adapthisteq(I1);

%             [row,col]=size(I1);
% 
%             [row col]=size(I1);
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=255/(maxval-minval);
%             I1=range.*(I1-minval);
%             figure, imshow(I1,[]);
% 
            maxval=max(max(I1));
            minval=min(min(I1));
            range=1/(maxval-minval);
            I1=range.*(I1-minval); %bringing the image to a scale of floating point 0.0-1.0


            [row,col]=size(I1);
            
            I1 = adapthisteq((I1),'ClipLimit',0.05);
            
%             maxval=max(max(I1));
%             minval=min(min(I1));
%             range=1/(maxval-minval);
%             I1=range.*(I1-minval);
%             %-------------------------------------------------loading facial mask-------------------------------------------------------------------------------------------%
% 
            folder_name=['..\..\..\..\ThermalDatabase\NonMalignant\', nameFolds{folder_idx}, '\Front_ROI_' nameFolds{folder_idx}];

            cd(folder_name);
            load('Face_Mask.mat');
            mask_F_precancer_lt(1:row,1:col)=0;
            col_mask=size(mask_F_precancer_lt,2)-size(img_face_lt,2);
            mask_F_precancer_lt(:,col_mask+1:size(mask_F_precancer_lt,2))=img_face_lt;


            mask_F_precancer_rt(1:row,1:col)=0;
            % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
            mask_F_precancer_rt(:,1:size(img_face_rt,2))=img_face_rt;
%              figure, imshow(I1,[]);
%            figure, imshow(mask_F_precancer_lt);
%            figure, imshow(mask_F_precancer_rt);

             %-------------------------------------------------loading Automated facial mask-------------------------------------------------------------------------------------------%
%             
%             folder_name=['..\..\..\ThermalDatabase_OOC\NonMalignant\', nameFolds{folder_idx}, '\A_ROI_Front_' nameFolds{folder_idx}];
% 
%             cd(folder_name);
%             load('A_ROI_Front.mat');
%             
%             mask_F_precancer_lt(1:row,1:col)=0;
%             col_mask=size(mask_F_precancer_lt,2)-size(A_ROI_L,2);
%             mask_F_precancer_lt(:,col_mask+1:size(mask_F_precancer_lt,2))=A_ROI_L;
% 
%             mask_F_precancer_rt(1:row,1:col)=0;
%             % col_mask=size(mask_F_normal_rt,2)-size(img_face_rt,2)
%             mask_F_precancer_rt(:,1:size(A_ROI_R,2))=A_ROI_R;
%             
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            cd '..\..\..\..\code repository\Multiresolution\Program For MR8\AgeAdjust';

            GT_MR8_F_precancer_lt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_precancer_lt),ROS_idx,N_Scale,N_Orientation);
            GT_MR8_F_precancer_rt = TexturalFeatureExtraction_IGMGD_MR8(I1,logical(mask_F_precancer_rt),ROS_idx,N_Scale,N_Orientation);
            
%             R1=1; P1=8; R2=3; P2=8;
%              mapping=getmapnew(P1,'u2');
%              MR8_F_normal_lt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_lt),I1,R1,P1, R2, P2, mapping );
%              MR8_F_normal_rt = FeatureLBPHF_S_M_IGMGD(logical(mask_F_normal_rt),I1, R1,P1, R2, P2, mapping);

            rel_path=['..\..\..\..\ThermalDatabase\NonMalignant\',nameFolds{folder_idx}];
            cd(rel_path);
            folder_name=['AgeAdjust_GT_MR8_precancer_Front_' nameFolds{folder_idx}];
            % rmdir(folder_name);
                if ~exist(folder_name)
                    mkdir(folder_name);
                    cd(folder_name);
                else
                    rmdir(folder_name,'s');
                    mkdir(folder_name);
                    cd(folder_name);
                end
               save('AgeAdjust_GT_MR8_Precancer_Front','GT_MR8_F_precancer_lt','GT_MR8_F_precancer_rt');

            cd '..\..\..\..\code repository\Multiresolution\Program For MR8\AgeAdjust';

end     
%  otherwise
%       fprintf('Invalid operation\n' );
% end
end