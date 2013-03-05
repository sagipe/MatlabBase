function sp_maximize_figure(handle)
% function sp_maximize_figure()
% 
% Maximizes the given or current figure
%
% Sagi Perel, 10/2011

if(~exist('handle','var'))
    handle = gcf;
end
set(handle, 'Position', get(0,'ScreenSize'));