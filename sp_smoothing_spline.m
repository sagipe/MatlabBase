function SY = sp_smoothing_spline(Y, method, p, idxs, m)
% function SY = sp_smoothing_spline(Y, method, p, idxs, m)
%
% Uses Matlab's spaps to smooth spline the data in Y
% 
% INPUTS:
% Y       : [cell] array of matrices with curves OR
%           [matrix][N x num curves] curves to smooth in columns
% [method]: [string] 'spaps', 'csaps' (Default)
%
% -> When using csaps:
% [p]     : [double] in the range [0 1], where 0=least-squares straight line fit to the data, 1=`natural' cubic spline interpolant
%              Default is the value selected by csaps
% -> When using spaps
% [p]     : [double] specifying the noise level: Default: STD of the curve. OR
%                [string] 'std_MULTIPLIER' specifying a multiplier of the STD (3 is very smooth)
%
% [idxs]  : [double array] indices to use for all curves. Default: entire curve
%
% -> When using csaps:
% [m]     : NOT USED
% -> When using spaps
% [m]     : [double] smoothing spline type for spaps:
%           1 (for a piecewise linear smoothing spline)
%           2 (for the cubic smoothing spline)
%           3 (for a quintic smoothing spline) DEFAULT
%
%
% OUTPUTS:
% SY: [cell] OR [matrix][N x num curves] of smoothed curves
%
% Sagi Perel, 11/2011

    %--- sanity check on inputs
    if(nargin < 1 || nargin > 5)
        error('sp_smoothing_spline: wrong number of input arguments provided');
    end
    if(isvector(Y))
        Y = make_column_vector(Y);
    end
    
    if(~exist('method','var'))
        method = 'csaps';
    else
        switch(method)
            case {'spaps','csaps'}
            otherwise
                error(['sp_smoothing_spline: unknown value for method=[' method ']']);
        end
    end
    
    if(~exist('p','var'))
        p = [];
        std_multiplier = 1;
    else
        switch(class(p))
            case 'char'
                if(strcmp(p(1:4),'std_'))
                    std_multiplier = str2double(p(5:end));
                    p = [];
                else
                    error('sp_smoothing_spline: unknown value for p');
                end
            case 'double'
                % use the given value
                std_multiplier = [];
        end
    end
    
    if(~exist('idxs','var'))
        idxs = [];
    else
        if(~isvector(idxs))
            error('sp_smoothing_spline: idxs must be a vector');
        end
    end
    
    if(~exist('m','var'))
        m =3;
    else
        switch(m)
            case {1, 2, 3}
            otherwise
                error('sp_smoothing_spline: illegal value specified for m');
        end
    end
    
    if(iscell(Y))
        SY = cell(size(Y));
        for c=1:length(Y)
            switch(method)
                case 'csaps'
                    SY{c} = spline_smooth_matrix_csaps(double(Y{c}), idxs, p);
                case 'spaps'
                    SY{c} = spline_smooth_matrix_spaps(double(Y{c}), idxs, p, std_multiplier, m);
            end
        end
    else
        switch(method)
            case 'csaps'
                SY = spline_smooth_matrix_csaps(double(Y), idxs, p);
            case 'spaps'
                SY = spline_smooth_matrix_spaps(double(Y), idxs, p, std_multiplier, m);
        end
    end
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function SY = spline_smooth_matrix_csaps(Y, idxs, p)
% Performs spline smoothing on a matrix of curves        

    if(isempty(idxs))
        idxs = 1:size(Y,1);
    end

    num_curves = size(Y,2);
    SY = nan(length(idxs), num_curves);
    
    for i=1:num_curves
        if(isempty(p))
            SY(:,i) = fnval(csaps(idxs, Y(idxs,i)), idxs);
        else
            SY(:,i) = csaps(idxs, Y(idxs,i), p, idxs);
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
function SY = spline_smooth_matrix_spaps(Y, idxs, noise_level, std_multiplier, m)
% Performs spline smoothing on a matrix of curves        

    if(isempty(idxs))
        idxs = 1:size(Y,1);
    end

    num_curves = size(Y,2);
    SY = nan(length(idxs), num_curves);
    
    for i=1:num_curves
        if(isempty(p))
            this_noise_level = nanstd(Y(idxs,i))*std_multiplier;
        else
            this_noise_level = noise_level;
        end
        if(m==3)
            % spaps seems to hang sometimes when supplying m, so if using the default one- don't supply m
            [~, S] = spaps(idxs,Y(idxs,i),this_noise_level);
        else
            [~, S] = spaps(idxs,Y(idxs,i),this_noise_level,m);
        end
        SY(:,i) = S;
    end
    