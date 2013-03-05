function set_axis_labels(handle, tick_locations, tick_labels, axis_type)
% function set_axis_labels(handle, tick_locations, tick_labels, axis_type)
% 
% Sets the axis ticks locations and labels
%
% INPUTS:
% handle        : [handle] to the axis
% tick_locations: [array] of numerical values
% tick_labels   : [cell array] of string values. If empty, then tick_locations will be converted to strings
% axis_type     : [string] 'x','y'
%
% Sagi Perel, 01/2011

    if(nargin ~= 4)
        error('set_axis_labels: wrong number of input arguments provided');
    end
    if(~isscalar(handle))
        error('set_axis_labels: handle must be a valid handle');
    end
    if(~isvector(tick_locations) && ~isempty(tick_locations))
        error('set_axis_labels: tick_locations must be an array');
    end
    if(isempty(tick_labels))
        if(~isempty(tick_locations))
            tick_labels = get_array_as_string_cell(tick_locations);
        end
    else
        if(length(tick_locations) ~= length(tick_labels))
            error('set_axis_labels: length(tick_locations) ~= length(tick_labels)');
        end
    end
    
    switch(axis_type)
        case 'x'
            set(handle,'XTick',tick_locations)
            set(handle,'XTickLabel',tick_labels)
        case 'y'
            set(handle,'YTick',tick_locations)
            set(handle,'YTickLabel',tick_labels)
        otherwise
            error(['set_axis_labels: unknown axis_type [' axis_type ']']);
    end