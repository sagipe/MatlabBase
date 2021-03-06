function [R,sigma] = sp_corrcov(C,nocheck)
%CORRCOV Compute correlation matrix from covariance matrix.
%   R = CORRCOV(C) computes the correlation matrix R that corresponds to the
%   covariance matrix C, by standardizing each row and column of C using the
%   square roots of the variances (diagonal elements) of C.  C is square,
%   symmetric, and positive semi-definite.  The correlation for a constant
%   variable (zero diagonal element of C) is undefined.
%
%   [R,SIGMA] = CORRCOV(C) computes the vector of standard deviations SIGMA
%   from the diagonal elements of C.
%
%   See also COV, CORR, CORRCOEF, CHOLCOV.

%   R = CORRCOV(C,1) computes the correlation matrix R without checking that C
%   is a valid covariance matrix.

%   Copyright 2007 The MathWorks, Inc. 
%   $Revision: 1.1.8.2 $  $Date: 2010/10/08 17:23:01 $

% before calling corrcov, make sure there are no rows/columns with only
% NaN values in them
all_nan_lidx = all(isnan(C));
[tmp_R, sigma] = corrcov(C(~all_nan_lidx, ~all_nan_lidx));
R = nan(size(C));
R(~all_nan_lidx, ~all_nan_lidx) = tmp_R;