function M=sp_mod(X,Y)
% function M=sp_mod(X,Y)
%
% A wrapper for Matlab's mod, which makes it easier to use with Matlab's 1 based indexing
% When mod(X,Y)==0, this function returns Y instead:
%
% mod(1,3) = 1  | sp_mod(1,3)=1
% mod(2,3) = 2  | sp_mod(2,3)=2
% mod(3,3) = 0  | sp_mod(3,3)=3
% mod(4,3) = 1  | sp_mod(4,3)=1
%
% 
% Sagi Perel, 04/2011


    M = mod(X,Y);
    M( M==0 ) = Y;
