function GT_Gabor_HM_M_Frontal_new = improve_imbalance(GT_Gabor_HM_M_Frontal,ratio)
[row,col]=size(GT_Gabor_HM_M_Frontal);
GT_Gabor_HM_M_Frontal_new=cell(row,col);
        for i = 1:row
               I1 = GT_Gabor_HM_M_Frontal(i);
               I1 = cell2mat(I1);
               I1 = SMOTE(I1,ratio,2);
               [I1_row,I1_col] = size(I1);
%                I2 = mat2cell(I1,[I1_col-5 I1_row-4],[5 4]);
               GT_Gabor_HM_M_Frontal_new{i,1} = I1;
        end
end

    
    
    


