% =========================== uppper_nose.m ====================================== %
% Description  : 
%%%this function finds approximately nearest cordinates of the lateral eye
%%%canthus and also the cordinates in fore head at the front edge of the
%%%profile face
% ================================================================================== %
% Input Parameters :
%                    
%                  e_row, e_col..... are the cordinates at the forehead
%                  g_row, g_col..... are the cordinates of approximate lateral canthus of
%                  the eye
%                  mask = mask of the image
%------------------------------------------------------------------------------------%  
% Output parameter:  
%                   cooerdinates of the point near the eye canthus
%                    
%------------------------------------------------------------------------------------%
% Subroutine  called : 
% 
% Called by : ~~~~
%------------------------------------------------------------------------------------%
% Reference:    
%~~~~~~~~~~~~
%~~~~~~~~~~~~
% Author of the code:  Ankit Tiwari  
% Date of creation :    10-05-2018
% ------------------------------------------------------------------------------------------------------- %
% Modified on :            11-05-2019
% Modification details:    Line: 49 and Line: 50 added to include the
%                          corner case in forehead detection 
% 
% Modified By :            Abhishek Prajapati
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
function  [e_row, e_col, g_row, g_col]= uppper_nose( chin_row, chin_col,tip_row,tip_col,mask,u_b)

[row, col] = size(mask);


dist = sqrt(abs(chin_row-tip_row)^2+abs(chin_col-tip_col)^2);

dist = round(dist);

        e_row = tip_row ;
        e_col = tip_col-1;

for r = tip_row-1 :-1: tip_row-abs(tip_row-chin_row)

     c = find_first(r, mask);
      e_row=r; % uncomment to include the corner cases. 
      e_col=c; 
    temp=round(sqrt(abs(r-tip_row)^2+abs(c-tip_col)^2));
    if temp > dist && temp < dist+5
        
        e_row = r;
        e_col = c;
        break;
    end




end
%  e_row = tip_row-abs(tip_row-chin_row);
%  e_col = find_first(e_row, mask);




%     %%%(e_row, c_col) second point
%     %%%(tip_row,tip_col) first point
%     
      m = (tip_row- e_row)/(tip_col-e_col);
      m = -m;
      angle = atand(m);
    
      k = e_row - m * e_col;
     
%%%%%%%%%%%%%%%% shift the mask to center,(240,310)
shift_row = 240 - tip_row;
shift_col = 310 - tip_col;
orgmask = mask;
mask = imtranslate(mask ,[shift_col,shift_row]);
figure,imshow(mask);
%rotate to make ther nose eye plane perpendicular
mask=imrotate(mask,90-angle,'nearest','crop');
figure,imshow(mask);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%% find the max dist
[row, col] = size(mask);

cmax= 0;rmax=0;
% t=round(abs(dist*cos(angle)));
for r = abs(row/2):-1:abs(row/2)-dist
     
       c = find_first(r, mask);
       if c > cmax
     
       cmax = c;
       rmax = r;
     
       end
     
end

%%% max and cmax are untransformed point eye canthus.

dist = round( sqrt(abs(rmax-240)^2+abs(cmax-310)^2));

mask = orgmask;

g_row=240;
g_col=310;
for r = tip_row-1 :-1: tip_row-dist
       
       c = find_first(r, mask);
       temp=round(sqrt((r-tip_row)^2+(c-tip_col)^2));
       if temp > dist && temp < dist+5
        
        g_row = r;
        g_col = c;
        break;
       end

     

end















end


function [col] = find_first(row, mask)
  
 
    if row <size(mask,1)

         arr = mask(row,:);
         col = min(find(arr>0));
         if  size(col,2)==0
             col = 640;
         end
    end   


end