function[samples] = sample_linear_density_samples(domain,values, N_samples, interval)
% sample_linear_density_samples -- Samples from a density function
%
% samples = sample_linear_density_samples(domain, values, N, interval)
%
%     Given pointwise samples of a positive function (domain, values), this
%     takes N samples assuming that the underlying function represents desired
%     density values. The function is linearly interpolated and
%     integrated to form a full function. 

persistent linear_integrator sample_density_function
if isempty(sample_density_function)
  from labtools.sampling import sample_density_function
  from labtools.sampling import linear_integrator
end

domain = domain(:);  % Meh, just in case.
values = values(:);
myfun = @(z) linear_integrator(domain, values, z);

samples = sample_density_function(interval, myfun, N_samples);
