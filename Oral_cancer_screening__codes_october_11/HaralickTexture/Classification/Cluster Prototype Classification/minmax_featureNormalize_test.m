function [X_norm] = minmax_featureNormalize_test(X,min_data,max_data)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   where data is between 0 and 1.
% You need to set these values correctly


% ====================== YOUR CODE HERE ======================
range=max_data-min_data;
X_norm = bsxfun(@minus, X, min_data);
X_norm = bsxfun(@rdivide, X_norm, range);








% ============================================================

end
