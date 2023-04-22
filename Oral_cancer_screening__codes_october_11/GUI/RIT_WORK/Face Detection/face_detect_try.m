function [I_new,mask_F,r_min1] = face_detect( I_F,Mode )
    I_F_n=((I_F-min(I_F(:)))/(max(I_F(:))-min(I_F(:))))*255;
    [level,criterion]=kittlerMinimimErrorThresholding(I_F_n);
    BW = im2bw(I_F_n/255,level/255); 
    mask_F=I_F_n.*double(BW);
%     figure();
% imshow(mask_F);title('BEFORE FILLING');
    mask_F=imfill(mask_F,'holes');
%     figure();
%     imshow(mask_F);title('AFTER FILLING');
    
%% Boundary Formation
    Ph=[];
    Pv=[];
    [row,col]=find (mask_F>0);
    rmin=min(row);
    cmin=min(col);
    xmin = round(1/3*(size(mask_F,1)-rmin))+rmin;
    
    for i=1:xmin
       Ph(i)=sum(mask_F(i,:));
    end
    
     xmin1 = round(2.5/3*(size(mask_F,1)-rmin))+rmin;
    
    for i=xmin1:(xmin1+40)
       Ph1(i)=sum(mask_F(i,:));
    end
    Ph2=Ph1((xmin1+1):(xmin1+15));
    Fx=gradient(Ph);
    Fx1=gradient(Ph2);
    r_max=find(Fx==max(Fx));
    temp=[1:size(mask_F,2)];
%     figure();
%     imshow(I_F_n/255);title('Bounding Box');
    %hold on;
%     plot(temp,r_max,'c*');
    r_min1=find(Fx1==min(Fx1));
    r_min1=r_min1+xmin1;
    temp=[1:size(mask_F,2)];
    %plot(temp,r_min1,'c*');
   

    for i=cmin:size(mask_F,2)
        Pv(i)=sum(mask_F(:,i));
    end
%      for i=162:508
%         Pv(i)=sum(mask_F(:,i));
%     end
    
    Fy=gradient(Pv);
    row_0=find(Fy>0);
    Fy_0=Fy(min(row_0):end);
    Fyy=gradient(Fy_0);
    temp=[1:size(mask_F,1)];
    %hold on;
%     max_mask=[-1 0 2 0 -1];
    Fy_c=imboxfilt(Fy,21);
%     Fy_c=conv(max_mask,Fyy);
%     figure();plot(Fy_c);
    th=floor((1/2).*max(abs(Fy_c)));
    c1=find(Fy_c>th);
%     plot((c2(1)+min(row_0)),temp,'c*');
    if(Mode=='F' || Mode=='L')
   %  plot(c1(1),temp,'c*');
    end
%     min_mask=[1 0 -2 0 1];
%     Fy_c1=conv(min_mask,Fyy(length(Fyy):-1:1));
    Fy_c1=imboxfilt(Fy(length(Fy):-1:1),21);
%     figure();plot(Fy_c1);
    th_min=floor((1/2).*max(abs(Fy_c1)));
    c2=find(abs(Fy_c1)>th_min);
    c2=length(Fy)-c2;
    temp=[1:size(mask_F,1)];
%     plot((c2(1)+min(row_0)),temp,'c*');
if(Mode=='F' || Mode=='R')
   % plot(c2(1),temp,'c*');
end
  
%% Face Cropping-Initial
    for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if Mode=='F'
            if((j>c1(1)) && j<((c2(1))) && (i>r_max) )   %FRONTAL
                I_new(i,j)=BW(i,j);
            else
                I_new(i,j)=0;
            end
           elseif Mode=='L'
                if( j>((c1(1))) && (i>r_max) )
                    I_new(i,j)=BW(i,j);
                else
                    I_new(i,j)=0;
                end
           else
                if( j<((c2(1))) && (i>r_max) )
                    I_new(i,j)=BW(i,j);
                else
                    I_new(i,j)=0;
                end
           end
               
        end
    end
    
%% Harris Corner Detection
C=corner(I_new(r_min1:end,:),'Harris');
%imshow(I_new);hold on;plot(C(:,1),(C(:,2)+r_min1),'c*');
min_r_min1=median(C(:,2));
min_r_min1=min_r_min1+r_min1;
%% Boundary Plot
temp=[1:size(mask_F,2)];
%plot(temp,min_r_min1,'c*');
%hold off;
%% Projection Plots
%figure();
%plot(temp,Pv);title('Vertical Projection');
%temp=[1:xmin]; figure();
%plot(temp,Ph);title('Horizontal Projection');
%% Gradient Plots
%figure();
Fy_c_length=[1:length(Fy_c)];
Fy_c1_length=[1:length(Fy_c1)];
%plot(Fy_c_length,Fy_c);title('Vertical Projection Max - Double Gradient');
%figure();
%plot(Fy_c_length,Fy_c1);title('Vertical Projection Min -Double Gradient');
%% Face Cropping
for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
           if Mode=='F'
            if((j>c1(1)) && j<((c2(1))) && (i>r_max) && (i<min_r_min1))   %FRONTAL
         %   if(j<c2)       %lEFT
%             if(j>c1)       %right
                I_new(i,j)=BW(i,j);
            else
                I_new(i,j)=0;
            end
           elseif Mode=='L'
                if( j>((c1(1))) && (i>r_max) && (i<min_r_min1))
                    I_new(i,j)=BW(i,j);
                else
                    I_new(i,j)=0;
                end
           else
                if( j<((c2(1))) && (i>r_max) && (i<min_r_min1))
                    I_new(i,j)=BW(i,j);
                else
                    I_new(i,j)=0;
                end
           end
               
        end
end

end
%%  Harris detector

% I =double(mask_F);
% 
% ymin = c1; 
% ymax = c2;
% [row,col]=find (mask_F>0);
% %rmin=min(row);
% xmin = r_min1;
% xmax=450;
% 
% Aj=0;
% cmin_harris=xmin-Aj; 
% cmax_harris=xmax+Aj; 
% rmin_harris=ymin-Aj; 
% rmax_harris=ymax+Aj;
% 
% min_N=12;
% max_N=16;
% sigma=2; Thrshold=20; r=6; disp=1;
% dx = [-1 0 1; -1 0 1; -1 0 1]; % The Mask 
% dy = dx';
% 
% Ix = conv2(I(cmin_harris:cmax_harris,rmin_harris:rmax_harris), dx, 'same');   
% Iy = conv2(I(cmin_harris:cmax_harris,rmin_harris:rmax_harris), dy, 'same');
% g = fspecial('gaussian',max(1,fix(6*sigma)), sigma); %%%%%% Gaussien Filter
%     
% Ix2 = conv2(Ix.^2, g, 'same');  
% Iy2 = conv2(Iy.^2, g, 'same');
% Ixy = conv2(Ix.*Iy, g,'same');
% 
% k = 0.04;
% R11 = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;
% R11=(1000/max(max(R11)))*R11;
% R=R11;
% ma=max(max(R));
% sze = 2*r+1; 
% MX = ordfilt2(R,sze^2,ones(sze));
% R11 = (R==MX)&(R>Thrshold); 
% count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));
%    
% loop=0;
% while (((count<min_N)|(count>max_N))&(loop<30))
%    if count>max_N
%        Thrshold=Thrshold*1.5; 
%    elseif count < min_N
%        Thrshold=Thrshold*0.5;
%    end
%     
%    R11 = (R==MX)&(R>Thrshold); 
%    count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));
%    loop=loop+1;
% end
% 
% R=R*0;
% R(5:size(R11,1)-5,5:size(R11,2)-5)=R11(5:size(R11,1)-5,5:size(R11,2)-5);
% [r1_new,c1_new] = find(R);
% PIP=[r1_new+cmin_harris,c1_new+rmin_harris];%% IP 
%    
% Size_PI=size(PIP,1);
% for r=1: Size_PI
%    I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)-2)=255;
%    I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)+2)=255;
%    I(PIP(r,1)-2,PIP(r,2)-2:PIP(r,2)+2)=255;
%    I(PIP(r,1)+2,PIP(r,2)-2:PIP(r,2)+2)=255;
% end
% sort_PIP=sort(PIP);
% search=sort_PIP(floor(size(sort_PIP,1)/2),1);
% [r,c]=find(search==PIP(:,1),1);
% temp=[1:size(mask_F,2)];
% plot(temp,PIP(r,1),'c*');
% %figure,imshow(uint8(I));
%% Eroding / FIlling
%     b_mask_F=im2bw(mask_F);
%     se = strel('disk',11);        
%     e_mask_F = imerode(b_mask_F,se);
%     imshow(mask_F/255);title('AFTER THRESHOLDING');figure, imshow(e_mask_F);title('ERODED MASK');
%     eroded=double(e_mask_F).*I_F_n;
%     figure();imshow(eroded/255);title('Image after Eorsion');
%     fill_mask_F=imfill(eroded,'holes');
%     figure();imshow(fill_mask_F/255);title('Image after Filling');


