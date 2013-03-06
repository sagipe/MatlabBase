function save_fig(filename, figures_dir, actually_save, figure_handle, maximize_figure)
% function save_fig(filename, figures_dir, actually_save, figure_handle, maximize_figure)
%
% Saves the given figure to the given directory and filename
%
% INPUTS:
% filename     : [string] filename (without extension)
% [figures_dir]: [string] directory where the file should be saved to
%                The global variable FIGURES_DIRECTORY will be used if figures_dir is not specified
%                If it is not specified, then the current directory will be used
% [actually_save]: [bool] Default: true
% [figure_handle]: [handle] Default: gcf
% [maximize_figure]: [bool] Default: false. Should the figure be maximized before printing the figure
% 
% Sagi Perel, 03/13

global FIGURES_DIRECTORY;

switch(nargin)
    case 1
        if(isempty(FIGURES_DIRECTORY))
            dir = '.';
        else
            dir = FIGURES_DIRECTORY;
        end
    case {2,3,4,5}
        dir = figures_dir;        
    otherwise
        error('save_fig: wrong number of input arguments provided');
end
if(~exist('actually_save','var') || isempty(actually_save))
    actually_save = true;
end
if(actually_save && ~sp_exist(dir,'dir'))
    error(['save_fig: the directory ' dir ' does not exist!']);
end
if(~exist('figure_handle','var') || isempty(figure_handle))
    figure_handle = gcf;
end
if(~exist('maximize_figure','var') || isempty(maximize_figure))
    maximize_figure = false;
end
if(maximize_figure)
    sp_maximize_figure();
end

if(actually_save)
    full_path = [dir filesep filename '.fig'];
    
    % first set background to invisible
    gcf_color = get(gcf,'Color');
    gca_color = get(gca,'Color');
%     set(gcf,'Color','none');
    set(gcf,'Color','white');
    set(gca,'Color','none');
    
    % save the figure
    saveas(figure_handle, full_path);
    
    % set the colors back to the originals
    set(gcf,'Color',gcf_color);
    set(gca,'Color',gca_color);
    
    log_disp(['Saved ' full_path]);
end
