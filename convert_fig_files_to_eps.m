function convert_fig_files_to_eps(source_directory, output_directory, overwrite_existing)
% function convert_fig_files_to_eps(source_directory, output_directory, overwrite_existing)
%
% Loads all fig files in source_directory and saves them as eps files in output_directory
%
% INPUTS:
% source_directory  : [string]
% [output_directory]: [string] Default: source_directory
% [overwrite_existing]: [bool] Default: false
%
% OUTPUTS:
% NONE
%
% Sagi Perel, 03/2013

    if(nargin < 1 || nargin > 3)
        error('convert_fig_files_to_eps: wrong number of input arguments provided');
    end
    if(~ischar(source_directory))
        error('convert_fig_files_to_eps: source_directory must be a string');
    elseif(~sp_exist(source_directory,'dir'))
        error(['convert_fig_files_to_eps: the input directory ' source_directory ' does not exist']);
    end
    if(~exist('output_directory','var') || isempty(output_directory))
        output_directory = source_directory; 
    elseif(~ischar(output_directory))
        error('convert_fig_files_to_eps: output_directory must be a string');
    elseif(~sp_exist(output_directory,'dir'))
        error(['convert_fig_files_to_eps: the output directory ' output_directory ' does not exist']);
    end
    if(~exist('overwrite_existing','var') || isempty(overwrite_existing))
        overwrite_existing = false; 
    end
    
    files_list = mv_dir([source_directory filesep '*.fig']);
    for i=1:length(files_list)
        filename_base = files_list{i}(1:end-4);
        output_file_name = [filename_base '.eps'];
        output_file_path = ([output_directory filesep output_file_name]);
        if(overwrite_existing || (~overwrite_existing && ~sp_exist(output_file_path,'file')))
            open([source_directory filesep files_list{i}]);
            print_eps(filename_base, output_directory, true);
            close(gcf);
        else
            log_disp(['Skipping existing file ' output_file_path]);
        end
    end