function [x_decay] = applyExponentialDecay(t60, x, fs)
%APPLYEXPONENTIALDECAY Applies exponential decay envelope to a signal
%   INPUTS:
%   t60 = t60 decay time in seconds
%   x = input signal 
%   fs = sampling frequency
%
%   OUTPUTS:
%   x_decayed = exponential decayed signal
decay_60db = db2mag(-60);

a = decay_60db^(1/t60);
t = 0:length(fs,1).'/fs; % time vector

exp_env = a.^t;
x_decay = x.*exp_env;

end

