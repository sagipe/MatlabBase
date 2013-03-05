function rand_idxs = generate_random_indices(num_indices, min_val, max_val, eliminate_repeats)
% function rand_idxs = generate_random_indices(num_indices, min_val, max_val, eliminate_repeats)
%
% Generates a vector sized [num_indices x 1] of random integers with values from min_val to max_val
% This vector has no repeats
%
% INPUTS:
% num_indices: [double] length of the requested vector
% min_val    : [double]
% max_val    : [double]
% [eliminate_repeats]: [bool] true
% 
%
% OUTPUTS:
% rand_idxs: [array] sorted integer indices
%
% Sagi Perel, 05/2010

if(nargin < 3 || nargin > 4)
    error('generate_random_indices: wrong number of input arguments provided');
end
if(length(num_indices) ~= 1)
    error('generate_random_indices: num_indices should be a double');
end
if(length(min_val) ~= 1)
    error('generate_random_indices: min_val should be a double');
end
if(length(max_val) ~= 1)
    error('generate_random_indices: max_val should be a double');
end
if(max_val < min_val)
    error('generate_random_indices: max_val should be larger than min_val');
end
if(~exist('eliminate_repeats','var'))
    eliminate_repeats = true;
end
if(num_indices > max_val)
    error('generate_random_indices: this algorithm will never finish running when num_indices > max_val');
end

if(num_indices == 0)
    rand_idxs = [];
    return;
end

if(~eliminate_repeats)
    rand_idxs = sort(randi([min_val max_val], [num_indices, 1]));
else
    first_val = ceil(min_val);
    last_val  = ceil(max_val);
    
    rand_idxs = nan(1,num_indices);
    all_idx = first_val : last_val;
    
    for i=1:num_indices
        idx = randi([1 length(all_idx)], [1, 1]);
        rand_idxs(i) = all_idx(idx);
        all_idx(idx) = [];
    end    
end

% if(eliminate_repeats)
%     repeats_exits = true;
%     while(repeats_exits)    
%         idxs_diff = diff(rand_idxs);
%         lrepeat_idxs = (idxs_diff==0);
%         num_repeats = sum(lrepeat_idxs);
%         if( num_repeats > 0 )
%             more_rand_idxs = randi([min_val max_val], [num_repeats, 1]);
%             rand_idxs(lrepeat_idxs) = more_rand_idxs;
%             rand_idxs = sort(rand_idxs);
%         else
%             repeats_exits = false;
%         end
%     end
% end
