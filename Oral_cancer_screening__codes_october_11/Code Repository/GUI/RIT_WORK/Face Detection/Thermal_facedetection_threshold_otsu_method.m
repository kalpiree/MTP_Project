%%
clear;
clc;
close all;

%% Load the contents of the folder
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal\');
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%% Face Extraction
for folder_idx=12:no_dir
disp(nameFolds(folder_idx)); 
%close all;
    % Frontal Face
    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
%    I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
   
    int_F=(255/(max(max(I_F))-min(min(I_F))))*[I_F-min(min(I_F))]; % Map the temperature variations bet 0 and 255
    int_F=int_F/255; % Normalizing bet 0 and 1
%     level = graythresh(int_F); % fINDING THE GLOBAL THRESHOLD USING OTSU METHOD
%     BW = im2bw(int_F,level); 
%     mask_F=int_F.*double(BW); % Extracting the face
%     figure();
  % imshow(int_F);
%% 
%    mask_F_new=mask_F.* double(mask_F>0.7);
%    imshow(mask_F);
%    figure,imshow(mask_F_new);
%  
%% 
   B=imgaussfilt(int_F);
figure();imshow(B);     

     
%       mask_F=mask_F*255;
      temp=1:480;
      for j=1:640
          Ph_x(j)=sum(B(:,j));
      end
     Fx_x=gradient(Ph_x);
     a1=max(Fx_x);
     a2=min(Fx_x);
     r1=find(Fx_x==a1);
     r2=find(Fx_x==a2);
     hold on;
     plot(r1,temp,'c*');
     plot(r2,temp,'c*');
     int_F_ver=B(:,(r1:r2));
    temp1=1:640;
      for k=1:480
          Ph_y(k)=sum(int_F_ver(k,:));
      end
     Fx_y=gradient(Ph_y);
     a1y=max(Fx_y);
     a2y=min(Fx_y);
     c1y=find(Fx_y==a1y);
     c2y=find(Fx_y==a2y);
     hold on;
     plot(temp,c1y,'c*');
     plot(temp,c2y,'c*');
     int_F_hor=int_F_ver((c1y:c2y),:);
     figure();
imshow(int_F_ver);
figure();
imshow(int_F_hor);
%%
%     mask_F=mask_F/255;
%     figure();
%     imshow(mask_F*255);
%     for i=1:640
%         Ph_x(i)=sum(mask_F(:,i));
%     end
%     mask_F=mask_F*255;
%     temp=1:480;
%     Fx_x=gradient(Ph_x);
%     a1=max(Fx_x);
%     a2=min(Fx_x);
%     r1=find(Fx_x==a1);
%     r2=find(Fx_x==a2);
%    % hold on;
%    % plot(r1,temp,'c*');
%    % plot(r2,temp,'c*');
%     for i=1:480
%         Ph_y(i)=sum(mask_F(i,:));
%     end
%     temp=1:size(mask_F,2);
%     Fx_y=gradient(Ph_y);
%     a1=max(Fx_y);
%     %a2=min(Fx_y);
%     %c2=find(Fx_y==a2);
%     c1=find(Fx_y==a1);
%     %plot(temp,c1,'b--o');
%     %plot(temp,c2,'b--o');
%     I_new=[];
%     for i=1:480
%        for j=1:640
%            if(j>=r1 && j<=r2 ) 
%                I_new(i,j)=mask_F(i,j);
%            else 
%                I_new(i,j)=0;
%            end
%        end
%     end
%     figure();
%     imshow(I_new);
%%  
%     Fx_x_min=[];
%     Fx_x_max=[];
%     [r,c]=find(int_F>0);
%      for i=min(c):max(c)
%         if(find(i==c))
%          temp=min(find(c==i));
%          j=[r(temp):480];
%          mask_temp=int_F(j(:),i);
%          Fx=gradient(mask_temp);
%          Fx_x_max(i)=min(r(temp)+find(Fx==max(Fx)));  
%          Fx_x_min(i)=min(r(temp)+find(Fx==min(Fx)));  
%         end
%      end
%          temp=[1:640];
%          a1=max(Fx_x_min);
%          a2=a1;
%          for i=1:size(Fx_x_max,2)
%              if(Fx_x_max(i)~=0)
%                  if(a2>Fx_x_max(i))
%                      a2=Fx_x_max(i);
%                  end
%              end
%          end
%          r1=r(min(find(Fx_x_min==a1)));
%          r2=a2;
%          hold on;
%          plot(temp,r1,'c*');
%          plot(temp,r2,'c*');
    %%
%         [y,x]=find(I_new>0);
%      ellipse=fit_ellipse(x,y);
%      if(ellipse.a>ellipse.b)
%          a_ellipse=ellipse.X0_in+ellipse.b;
%          a_ellipse_minus=ellipse.X0_in-ellipse.b;
%          b_ellipse_minus=ellipse.Y0_in-ellipse.a;
%          b_ellipse=ellipse.Y0_in+ellipse.a;
%      else
%          a_ellipse=ellipse.X0_in+ellipse.a;
%          a_ellipse_minus=ellipse.X0_in-ellipse.a;
%          b_ellipse_minus=ellipse.Y0_in-ellipse.b;
%          b_ellipse=ellipse.Y0_in+ellipse.b;
%      end
%      x1=a_ellipse;
%      x2=a_ellipse_minus;
%      y1=ellipse.Y0_in;
%      y2=ellipse.Y0_in;
%      x3=ellipse.X0_in;
%      x4=ellipse.X0_in;
%      y3=b_ellipse;
%      y4=b_ellipse_minus;
%      a = 1/2*sqrt((x2-x1)^2+(y2-y1)^2);
%      b = 1/2*sqrt((x3-x4)^2+(y3-y4)^2);
%      t=linspace(0,2*pi);
%      X=a*cos(t);
%      Y=b*sin(t);
%      w = atan2(y2-y1,x2-x1);
%      x = (x1+x2)/2 + X*cos(w) - Y*sin(w);
%      y = (y1+y2)/2 + X*sin(w) + Y*cos(w);
%      hold on;
%      plot(x,y,'r-')
%      axis equal
%      hold on;
%      plot(ellipse.X0_in,ellipse.Y0_in,'*');
%      axis equal;

end