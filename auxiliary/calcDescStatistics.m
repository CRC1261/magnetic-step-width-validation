function stat = calcDescStatistics(b)
%CALCDESCSTATISTICS Summary of this function goes here
%   Detailed explanation goes here
    stat.l.mn = mean(b.sw_l);
    stat.r.mn = mean(b.sw_r);
    stat.l.std = std(b.sw_l);
    stat.r.std = std(b.sw_r);
end

