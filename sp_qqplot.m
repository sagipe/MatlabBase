function [h mu sigma]= sp_qqplot(x,y,draw_lines)
% function sp_qqplot(x,y,draw_lines)
% 
% Wrappe for qqplot which also adds the X=Y line if draw_lines==true (default) and x & y are specified
%
% Sagi Perel, 04/2010

    if(~exist('draw_lines','var'))
        draw_lines = true;
    end

    switch(nargin)
        case 1

            % plot sample data against standard normal
            if size(x,1)==1
                x = x';
            end

            mu = nanmean(x);
            sigma = nanstd(x);

            [y,origindy]  =  sort(x);
            x = plotpos(y);
            origindx = [];
            x = norminv(x);
            xx = x;
            yy = y;
            xlab = 'Standard Normal Quantiles';
            ylab = 'Quantiles of Input Sample';
%             tlab = 'QQ Plot of Sample Data versus Standard Normal';
            tlab = '';
            
        case {2,3}

            % this line is not drawn for a qqplot, just qqnorm
            mu = NaN;
            sigma = NaN;
            
            % plot one sample against another
            if size(x,1)==1
                x = x';
            end
            if size(y,1)==1
                y = y';
            end

            xlab = 'X Quantiles';
            ylab = 'Y Quantiles';
            tlab = '';

            % find interpolation points using smaller sample, if none given
            nx = sum(~isnan(x));
            if (length(nx) > 1)
                nx = max(nx);
            end
            ny = sum(~isnan(y));
            if (length(ny) > 1)
                ny = max(ny);
            end
            n = min(nx, ny);
            pvec = 100*((1:n) - 0.5) ./ n;

            if size(x,1)==n
                xx = zeros(size(x));
                origindx = zeros(size(x));
                nancols = find(any(isnan(x),1));
                fullcols = find(all(~isnan(x),1));
                [xx(:,fullcols),origindx(:,fullcols)] = sort(x(:,fullcols));
                xx(:,nancols) = prctile(x(:,nancols),pvec);
                if size(x,2)==1 && size(y,2)~=1
                    origindx = repmat(origindx,1,size(y,2));
                end

            else
                xx = prctile(x,pvec);
                origindx = [];
            end
            if size(y,1)==n
                yy = zeros(size(y));
                origindy = zeros(size(y));
                nancols = find(any(isnan(y),1));
                fullcols = find(all(~isnan(y),1));
                [yy(:,fullcols),origindy(:,fullcols)] = sort(y(:,fullcols));
                yy(:,nancols) = prctile(y(:,nancols),pvec);
                if size(y,2)==1 && size(x,2)~=1
                    origindy = repmat(origindy,1,size(x,2));
                end
            else
                yy = prctile(y,pvec);
                origindy = [];
            end
            
            min_x = min(min(xx), min(yy));
            max_x = max(max(xx), max(yy));
            
        otherwise
            error('sp_qqplot only supports one or two input arguments');
    end

    newplot();
    hdat = line(xx,yy,'LineStyle','none','Marker','+');
    
    if(draw_lines)
        switch(nargin)
            case 1
                eq_line = mu + sigma .*xx;
                heq  = line(xx,eq_line); % red
                heq2 = line(xx, xx,'LineWidth',2);     % black
                tlab = [tlab ' Mean=' sprintf('%.2f',mu) ', SD=' sprintf('%.2f',sigma)];
                
            case {2,3}
                heq2  = line([min_x max_x],[min_x max_x]); % red
                heq   = []; % black
                % make sure x and y axis have the same limits
                ylim(xlim);
        end
    else
        heq  = [];
        heq2 = [];
    end
    
    if length(hdat)==1
        set(hdat,'MarkerEdgeColor','b');
        if(~isempty(heq))
            set(heq,'Color','r');
        end
        if(~isempty(heq2))
            set(heq2,'Color','k');
        end
    end
    if nargout>0
        h = [hdat;heq];
    end

    for i=1:length(hdat)
        % Set custom data cursor on data
        hB = hggetbehavior(hdat(i),'datacursor');
        set(hB,'UpdateFcn',@qqplotDatatipCallback);
        % Disable datacursor on reference lines
        if(~isempty(heq))
            hB = hggetbehavior(heq(i),'datacursor');
            set(hB,'Enable',false);
        end
        if length(hdat)>1
            setappdata(hdat(i),'group',i);
        end
        if ~isempty(origindx)
            setappdata(hdat(i),'origindx',origindx(:,i));
        end
        if ~isempty(origindy)
            setappdata(hdat(i),'origindy',origindy(:,i));
        end
    end


    xlabel(xlab);
    ylabel(ylab);
    title (tlab);
    make_plot_nicer();

    %===================== helper function ====================
    function pp = plotpos(sx)
    %PLOTPOS Compute plotting positions for a probability plot
    %   PP = PLOTPOS(SX) compute the plotting positions for a probability
    %   plot of the columns of SX (or for SX itself if it is a vector).
    %   SX must be sorted before being passed into PLOTPOS.  The ith
    %   value of SX has plotting position (i-0.5)/n, where n is
    %   the number of rows of SX.  NaN values are removed before
    %   computing the plotting positions.

    [n, m] = size(sx);
    if n == 1
       sx = sx';
       n = m;
       m = 1;
    end

    nvec = sum(~isnan(sx));
    pp = repmat((1:n)', 1, m);
    pp = (pp-.5) ./ repmat(nvec, n, 1);
    pp(isnan(sx)) = NaN;

    %===================== callback ====================
    function datatipTxt = qqplotDatatipCallback(obj,evt)

    target = get(evt,'Target');
    pos = get(evt,'Position');
    ind = get(evt,'DataIndex');

    group = getappdata(target,'group');
    origindx = getappdata(target,'origindx');
    origindy = getappdata(target,'origindy');


    datatipTxt = {
        ['x: ',num2str(pos(1))],...
        ['y: ',num2str(pos(2))]...
        };

    if ~isempty(group) || ~isempty(origindx) || ~isempty(origindy)
        datatipTxt{end+1} = '';
    end

    if ~isempty(group)
        datatipTxt{end+1} = ['Group: ',num2str(group)];
    end
    if ~isempty(origindx)
        dat = origindx(ind);
        if dat~=0
            datatipTxt{end+1} = ['X observation: ',num2str(dat)];
        end
    end
    if ~isempty(origindy)
        dat = origindy(ind);
        if dat~=0
            datatipTxt{end+1} = ['Y observation: ',num2str(dat)];
        end
    end