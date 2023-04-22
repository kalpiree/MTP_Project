function Values_of_four_contour_based_metrices=Comtour_based_metrices(Mask_of_segmented_nodule, Ground_truth_mask, GT_1_biggest_crop)

% Contour-based similarity (Mean distance, Pratt function, Hausdorff distance, Modified Hausdorff distance)

% figure,
% for i=1:size(Rescased_croped_segmented_nodule_Knuigkh_2006,3)
%     subplot(6,ceil(size(Rescased_croped_segmented_nodule_Knuigkh_2006,3)/6),i),imshow(Rescased_croped_segmented_nodule_Knuigkh_2006(:,:,i),[]);
%     set(gcf,'Position',get(0,'Screensize'));
% end

if sum(Mask_of_segmented_nodule(:))>0 && sum(Ground_truth_mask(:))>0
    
    List_of_rejected_slice=zeros(size(Mask_of_segmented_nodule,3),1);
    for slice_no=1:size(Mask_of_segmented_nodule,3)
        segmented_slice_temp=Mask_of_segmented_nodule(:,:,slice_no);
        Ground_truth_slice_temp=Ground_truth_mask(:,:,slice_no);
        
        if ((sum(segmented_slice_temp(:)))==0 && (sum(Ground_truth_slice_temp(:)))==0)
            List_of_rejected_slice(slice_no,1)=1;
        end
    end
    
    Sline_no_of_actual_slices=[];
    for slice_no=1:size(Mask_of_segmented_nodule,3)
        if (List_of_rejected_slice(slice_no,1)==0)
            Sline_no_of_actual_slices=[Sline_no_of_actual_slices;slice_no];
        end
    end
    
    for actual_slice_count=1 : size(Sline_no_of_actual_slices,1)
        segmented_slice_actual_temp=Mask_of_segmented_nodule(:,:,Sline_no_of_actual_slices(actual_slice_count));
        Ground_truth_actual_temp=Ground_truth_mask(:,:,Sline_no_of_actual_slices(actual_slice_count));
        
        %      Equvalant_diameter_seg = regionprops(segmented_slice_actual_temp, 'EquivDiameter')
        %      Equvalant_diameter_gt = regionprops(Ground_truth_actual_temp, 'EquivDiameter')
        %      AA=max(Equvalant_diameter_seg(1).EquivDiameter, Equvalant_diameter_gt(1).EquivDiameter)
        
        if (sum(segmented_slice_actual_temp(:))>5) &&  (sum(Ground_truth_actual_temp(:))>5)
            segmented_slice=Mask_of_segmented_nodule(:,:,Sline_no_of_actual_slices(actual_slice_count));
            Conn_comp_seg = bwconncomp(segmented_slice,8);
            Label_matrix_seg = labelmatrix(Conn_comp_seg);
            %         connectivity_index_seg=1:max(Label_matrix_seg(:));
            Area_of_objects_seg  = regionprops(Conn_comp_seg, 'area');
            for i=1:max(Label_matrix_seg(:))
                Area_individual_object_seg(i) = Area_of_objects_seg(i).Area;
            end
            [Area_values_seg, Index_of_biggest_area_seg] = max(Area_individual_object_seg);
            Bigest_object_seg=ismember(Label_matrix_seg,Index_of_biggest_area_seg);
            segmented_slice=Bigest_object_seg;
            %----------------------------------------
            Ground_truth_slice=Ground_truth_mask(:,:,Sline_no_of_actual_slices(actual_slice_count));
            Conn_comp_gt= bwconncomp(Ground_truth_slice,8);
            Label_matrix_gt = labelmatrix(Conn_comp_gt);
            %         connectivity_index_gt=1:max(Label_matrix_gt(:));
            Area_of_objects_gt  = regionprops(Conn_comp_gt, 'area');
            for i=1:max(Label_matrix_gt(:))
                Area_individual_object_gt(i) = Area_of_objects_gt(i).Area;
            end
            [Area_values_gt, Index_of_biggest_area_gt] = max(Area_individual_object_gt);
            Bigest_object_gt=ismember(Label_matrix_gt, Index_of_biggest_area_gt);
            Ground_truth_slice=Bigest_object_gt;
            [Mean_distance_slice, Prat_Function_slice]=Compute_mean_distance_Pratt_function_of_a_slice(segmented_slice, Ground_truth_slice);
            clear Area_individual_object_gt;
            clear Area_individual_object_seg;
            
            %         figure, imshow(Ground_truth_slice,[]);
            %         set(gcf,'Position',get(0,'Screensize'));
            %         figure, imshow(segmented_slice,[]);
            %         set(gcf,'Position',get(0,'Screensize'));
        else
            
            [Mean_distance_slice, Prat_Function_slice]=Compute_mean_distance_Pratt_function_for_missing_mask(segmented_slice_actual_temp, Ground_truth_actual_temp);
            
        end
        
        Acumulation_of_Mean_distance(actual_slice_count,1)=Mean_distance_slice;
        Acumulation_of_Prat_Function(actual_slice_count,1)=Prat_Function_slice;
    end
    Mean_distance=mean(Acumulation_of_Mean_distance);
    Prat_Function=mean(Acumulation_of_Prat_Function);

else
    Equivalent_diameter_of_biggest_slice = regionprops(GT_1_biggest_crop, 'EquivDiameter');
    Mean_distance=(Equivalent_diameter_of_biggest_slice(1).EquivDiameter)/2;
    Prat_Function=0;
end

% ==================End of Mean_distance and Pratt_function=======
if (sum(Mask_of_segmented_nodule(:))>0)
    %=======Start of Hausdorff distance, Modified Hausdorff distance ======
    [M,N,P]=size(Ground_truth_mask);
    conn6Kernel = zeros([3,3,3]);
    conn6Kernel(2,2,1) = 1;
    conn6Kernel(1,2,2) = 1;
    conn6Kernel(2,1,2) = 1;
    conn6Kernel(2,3,2) = 1;
    conn6Kernel(3,2,2) = 1;
    conn6Kernel(2,2,3) = 1;
    sumOfFaces = convn(Mask_of_segmented_nodule, conn6Kernel, 'same'); % For each voxel, determine how many 6-connected neighbors it has.
    surfaceArea = 6 * Mask_of_segmented_nodule  - sumOfFaces; % Find number of exposed faces for each voxel.
    surfaceArea(surfaceArea<0) = 0; % Mask out zero voxels that have negative exposed faces.
    binaryVolume = surfaceArea > 0; % Now we simply label the volume and sum up the values of each region.
    surface_voxel_no=0;
    for i=1:M,
        for j=1:N
            for k=1:P
                if (binaryVolume(i,j,k)>0)
                    surface_voxel_no=surface_voxel_no+1;
                    X1(1,surface_voxel_no)=i;
                    Y1(1,surface_voxel_no)=j;
                    Z1(1,surface_voxel_no)=k;
                end
            end
        end
    end
    sumOfFaces_1 = convn(Ground_truth_mask, conn6Kernel, 'same'); % For each voxel, determine how many 6-connected neighbors it has.
    surfaceArea_1 = 6 * Ground_truth_mask - sumOfFaces_1; % Find number of exposed faces for each voxel.
    surfaceArea_1(surfaceArea_1<0) = 0; % Mask out zero voxels that have negative exposed faces.
    binaryVolume_1 = surfaceArea_1 > 0; % Now we simply label the volume and sum up the values of each region.
    voxel_no_1=0;
    for i=1:M,
        for j=1:N
            for k=1:P
                if (binaryVolume_1(i,j,k)>0)
                    voxel_no_1=voxel_no_1+1;
                    X11(1,voxel_no_1)=i;
                    Y11(1,voxel_no_1)=j;
                    Z11(1,voxel_no_1)=k;
                end
            end
        end
    end
    set_1=vertcat(X1,Y1,Z1);
    set1=transpose(set_1);
    set_11=vertcat(X11,Y11,Z11);
    set11=transpose(set_11);
    P=set1;
    Q=set11;
    sP = size(P);
    sQ = size(Q);
    d=zeros(1,sQ(1));
    dmin=zeros(1,sP(1));
    for i=1:sP(1)
        for j=1:sQ(1)
            d(1,j)=sqrt((P(i,1)-Q(j,1))^2+(P(i,2)-Q(j,2))^2+(P(i,3)-Q(j,3))^2);
        end
        dmin(1,i)=min(d);
    end
    HD_max1=max(dmin);
    MHD_1=mean(dmin);
    
    d1=zeros(1,sP(1));
    dmin1=zeros(1,sQ(1));
    for i=1:sQ(1)
        for j=1:sP(1)
            d1(1,j)=sqrt((P(j,1)-Q(i,1))^2+(P(j,2)-Q(i,2))^2+(P(j,3)-Q(i,3))^2);
        end
        dmin1(1,i)=min(d1);
    end
    
    HD_max2=max(dmin1);
    MHD_2=mean(dmin1);
    Hausdorff_distance=max(HD_max2,HD_max1);
    Modified_Hausdorff_distance=max(MHD_1,MHD_2);
else
    Equivalent_diameter_of_biggest_slice = regionprops(GT_1_biggest_crop, 'EquivDiameter');
    Hausdorff_distance=Equivalent_diameter_of_biggest_slice(1).EquivDiameter;
    Modified_Hausdorff_distance = Equivalent_diameter_of_biggest_slice(1).EquivDiameter;
end
Values_of_four_contour_based_metrices=[Mean_distance Prat_Function Hausdorff_distance Modified_Hausdorff_distance];
end