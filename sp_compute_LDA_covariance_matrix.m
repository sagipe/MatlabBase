function [coeff variances score] = sp_compute_LDA_covariance_matrix(training, group)
% function [coeff variances score] = sp_compute_LDA_covariance_matrix(training, group)
%
% Computes the coefficients and variances (eigenvalues of X0'*x0./(n-1), same as latent in princomp())
% based on the covariance matrix used by LDA for classification
% Use the same inputs as you would for classify(...) with type 'linear' .
% 
% LDA computes the covariance matrix the same way as PCA, but subtracts a specific mean from every sample:
% (*) PCA subtracts the overall mean (across all samples) such as bsxfun(@minus,x,mean(x,1))
% (*) LDA computes a mean vector for all features, for every _group_. 
%     The specific group mean from every training sample is subtracted to calculate the covariance matrix
%
% INPUTS:
% training
% group
%
% OUTPUTS:
% coeff
% variances
%
% Sagi Perel, 03/2012


if nargin < 2
    error('sp_compute_LDA_covariance_matrix: wrong number of input arguments provided');
end

% grp2idx sorts a numeric grouping var ascending, and a string grouping
% var by order of first occurrence
[gindex,groups,glevels] = grp2idx(group);
nans = find(isnan(gindex));
if ~isempty(nans)
    training(nans,:) = [];
    gindex(nans) = [];
end
ngroups = length(groups);
gsize = hist(gindex,1:ngroups);
nonemptygroups = find(gsize>0);
nusedgroups = length(nonemptygroups);
if ngroups > nusedgroups
    warning(message('stats:classify:EmptyGroups'));

end

[n,d] = size(training);
if size(gindex,1) ~= n
    error(message('stats:classify:TrGrpSizeMismatch'));
end

gmeans = NaN(ngroups, d);
for k = nonemptygroups
    gmeans(k,:) = nanmean(training(gindex==k,:),1);
end

if n <= nusedgroups
    error(message('stats:classify:NTrainingTooSmall'));
end
% Pooled estimate of covariance.  Do not do pivoting, so that A can be
% computed without unpermuting.  Instead use SVD to find rank of R.

% classify uses the following code to compute the covariance matrix, which results
% in very similar results to the code in princomp
% We'll stick to the code in princomp since it's shorter
% [~,R] = qr(training - gmeans(gindex,:), 0);
% R = R / sqrt(n - nusedgroups); % SigmaHat = R'*R
% s = svd(R);
% if any(s <= max(n,d) * eps(max(s)))
%     error(message('stats:classify:BadLinearVar'));
% end

% remove NaNs from training
nan_lidx = any(isnan(training),2);
[U,sigma,coeff] = svd(training(~nan_lidx,:) - gmeans(gindex(~nan_lidx),:),0);% put in 1/sqrt(n-1) later

sigma = diag(sigma);
if(nargout>2)
    score = bsxfun(@times,U,sigma');
end
sigma = sigma ./ sqrt(n - nusedgroups); % princomp uses 1/sqrt(n-1), classify uses 1/sqrt(n - nusedgroups), so stick with classify

% The variances of the pc's are the eigenvalues of S = X0'*X0./(n-1).
variances = sigma.^2;

% Enforce a sign convention on the coefficients -- the largest element in each
% column will have a positive sign.
[n,p] = size(training);
[~,maxind] = max(abs(coeff),[],1);
d = size(coeff,2);
colsign = sign(coeff(maxind + (0:p:(d-1)*p)));
coeff = bsxfun(@times,coeff,colsign);
if(nargout > 2)
    score = bsxfun(@times,score,colsign);
end




        