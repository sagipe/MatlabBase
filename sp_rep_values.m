function values = sp_rep_values(data_array, num_reps)
% function values = sp_rep_values(data_array, num_reps)
%
% Creates a vector of values from the given inputs:
% Element [i] in data_array is repeated num_reps[i] times, then concatenated to values
%
% INPUTS:
% data_array: [array] of N values
% num_reps  : [array] indicating how many times the values in data_array should be repeated
%
% OUTPUT:
% values    : [array][sum(num_reps) x 1] with repeated values as specified
%
% For example:
% values = sp_rep_values([1 2 3 4 5], [2 3 1 0 4])
% 
% values =
% 
%      1
%      1
%      2
%      2
%      2
%      3
%      5
%      5
%      5
%      5
%
% Sagi Perel, 05/2011

    if(nargin ~= 2)
        error('sp_rep_values: wrong number of input arguments provided');
    end
    if(~isvector(data_array))
        error('sp_rep_values: data_array should be a non-empty vector');
    end
    if(~isvector(num_reps))
        error('sp_rep_values: num_reps should be a non-empty vector');
    end
    N = length(data_array);
    M = length(num_reps);
    if(N ~= M)
        error('sp_rep_values: data_array and num_reps should have the same size');
    end
    
    cumsum_reps = cumsum(num_reps);
    
    values = nan(sum(num_reps),1);
    values(1:num_reps(1)) = data_array(1);
    for i=2:N
        values( cumsum_reps(i-1)+1 : cumsum_reps(i) ) = data_array(i);
    end
