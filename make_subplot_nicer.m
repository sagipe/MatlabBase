function make_subplot_nicer(handles, varargin)
% function make_subplot_nicer(handles, varargin)
% 
% Changes the spacing between subplots to make them look better
%
% INPUT:
% handles : [array] of handles to subplots
% varargin: variable number of options in the format: 'option name', option value
%           (so this function must get an even number of varargin)
%           Valid options are: 'left','bottom','width','height'
%           and option values should be in the range [0 1], specifying how much to add
%           So to add 5% to the height of every subplot, call: make_subplot_nicer(handles,'height',0.05)
% 
% Sagi Perel, 10/10

    noptargin = size(varargin,2);
    
    if(noptargin == 0)
        return; % do nothing
    end
    if(mod(noptargin,2) > 0)
        error('make_subplot_nicer: number of optional varargin must be even');
    end

    for h=1:length(handles)
        p = get(handles(h), 'pos');
        % p=[left, bottom, width, height] by default is in normalized coordinates (percentage of figure window)
        for i=1:2:noptargin
            switch(varargin{i})
                case 'left'
                    p(1) = p(1) + varargin{i+1};
                case 'bottom'
                    p(2) = p(2) + varargin{i+1};
                case 'width'
                    p(3) = p(3) + varargin{i+1};
                case 'height'
                    p(4) = p(4) + varargin{i+1};                    
                otherwise
                    error(['make_subplot_nicer: unknown option ''' varargin{i} '''']);
            end
            set(handles(h), 'pos', p);
        end
    end