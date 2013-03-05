function sp_plot(varargin)
% function sp_plot(varargin)
% 
% A simple replacement for plot() in cases where multiple vectors with the same number of samples need to be overlayed.
% The data is plotted with the following color ordering: {'r','g','b','c','m','y','k'}
%
% INPUTS:
% varargin: [arrays] with data in them. All arrays must have the same length
% 
% Sagi Perel, 03/2011

    if(nargin == 0)
        return;
    end
        
    % check that all inputs have the same length
    options = {};
    nargin_to_plot = nargin;
    
    len = length(varargin{1});
    for i=2:nargin
        if(isscalar(varargin{i}) && isvector(varargin{i}))
            if(length(varargin{i}) ~= len)
                error('sp_plot: all input vectors must have the same length');
            end
        elseif(isscalar(varargin{i}) && ismatrix(varargin{i}))
            if(size(varargin{i},1) ~= len)
                error('sp_plot: all input vectors must have the same length');
            end
        elseif(ischar(varargin{i}))
            % assume every input from this point on is a property specifier
            options = varargin(i:end);
            nargin_to_plot = i-1;
            break;
        end
    end

    % plot the data
    colors = {'r','g','b','c','m','y','k'};
    xdata = 1:len;
    for i=1:nargin_to_plot
        if(i==1)
            hold on;
        end
        color_idx = mod(i,length(colors));
        if(color_idx == 0)
            color_idx = length(colors);
        end
        if(isempty(options))
            plot(xdata, varargin{i},colors{color_idx});
        else
            plot(xdata, varargin{i},colors{color_idx},options{:});
        end
    end
    hold off;