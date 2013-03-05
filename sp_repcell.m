function out_cell = sp_repcell(datum, cell_size)
% function out_cell = sp_repcell(datum, cell_size)
%
% Repeats the given datum in a cell array.
% Like repmat, only for cells
%
% INPUTS:
% datum    : any type of data
% cell_size: [M N P] specifying the size of the cell array
%
% OUTPUT:
% out_cell: [cell array sized cell_size] with datum repeated in every cell
% 
% Sagi Perel, 10/2011

    if(nargin ~= 2)
        error('sp_repcell: wrong number of input arguments provided');
    end
    
    num_dims = length(cell_size);
    if(num_dims > 3)
        error('sp_repcell: this function does not support more than 3 dimensions');
    end
    if(num_dims == 1)
        cell_size(end+1:end+2) = 1;
    end
    if(num_dims == 2)
        cell_size(end+1) = 1;
    end
    
    out_cell = cell(cell_size);
    
    for m=1:cell_size(1)
        for n=1:cell_size(2)
            for p=1:cell_size(3)
                out_cell{m,n,p} = datum;
            end
        end
    end
