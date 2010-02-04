function[samples] = sample_linear_stepsize_samples(domain,values, N_samples, interval)
% sample_linear_stepsize_samples -- Samples from a stepsize distribution
%
% samples = sample_linear_stepsize_samples(domain, values, interval)
%
%     Given pointwise samples of a positive function (domain, values), this
%     takes samples assuming that the underlying function represents desired
%     stepsize values. The function is linearly interpolated and
%     integrated to form a full function. 

persistent linear_integrator
if isempty(sample_stepsize_function)
  %from labtools.sampling import sample_stepsize_function
  from labtools.sampling import linear_integrator
end

domain = domain(:);  % Meh, just in case.
values = values(:);
myfun = @(z) linear_integrator(domain, values, z);

scale = diff(interval)/myfun(interval(2));

samples = interval(1) + myfun(linspace(interval(1), interval(2), N_samples).')*scale;

% WTF
%samples = sample_stepsize_function(interval, myfun, N_samples);
