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
w_max = round(0.80*Td);
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

%% Time Varying DVN
clear all; clc;
addpath('./audio')
fs = 44100;
t = 2;
[param_width, param_dens] = createUserInputPlots(t,2205,500);
[dvnVarying, dvnVarying_eNorm] = makeTimeVaryingDVN(param_width,param_dens,fs,t);
spectrogram2(dvnVarying,fs);  % spectrogram of unnormalized dvn
spectrogram2(dvnVarying_eNorm,fs);

% Exponential decay on time varying DVN
dvnVarying_env = applyExponentialDecay(t, dvnVarying_eNorm, fs);
figure
plot(dvnVarying_env)

% Convolution with inputs
%%%%
%%%% NOTE: Please find sounds with 44100Hz sample rate KIITOS ... or else
%%%% resample or rewrite code XP
%%%%

[inSig, ~] = audioread("gunshot_dry.wav");
gunshot_reverb = normalizeLoudness(easyConvolution(dvnVarying_env, inSig),fs);
% sound(gunshot_reverb,fs);

[inSig, ~] = audioread("Vocal.wav");
vocal_reverb = normalizeLoudness(easyConvolution(dvnVarying_env, inSig),fs);
sound(vocal_reverb,fs);

[inSig, ~] = audioread("guitar_twang.wav");
guitar_reverb = normalizeLoudness(easyConvolution(dvnVarying_env, inSig),fs);
sound(guitar_reverb,fs);

[inSig, ~] = audioread("tomsdiner.wav");
startidx = round(fs*33.35);  % we want 0:33-0:39 (trust me)
endidx = startidx + 6*fs ;
inSig = inSig(startidx:endidx,:);
diner_reverb = normalizeLoudness(easyConvolution(dvnVarying_env, inSig),fs);

%%
%%%% Exporting DVN and convolved sounds %%%%
version = "05";
audiowrite("audio\dvn_" + version + ".wav",dvnVarying_eNorm,fs);
audiowrite("audio\dvn_" + version + "_decay.wav",dvnVarying_env,fs);
audiowrite("audio\dvn_" + version + "_gunshot.wav",gunshot_reverb,fs);
audiowrite("audio\dvn_" + version + "_counting.wav",vocal_reverb,fs);
audiowrite("audio\dvn_" + version + "_guitar.wav",guitar_reverb,fs);
audiowrite("audio\dvn_" + version + "_tomsdiner.wav",diner_reverb,fs);

%% If you want to convolve with an old dvn:
addpath('./audio')
oldVersion = "01";
inputfilename = "XXXXX.wav";

[dvn_in, fs] = audioread("dvn_" + oldVersion + ".wav");
spectrogram2(dvn_in,fs)

% [inSig, ~] = audioread(inputfilename);
% outSig = [conv(inSig(:,1),dvn_in), conv(inSig(:,2),dvn_in)] ;
% audiowrite("audio\dvn_" + oldVersion + "_" + inputfilename, outSig ,fs);

%% Exponential decay envelope

t60 = 2; % 2 seconds reverberation
dvn_env = applyExponentialDecay(t60, dvn, fs);
plot(dvn_env)

[inSig, ~] = audioread("gunshot_dry.wav");
gunshot_reverb = [conv(inSig(:,1),dvn_env), conv(inSig(:,2),dvn_env)] ;
soundsc(gunshot_reverb,fs);
%% 3. Filtered Velvet Noise FVN Reverberation Algorithm

% FVN reverb algo divides the RIR into short non-overlapping segments and
% approximates each segment as filtered white noise. Velvet noise is used
% instead of standard white noise.

% Block diagram
%

inSig = sweeptone(2);
sweep_reverb = conv(inSig,dvn_env) ;

spectrogram2(dvn,fs);
psd(dvn,fs);

soundsc(sweep_reverb,fs);















