% ================= PrecisionAndRecallAtAllNtopAndArea.m  =============== %
% Description  : 

% Determination of average percentage recall, average percentage precision
% and area under the Precisition-Recall curve (PR-curve).
% ====================================================================================%
% Input parameter :  
%       D=Distance matrix
%       N_RELEVANT = No. of relevant images for each image    
% Output parameter:  
%       AR =  Average percentage recall
%       AP =  Average percentage precision
%       Area = Area under the PR-curve
% Subroutine  called : None
% Called by :  
%       AreaOfPrecisionVsRecallCurve
% Reference:    

% Author of the code:  Rahul Das Gupta  
% Date of creation :    11-04-2011
% ------------------------------------------------------------------------------------------------------- %
% Modified on :    12-03-2016
% Modification details:    
% Modified By :   Rahul Das Gupta 
% ===================================================================== %
%   Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
function [AR,AP,Area] = PrecisionAndRecallAtAllNtopAndArea(D,N_Class)

N=size(D,1);
N_PER_CLASS=N/N_Class;
N_RELEVANT=N_PER_CLASS-1;
R=zeros(1,N);
P=zeros(1,N);
AR=zeros(1,N);
AP=zeros(1,N);  
D1=D;
Stop=0;
n_top=0;

while Stop==0
    n_top=n_top+1;

    for i=1:N
       class_no= ceil(i/N_PER_CLASS);
       D1(i,i)=Inf;
      
       [~,I]=sort(D1(i,:));
       
       Count = sum(I(1:n_top)>=(1+N_PER_CLASS*(class_no-1)) & I(1:n_top)<=(N_PER_CLASS*class_no));
       R(i)=(100*Count)/N_RELEVANT;
       P(i)=(100*Count)/n_top;
    end   
 AR(n_top)=mean(R);
 AP(n_top)=mean(P);  
 if AR(n_top)==100
     L=n_top;
     Stop=1;
 end

end


AR=AR(1:L);
AP=AP(1:L);

Area = sum((AR(2:L)-AR(1:L-1)).*((AP(1:L-1)+AP(2:L))/2));


end

