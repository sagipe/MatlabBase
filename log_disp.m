function log_disp(text,actually_log)
% function log_disp(text,actually_log)
%
% INPUTS:
% text: [string] 
% [actually_log]: [bool] Default: true
%
% Sagi Perel, 01/2011
    
    if(~exist('actually_log','var'))
        actually_log = true;
    end
    if(actually_log)
        nowtime = datestr(now, 31);
        disp(['[' nowtime '] ' text]);
    end