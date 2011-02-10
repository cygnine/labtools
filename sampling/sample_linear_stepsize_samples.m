function[samples] = sample_linear_stepsize_samples(domain,values, N_samples, interval)
% sample_linear_stepsize_samples -- Samples from a stepsize distribution
%
% samples = sample_linear_stepsize_samples(domain, values, interval)
%
%     Given pointwise samples of a positive function (domain, values), this
%     takes samples assuming that the underlying function represents desired
%     stepsize values. The function is linearly interpolated and
%     integrated to form a full function. 

persistent linear_integrator bisection
if isempty(linear_integrator)
  %from labtools.sampling import sample_stepsize_function
  from labtools.sampling import linear_integrator
  from labtools.rootfind import bisection
end

domain = domain(:);  % Meh, just in case.
values = values(:);
myfun = @(z) linear_integrator(domain, values, z);

scale = diff(interval)/myfun(interval(2));

% The below is wrong...wtf was I thinking?
%samples = interval(1) + myfun(linspace(interval(1), interval(2), N_samples).')*scale;

% Use bisection to determine `equidensity' locations
endval = myfun(interval(2));

vals = linspace(0, endval, N_samples+1).';
vals(end) = [];
vals = vals + diff(vals(1:2))/2;

samples = bisection(ones([N_samples 1])*interval(1), ones([N_samples 1])*interval(2), myfun, 'F', vals);
