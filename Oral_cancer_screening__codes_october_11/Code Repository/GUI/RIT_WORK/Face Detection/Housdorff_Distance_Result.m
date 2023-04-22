%% Main Code for Face Detection
close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
d = dir('D:\Work\ThermalOOC_Manashi\Normal'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%
% Result_ratio_Malig=[];
for folder_idx=1:no_dir
 %% Normal  
    direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
%     direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
%     direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
%     direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
%     direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];

  Save_Direc=['D:\Work\ThermalOOC_Manashi\Normal\',nameFolds{folder_idx},'\','Jpeg','\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];

%%

     load(direc);

     load(Save_Direc);
     
     detected_left_col=lt_boundary_col;
     detected_top_row=upper_boundary_row;
     detected_bottom_row=lower_boundary_row;
     detected_right_col=rt_boundary_col;
     
%%
detected_boundary_points=[];
ground_boundary_points=[];
detected_counter=1;
for col_index=detected_right_col:detected_left_col
    detected_boundary_points(detected_counter,1)=detected_top_row;
    detected_boundary_points(detected_counter,2)=col_index;
    detected_counter=detected_counter+1;
end
for col_index=detected_right_col+1:detected_left_col
    detected_boundary_points(detected_counter,1)=detected_bottom_row;
    detected_boundary_points(detected_counter,2)=col_index;
    detected_counter=detected_counter+1;
end
for row_index=detected_top_row+1:detected_bottom_row
    detected_boundary_points(detected_counter,1)=row_index;
    detected_boundary_points(detected_counter,2)=detected_right_col;
    detected_counter=detected_counter+1;
end
for row_index=detected_top_row+1:detected_bottom_row
    detected_boundary_points(detected_counter,1)=row_index;
    detected_boundary_points(detected_counter,2)=detected_left_col;
    detected_counter=detected_counter+1;
end

ground_counter=1;
for col_index=ground_right_col:ground_left_col
    ground_boundary_points(ground_counter,1)=ground_top_row;
    ground_boundary_points(ground_counter,2)=col_index;
    ground_counter=ground_counter+1;
end
for col_index=ground_right_col+1:ground_left_col
    ground_boundary_points(ground_counter,1)=ground_bottom_row;
    ground_boundary_points(ground_counter,2)=col_index;
    ground_counter=ground_counter+1;
end
for row_index=ground_top_row+1:ground_bottom_row
    ground_boundary_points(ground_counter,1)=row_index;
    ground_boundary_points(ground_counter,2)=detected_right_col;
    ground_counter=ground_counter+1;
end
for row_index=ground_top_row+1:ground_bottom_row
    ground_boundary_points(ground_counter,1)=row_index;
    ground_boundary_points(ground_counter,2)=detected_left_col;
    ground_counter=ground_counter+1;
end

    P=detected_boundary_points;
    Q=ground_boundary_points;
    sP = size(P);
    sQ = size(Q);
    d=zeros(1,sQ(1));
    dmin=zeros(1,sP(1));
    for i=1:sP(1)
        for j=1:sQ(1)
            d(1,j)=sqrt((P(i,1)-Q(j,1))^2+(P(i,2)-Q(j,2))^2);
        end
        dmin(1,i)=min(d);
    end
    HD_max1=max(dmin);
    MHD_1=mean(dmin);
    
    d1=zeros(1,sP(1));
    dmin1=zeros(1,sQ(1));
    for i=1:sQ(1)
        for j=1:sP(1)
            d1(1,j)=sqrt((P(j,1)-Q(i,1))^2+(P(j,2)-Q(i,2))^2);
        end
        dmin1(1,i)=min(d1);
    end
    
    HD_max2=max(dmin1);
    MHD_2=mean(dmin1);
    Hausdorff_distance_Normal(folder_idx)=max(HD_max2,HD_max1);
    Modified_Hausdorff_Normal(folder_idx)=max(MHD_1,MHD_2);
end 
% 

%% MALIGNANT
%% Fetch the Index Numbers of the Malignant Patients
d = dir('D:\Work\ThermalOOC_Manashi\Malignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir
% %% Malignant
   direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
%    direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
%    direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
%    direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
%    direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];

Save_Direc=['D:\Work\ThermalOOC_Manashi\Malignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];

%%

     load(direc);

     load(Save_Direc);
     
     detected_left_col=lt_boundary_col;
     detected_top_row=upper_boundary_row;
     detected_bottom_row=lower_boundary_row;
     detected_right_col=rt_boundary_col;
     
%%
detected_boundary_points=[];
ground_boundary_points=[];
detected_counter=1;
for col_index=detected_right_col:detected_left_col
    detected_boundary_points(detected_counter,1)=detected_top_row;
    detected_boundary_points(detected_counter,2)=col_index;
    detected_counter=detected_counter+1;
end
for col_index=detected_right_col+1:detected_left_col
    detected_boundary_points(detected_counter,1)=detected_bottom_row;
    detected_boundary_points(detected_counter,2)=col_index;
    detected_counter=detected_counter+1;
end
for row_index=detected_top_row+1:detected_bottom_row
    detected_boundary_points(detected_counter,1)=row_index;
    detected_boundary_points(detected_counter,2)=detected_right_col;
    detected_counter=detected_counter+1;
end
for row_index=detected_top_row+1:detected_bottom_row
    detected_boundary_points(detected_counter,1)=row_index;
    detected_boundary_points(detected_counter,2)=detected_left_col;
    detected_counter=detected_counter+1;
end

ground_counter=1;
for col_index=ground_right_col:ground_left_col
    ground_boundary_points(ground_counter,1)=ground_top_row;
    ground_boundary_points(ground_counter,2)=col_index;
    ground_counter=ground_counter+1;
end
for col_index=ground_right_col+1:ground_left_col
    ground_boundary_points(ground_counter,1)=ground_bottom_row;
    ground_boundary_points(ground_counter,2)=col_index;
    ground_counter=ground_counter+1;
end
for row_index=ground_top_row+1:ground_bottom_row
    ground_boundary_points(ground_counter,1)=row_index;
    ground_boundary_points(ground_counter,2)=detected_right_col;
    ground_counter=ground_counter+1;
end
for row_index=ground_top_row+1:ground_bottom_row
    ground_boundary_points(ground_counter,1)=row_index;
    ground_boundary_points(ground_counter,2)=detected_left_col;
    ground_counter=ground_counter+1;
end

    P=detected_boundary_points;
    Q=ground_boundary_points;
    sP = size(P);
    sQ = size(Q);
    d=zeros(1,sQ(1));
    dmin=zeros(1,sP(1));
    for i=1:sP(1)
        for j=1:sQ(1)
            d(1,j)=sqrt((P(i,1)-Q(j,1))^2+(P(i,2)-Q(j,2))^2);
        end
        dmin(1,i)=min(d);
    end
    HD_max1=max(dmin);
    MHD_1=mean(dmin);
    
    d1=zeros(1,sP(1));
    dmin1=zeros(1,sQ(1));
    for i=1:sQ(1)
        for j=1:sP(1)
            d1(1,j)=sqrt((P(j,1)-Q(i,1))^2+(P(j,2)-Q(i,2))^2);
        end
        dmin1(1,i)=min(d1);
    end
    
    HD_max2=max(dmin1);
    MHD_2=mean(dmin1);
    Hausdorff_distance_Malignant(folder_idx)=max(HD_max2,HD_max1);
    Modified_Hausdorff_Malignant(folder_idx)=max(MHD_1,MHD_2);
end 

clear all
%% NonMalignant
%% Fetch the Index Numbers of the Malignant Patients
d = dir('D:\Work\ThermalOOC_Manashi\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);

for folder_idx=1:no_dir
%% Non-Malignant

   direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Detected_PR_Otsu',nameFolds{folder_idx},'.mat'];
%    direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Detected_Face_F_Borders_',nameFolds{folder_idx},'.mat'];
%    direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Detected_SPIE_Paper_F_',nameFolds{folder_idx},'.mat'];
%    direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Boundary_F_',nameFolds{folder_idx},'.mat'];
%    direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Viola_Jones_Optical_Boundary_F_',nameFolds{folder_idx},'.mat'];

Save_Direc=['D:\Work\ThermalOOC_Manashi\NonMalignant\',nameFolds{folder_idx},'\','Ground_Truth_F_Borders_',nameFolds{folder_idx},'.mat'];
%%

     load(direc);

     load(Save_Direc);
     
     detected_left_col=lt_boundary_col;
     detected_top_row=upper_boundary_row;
     detected_bottom_row=lower_boundary_row;
     detected_right_col=rt_boundary_col;
     
%%
detected_boundary_points=[];
ground_boundary_points=[];
detected_counter=1;
for col_index=detected_right_col:detected_left_col
    detected_boundary_points(detected_counter,1)=detected_top_row;
    detected_boundary_points(detected_counter,2)=col_index;
    detected_counter=detected_counter+1;
end
for col_index=detected_right_col+1:detected_left_col
    detected_boundary_points(detected_counter,1)=detected_bottom_row;
    detected_boundary_points(detected_counter,2)=col_index;
    detected_counter=detected_counter+1;
end
for row_index=detected_top_row+1:detected_bottom_row
    detected_boundary_points(detected_counter,1)=row_index;
    detected_boundary_points(detected_counter,2)=detected_right_col;
    detected_counter=detected_counter+1;
end
for row_index=detected_top_row+1:detected_bottom_row
    detected_boundary_points(detected_counter,1)=row_index;
    detected_boundary_points(detected_counter,2)=detected_left_col;
    detected_counter=detected_counter+1;
end

ground_counter=1;
for col_index=ground_right_col:ground_left_col
    ground_boundary_points(ground_counter,1)=ground_top_row;
    ground_boundary_points(ground_counter,2)=col_index;
    ground_counter=ground_counter+1;
end
for col_index=ground_right_col+1:ground_left_col
    ground_boundary_points(ground_counter,1)=ground_bottom_row;
    ground_boundary_points(ground_counter,2)=col_index;
    ground_counter=ground_counter+1;
end
for row_index=ground_top_row+1:ground_bottom_row
    ground_boundary_points(ground_counter,1)=row_index;
    ground_boundary_points(ground_counter,2)=detected_right_col;
    ground_counter=ground_counter+1;
end
for row_index=ground_top_row+1:ground_bottom_row
    ground_boundary_points(ground_counter,1)=row_index;
    ground_boundary_points(ground_counter,2)=detected_left_col;
    ground_counter=ground_counter+1;
end

    P=detected_boundary_points;
    Q=ground_boundary_points;
    sP = size(P);
    sQ = size(Q);
    d=zeros(1,sQ(1));
    dmin=zeros(1,sP(1));
    for i=1:sP(1)
        for j=1:sQ(1)
            d(1,j)=sqrt((P(i,1)-Q(j,1))^2+(P(i,2)-Q(j,2))^2);
        end
        dmin(1,i)=min(d);
    end
    HD_max1=max(dmin);
    MHD_1=mean(dmin);
    
    d1=zeros(1,sP(1));
    dmin1=zeros(1,sQ(1));
    for i=1:sQ(1)
        for j=1:sP(1)
            d1(1,j)=sqrt((P(j,1)-Q(i,1))^2+(P(j,2)-Q(i,2))^2);
        end
        dmin1(1,i)=min(d1);
    end
    
    HD_max2=max(dmin1);
    MHD_2=mean(dmin1);
    Hausdorff_distance_NonMalignant(folder_idx)=max(HD_max2,HD_max1);
    Modified_Hausdorff_NonMalignant(folder_idx)=max(MHD_1,MHD_2);
end 
%% RESULTS
Haus_Overall=[Hausdorff_distance_Malignant, Hausdorff_distance_NonMalignant, Hausdorff_distance_Normal];
Modified_Haus_Overall=[Modified_Hausdorff_Malignant, Modified_Hausdorff_NonMalignant, Modified_Hausdorff_Normal];
mean(Haus_Overall)
std(Haus_Overall)
mean(Modified_Haus_Overall)
std(Modified_Haus_Overall)