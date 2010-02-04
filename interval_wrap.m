function[inp] = interval_wrap(inp, interval)
% interval_wrap -- Performs mod(inp, interval)
%
% wrapped = interval_wrap(inp, interval)
%
%     "Wraps" the input so that the values lie in the specified interval.

inp = mod(inp - interval(1), interval(2) - interval(1)) + interval(1);
