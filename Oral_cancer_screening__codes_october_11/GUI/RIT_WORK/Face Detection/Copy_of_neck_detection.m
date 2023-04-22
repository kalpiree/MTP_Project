function [ p,x,y ] = neck_detection( face_img,req_row )
%% Documentation
% neck_detection:-
% Called by funtion          : face_detect.m
% Functions called in this fn: Nil
% i/p parameters to the fn   : face_img,req_row 
% o/p parameters of the fn   : p,x,y  ( polynomial coefficients, x data , y data)
%                              

% Variable names: 
%                    1. I_r_t    :: Right face separated
%                    2. I_l_t    :: Left face separated 
%                    3. C_rt_neck:: Corner points of the right face  
%                    4. C_rt_neck:: Corner points of the left face
%                    5. sort_C_rt_neck:: Set of corner points sorted w.r.t rows
%                    6. sort_C_lt_neck:: Set of corner points sorted w.r.t rows
%                    7. corner_slope_rt :: Compute the slope between consecutive points
%                    8. corner_slope_lt :: Compute the slope between consecutive points for left face  
%                    9. corner_angle_rt :: Peaks and locations of peaks using findpeaks
%                   10. corner_angle_lt :: Identifying the top boundary of the face
%                   11. neg_count:: Flag for the spurious angle for right face
%                   12. pos_count:: Flag for the spurious angle for left face
%                   13. neck_index_rt :: Determining the row corres. to the inflection point for the right face
%                   14. neck_index_lt :: Determining the row corres. to the inflection point for the left face
%                   15. column_reject_rt:: Threshold for avoiding nose/mouth corners
%                   16. column_reject_lt:: Threshold for avoiding nose/mouth corners
%                   17. row_vector :: Row component of the Corner points, for the polynomial fit
%                   18. col_vector :: Column component of the Corner points, for the polynomial fit
%                   19. p :: Coefficients of the second order polynimial equation
%                   20. x :: Column values for evaluating the equation                  
%                   21. y :: Row values satisfying the equation for abv x values
%% Finding the corners
%  Working: 1.The face_img is split into two halves. 
%           2.Find corners using Harris corner operator. 
%           3.Sort them w.r.t to their row components.

[r,c]=find(face_img>0);
mid_c=ceil((min(c)+max(c))/2);
mid_rt=ceil((min(c)+mid_c)/2); % Avoid the nose/mouth region
mid_lt=ceil((max(c)+mid_c)/2); % Avoid the nose/mouth region
I_rt = face_img(req_row:max(r),min(c):mid_rt);
I_lt = face_img(req_row:max(r),mid_lt+1:max(c));
C_rt_neck = corner(I_rt);
C_lt_neck = corner(I_lt);
sort_C_rt_neck=sortrows(C_rt_neck,2);
sort_C_lt_neck=sortrows(C_lt_neck,2);

%% Tracing the neck
% Working: 1.For all the corener points, the slopes constituting two
%            successive elements are determined for both halves of the image.
%          2.Based on the above slopes, corresponding angles are obtained. 
%          3.Determine the inflection points, the beginning of the neck.
%          4.For the right face, track the change of +ve to -ve sign change ( angle change acute to obtuse )
%          5.For the left face, track the change of -ve to +ve sign change ( angle change obtuse to acute )
%          6.Based on the inflection points, reject corners found at the
%            nose/mouth.
%          7.Store the corners for both the halves combined in row_vector[]
%            and col_vector[].
%          8.Feed the row and col_vecor[] to polyfit function with order 2.
%          9.Find the values for different values of columns w.r.t to the equation of the parabola. 


corner_slope_lt=[];
corner_angle_lt=[];
corner_slope_rt=[];
corner_angle_rt=[];
for i=1:size(sort_C_rt_neck,1)-1
    corner_slope_rt(i)=(sort_C_rt_neck(i+1,2)-sort_C_rt_neck(i,2))/(sort_C_rt_neck(i+1,1)-sort_C_rt_neck(i,1));
    corner_angle_rt(i)=atan(corner_slope_rt(i))*(180/pi);
end

for i=1:size(sort_C_lt_neck,1)-1
    corner_slope_lt(i)=(sort_C_lt_neck(i+1,2)-sort_C_lt_neck(i,2))/(sort_C_lt_neck(i+1,1)-sort_C_lt_neck(i,1));
    corner_angle_lt(i)=atan(corner_slope_lt(i))*(180/pi);
end

neck_index_rt=1;
neg_count=0;
    if(corner_angle_rt(neck_index_rt)>=0)
        while((corner_angle_rt(neck_index_rt)>=0 || neg_count<=1) && neck_index_rt~=size(corner_angle_rt,2))
            if(corner_angle_rt(neck_index_rt)<0)
                neg_count=neg_count+1;
                if(corner_angle_rt(neck_index_rt+1)<0)
                    neg_count=2;
                    break;
                else
                    neg_count=0;
                end
            end
            neck_index_rt=neck_index_rt+1;
        end
    else
         while(corner_angle_rt(neck_index_rt)<=0)
             neck_index_rt=neck_index_rt+1;
         end
         neg_count=0;
         while((corner_angle_rt(neck_index_rt)>=0 || neg_count<=1 )&& neck_index_rt~=size(corner_angle_rt,2))
            if(corner_angle_rt(neck_index_rt)<0)
                neg_count=neg_count+1;
                if(corner_angle_rt(neck_index_rt+1)<0)
                    neg_count=2;
                    break;
                end
            end
            neck_index_rt=neck_index_rt+1;
         end
    end
    
neck_index_rt= neck_index_rt-1;
  
neck_index_lt=1;
pos_count=0;
    if(corner_angle_lt(neck_index_lt)<=0)
        while((corner_angle_lt(neck_index_lt)<=0 || pos_count<=1) && neck_index_lt~=size(corner_angle_lt,2))
            if(corner_angle_lt(neck_index_lt)>0)
                pos_count=pos_count+1;
                if(corner_angle_lt(neck_index_lt+1)>0)
                    pos_count=2;
                    break;
                else
                    pos_count=0;
                end
            end
            neck_index_lt=neck_index_lt+1;
        end
    else
         while(corner_angle_lt(neck_index_lt)>=0)
             neck_index_lt=neck_index_lt+1;
         end
         pos_count=0;
         while((corner_angle_lt(neck_index_lt)<=0 || pos_count<=1) && neck_index_lt~=size(corner_angle_lt,2))
            if(corner_angle_lt(neck_index_lt)>0)
                pos_count=pos_count+1;
                if(corner_angle_lt(neck_index_lt+1)>0)
                    pos_count=2;
                    break;
                end
            end
            neck_index_lt=neck_index_lt+1;
        end
   end
neck_index_lt= neck_index_lt-1;
if(neck_index_lt==size(corner_angle_lt,2))
   neck_index_lt=size(corner_angle_lt,2);
end
if(neck_index_rt==size(corner_angle_rt,2))
   neck_index_rt=size(corner_angle_rt,2);
end

column_reject_rt=sort_C_rt_neck(neck_index_rt,1)+min(c);
column_reject_lt=sort_C_lt_neck(neck_index_lt,1)+mid_lt;
array_counter=1;
row_vector=[];
col_vector=[];
for array_index=1:neck_index_rt
   if((sort_C_rt_neck(array_index,1)+min(c))<column_reject_rt)
       row_vector(array_counter)=sort_C_rt_neck(array_index,2)+req_row;
       col_vector(array_counter)=sort_C_rt_neck(array_index,1)+min(c);
       array_counter=array_counter+1;
   end
end
         
for array_index=1:neck_index_lt
   if((sort_C_lt_neck(array_index,1)+mid_lt)>column_reject_lt)
       row_vector(array_counter)=sort_C_lt_neck(array_index,2)+req_row;
       col_vector(array_counter)=sort_C_lt_neck(array_index,1)+mid_lt;
       array_counter=array_counter+1;
   end 
end          
          
p = polyfit(col_vector,row_vector,2);
x=[min(c):max(c)];
y=polyval(p,x);


end

