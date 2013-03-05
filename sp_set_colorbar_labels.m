function sp_set_colorbar_labels(values, labels)
% function sp_set_colorbar_labels(values, labels)
%
% Sets the colorbar labels at the given values
%
% INPUTS:
% values  : [array] array of values to set in the colorbar
% [labels]: [cell array] of strings to set in the colorbar. Default: string representations of values.
%
% Sagi Perel, 03/2012

    if(nargin < 1 || nargin > 2)
        error('sp_set_colorbar_labels: wrong number of input arguments provided');
    end
    if(~isvector(values))
        error('sp_set_colorbar_labels: values must be a vector');
    end
    if(~exist('labels','var'))
        labels = get_array_as_string_cell(values);
    else
        if(~iscell(labels))
            error('sp_set_colorbar_labels: labels must be a cell array of strings');
        elseif(~all(cellfun(@ischar, labels)))
            error('sp_set_colorbar_labels: labels must contain only strings');
        end
    end

    hC = colorbar;
    set(hC,'Ytick',values,'YTicklabel',labels);