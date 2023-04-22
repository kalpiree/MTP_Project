%% Main Code for Face Detection
% close all
clear all
clc
%% Fetch the Index Numbers of the Malignant Patients
%d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Normal'); % Reading Dir of the Specified Folder
d = dir('E:\Suraj Kiran\Suraj_Intern\Edited\Malignant'); % Reading Dir of the Specified Folder
%d = dir('F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant'); % Reading Dir of the Specified Folder
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}';
nameFolds=nameFolds(3:end);
no_dir=numel(nameFolds);
%%
for folder_idx=62:no_dir
     close all;
%     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Normal\',nameFolds{folder_idx},'\','Jpeg','\',nameFolds{folder_idx},'.csv']);
     I_F=xlsread(['E:\Suraj Kiran\Suraj_Intern\Edited\Malignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
%    I_F=xlsread(['F:\MS\matlab_code\WORK\ThermalDatabase_OOC\NonMalignant\',nameFolds{folder_idx},'\',nameFolds{folder_idx},'.csv']);
      [BW_mask_F,mask_F]=(face_detect( I_F ));
      I_F=mat2gray(I_F);
      face_img=adapthisteq(I_F).*double(BW_mask_F);
%        face_img=(I_F).*double(BW_mask_F);
%       face_img=adapthisteq(face_img);
      figure,imshow(face_img);
      Pv=[];
      Ph=[];
     [row,col]=find (face_img>0);
     rmin=min(row);
     cmin=min(col);
     rmax=max(row);
     cmax=max(col);
     cmid=ceil((cmax+cmin)/2);
     
     
     c1=face_img(:,cmid);
     c2=face_img(:,cmid+15);
     c3=face_img(:,cmid-15);
     find_c1=find(c1>0.75);
     if isempty(find_c1)==isempty([])
        find_c1=rmin;
     end   
     find_c1=find_c1(1);
     find_c2=find(c2>0.75);
     if isempty(find_c2)==isempty([])
        find_c2=find_c1;
     end 
     find_c2=find_c2(1);
     find_c3=find(c3>0.75);
      if isempty(find_c3)==isempty([])
        find_c3=find_c2;
     end 
     find_c3=find_c3(1);
     r_eye_reigon_max=ceil((rmax-rmin)*(1/2.5))+rmin;
    % r_eye_reigon_max=ceil((rmax-rmin)*(1/2.5))+rmin;
    
     [req_c,index]=max([find_c1,find_c2,find_c3]);
     
   if(index==1)
     if req_c ~= rmin:(r_eye_reigon_max)
        [req_c,index]=max([find_c2,find_c3]);
        if(index==1)
        req_c=find_c2;
        end
        if(index==2)
        req_c=find_c3;
        end
     end
   end
   if(index==2)
     if req_c ~= rmin:(r_eye_reigon_max)
        [req_c,index]=max([find_c1,find_c3]);
        if(index==1)
        req_c=find_c1;
        end
        if(index==2)
        req_c=find_c3;
        end
     end
   end
if(index==3)
     if req_c ~= rmin:(r_eye_reigon_max)
        [req_c,index]=max([find_c1,find_c2]);
        if(index==1)
        req_c=find_c1;
        end
        if(index==2)
        req_c=find_c2;
        end
     end
   end

   
   
   
   if req_c ~= rmin:(rmin+5)
        rmin=req_c;
        r_eye_reigon_max=ceil((rmax-rmin)*(1/2.5))+rmin;
     end   
     
      r_eye_reigon_min=ceil(rmin+(0.2*rmin));
     r_eye_reigon_max=ceil((rmax-rmin)*(1/2.5))+rmin;
     
     
      for i= r_eye_reigon_max:-1:(r_eye_reigon_min+30)
       Ph1(i)=sum(face_img(i,cmin:cmax));
      end
      Ph=Ph1(r_eye_reigon_max:-1:(r_eye_reigon_min+30));
      Fx=gradient(Ph);
      a2=find(abs(Fx)==max(abs(Fx)));
      r_find_eye_max=a2(1)+r_eye_reigon_min+10;
%       a1=find(abs(Fx)==min(abs(Fx)));
%       r_find_eye_min=a1(1)+r_eye_reigon_min;
      
      
      
      for i=r_eye_reigon_min:(r_eye_reigon_max-30) 
       Ph1min(i)=sum(face_img(i,cmin:cmax));
      end
      Phmin=Ph1min(r_eye_reigon_min:end);
      Fxmin=gradient(Phmin);
%       a2=find(abs(Fx)==max(abs(Fx)));
%       r_find_eye_max=a2(1)+r_eye_reigon_min;
      a1=find(abs(Fxmin)==min(abs(Fxmin)));
      r_find_eye_min=a1(1)+r_eye_reigon_min+20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       a=find(Ph==max(Ph))
%        r_find_eye_max1=a(1)+rmin;
%        b=find(Ph==min(Ph))
%        r_find_eye_min1=b(1)+rmin;
% 
% 
%     
%      for i=cmin:cmax
%         Pv(i)=sum(face_img(:,i));
%      end
%     Fy=gradient(Pv);
%     
%      c_find_eye_max=find(Fy==max(Fy))+cmin;
%      c_find_eye_min=find(Fy==min(Fy))+cmin;
%      
      temp=[1:size(face_img,2)];
      temp1=[1:size(face_img,1)];
      figure();
      imshow(face_img);title('Find eye');
     hold on;
%     plot(temp,r_find_eye_max,'c*');
   plot(temp,r_eye_reigon_min,'c*');
     hold on;
%     plot(temp,r_find_eye_min,'c*');
%     hold on;
 plot(temp,r_eye_reigon_max,'c*');
 
 eye_reigon=face_img(r_eye_reigon_min:r_eye_reigon_max,cmin:cmax);
 rt_eye=eye_reigon(1:(r_eye_reigon_max-r_eye_reigon_min),1:(cmid-cmin));
 lt_eye=eye_reigon(1:(r_eye_reigon_max-r_eye_reigon_min),(cmid+1-cmin):(cmax-cmin));
 figure();
 subplot(1,2,1);imshow(rt_eye);title(nameFolds(folder_idx));
 subplot(1,2,2);imshow(lt_eye);
 
 
     
%       
%       plot(temp,r_find_eye_max1,'r*');
%      hold on;
%       plot(temp,r_find_eye_min1,'r*');
% %      plot(c_find_eye_max,temp1,'c*');
% %       hold on;
% %      plot(c_find_eye_min,temp1,'c*');
%     
    
end