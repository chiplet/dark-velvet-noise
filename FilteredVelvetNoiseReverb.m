%%%%% ELEC-E5620 Audio Signal Processing Demo Project %%%%%
%%%%% Filtered Velvet Noise Reverberation Algorithm %%%%%
clear all; close all; clc;
addpath('./audio');

%% 1. Velvet noise generation 

fs = 44100;
Nd = 2205;      % Pulse density: pulses/sec
% fs = 100;
% Nd = 5;      % Pulse density: pulses/sec
Td = fs/Nd;     % Avg distance btw impulses, in samples
sec = 2;        % Velvet noise duration
samp = fs*sec;  % Num samples
puls = Nd*sec;   % Num pulses

s = zeros(fs*sec,1);
m = 0:puls-1;   % Pulse counter

k = round(m*Td + rand(size(m))*(Td-1)); % Impulse positions
s(k) = 2*round(rand(size(m)))-1;

%% 2. Dark Velvet noise

% Create dark velvet noise with pulse width
m = 0:puls-1;
w_min = 1;
w_max = round(0.50*Td);
w = round(rand(size(m))*(w_max-w_min) + w_min);
k = round(m*Td + rand(size(m)).*(Td-w));
s_m = 2*round(rand(size(m)))-1;

dvn = zeros(fs*sec,1);
for i = 0:samp-1
    m_ = floor(i/Td)+1;
    n = i+1;
    if k(m_) <= n && n < k(m_) + w(m_)
        dvn(n) = s_m(m_);
    end
end

stem(dvn)

%% Exponential decay envelope

t60 = 2; % 2 seconds reverberation
dvn_env = applyExponentialDecay(t60, dvn, fs);
plot(dvn_env)

[inSig, ~] = audioread("gunshot_dry.wav");
gunshot_reverb = [conv(inSig(:,1),dvn_env), conv(inSig(:,2),dvn_env)] ;

%% 3. Filtered Velvet Noise FVN Reverberation Algorithm

% FVN reverb algo divides the RIR into short non-overlapping segments and
% approximates each segment as filtered white noise. Velvet noise is used
% instead of standard white noise.

% Block diagram
%


dsfasdfsdf


















