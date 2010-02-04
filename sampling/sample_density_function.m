function[samples] = sample_density_function(interval, stepfun, N_samples)
% sample_density_function -- Samples a function handle for samples
%
% samples = sample_density_function(interval, stepfun, N_samples)
%
%     Given a sampling interval and a funtion stepfun defined on that interval,
%     this function assumes that stepfun is the primitive of a function that
%     represents density. I.e., it assumes that stepfun = \int
%     desired_density. stepfun will be normalized appropriately. N_samples must
%     be greater than 1, and the samples always include the endpoints.

persistent bisection
if isempty(bisection)
  from labtools.rootfind import bisection
end

assert(N_samples>1, 'Error: you must request at least two samples');



scale = diff(interval);
current_scale = stepfun(interval(2)) - stepfun(interval(1));
newfun = @(x) scale/current_scale*(stepfun(x) - stepfun(interval(1)));

if N_samples>2
  left_sample_guess = interval(1)*ones([N_samples-2 1]);
  right_sample_guess = interval(2)*ones([N_samples-2 1]);

  temp = linspace(interval(1), interval(2), N_samples).';
  temp([1,end]) = [];
  samples = bisection(left_sample_guess, right_sample_guess, newfun, 'F', temp, 'x_tol', 1e-14);
else
  samples = [];
end

samples = [interval(1); samples; interval(2)];
