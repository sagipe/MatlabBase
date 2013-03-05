function sp_figure(bool_keep_figure)
% function sp_figure(bool_keep_figure)
% 
% Opens a new figure, or selects the current one for plotting
%
% INPUTS:
% bool_keep_figure: [bool] If false: opens a new figure, if true: selects the current figure
%
%
% Sagi Perel, 02/2012

    if(nargin ~= 1)
        error('sp_figure: wrong number of input arguments provided');
    end
    if(isempty(bool_keep_figure))
        error('sp_figure: bool_keep_figure cannot be empty');
    end
    
    if(bool_keep_figure)
        gcf;
        clf;
    else
        figure;
    end
