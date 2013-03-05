function idx = sp_find_first_non_empty_cell(cell_array)
% function idx = sp_find_first_non_empty_cell(cell_array)
%
% Finds the first non empty cell in the given cell array
% 
% INPUT:
% cell_array: [cell array]
% 
% OUTPUT:
% idx : [int] the index of the first non-empty cell array, or empty if all cells are empty
%
% Sagi Perel, 11/2011

    if(nargin ~= 1)
    end
    if(~iscell(cell_array))
    end
    
    % for loop is faster than cellfun
    idx = [];
    for i=1:length(cell_array)
        if(~isempty(cell_array{i}))
            idx = i;
            return;
        end
    end
  