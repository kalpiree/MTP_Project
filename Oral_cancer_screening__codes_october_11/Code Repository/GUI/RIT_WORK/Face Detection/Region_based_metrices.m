function Values_of_six_region_based_metrices = Region_based_metrices(Mask_of_segmented_nodule, Ground_truth_mask)

% Region based similarity (Accuracy, Overlap, Sensitivity, Specificity, Similarity angle Similarity region)

% figure,
% for i=1:size(Ground_truth_mask,3)
%     subplot(6,ceil(size(Ground_truth_mask,3)/6),i),imshow(Ground_truth_mask(:,:,i),[]);
%     set(gcf,'Position',get(0,'Screensize'));
% end

[M,N,P]=size(Ground_truth_mask);
tp=0; tn=0; fp=0; fn=0;
for i=1:M
    for j=1:N
        for k=1:P
            if(Ground_truth_mask(i,j,k)==1 && Mask_of_segmented_nodule(i,j,k)==1)
                tp=tp+1;
            end
            
            if(Ground_truth_mask(i,j,k)==0 && Mask_of_segmented_nodule(i,j,k)==0)
                tn=tn+1;
            end
            
            if(Ground_truth_mask(i,j,k)==0 && Mask_of_segmented_nodule(i,j,k)==1)
                fp=fp+1;
            end
            
            if(Ground_truth_mask(i,j,k)==1 && Mask_of_segmented_nodule(i,j,k)==0)
               fn=fn+1;
            end
        end
    end
end

Accuracy=(tp+tn)/(tn+ tp+fp+fn);
Overlap=tp/(tp+fp+fn);
Sensitivity=tp/(tp+fn);
Specificity=tn/(tn+fp);

No_row_multiplied_by_column=size(Ground_truth_mask,1)* size(Ground_truth_mask,2)*size(Ground_truth_mask,3);
Ground_truth_mask_one_D=reshape(Ground_truth_mask,1,No_row_multiplied_by_column);
Mask_of_segmented_nodule_one_D=reshape(Mask_of_segmented_nodule,1,No_row_multiplied_by_column);
SA=dot(Ground_truth_mask_one_D, Mask_of_segmented_nodule_one_D)/(norm(Ground_truth_mask_one_D) * norm(Mask_of_segmented_nodule_one_D));
Similarity_angle_computed=acos(SA);

if sum(Mask_of_segmented_nodule(:))~=0
    Similarity_angle=Similarity_angle_computed;
else
    Similarity_angle=1.5708;
end

Similarity_region=2*tp/(2*tp+fp+fn);
Values_of_six_region_based_metrices=[Accuracy, Overlap, Sensitivity, Specificity, Similarity_angle Similarity_region];
end