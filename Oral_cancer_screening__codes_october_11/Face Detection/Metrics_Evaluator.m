function [IOU,Dice,E1,E2] = Metrics_Evaluator(direc,Ground_direc)

    load(direc);
    load(Ground_direc);
     
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
    E1=nnz(Product_mask);
    E1=E1/(480*640);
     
    %% E2 Metric = FPR & FNR    
    TP=nnz(and(detected_mask(1:480,1:640),ground_truth_mask(1:480,1:640)));
    FP=nnz(and(detected_mask(1:480,1:640),not(ground_truth_mask(1:480,1:640))));
    FN=nnz(and(not(detected_mask(1:480,1:640)),ground_truth_mask(1:480,1:640)));
    TN=nnz(and(not(detected_mask(1:480,1:640)),not(ground_truth_mask(1:480,1:640))));
    
    Total_Positive=nnz(ground_truth_mask(1:480,1:640));
    Total_Negative=nnz(not(ground_truth_mask(1:480,1:640)));
    
    FPR=FP/Total_Negative;
    FNR=FN/Total_Positive;
    
    E2=(FPR+FNR)/2;
    
    
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
       IOU=(area_intersection)/(area_union);
       Dice=2*(area_intersection)/(area_detected+area_ground);
    else
       IOU=0;
       Dice=0;
    end
% end
IOU=IOU.*(IOU>0);
Dice=Dice.*(Dice>0);
end

