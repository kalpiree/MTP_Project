% =========================== GT_MN_kmeans_fuzzy.m ====================================== %
% Description  :
%Finds optimum cluster for k menas
%
%
%
% ================================================================================== %
% Input Parameters : X    --> Nxd data, N: no of instances, d: dimension
%                   no_of_cluster --> maximum no of cluster
%------------------------------------------------------------------------------------%
% Output parameter: optimum_cluster_kmeans
%------------------------------------------------------------------------------------%
% Subroutine  called :
%
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


function[optimum_cluster_kmeans]= find_optimum_clust_kmeans(X,no_of_cluster)

close all;
rng('default');  % For reproducibility



cost=zeros(no_of_cluster,1);
costplot=zeros(no_of_cluster,1);
for current_no_of_cluster=2:no_of_cluster
    
    [idx,Center] = kmeans(X,current_no_of_cluster);
    S=cell(1,current_no_of_cluster);
    SW=zeros(size(X,2));
    
    
    for i=1:current_no_of_cluster
        X_i = X( idx == i,:);
        SW=SW+ ((X_i-repmat(Center(i,:),size(X_i,1),1))'*(X_i-repmat(Center(i,:),size(X_i,1),1)));
    end
    
    SW=SW/size(X,1);
    
    mu_global=mean(X);
    
    SB=zeros(size(X,2));
    
    for j=1:current_no_of_cluster
        
        
        SB=SB+ (((Center(j,:)-mu_global)'*(Center(j,:)-mu_global)).*sum(idx==j));
    end
    
    SB=SB/size(X,1);
    maximization_term=trace(inv(SW)*SB);
    cost(current_no_of_cluster)=(maximization_term);
    costplot(current_no_of_cluster)=1/cost(current_no_of_cluster);
end

total_no_of_cluster=2:no_of_cluster;
data_cost=costplot(2:end);

% data_fit=[data_cost,total_no_of_cluster'];
f = fit(total_no_of_cluster',data_cost, 'exp2') ; %smooths the function of cost

f_values = feval(f, total_no_of_cluster);  %evaluates f at given values of n_cluster

d2 = diff(f_values, 2); % double differentiation

% figure, scatter(total_no_of_cluster,costplot(2:end));xlabel('No of Cluster');ylabel('Cost Function');
% hold on;
% plot (f,total_no_of_cluster,data_cost')

idx=find( (d2 < 0.001));
idx= sort(idx);
idx=idx(1)-2;
optimum_cluster_kmeans=total_no_of_cluster(idx);
