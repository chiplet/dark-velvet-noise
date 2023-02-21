%%%%% ELEC-E5620 Audio Signal Processing Demo Project %%%%%
%%%%% Filtered Velvet Noise Reverberation Algorithm %%%%%
clear all; close all; clc;

%% 1. Velvet noise generation 

fs = 44100;
Nd = 2205;      % Pulse density: pulses/sec
% fs = 100;
% Nd = 5;      % Pulse density: pulses/sec
Td = fs/Nd;     % Avg distance btw impulses, in samples
sec = 1;        % Velvet noise duration

s = zeros(fs*sec,1);
m = 0:Nd*sec-1;   % Pulse counter

k = round(m*Td + rand(size(m))*(Td-1)); % Impulse positions
s(k) = 2*round(rand(size(m)))-1;

%% 2. Velvet noise convolution

% Time-domain convolution is highly economical
% Samples of the velvet noise sequence are used as FIR filter coefficients
% Convolution reduces to a sparse multiplication-free convolution because 
% nonzero samples in the velvet noise are -1 or 1.

% In practice, 
% the input signal is propagated in the delay line of the filter. Add 
% Run through the indicies of non-zero filter values and the corresponding 
% values from the delay line are added and subtracted.
% Computation: when 5% of the velvet noise coefficients are nonzero, there
% are 0.05*L computations, compared to 2L-1 computations

%% 3. Filtered Velvet Noise FVN Reverberation Algorithm

% FVN reverb algo divides the RIR into short non-overlapping segments and
% approximates each segment as filtered white noise. Velvet noise is used
% instead of standard white noise.

% Block diagram
%


dsfasdfsdf


















