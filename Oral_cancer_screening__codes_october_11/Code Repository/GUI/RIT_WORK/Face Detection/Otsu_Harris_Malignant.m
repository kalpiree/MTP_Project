%%
close all
clear all

%% Fetch the Index Numbers of the Malignant Patients
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=1:no_dir
    close all;
    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
    I_F_n=((I_F-min(I_F(:)))/(max(I_F(:))-min(I_F(:))))*255;
    level = graythresh(I_F_n/255);
    BW = im2bw(I_F_n/255,level);
%    figure();
    mask_F=I_F_n.*double(BW);
%    imshow(mask_F/255);
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
   
     %figure();
    %imshow(I_new/255);
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
xmax=480;

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
   
%    figure,imshow(uint8(I))
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
    