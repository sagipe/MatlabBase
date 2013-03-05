function interpY = sp_spline_interpolate(X, Y, XX, method)
% function interpY = sp_spline_interpolate(X, Y, XX, method)
%
% Interpolates the data in the columns of Y from the times given in X
% to the times given in XX
%
% INPUTS:
% X : [array][Nx1] the sample times of the data in the colums of Y
% Y : [matrix][NxP] with data in columns
% XX: [array][Mx1] the interpolated sample times of the data in Y
% [method]: [string] 'nearest','linear','spline' (Default) ,'pchip'
%
% OUTPUTS:
% interpY: [matrix][MxP] with the interpolated values in Y
%
% Sagi Perel, 11/2011

    if(nargin < 3 || nargin > 4)
        error('sp_spline_interpolate: wrong number of input arguments given');
    end
    if(~isvector(X) || isempty(Y) || ~isvector(XX))
        error('sp_spline_interpolate: input arguments cannot be empty');
    else
        X  = make_row_vector(X);
        XX = make_row_vector(XX);
    end
    if(~exist('method','var'))
        method = 'spline';
    else
        switch(method)
            case {'nearest','linear','spline','pchip'}                
            otherwise
                error(['sp_spline_interpolate: unknown value for method=[' method ']']);
        end
    end
    
    interpY = nan(length(XX), size(Y,2));
    for i=1:size(Y,2)
        if(~all(isnan( Y(:,i) )))
            % check to see if XX has values before/after the first/last values in X
            % if so, reflect pad Y, so the interpolation does not add edge effects
            if(XX(1)<X(1) || XX(end)>X(end))
                padding_num_samples = min(10, round(length(Y(:,i))*0.20));
                % pad the signal
                padded_Y = sp_pad_signal(Y(:,i), padding_num_samples, 'reflect');
                % pad the time vector
                T = nanmean(diff(X));
                padded_X = [X(1)-padding_num_samples*T : T : X(1) X(2:end-1) X(end):T:X(end)+padding_num_samples*T];
                interpY(:,i) = interp1(padded_X, padded_Y, XX,method);
            else
                interpY(:,i) = interp1(X, Y(:,i), XX,method);
            end
        end
    end