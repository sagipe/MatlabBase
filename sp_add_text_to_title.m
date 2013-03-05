function sp_add_text_to_title(text, placement, handle, target_object)
% function sp_add_text_to_title(text, placement, handle, target_object)
% 
% Adds the given text to the Axis title (or xlabel, ylabel)
% Also replaces any '_' with white spaces
%
% INPUTS:
% text       : [string] text to add to the title
% placement  : [string] 'first_row': add the text as the first row of the title
%                       'last_row' : add the text as the last row of the title
%                       'prefix_X'   : prefix to row X
%                       'suffix_X'   : suffix to row X
% [handle]   : the axis handle. Default: gca
% [target_object]: [string] 'Title' (default), 'XLabel', 'YLabel'
%
% Sagi Perel, 09/07

    if(nargin < 2 || nargin > 4)
        error('sp_add_text_to_title: wrong number of input arguments provided');
    end
    
    text = strrep(text, '_',' ');
    
    row    = [];
    prefix = false;
    suffix = false;    
    switch(placement)
        case 'first_row'
            row = 1;
        case 'last_row'
            row = -1;
        otherwise
            if(strcmp(placement(1:7),'prefix_'))
                row = str2double(placement(8:end));
                prefix = true;
            elseif(strcmp(placement(1:7),'suffix_'))
                row = str2double(placement(8:end));
                suffix = true;
            else
                error(['sp_add_text_to_title: Unknown value for placement=[' placement ']']);
            end
    end
        
    if(~exist('handle','var'))
        handle = gca;
    end
    
    if(~exist('target_object','var'))
        target_object = 'Title';
    else
        switch(target_object)
            case {'Title','XLabel','YLabel'}
            otherwise
                error(['sp_add_text_to_title: Unknown value for target_object=[' target_object ']']);
        end
    end
    
    object_handle = get(handle, target_object);
    title_text   = get(object_handle, 'String');
    switch(class(title_text))
        case 'char'
            % the title has one line of text
            switch(row)
                case 1
                    if(prefix)
                        % add the text as a prefix to the first row
                        set(object_handle, 'String', [text title_text]);
                    elseif(suffix)
                        % add the text as a suffix to the first row
                        set(object_handle, 'String', [title_text text]);
                    else
                        % add the text as the first row
                        set(object_handle, 'String', {text, title_text});
                    end
                case -1
                    % add the text as the last row
                    set(object_handle, 'String', {title_text, text});
                otherwise
                    % another row number
                    if(prefix || suffix)
                        % there is only one row now, so add more rows as needed and place the new text in the requested row
                        new_text = cell(row,1);
                        new_text{1}   = title_text;
                        new_text{row} = text;
                        set(object_handle, 'String', new_text);
                    end
            end
        case 'cell'
            % the title has more than one line of text
            switch(row)
                case 1
                    if(prefix)
                        % add the text as a prefix to the first row
                        title_text{1} = [text title_text{1}];
                        set(object_handle, 'String', title_text);
                    elseif(suffix)
                        % add the text as a suffix to the first row
                        title_text{1} = [title_text{1} text];
                        set(object_handle, 'String', title_text);
                    else
                        % add the text as the first row
                        new_text = cell(length(title_text)+1,1);
                        new_text{1} = text;
                        new_text(2:end) = title_text;
                        set(object_handle, 'String', new_text);
                    end
                case -1
                    % add the text as the last row
                    title_text{end+1} = text;
                    set(object_handle, 'String', title_text);
                otherwise
                    % another row number: so extend title_text if necessary
                    if(length(title_text) < row)
                        new_text = cell(row,1);
                        new_text(1:length(title_text)) = title_text;
                        title_text = new_text;
                    end
                    
                    if(prefix)
                        title_text{row} = [text title_text{row}];
                        set(object_handle, 'String', title_text);
                    end
                    if(suffix)
                        title_text{row} = [title_text{row} text];
                        set(object_handle, 'String', title_text);
                    end
            end
    end
    