function [r_lt,c_lt,r_rt,c_rt] = nose_detection( face_img,modified_min_row_nose,mean_eye_brow_row,req_row,col_rt_eye,col_lt_eye,req_col_mouth_lt,req_col_mouth_rt)
%% Documentation
% % Functions called in this fn: Nil
% i/p parameters to the fn:  face_img, 
%                            modified_min_row_nose 
%                            mean_eye_brow_row 
%                            req_row 
%                            col_rt_eye 
%                            col_lt_eye 
%                            req_col_mouth_lt
%                            req_col_mouth_rt
% o/p parameters of the fn:  r_lt 
%                            c_lt
%                            r_rt
%                            c_rt

% Variable names: 
% Variables with subscripts _lt refer to left face and _rt refers to the same quantity on the right face
%                    1. modified_min_row_nose :: Specifies the modified upper boundary for Nose Region
%                    2. req_row :: Row between Nose and Mouth.
%                    3. nose_right_img :: Search Region for Right Nose. 
%                    4. nose_left_img :: Search Region for Left Nose.
%                    5. new_nose_right_img :: Search region for Right Nose after gamma correction
%                    6. new_nose_left_img :: Search region for Left Nose after gamma correction
%                    7. the_edge_rt :: Binary Images with marked Edges.
%                    8. r_rt :: Contains row coord. of right nose edges.
%                    9. c_rt :: Contains col coord. of right nose edges.
%                   10. the_edge_lt :: Binary Images with marked Edges.
%                   11. r_lt :: Contains row coord. of left nose edges.
%                   12. c_lt :: Contains col coord. of left nose edges.
%% 
    modified_min_row_nose=floor(0.5*(req_row-modified_min_row_nose))+modified_min_row_nose; % Reduce the search area, redine teh upper boundary
    cmid=ceil((col_rt_eye+col_lt_eye)/2);
    nose_right_img=face_img( modified_min_row_nose:req_row, req_col_mouth_rt:cmid ); % Right Nose search region
    nose_left_img=face_img( modified_min_row_nose:req_row, cmid:req_col_mouth_lt ); % Left Nose Search Region
    c=2;
    g=25;
    % Apply Gamma Correction, for enhancing the contrast.
    new_nose_right_img=c*nose_right_img.^g;
    new_nose_left_img=c*nose_left_img.^g;
    %% Right Nose
    I_rt=new_nose_right_img;
    the_edge_rt = edge(I_rt); % Detect the edges in the nose image. Binary Image obtained.
    count_rt=1;
    % r_rt and c_rt contains the row and column coordinates of all the detected edges. The loop
    % selects the extreme edges in each column.
    for i=1:size(new_nose_right_img,1)
        for j=1:size(new_nose_right_img,2)
            if(the_edge_rt(i,j)>0)
                r_rt(count_rt)=i;
                c_rt(count_rt)=j;
            end
        end
       array_rt=nonzeros(the_edge_rt(i,:));
       if isempty(array_rt)==isempty([]) 
           continue;
       else
           count_rt=count_rt+1;
       end
    end
    
    r_rt=r_rt+modified_min_row_nose; % Identifying indices, with added offsets.
    c_rt=c_rt+req_col_mouth_rt; % Identifying indices, with added offsets.
    %% Left Nose
    I_lt=new_nose_left_img;
    the_edge_lt = edge(I_lt); % Detect the edges in the nose image. Binary Image obtained.
    count_lt=1;
    % r_lt and c_lt contains the row and column coordinates of all the detected edges. The loop
    % selects the extreme edges in each column.
    for i=1:size(new_nose_left_img,1)
       for j=size(new_nose_left_img,2):-1:1
           if(the_edge_lt(i,j)>0)
                r_lt(count_lt)=i;
                c_lt(count_lt)=j;
           end
       end
       array_lt=nonzeros(the_edge_lt(i,:));
       if isempty(array_lt)==isempty([]) 
           continue;
       else
           count_lt=count_lt+1;
       end
    end
    
    r_lt=r_lt+modified_min_row_nose;% Identifying indices, with added offsets.
    c_lt=c_lt+cmid;% Identifying indices, with added offsets.
    
    c_loc_rt=find(min(c_rt)==c_rt); % Least Horizontal Coord gives the Right Nose extreme
    c_loc_lt=find(max(c_lt)==c_lt); % Maximum Horizontal Coord gives the Left Nose extreme
   
    r_lt=max(r_lt(c_loc_lt));
    c_lt=c_lt(c_loc_lt);
    r_rt=max(r_rt(c_loc_rt));
    c_rt=c_rt(c_loc_rt);

end

