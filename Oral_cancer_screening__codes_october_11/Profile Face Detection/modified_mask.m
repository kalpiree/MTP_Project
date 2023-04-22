% =========================== modified_mask.m ====================================== %
% Description  : 
% In this code we generate the mask, using the cordinates which we calculated 
% ================================================================================== %
% Input Parameters :
%                    I  = Input image
%                    tip_row,tip_col = cordinates of the tip
%                    canthus_r,canthus_c =  eye canthus cordinates
%                    nw_row,nw_col = nose wing cordinates
%                    ear_row,ear_col =  ear hotspot cordinates 
%                    chin_row, chin_col, =  cordinates of a point in chin
%------------------------------------------------------------------------------------%  
% Output parameter:  
%                    binary modified mask
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
% Modified on :    ~~
% Modification details:    ~~
% Modified By :  ~~ 
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %

function [mask,row,col,ROI] = modified_mask(tip_row,tip_col,canthus_r,canthus_c,nw_row,nw_col,ear_row,ear_col,chin_row, chin_col,mask,I1)
chin_col = chin_col +(nw_col - tip_col);

b_e_row = chin_row;
b_e_col = ear_col;

row = zeros(5,1);
col = zeros(5,1);























row(1,1)=canthus_r;
row(2,1)= nw_row;
row(3,1)= ear_row;
row(4,1)= chin_row;
row(5,1)=b_e_row;

col(1,1)=canthus_c;
col(2,1)= nw_col;
col(3,1)= ear_col;
col(4,1)= chin_col;
col(5,1)=b_e_col;


% for generating final mask uncomment this

%mask(:,b_e_col:1:640)=0; (MASKED)
mask(:,floor(b_e_col):1:64)=0;
%mask(b_e_row:1:480,:)=0; (MASKED)
mask(floor(b_e_row):1:480,:)=0;


% % % % % % removing the outer part of the polygon
   
    %%%(nw_row,nw_col) first point
    %%%(chin_row,chin_col) second point
   
    m = (chin_row-nw_row)/(chin_col-nw_col);
    
    k = nw_row - m * nw_col;
    
   
    for row = 1:1:480
     for col =1:1:640
        
       if( row - m*col - k >0)
       mask(row,col)= 0;
       end
        
     end
    end
    
    
    
    %%%(canthus_r,canthus_c) first point
     %%%(nw_row,nw_col) second point

        m = (nw_row-canthus_r)/(nw_col-canthus_c);

        k = canthus_r- m * canthus_c;


        for row = 1:1:480
         for col =1:1:640

           if( row - m*col - k <0)
           mask(row,col)= 0;
           end

         end
        end
        
     %%%(ear_row,ear_col) first point
     %%%(canthus_r,canthus_c) second point

        m = (ear_row-canthus_r)/(ear_col-canthus_c);

        k = canthus_r- m * canthus_c;


        for row = 1:1:480
         for col =1:1:640

           if( row - m*col - k <0)
           mask(row,col)= 0;
           end

         end
        end
        
        
  pos_pentagon = [canthus_c canthus_r ear_col ear_row ear_col chin_row chin_col chin_row nw_col nw_row];
  %pos_pentagon=[canthus_c canthus_r ear_col ear_row ear_col chin_row chin_col chin_row]
  ROI = insertShape(I1,'Polygon',{pos_pentagon},'Color', {'blue'},'Opacity',0.7);


end