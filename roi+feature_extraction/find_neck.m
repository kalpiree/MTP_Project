
% =========================== find_neck.m ====================================== %
% Description  : 
% In this code we find the neck based on the shape of neck on the mask.
% Neck is the smaller pipe shaped region in the mask, which is smaller than
% the facial part using this property we find some points in rows and
% columns of the image to  using them we make a line and find how many
% white pixels are present in that line. we take the minimum of that and
% that line is represented as neck row.
% ================================================================================== %
% Input Parameters :
%                    Mask = Mask generated
%------------------------------------------------------------------------------------%  
% Output parameter:  
%                    Cordinates of keypoints shown in figure
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   
% Called by : profile_keypoints_main
%------------------------------------------------------------------------------------%
% Reference:    
%~~~~~~~~~~~~
%~~~~~~~~~~~~
% Author of the code:  Ankit Tiwari  
% Date of creation :    10-05-2018
% ------------------------------------------------------------------------------------------------------- %
% Modified on :    ~~
% Modification details:    ~~
% Modified By :  Srijita Saha Roy 
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %

function [slope, constant, neck_col, neck_row]=find_neck(org_mask)

 mask=org_mask;
 [rmax,cmax] = size(mask);

 count_min=1000000;


%1. Find the lowest row which has the white pixel in it
    ver_pro = sum(mask,2);%S = sum(A,dim) returns the sum along dimension dim.
    for i=479:-1:1
      if ver_pro(i)>0 
        lowest_row=i; %lowest row is the last row upto which image is segmented 
        break;
      end
    end
    lowest_col = find_first(lowest_row,mask);
    
  
    
    
  c_=lowest_col;
%2. find the line with minimum white pixel count between two points
    for c = 1:5:c_
    % % (lowest_row, c) first point
    
        for f = lowest_row:-5:200%(why 200?, because we want to reduce the space of search)
        % % (f, 640) second point
    
        m = (f-lowest_row)/(640-c);
    
        k = lowest_row - m * c;
    
        mask = org_mask;
        count=0;
%     Count  the Number of white pixels in that line
        for col =c:1:640

           if( mask(round(m*col+k), col)==1)
           count=count+1;
           end

        end
% % 
% Get the slope and constant of the line with minimum sum
            if count<count_min && count>0

                count_min = count;
                slope=m;
                constant = k;
                c_start= c;
            end
    
    end
end
% % 
% cordinates where line intersect the face
    for col =c_start:1:640
        row=round(slope*col+constant);
        
       if (mask(row , col)==1)
       break;
       end
        
    end
% %

neck_col=col;
neck_row=round(slope*col+constant);
% mask(neck_row:480,:)=0;  



% 
%    
%  t_min=0; %temp variable 
%    for n_row = 480:-1:336
%        
%        column = find_first(n_row, mask);
%         
%         if column > t_min
%         
%         t_min=column;
%         neck_col= t_min;
%         neck_row = n_row;
%         
%         end
%         
%    end
   
   
end




function [col] = find_first(row, mask)
  
 
    if row < size(mask,1)

         arr=mask(row,:);
         col = min(find(arr>0)); % from among the different 'y' values, this returns the minimum value
         if  size(col,2)==0
             col=640;
         end
    end   


end








