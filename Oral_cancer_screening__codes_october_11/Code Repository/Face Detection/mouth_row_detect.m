function [ mouth_row_index_req,lower_lip_row ] = mouth_row_detect( face_img,req_row,col_lt_eye,col_rt_eye,r_rt,row_rt_eye,req_col_mouth_rt,req_col_mouth_lt )
%% Documentation
% % Functions called in this fn: Nil

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. distance_1_3 :: Distance between row coord. of right nose and right eye canthus
%                    2. distance_3_5_eqn1 :: Row between Nose and Mouth.
%                    3. distance_3_5_eqn2 :: Search Region for Right Nose. 
%                    4. row_3_5_eqn1 :: Search Region for Left Nose.
%                    5. row_3_5_eqn2 :: Search region for Right Nose after gamma correction
%                    6. lower_lip_row :: Search region for Left Nose after gamma correction
%                    7. Mouth_Region_Image :: Binary Images with marked Edges.
%                    8. var_mouth :: Contains row coord. of right nose edges.
%                    9. c_rt :: Contains col coord. of right nose edges.
%                   10. the_edge_lt :: Binary Images with marked Edges.
%                   11. r_lt :: Contains row coord. of left nose edges.
%                   12. c_lt :: Contains col coord. of left nose edges.distance_1_2=col_lt_eye-col_rt_eye;
%                   13. distance_1_2 :: Distance bet. the R & L eye canthus
%% Working: The objective is to obtain the row coordinate of the mouth. The intuition is that the row between the lips is of uniform 
% variance and is significantly different from the adjacent rows. In order to restrict the search region, we model a regression parameter 
% to identify the lower lip row based on the distance between the eye and
% nose coordinates. The new search region is has the mouth column boundaries, req_row and lower_lip_row boundaries. Within this region,
% we check for the local minima in variace to obtain the mouth row coord.  

distance_1_2=col_lt_eye-col_rt_eye; % Eye Canthus Distance
distance_1_3=r_rt-row_rt_eye; % Distance between Nose and Eye Canthus.

distance_3_5_eqn1=0.83763*distance_1_2+4.9135; % Regression expression based on Eye Canthus distance.
distance_3_5_eqn2=0.86625*distance_1_3+2.3029; % Regression expression beased on distance between nose and eye.

row_3_5_eqn1=distance_3_5_eqn1+r_rt; % Obtaining the indices, adding offsets
row_3_5_eqn2=distance_3_5_eqn2+r_rt; % Obtaining the indices, adding offsets

lower_lip_row=ceil((row_3_5_eqn1+row_3_5_eqn2)/2); % Average of the regression outputs, yield the lower lip row for the new search region.

Mouth_Region_Image=face_img(req_row:lower_lip_row,req_col_mouth_rt:req_col_mouth_lt); % Search Region for Mouth 
Mouth_Region_Image = adapthisteq(Mouth_Region_Image); % enhance the contrast using CLAHE.

% Compute row-wise variance within the search window.
var_mouth=[];
for mouth_row_index=1:size(Mouth_Region_Image,1)
    var_mouth(mouth_row_index)=var(Mouth_Region_Image(mouth_row_index,:));
end
rev_var_mouth=var_mouth(length(var_mouth):-1:1); % Reversing the variance vector.
choice=1;
mouth_index=1;

% The objective is to reach the valley point. The first while loop skips to
% the peak point, if any and the second loop identifies the valley point.
% In order to ensure that no spurious valley points are identified, another
% check is performed below, in order to check its consistency. 
while(rev_var_mouth(mouth_index)<rev_var_mouth(mouth_index+1))
    mouth_index=mouth_index+1;
end
while(choice==1) % Breaks when a valley point is encountered.
    if(rev_var_mouth(mouth_index)-rev_var_mouth(mouth_index+1)>0)
        mouth_index=mouth_index+1;
    else
        if(rev_var_mouth(mouth_index+1)>rev_var_mouth(mouth_index) && rev_var_mouth(mouth_index+2) > rev_var_mouth(mouth_index))
            choice=0;
            mouth_row_index_req=mouth_index;
            break;
        else
            mouth_index=mouth_index+1;
        end
    end 
end

 mouth_row_index_req=length(var_mouth)-mouth_row_index_req; % Since the variance vector was reversed.
 mouth_row_index_req= mouth_row_index_req+req_row; % Adding the required offset.
end

