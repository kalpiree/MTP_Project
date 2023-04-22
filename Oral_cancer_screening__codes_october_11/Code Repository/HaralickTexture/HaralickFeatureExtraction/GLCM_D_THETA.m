function GC  = GLCM_D_THETA(Input_slice,d,theta, Mask)

% clc; clear all; close all;
% d=4; theta=135;



if ~(exist('Mask','var'))
    [row,col] = size(Input_slice); 
    
    
    
%     Mask = true(row,col);
    if theta==0
        offset = [0 d];
    elseif theta==45
        offset = [-d d];
    elseif theta==90
        offset = [-d 0];
    elseif theta==135
        offset = [-d -d];
    end
    GC = graycomatrix(Input_slice,'Offset',offset, 'GrayLimits',[], 'NumLevels', max(Input_slice(:))-min(Input_slice(:))+1);

else
I = ceil(Input_slice);
MAX = max((I(:)));
MAX=255;
GC = zeros(MAX+1,MAX+1);
[m,n]=size(I);
for x=1:m
    for y=1:n
        %switch theta
            if theta == 0 % 0 degree
            if(y+d)<=n
                if (Mask(x,y)==1 && Mask(x,y+d)==1)
%                     GC(I(x+d,y)+1,I(x,y)+1)=GC(I(x+d,y)+1,I(x,y)+1)+1;
                      GC(I(x,y)+1,I(x,y+d)+1)=GC(I(x,y)+1,I(x,y+d)+1)+1;  
                end
            end        
        
            elseif theta == 45 % 45 degree
            if(x-d>=1 && y+d<=n)
                if (Mask(x,y)==1 && Mask(x-d,y+d)==1)
                    GC(I(x,y)+1,I(x-d,y+d)+1)=GC(I(x,y)+1,I(x-d,y+d)+1)+1;
                end
            end
            
            elseif theta == 90 % 90 degree
            if (x-d>=1)
                if (Mask(x,y)==1 && Mask(x-d,y)==1)
                    GC(I(x,y)+1,I(x-d,y)+1)=GC(I(x,y)+1,I(x-d,y)+1)+1;
                end
            end
        
            elseif theta == 135 % 135 degree
            if(x-d>=1 && y-d>=1)
                if (Mask(x,y)==1 && Mask(x-d,y-d)==1)
                    GC(I(x,y)+1,I(x-d,y-d)+1)=GC(I(x,y)+1,I(x-d,y-d)+1)+1;
                end
            end
            end
        %end
        
    end
end
GC=GC./(sum(GC(:)));
end



 end