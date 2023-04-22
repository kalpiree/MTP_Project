
%%
clear;
clc;
%close all;

%% Load the contents of the folder
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal\');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%% Face Extraction
for folder_idx=1:no_dir
% disp(nameFolds(folder_idx)); 
close all;
    % Frontal Face
    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
    I_F_u=(255/(max(max(I_F))-min(min(I_F))))*[I_F-min(min(I_F))]; % Map the temperature variations bet 0 and 255
   % I_F_u=uint8(I_F);
    [level,criterion]=kittlerMinimimErrorThresholding(I_F_u);
    BW = im2bw(I_F_u/255,level/255); 
    mask_F=I_F_u.*double(BW); % Extracting the face
    figure();
    imshow(mask_F/255);
    [level_mask,criterion_mask]=kittlerMinimimErrorThresholding(mask_F);
    BW_mask = im2bw(mask_F/255,level_mask/255); 
    mask_mask_F=mask_F.*double(BW_mask); % Extracting the face
%     figure();
%     imshow(mask_mask_F/255);
%%
 Ph=[];
    Pv=[];
     for i=1:floor((1/3)*size(mask_F,1))
        Ph(i)=sum(mask_F(i,:));
     end
%     mask_F(450:end,:)=0;
    Fx=gradient(Ph);
    r_row=find(Fx==max(Fx));
    temp=[1:size(mask_F,2)];
    imshow(mask_F/255);title(nameFolds{folder_idx});
    hold on;
    plot(temp,r_row,'c*');


%     for i=(floor((1/3.05)*size(mask_F,2))):floor((1/1.2)*size(mask_F,2))
%         Pv(i)=sum(mask_F(:,i));
%     end
    for i=1:size(mask_F,2)
        Pv(i)=sum(mask_F(:,i));
    end
    Fy=gradient(Pv);
    c1=find(Fy==max(Fy));
    temp=[1:size(mask_F,1)];
     hold on;
     plot(c1-5,temp,'c*');
    c2=find(Fy==min(Fy));
    temp=[1:size(mask_F,1)];
     plot(c2+5,temp,'c*');
    %     
%     [y,x]=find(mask_F>0);
%     ellipse=fit_ellipse(x,y);
%      if(ellipse.a>ellipse.b)
%      a_ellipse=ellipse.X0_in+ellipse.b;
%      a_ellipse_minus=ellipse.X0_in-ellipse.b;
%      b_ellipse_minus=ellipse.Y0_in-ellipse.a;
%      b_ellipse=ellipse.Y0_in+ellipse.a;
%      else
%      a_ellipse=ellipse.X0_in+ellipse.a;
%     a_ellipse_minus=ellipse.X0_in-ellipse.a;
%      b_ellipse_minus=ellipse.Y0_in-ellipse.b;
%      b_ellipse=ellipse.Y0_in+ellipse.b;
%      end
% % %     c=[];
% % %     c1=[];
% % %     for r=a_ellipse_minus:a_ellipse
% % %         c=[c b_ellipse*(sqrt(1-(r^2/a_ellipse^2)))];
% % %     end
% % %     r=[a_ellipse_minus:a_ellipse];
% % %     hold on;
% % %     plot(r,c,'r','Linewidth',3);
% % %     r=[];
% % %     for c=ellipse.Y0:-1:b_ellipse_minus
% % %         r=[r a_ellipse*(sqrt(1-(c^2/b_ellipse^2)))];
% % %     end
% % %     c=[ellipse.Y0:-1:b_ellipse_minus];
% % %     hold on;
% % %     plot(r,c,'r','Linewidth',3);
% % %     hold on;
% % %     plot(ellipse.X0_in,ellipse.Y0_in,'*');
% % %     
%  x1=a_ellipse;
%  x2=a_ellipse_minus;
%  y1=ellipse.Y0_in;
%  y2=ellipse.Y0_in;
%  x3=ellipse.X0_in;
%  x4=ellipse.X0_in;
%  y3=b_ellipse;
%  y4=b_ellipse_minus;
%  a = 1/2*sqrt((x2-x1)^2+(y2-y1)^2);
%  b = 1/2*sqrt((x3-x4)^2+(y3-y4)^2);
%  t=linspace(0,2*pi);
%  X=a*cos(t);
%  Y=b*sin(t);
%  w = atan2(y2-y1,x2-x1);
%  x = (x1+x2)/2 + X*cos(w) - Y*sin(w);
%  y = (y1+y2)/2 + X*sin(w) + Y*cos(w);
%  hold on;
%   plot(x,y,'r-')
%   axis equal
%  hold on;
%  plot(ellipse.X0_in,ellipse.Y0_in,'*');
%    
%     
%     
%     
%     
%     
%     
%     
%     
% %     a = mask_F*255;
% %           bw = a > 200;
% % ch=bwconvhull(bw);
% % imshow(bw);title('BW image');
% % figure();
% % imshow(mask_F);title('mask_F');
% % mask_new=mask_F.*double(ch);
% % figure();imshow(mask_new);title('New Mask');
% % figure();
% % imshow(ch);title('Convex Hull');
% %     % Right Profile
% %     I_R=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_rt.csv']);
% %     int_R=(255/(max(max(I_R))-min(min(I_R))))*[I_R-min(min(I_R))];
% %     int_R=int_R/255;
% %     level = graythresh(int_R);
% %     BW = im2bw(int_R,level); 
% %     mask_R=int_R.*double(BW);
% %     figure();
% %     imshow(mask_R);
% %     % Left Profile
% %     I_L=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'_lt.csv']);
% %     int_L=(255/(max(max(I_L))-min(min(I_L))))*[I_L-min(min(I_L))];
% %     int_L=int_L/255;
% %     level = graythresh(int_L);
% %     BW = im2bw(int_L,level); 
% %     mask_L=int_L.*double(BW);
% %     figure();
% %     imshow(mask_L);
%     
%%
  %% 
    % Harris detector
% The code calculates
% the Harris Feature Points(FP) 
% 
% When u execute the code, the test image file opened
% and u have to select by the mouse the region where u
% want to find the Harris points, 
% then the code will print out and display the feature
% points in the selected region.
% You can select the number of FPs by changing the variables 
% max_N & min_N
% A. Ganoun
% 
 I =double(mask_F);
%I=I_F_n;
%****************************

% k = waitforbuttonpress;
% point1 = get(gca,'CurrentPoint');  %button down detected
% 
% point2 = get(gca,'CurrentPoint');%%%%button up detected
% rectregion = rbbox;  %%%return figure units
% point1 = point1(1,1:2); %%% extract col/row min and maxs
% point2 = point2(1,1:2);
% lowerleft = min(point1, point2);
% upperright = max(point1, point2); 
% ymin = round(lowerleft(1)); %%% arrondissement aux nombrs les plus proches
% ymax = round(upperright(1));
% xmin = round(lowerleft(2));
% xmax = round(upperright(2));
ymin = c1; %%% arrondissement aux nombrs les plus proches
ymax = c2;
[row,col]=find (mask_F>0);
rmin=min(row);
xmin = round(2/3*(size(I_F,1)-rmin))+rmin;
% xmax=size(mask_F,1);
xmax=430;

%***********************************
Aj=0;
cmin=xmin-Aj; cmax=xmax+Aj; rmin=ymin-Aj; rmax=ymax+Aj;
min_N=12;max_N=16;
%%%%%%%%%%%%%%Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma=2; Thrshold=20; r=6; disp=1;
dx = [-1 0 1; -1 0 1; -1 0 1]; % The Mask 
    dy = dx';
    %%%%%% 
    Ix = conv2(I(cmin:cmax,rmin:rmax), dx, 'same');   
    Iy = conv2(I(cmin:cmax,rmin:rmax), dy, 'same');
    g = fspecial('gaussian',max(1,fix(6*sigma)), sigma); %%%%%% Gaussien Filter
    
    %%%%% 
    Ix2 = conv2(Ix.^2, g, 'same');  
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g,'same');
    %%%%%%%%%%%%%%
    k = 0.04;
    R11 = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;
    R11=(1000/max(max(R11)))*R11;
    R=R11;
    ma=max(max(R));
    sze = 2*r+1; 
    MX = ordfilt2(R,sze^2,ones(sze));
    R11 = (R==MX)&(R>Thrshold); 
    count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));
    
    
    loop=0;
    while (((count<min_N)|(count>max_N))&(loop<30))
        if count>max_N
            Thrshold=Thrshold*1.5;
        elseif count < min_N
            Thrshold=Thrshold*0.5;
        end
        
        R11 = (R==MX)&(R>Thrshold); 
        count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));
        loop=loop+1;
    end
    
    
	R=R*0;
    R(5:size(R11,1)-5,5:size(R11,2)-5)=R11(5:size(R11,1)-5,5:size(R11,2)-5);
	[r1_new,c1_new] = find(R);
    PIP=[r1_new+cmin,c1_new+rmin]%% IP 
   

   %%%%%%%%%%%%%%%%%%%% Display
   
   Size_PI=size(PIP,1);
   for r=1: Size_PI
   I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)-2)=255;
   I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)+2)=255;
   I(PIP(r,1)-2,PIP(r,2)-2:PIP(r,2)+2)=255;
   I(PIP(r,1)+2,PIP(r,2)-2:PIP(r,2)+2)=255;
   
   end
   
    figure,imshow(uint8(I))
   %%
    for i=1:size(mask_F,1)
        for j=1:size(mask_F,2)
            max_pip=max(PIP(:,1));
         if(j>(c1-5) && j<(c2+5) && (i>r_row) && (i<max_pip))   %FRONTAL
         %   if(j<c2)       %lEFT
%             if(j>c1)       %right
                I_new(i,j)=mask_F(i,j);
            else
                I_new(i,j)=0;
            end
        end
    end
     figure,imshow(uint8(I_new))
end