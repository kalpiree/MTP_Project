function [ p,x,y ] = neck_detection( face_img,req_row )
[r,c]=find(face_img>0);
mid_c=ceil((min(c)+max(c))/2);
mid_rt=ceil((min(c)+mid_c)/2);
mid_lt=ceil((max(c)+mid_c)/2);
I_rt = face_img(req_row:max(r),min(c):mid_rt);
I_lt = face_img(req_row:max(r),mid_lt+1:max(c));
C_rt_neck = corner(I_rt);
subplot(1,2,1);imshow(I_rt);
hold on
plot(C_rt_neck(:,1), C_rt_neck(:,2), 'r*');
hold off;
subplot(1,2,2);
C_lt_neck = corner(I_lt);
imshow(I_lt);
hold on
plot(C_lt_neck(:,1), C_lt_neck(:,2), 'r*');
hold off;
sort_C_rt_neck=sortrows(C_rt_neck,2);
sort_C_lt_neck=sortrows(C_lt_neck,2);
corner_slope_lt=[];
corner_angle_lt=[];
corner_slope_rt=[];
corner_angle_rt=[];
for i=1:size(sort_C_rt_neck,1)-1
    corner_slope_rt(i)=(sort_C_rt_neck(i+1,2)-sort_C_rt_neck(i,2))/(sort_C_rt_neck(i+1,1)-sort_C_rt_neck(i,1));
   % corner_angle(i)=((corner_angle(i)*180)/pi);
    corner_angle_rt(i)=atan(corner_slope_rt(i))*(180/pi);
end

for i=1:size(sort_C_lt_neck,1)-1
    corner_slope_lt(i)=(sort_C_lt_neck(i+1,2)-sort_C_lt_neck(i,2))/(sort_C_lt_neck(i+1,1)-sort_C_lt_neck(i,1));
   % corner_angle(i)=((corner_angle(i)*180)/pi);
    corner_angle_lt(i)=atan(corner_slope_lt(i))*(180/pi);
end

figure();
stem(corner_angle_rt);
figure();
stem(corner_angle_lt);

neck_index_rt=1;
neg_count=0;
pos_count=0;
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
     neck_index_rt_value=sort_C_rt_neck(neck_index_rt,2);
     
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
     neck_index_lt_value=sort_C_lt_neck(neck_index_lt,2);
     
     
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
         figure();
         imshow(face_img,[]);
         hold on;
         plot(col_vector,row_vector,'*');
         hold off;
             
          
p = polyfit(col_vector,row_vector,2);
x=[min(c):max(c)];
y=polyval(p,x);

end

