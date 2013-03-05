function h = sp_imsc(matrix, heatmap_colormaps, show_colorbar, limits)
% function sp_imsc(matrix, heatmap_colormaps, show_colorbar, limits)
%
% A wrapper to imsc, with some default options set.
%
% INPUTS:
% matrix             : [matrix] of data
% [heatmap_colormaps]: [cell array] of colormap strings OR a string. Default: 'jet' 
% [show_colorbar]    : [boolean] Default: true
% [limits]           : [min max] where values in image less than min will be set to
%                       min and values greater than max will be set to max.
%
% OUTPUTS:
% h : [handle]
%
% Sagi Perel, 01/2013

    if(nargin < 1 || nargin > 4)
        error('sp_imsc: wrong number of input arguments provided');
    end
    if(~sp_ismatrix(matrix))
        error('sp_imsc: matrix should be a 2D matrix');
    end
    if(~exist('heatmap_colormaps','var') || isempty(heatmap_colormaps))
        heatmap_colormaps  = {'jet'};
    elseif(ischar(heatmap_colormaps))
        heatmap_colormaps = {heatmap_colormaps};
    elseif(~iscell(heatmap_colormaps))
        error('sp_imsc: heatmap_colormaps must be a cell array');
    elseif(~all(cellfun(@ischar, heatmap_colormaps)))
        error('sp_imsc: heatmap_colormaps must be a cell array of strings');
    end
    if(~exist('show_colorbar','var') || isempty(show_colorbar))
        show_colorbar = true;
    end
    if(~exist('limits','var') || isempty(limits))
        limits = [];
    elseif(~sp_isvector(limits))
        error('sp_imsc: limits must be a vector');
    elseif(length(limits)~=2)
        error('sp_imsc: limits must be a vector [min max]');
    end
    
    % make colormap limited to 5th-9th prctiles
    prctiles = prctile(matrix(:),[5 95]);
    matrix(matrix < prctiles(1)) = prctiles(1);
    matrix(matrix > prctiles(2)) = prctiles(2);
    
    for i=1:length(heatmap_colormaps)
        if(i>1)
            figure;
        end
        if(isempty(limits))
            h = imsc(matrix, heatmap_colormaps{i}, 'w');
        else
            h = imsc(matrix, heatmap_colormaps{i}, limits, 'w');
        end
        if(show_colorbar)
            colorbar;
        end
    end