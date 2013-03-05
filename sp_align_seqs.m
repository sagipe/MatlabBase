function [match_idx sum_of_squares] = sp_align_seqs(sequence, template)
% function [match_idx sum_of_squares] = sp_align_seqs(sequence, template)
%
% INPUTS:
% sequence: [array] of length N
% template: [array] of length M, M<= N
%
% OUTPUT:
% match_idx     : [int] the best match index of template within the sequence
% sum_of_squares: [array][N-M+1 x 1] of 
%
% Sagi Perel, 08/2011

    if(nargin ~= 2)
        error('sp_align_seqs: wrong number of input arguments provided');
    end
    if(~isvector(sequence) || ~isvector(template))
        error('sp_align_seqs: sequence and template must both be vectors');
    end
    N = length(sequence);
    M = length(template);
    if(M > N)
        error('sp_align_seqs: length(template) > length(sequence)');
    end
    
    sequence = make_column_vector(sequence);
    template = make_column_vector(template);
    
    num_possible_matches = N-M+1;
    sum_of_squares = nan(num_possible_matches,1);
    
    for i=1:num_possible_matches
        sum_of_squares(i) = nansum( (sequence(i:i+M-1)-template).^2);
    end
    
    [~, match_idx] = nanmin(sum_of_squares);