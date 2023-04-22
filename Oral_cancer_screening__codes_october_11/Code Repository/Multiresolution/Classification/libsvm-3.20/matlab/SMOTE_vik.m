function  Syn_data = SMOTE_vik(data,N,K)
rng('default');
n_dim = size(data,2);
n_samples = size(data,1);
i=1;
all_dist = pdist(data);
Dist_mat = squareform(all_dist);

Dist_mat(Dist_mat==0) = inf;

Syn_data = zeros(n_samples*N,n_dim);
for s=1:n_samples
[~,idx] = sort(Dist_mat(s,:));

for no_of_points=1:N    
    k = randperm(K,1);
    gap = rand(1,n_dim);
    diff = data(idx(k),:) - data(s,:);
    Syn_data(i,:) = data(s,:) + gap.*diff;
    i=i+1;
end       
   
end
end

