function log_disp_progress(iteration, total_iterations ,actually_log, prefix)
% function log_disp_progress(iteration, total_iterations ,actually_log, prefix)
%
% Prints messages in the format:
% [2012-01-13 17:13:47] 2 out of 100 (2.00%)
%
% INPUTS:
% iteration       : [double] 
% total_iterations: [double] 
% [actually_log]: [bool] Default: true
% [prefix]      : [string]/[scalar] Default: ''. [2012-01-13 17:13:47] PREFIX 2 out of 100 (2.00%)
%
% Sagi Perel, 01/2011
    
    if(~exist('actually_log','var'))
        actually_log = true;
    end
    if(~exist('prefix','var'))
        prefix = '';
    else
        if(~ischar(prefix))
            if(isscalar(prefix))
                prefix = num2str(prefix);
            else
                error('log_disp_progress: prefix must be a string or a scalar');
            end
        end
    end
    if(isempty(prefix))
        log_disp([num2str(iteration) ' out of ' num2str(total_iterations) ' (' sprintf('%.2f',100*iteration/total_iterations) '%)'], actually_log);
    else
        log_disp([prefix ' ' num2str(iteration) ' out of ' num2str(total_iterations) ' (' sprintf('%.2f',100*iteration/total_iterations) '%)'], actually_log);
    end