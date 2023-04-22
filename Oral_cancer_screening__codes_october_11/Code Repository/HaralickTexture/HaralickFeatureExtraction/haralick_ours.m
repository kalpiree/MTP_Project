function [fH]  = haralick_ours(Input_slice,GC)

% clc; clear all; close all;
% d=4; theta=135;




[M,N]=size(GC);
 [x,y,v]=find(GC);
 p_xplusy=zeros(1,2*M-2);p_xminusy=zeros(1,M-1);
 for k=0:2*M-2
    p_xplusy(1,k+1)=sum(v(x+y-2==k));
 end
  for k=0:M-1
    p_xminusy(1,k+1)=sum(v(abs(x-y)==k));
  end
  p_x=sum(GC,2);p_y=sum(GC);
 mu_x=mean(p_x);mu_y=mean(p_y);prod_mu = mu_x*mu_y;
 std_x=std(p_x,1);std_y=std(p_y,1);
 if std_x ==0 || std_y ==0
     prod_std = 0;
 else
 prod_std=1/(std_x*std_y);
 end


 Contrast=sum(((x-y).^2).*v);
 Entropy=sum(-v.*log2(v));
 Energy=sum(v.^2);          % also called Angular second moment
 Inverse_diff_moment=sum(v./(1+(x-y).^2));
 Sum_average=sum((x-1+y-1).*v); % Sum_average
 Sum_variance=sum(((x-1+y-1-Sum_average).^2).*v);%Sum_variance
 Sum_entropy=-sum(p_xplusy(p_xplusy>0).*log2(p_xplusy(p_xplusy>0)));
 Sum_squares=sum(((x-1-mean(Input_slice(:))).^2).*v);           % also called variance
 diff_entropy=-sum(p_xminusy(p_xminusy>0).*log2(p_xminusy(p_xminusy>0)));
 diif_variance=sum(((x-1+y-1-Sum_average).^2).*v.*(x>y)); 
 Corellation=prod_std*sum(((x-1).*(y-1).*v-prod_mu));
 hxy=Entropy;
 temp_mat = log2(p_x*p_y); temp_mat(isinf(temp_mat)) = 0;
 hxy1=sum(sum(-GC.*temp_mat));
 hxy2=sum(sum(-(p_x*p_y).*temp_mat));
 hx=sum(-p_x(p_x>0).*log2(p_x(p_x>0)));hy=sum(-p_y(p_y>0).*log2(p_y(p_y>0)));
 inf_measure1=(hxy-hxy1)/max(hx,hy);
 inf_measure2=(1-exp(-2*(hxy2-hxy)))^0.5;
 pr=p_x'.*p_y;
 Q=(GC./repmat(pr,M,1))*GC';

 fH=[Contrast;Entropy;Energy;Inverse_diff_moment;Sum_average;Sum_variance;Sum_entropy;Sum_squares;diff_entropy;diif_variance;Corellation;inf_measure1;inf_measure2];
 end