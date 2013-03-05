function sp_change_hist_color(face_color, edge_color, axis_handle)
% function sp_change_hist_color(face_color, edge_color, axis_handle)
% 
% Changes the colors of the given histogram(s).
% If more than one histogram is present on the axis, you may specify colors as cell arrays for each.
%
% INPUTS:
% [face_color] : [string] Default: 'b'; or cell array of strings sized #histograms
% [edge_color] : [string] Default: 'w'; or cell array of strings sized #histograms
% [axis_handle]: [handle] Default: gca
%
% Sagi Perel, 10/2011

    if(nargin > 3)
        error('sp_change_hist_color: wrong number of input arguments provided');
    end
    if(~exist('axis_handle','var'))
        axis_handle = gca;
    end
    h = findobj(axis_handle,'Type','patch');
    num_hist = length(h);
    
    if(num_hist == 0)
        return;
    end
    
    if(~exist('face_color','var'))
        face_color = sp_repcell('b', [1 num_hist]);
    else
        switch(class(face_color))
            case 'char'
                face_color = sp_repcell(face_color, [1 num_hist]);
            case 'cell'
                if(length(face_color) ~= num_hist)
                    error(['sp_change_hist_color: if face_color is a cell array, it must have the same number of elements as the number of histograms (' num2str(num_hist) ')']);
                end
            otherwise
                error('sp_change_hist_color: face_color must be a string or a cell array of strings');
        end
    end
    
    if(~exist('edge_color','var'))
        edge_color = sp_repcell('w', [1 num_hist]);
    else
        switch(class(edge_color))
            case 'char'
                edge_color = sp_repcell(edge_color, [1 num_hist]);
            case 'cell'
                if(length(edge_color) ~= num_hist)
                    error(['sp_change_hist_color: if edge_color is a cell array, it must have the same number of elements as the number of histograms (' num2str(num_hist) ')']);
                end
            otherwise
                error('sp_change_hist_color: edge_color must be a string or a cell array of strings');
        end
    end

    % face_color has the colors in order of plotting
    % the handles in h are in the reverse order, so reverse the cell array
    face_color = face_color(end:-1:1);
    
    for i=1:num_hist
        set(h(i),'FaceColor',face_color{i},'EdgeColor',edge_color{i});
    end
    