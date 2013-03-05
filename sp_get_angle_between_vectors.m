 function angle_deg = sp_get_angle_between_vectors(a,b)
%  function angle_deg = sp_get_angle_between_vectors(a,b)
%
% Returns the angle between two vectors in degress
% If a,b are matrices, vectors are taken columwise
%
% Works for 2D and 3D cases
%
% INPUTS:
% a: [array] OR [matrix] with vectors in columns
% b: [array] OR [matrix] with vectors in columns
%
% OUTPUT:
% angle_deg: [array] of angles between vectors in degress
% 
% Sagi Perel, 02/2013

    if(nargin ~= 2)
        error('sp_get_angle_between_vectors: wrong number of input arguments provided');
    end
    if(sp_isvector(a))
        a_isvector = true;
        a = make_column_vector(a);
        dim = length(a);
    elseif(sp_ismatrix(a))
        a_isvector = false;
        dim = size(a,1);
    else
        error('sp_get_angle_between_vectors: a must be a vector or a matrix');
    end
    if(sp_isvector(b))
        if(~a_isvector)
            error('sp_get_angle_between_vectors: a is a not a vecror, but b is. a,b must both be vectors or matrices');
        end
        b = make_column_vector(b);
    elseif(sp_ismatrix(b))
        if(a_isvector)
            error('sp_get_angle_between_vectors: a is a vecror, but b is not. a,b must both be vectors or matrices');
        end
        if(~all( size(a) == size(b) ))
            error('sp_get_angle_between_vectors: a and b are matrices with incompatible sizes');
        end
    else
        error('sp_get_angle_between_vectors: b must be b vector or a matrix');
    end
    
    switch(dim)
        case 2
            if(a_isvector)
                angle_deg = rad2deg( acos(dot(a./norm(a),b./norm(b))) );
            else
                num_vectors = size(a,2);
                angle_deg = nan(num_vectors,1);
                for i=1:num_vectors
                    angle_deg(i) = rad2deg( acos(dot(a(:,i)./norm(a(:,i)),b(:,i)./norm(b(:,i)))) );
                end
            end
        case 3
            if(a_isvector)
                angle_deg = rad2deg( atan2(norm(cross(a,b)),dot(a,b)) );
            else
                num_vectors = size(a,2);
                angle_deg = nan(num_vectors,1);
                for i=1:num_vectors
                    angle_deg(i) = rad2deg( atan2(norm(cross(a(:,i),b(:,i))),dot(a(:,i),b(:,i))) );
                end
            end
        otherwise
            error();
    end
    
        
        