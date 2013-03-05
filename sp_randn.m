function r = sp_randn(dist_mean, dist_std, varargin)
% function r = sp_randn(dist_mean, dist_std, varargin)
% 
% Returns normally distributed pseudorandom numbers from the given distribution
%
% r = sp_rand(dist_mean, dist_std,N)     returns [N x N] matrix
% r = sp_rand(dist_mean, dist_std,M,N)   returns [M x N] matrix
% r = sp_rand(dist_mean, dist_std,[M N]) returns [M x N] matrix
%
% INPUTS:
% dist_mean : [double] normal distribution mean
% dist_std  : [double] normal distribution SD
% See above for more arguments
%
% OUTPUTS:
% r  : [matrix] 
%
% Sagi Perel, 02/2012

    if(nargin < 3)
        error('sp_randn takes at least 3 arguments');
    end
    if( ~isscalar(dist_mean) || ~isscalar(dist_std) )
        error('sp_randn: dist_mean, dist_std must be non-empty real numbers');
    end

    switch(nargin)
        case 3
            if(~isvector(varargin{1}))
                error('sp_randn: size vector must be a non-empty row vector');
            end
            if(size(varargin{1},1) == 1)
                switch(size(varargin{1},2))
                    case 1
                        output_size = [varargin{1} varargin{1}];
                    case 2
                        output_size = varargin{1};                        
                    otherwise
                        error('sp_randn: size vector must be a non-empty row vector sized either [1 1] or [1 2]');
                end
            else
                error('sp_randn: size vector must be a non-empty row vector sized either [1 1] or [1 2]');
            end            
            
        case 4
            if(~isscalar(varargin{1}) || ~isscalar(varargin{2}))
                error('sp_randn: size vectors must be non-empty scalars');
            end
            output_size = [varargin{1} varargin{2}];
            
        otherwise
            error('sp_randn: wrong number of input arguments supplied');
    end

    r = dist_mean + dist_std.*randn(output_size);
    
    