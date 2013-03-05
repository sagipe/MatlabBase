function idx = sp_get_idx_at_specified_speed(speed, when, speed_mark)
% function idx = sp_get_idx_at_specified_speed(speed, when, speed_mark)
% 
% Returns the sample index at the specified speed mark
% sp_get_idx_at_specified_speed(speed, 'max_speed')   -> the index of max speed
% sp_get_idx_at_specified_speed(speed, 'before', 0.1) -> first occurance 10% max speed
% sp_get_idx_at_specified_speed(speed, 'after', 0.2)  -> first occurance of 20% max speed, after max speed
%
% INPUTS:
% speed: [array]
% when : [string] 'max_speed','before','after'
% speed_mark: [double] percentage
% 
% OUTPUTS:
% idx: [int]
% 
% Sagi Perel, 10/2012

    %--- sanity check on input arguments
    if(nargin < 2 || nargin > 3)
        error('sp_get_idx_at_specified_speed: wrong number of input arguments provided');
    end
    if(~isvector(speed))
        error('sp_get_idx_at_specified_speed: speed must be an array')
    end
    if(~ischar(when))
        error('sp_get_idx_at_specified_speed: when must be a string');
    elseif(~any(strcmp(when,{'before', 'after', 'max_speed'})))
        error('sp_get_idx_at_specified_speed: when is in the wrong format');
    end
    if(~strcmp(when,'max_speed'))
        if(~exist('speed_mark','var'))
            error('sp_get_idx_at_specified_speed: must specify speed_mark with when~=''max_speed''');
        elseif(~isscalar(speed_mark))
            error('sp_get_idx_at_specified_speed: speed_mark must be a scalar');
        else
            if(speed_mark < 0 || speed_mark > 1)
                error('sp_get_idx_at_specified_speed: speed_mark must be in the range [0 1]');
            end
        end
    end
    
    [max_speed max_idx] = max(speed);    
    switch(when)
        case 'max_speed'
            idx = max_idx;
        case 'before'
            idx = Cfind_first_bigger_sample_in_array2(speed, max_speed*speed_mark);
        case 'after'
            idx = Cfind_first_smaller_sample_in_array2(speed(max_idx:end), max_speed*speed_mark);
            idx = idx + max_idx -1; 
    end
    