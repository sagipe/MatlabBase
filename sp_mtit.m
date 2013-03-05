function sp_mtit(varargin)
% function sp_mtit(varargin)
% 
% A wrapper to mtit, which replaces '_' in the title text with white spaces
% Assumes that varargin{1} is the title text
%
% Sagi Perel, 10/2012

    if(iscell(varargin{1}))
        % multiline title
        rep_fun = @(x)( strrep(x, '_', ' ') );
        title_text = sp_cellfun(rep_fun, varargin{1});
    else
        % it's a string
        title_text = strrep(varargin{1}, '_', ' ');
    end
    
    
    mtit(gcf, title_text, varargin{2:end});
