function [X_norm,mu,sigma] = featureNormalize_test(X,mu_train,sigma_train)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.

% You need to set these values correctly
X_norm = X;
mu = mu_train;
sigma = sigma_train;

% ====================== YOUR CODE HERE ======================
% Instructions: First, for each feature dimension, compute the mean
%               of the feature and subtract it from the dataset,
%               storing the mean value in mu. Next, compute the 
%               standard deviation of each feature and divide
%               each feature by it's standard deviation, storing
%               the standard deviation in sigma. 
%
%               Note that X is a matrix where each column is a 
%               feature and each row is an example. You need 
%               to perform the normalization separately for 
%               each feature. 
%
% Hint: You might find the 'mean' and 'std' functions useful.
%       
% mu=mean(X);
% sigma=std(X);
% for i=1:size(X,2)
%     sub=ones(size(X,1),1)*mu(i);
%     Xnorm(:,i)=(X_norm(:,i)-sub)/sigma(i);
% end
% mu = mean(X);
X_norm = bsxfun(@minus, X, mu);

% sigma = std(X_norm);
X_norm = bsxfun(@rdivide, X_norm, sigma);







% ============================================================

end
