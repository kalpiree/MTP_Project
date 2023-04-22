% ===================== PrecisionAndRecallValues.m ============================= %
% Description  :

% Generate series of Precision and Recall values to obtain Precision-Recall
% curve (PR-curve).

% ====================================================================================%
% Input parameter :  
%   D = Distance matrix 
%   N_RELEVANT = No. of relevant images. 
% Output parameter:  
%   AR = Series of recall values.
%   AP = Series of precision values.
%
% Subroutine  called : None
%             
% Called by :  PlotAllPrecisionVsRecallCurve_IGMGDH.m
%            
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


function [AR,AP] = PrecisionAndRecallValues(D,N_RELEVANT)


N=size(D,1);
N_PER_CLASS=N_RELEVANT+1;

R=zeros(1,N);
P=zeros(1,N);
AR=zeros(1,N);
AP=zeros(1,N);  

Stop=0;
n_top=0;
D1=D;
for i=1:N
    D1(i,i)=Inf;
end
[~,I]=sort(D1,2);
while Stop==0
    n_top=n_top+1;

    for i=1:N
       class_no= ceil(i/N_PER_CLASS);
          

count = sum(I(i,1:n_top)>=(1+N_PER_CLASS*(class_no-1)) & I(i,1:n_top)<=(N_PER_CLASS*class_no));
       R(i)=(100*count)/N_RELEVANT;
       P(i)=(100*count)/n_top;
    end   
 AR(n_top)=mean(R);
 AP(n_top)=mean(P);  
 if AR(n_top)==100
     L=n_top;
     Stop=1;
 end

end
AR=AR(1:L)/100;
AP=AP(1:L)/100;

end

