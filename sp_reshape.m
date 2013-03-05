function B = sp_reshape(A, varargin)
% function B = sp_reshape(A, varargin)
%
% sp_reshape(A,[m n]) or sp_reshape(A,m,n)
% Does the same thing as reshape, but if the number of elements in A is not N*M
% it pads with nans.
% Think about it as dividing a vector A to n groups with m elements each, with groups column-wise
% For simplicity, works only on vectors.
%
% Sagi Perel, 10/10

    switch(nargin)
        case 2
            if(~isvector(varargin{1}))
                error('sp_reshape: when supplying two arguments, the second one should be a vector [m n]');
            end
            if(length(varargin{1}) ~= 2)
                error('sp_reshape: when supplying two arguments, the second one should be a vector [m n]');
            end
            m = varargin{1}(1);
            n = varargin{1}(2);
        case 3
            m = varargin{1};
            n = varargin{2};
        otherwise
            error('sp_reshape: wrong number of input arguments provided');
    end
    if(~isvector(A))
        error('sp_reshape: A must be a vector');
    else
        A = make_row_vector(A);
    end

    numelA = numel(A);
    num_required_elements = m*n;
    
    num_extra_elements   = mod(numelA, m); % #extra elements in the last group where we have enough data   
    if(num_extra_elements > 0)
        num_missing_elements = m-num_extra_elements; % how many extra elements add to the last group to fill it up
        
        % check if there are groups with no elements at all and add NaNs in those groups
        if(numelA+num_missing_elements < num_required_elements)
            extra_elements = nan(1,num_required_elements - (numelA+num_missing_elements));
        else
            extra_elements = [];
        end
        
        AA = [A nan(1, num_missing_elements) extra_elements];
        B = reshape(AA, [m n]);
    else
        % if no extra elements are missing, maybe we are missing a whole group so check for that
        if(numelA < num_required_elements)
            AA = [A nan(1, m)];
            B = reshape(AA, [m n]);
        else
            B = reshape(A, [m n]);
        end
    end
    
    