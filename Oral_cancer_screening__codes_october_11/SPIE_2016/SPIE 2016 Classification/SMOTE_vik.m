% =========================== SMOTE_vik.m ====================================== %
% Description  :
% Generates Synthetic samples for minority class
%    

% 
%
% ================================================================================== %
% Input Parameters : data    
%                    N   --> factor by which orignal data needs to be oversampled
%                    
%                    K   --> Number of nearest neighbour
%                    
%                    
%                    
%------------------------------------------------------------------------------------%  
% Output parameter: Syn_data       --> oversampled data
%                   
%------------------------------------------------------------------------------------%
% Subroutine  called : 
%   #1: classification
% Called by :  GT_PN_k.mmeans1D_hard_fuzzy
%------------------------------------------------------------------------------------%
% Reference:    
%


% Author of the code: Vikrant Karale
% Date of creation :    
% ------------------------------------------------------------------------------------------------------- %
% Modified on :   
% Modification details:    
% Modified By : 
% ===================================================================== %
%        Copy righted by E&ECE Department, IIT Kharagpur, India.
% ===================================================================== %



function  Syn_data = SMOTE_vik(data,N,K)

n_dim = size(data,2); % dimension of the data
n_samples = size(data,1); % no of instance
i=1;
all_dist = pdist(data); % distance between pairwise data
Dist_mat = squareform(all_dist);

Dist_mat(Dist_mat==0) = inf;

Syn_data = zeros(n_samples*N,n_dim);
for s=1:n_samples
[~,idx] = sort(Dist_mat(s,:)); % finding the index of the sorted distance

for no_of_points=1:N    
    k = randperm(K,1);
    gap = rand(1,n_dim);
    diff = data(idx(k),:) - data(s,:);
    Syn_data(i,:) = data(s,:) + gap.*diff; %synthetic data
    i=i+1;
end       
   
end
end

