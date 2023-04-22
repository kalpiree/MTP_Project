% =========================== find_optimum_clust_fcm.m ====================================== %
% Description  :This function calculates the optimal clusters required for the
%given data set , this is calculated by finding the interclass variance and intraclass
%variance for each cluster. cluster number for which interclass variance is max
% and intra class variance is minimum that is the optimal cluster number
%
%
%
% ================================================================================== %
% Input Parameters : X == Feature vector
%                    no_of_cluster == Max no. of clusters
%                    options == initializations for the clustering function
%------------------------------------------------------------------------------------%
% Output parameter: optimum_cluster_fcm == Ideal no. of clusters required
%------------------------------------------------------------------------------------%
% Subroutine  called :
%   #1: classification
% Called by :  GT_PN_k.mmeans1D_hard_fuzzy
%------------------------------------------------------------------------------------%
% Reference:
%
%[1] https://www.andrew.cmu.edu/user/skolouri/Presentations/DiscAnalysis.pdf

% Author of the code: Manashi Chakraborty
% Date of creation :
% ------------------------------------------------------------------------------------------------------- %
% Modified on :
% Modification details:
% Modified By :  Manashi Chakraborty
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %
function[optimum_cluster_fcm]= find_optimum_clust_fcm(X,no_of_cluster,options)

close all;
rng('default');  % For reproducibility



cost=zeros(no_of_cluster,1);
costplot=zeros(no_of_cluster,1);
for current_no_of_cluster=2:no_of_cluster
    
    [Center,U] = fcm(X,current_no_of_cluster,options);
    [~,idx]=max(U);
    S=cell(1,current_no_of_cluster);
    SW=zeros(size(X,2));
    
    
    for i=1:current_no_of_cluster
        X_i = X( idx == i,:);
        SW=SW+ ((X_i-repmat(Center(i,:),size(X_i,1),1))'*(X_i-repmat(Center(i,:),size(X_i,1),1))); % within class scatter
    end
    
    SW=SW/size(X,1); %within class scatter
    
    mu_global=mean(X);
    
    SB=zeros(size(X,2));
    
    for j=1:current_no_of_cluster
        
        
        SB=SB+ (((Center(j,:)-mu_global)'*(Center(j,:)-mu_global)).*sum(idx==j));
    end
    
    SB=SB/size(X,1); %between class scatter
    maximization_term=trace(inv(SW)*SB); %within class scatter is desired to be min and between class scatter max
    cost(current_no_of_cluster)=(maximization_term);
    costplot(current_no_of_cluster)=1/cost(current_no_of_cluster);%cost function
end

total_no_of_cluster=2:no_of_cluster;
data_cost=costplot(2:end);

f = fit(total_no_of_cluster',data_cost, 'exp2') ; %smooths the function of cost

f_values = feval(f, total_no_of_cluster) ; %evaluates f at given values of n_cluster

d2 = diff(f_values, 2) ;% double differentiation
%
% figure, scatter(total_no_of_cluster,costplot(2:end));xlabel('No of Cluster');ylabel('Cost Function');
% hold on;
% plot (f,total_no_of_cluster,data_cost')

idx=find( (d2 < 0.001));
idx= sort(idx);
idx=idx(1)-2;
optimum_cluster_fcm=total_no_of_cluster(idx);
