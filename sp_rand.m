function r = sp_rand(a, b, varargin)
% function r = sp_rand(a, b, varargin)
% 
% Returns uniformly distributed pseudorandom numbers from a certain range
%
% r = sp_rand(a,b,N) returns [N x N] matrix with numbers from the range [a b]
% r = sp_rand(a,b,M,N) returns [M x N] matrix with numbers from the range [a b]
% r = sp_rand(a,b,[M N]) returns [M x N] matrix with numbers from the range [a b]
%
% INPUTS:
% a  : [double] smallest value for the range
% b  : [double] biggest value for the range
% See above for more arguments
%
% OUTPUTS:
% r  : [matrix] 
%
% Sagi Perel, 06/2009

    switch(nargin)
        
        case 3
            if(~isvector(varargin{1}))
                error('sp_rand: input arguments must be vectors (and non empty)');
            end
            if(size(varargin{1},1) == 1)
                switch(size(varargin{1},2))
                    case 1
                        output_size = [varargin{1} varargin{1}];
                    case 2
                        output_size = varargin{1};
                    otherwise
                        error('sp_rand: third input arguments must be sized either [1 1] or [1 2]');
                end
            else
                error('sp_rand: third input arguments must be sized either [1 1] or [1 2]');
            end            
            
        case 4
            if(~isvector(varargin{1}) || ~isvector(varargin{2}))
                error('sp_rand: input arguments must be vectors (and non empty)');
            end
            if(~isscalar(varargin{1}) || ~isscalar(varargin{2}))
                error('sp_rand: input arguments must be scalars');
            end
            output_size = [varargin{1} varargin{2}];
            
        otherwise
            error('sp_rand: wrong number of input arguments supplied');
    end

    if(~isscalar(a) || ~isscalar(b))
        error('sp_rand: a and b must be scalars');
    end
    
    r = a + (b-a).*rand(output_size);
    
    