function [X_norm,min_data,max_data] = minmax_featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   where data is between 0 and 1.
% You need to set these values correctly


% ====================== YOUR CODE HERE ======================
min_data = min(X);
max_data = max(X);
% X_norm= (X-min_data) / ( max_data- min_data );
range=max_data-min_data;
X_norm = bsxfun(@minus, X, min_data);
X_norm = bsxfun(@rdivide, X_norm, range);







% ============================================================

end
