function txt = sp_get_date_now()
% function txt = sp_get_date_now()
% 
% Returns the current date and time as a string in the format:
% [YYYY]_[MM]_[DD]_[HH]_[MM]_[SS]
%
% e.g. 2012_01_11_14_54_43 
%
% Sagi Perel, 01/2012

    txt = regexprep(datestr(now, 31), {' ','-',':'},'_');
