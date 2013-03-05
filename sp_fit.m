function [y_hat coeffs coeffs_ci gof cfit_obj] = sp_fit(x, y, fitType)
% function [y_hat coeffs coeffs_ci gof cfit_obj] = sp_fit(x, y, fitType)
% 
% Calls Matlab fit() and parses and outputs to make them more useful
% Performs column-wise fits for data
%
% INPUTS:
% x      : [array][Nx1] or [matrix][NxD] with data in columns
% y      : [array][Nx1] or [matrix][NxD] with data in columns
% fitType: [string] 'exp1' etc
%          [anonymous function] or [a fittype object] see fit() for details
%                   
%
% OUTUPTS:
% y_hat    : [array][Nx1] or [matrix][NxD] with fits in columns
% coeffs   : [array][Cx1] with C coefficients OR [matrix][CxD] with C coefficients in columns
% coeffs_ci: [matrix][2xC] with [low;high] 95% CI for every coefficient OR [matrix][2xCxD]
% gof      : [object] goodness-of-fit object OR [cell array] with objects
% cfit_obj : [object] OR [cell array] with objects
%
% Sagi Perel, 02/2013

    if(nargin < 3 || nargin > 3)
        error('sp_fit: wrong number of input arguments provided');
    end
    if(sp_ismatrix(x))
        [Nx, Dx] = size(x);
    elseif(sp_isvector(x))
        x = make_column_vector(x);
        Nx = length(x);
        Dx = [];
    else
        error('sp_fit: x must be a vector or matrix');
    end
    if(sp_ismatrix(y))
        [Ny, Dy] = size(y);
        if(Nx~=Ny)
            error('sp_fit: x and y do not have the same number of samples');
        end
        if(~isempty(Dx) && (Dx~=Dy))
            % x is a matrix
            error('sp_fit: x and y matrices do not have the same number of columns');
        end
    elseif(sp_isvector(y))
        if(~isempty(Dx))
            error('sp_fit: x is matrix while y is a vector');
        end
        Ny = length(y);
        Dy = [];
        if(Nx~=Ny)
            error('sp_fit: x and y do not have the same number of samples');
        end
        y = make_column_vector(y);
    else
        error('sp_fit: y must be a vector or matrix');
    end
    
    
    if(isempty(Dx) && isempty(Dy))
        % x and y are vectors
        [cfit_obj, gof] = fit(x,y,fitType);
        y_hat  = feval(cfit_obj,x);
        coeffs = coeffvalues(cfit_obj);
        coeffs_ci = confint(cfit_obj,0.95);
    elseif(~isempty(Dy))
        % y is a matrix, x is a vector or matrix
        y_hat     = nan(Nx,Dy);
        coeffs    = [];
        coeffs_ci = [];
        gof       = cell(1,Dy);
        cfit_obj  = cell(1,Dy);

        for d=1:Dy
            try
                if(~isempty(Dx))
                    % x is a matrix
                    [this_cfit_obj, this_gof] = fit(x(:,d), y(:,d), fitType);
                    y_hat(:,d)     = feval(this_cfit_obj,x(:,d));
                else
                    % x is a vector
                    [this_cfit_obj, this_gof] = fit(x, y(:,d), fitType);
                    y_hat(:,d)     = feval(this_cfit_obj,x);
                end

                this_coeffs    = coeffvalues(this_cfit_obj);
                this_coeffs_ci = confint(this_cfit_obj,0.95);

                if(d==1)
                    coeffs    = nan(length(this_coeffs), Dy);
                    coeffs_ci = nan(size(this_coeffs_ci,1), size(this_coeffs_ci,2), Dy);
                end
                coeffs(:,d)      = this_coeffs;
                coeffs_ci(:,:,d) = this_coeffs_ci;
                gof{d}           = this_gof;
                cfit_obj{d}      = this_cfit_obj;
            catch ME
                print_exception(ME);
            end
        end
    else
        error('sp_fit: internal error');
    end
    
    