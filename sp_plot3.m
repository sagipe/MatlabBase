function h = sp_plot3(data,varargin)
% function h = sp_plot3(data,varargin)
%
% Wrapper for plot3
% 
% INPUTS:
% data      : [matrix][Nx3] OR [3xN] with [x y z] data
% [varargin]: linespec etc
%
% OUTPUTS:
% h 
%
% Sagi Perel, 02/2011

    if(nargin == 0 || isempty(data))
        error('sp_plot3: data cannot be empty');
    end
    [m n] = size(data);
    if(m~=3 && n~=3)
        error('sp_plot3: one dimension of data must be 3');
    end
    
    if(n~=3 && m==3)
        data = data';
    end
    if(nargin == 1)
        plot3(data(:,1),data(:,2),data(:,3));
    else
        plot3(data(:,1),data(:,2),data(:,3),varargin{:});
    end