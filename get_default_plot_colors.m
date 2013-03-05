function colors = get_default_plot_colors()
% function colors = get_default_plot_colors()
% 
% Returns a cell array of strings with the default plot colors (in order):
% Instead of white, adds gray, since white can't be seen
% {'b','g','r','c','m','y','k','w'}

    colors = {'b','g','r','c','m','y','k',[.6 .6 .6],'w'};
