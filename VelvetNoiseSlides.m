%%%%% ELEC-E5620 Audio Signal Processing Demo Project %%%%%
%%%%% Filtered Velvet Noise Reverberation Algorithm %%%%%
% clear all; close all; clc;
clear all; clc;
addpath('./audio');

%% 1. Velvet noise generation 

fs = 44100;
Nd = 2205;      % Pulse density: pulses/sec
Td = fs/Nd;     % Avg distance btw impulses, in samples
sec = 2;        % Velvet noise duration
samp = fs*sec;  % Num samples
puls = Nd*sec;   % Num pulses

s = zeros(fs*sec,1);
m = 0:puls-1;   % Pulse counter

k = round(m*Td + rand(size(m))*(Td-1)); % Impulse positions
s(k) = 2*round(rand(size(m)))-1;

s_norm = normalizeLoudness(s,fs);
audiowrite("output/ovn.wav",s_norm,fs);
figure
psd(s,fs);
saveas(gcf,'output/ovn-spectrum.png')

figure
hold on
plot_n = 100;
stem(s(1:plot_n))
ylim([-1.25,1.25])
title("Original Velvet Noise",'Interpreter','latex','FontSize',20)
xlabel('Sample index $n$','Interpreter','latex','FontSize',18)
ylabel('Amplitude','Interpreter','latex','FontSize',18)
xline(0:Td:plot_n)
saveas(gcf,'output/ovn-stem.png')

%% 2. Dark Velvet noise

% Create dark velvet noise with pulse width
close all;

for wi = 20:20:80
    m = 0:puls-1;
    w_min = 1;
    w_max = round(wi/100.0*Td);
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

    wavfile = sprintf("output/dvn-%d.wav", wi);
    specfile = sprintf("output/dvn-spectrum-%d.png", wi);
    figure
    psd(dvn,fs);
    titlestr = sprintf("$$w_{\\max}=%.2f$$",wi/100.0);
    title(titlestr,'Interpreter','latex','FontSize',20)
    saveas(gcf, specfile)

    dvn_norm = normalizeLoudness(dvn,fs);
    audiowrite(wavfile,dvn_norm,fs);


    stemfile = sprintf("output/dvn-stem-%d.png", wi);
    figure
    hold on
    plot_n = 100;
    stem(dvn(1:plot_n))
    ylim([-2,2])
    title(titlestr,'Interpreter','latex','FontSize',20)
    xlabel('Sample index $n$','Interpreter','latex','FontSize',18)
    ylabel('Amplitude','Interpreter','latex','FontSize',18)
    xline(0:Td:plot_n)
    saveas(gcf,stemfile)
end

%% Time Varying DVN
clear all; close all; clc;
addpath('./audio')
fs = 44100;
t = 4;
[param_width, param_dens] = createUserInputPlots(t,2205,500);
dvnVarying = makeTimeVaryingDVN(param_width,param_dens,fs,t);
dvnVaryingNorm = normalizeLoudness(dvnVarying,fs);


figure
spectrogram2(dvnVaryingNorm,fs);
title('Time-varying DVN','Interpreter','latex','FontSize',16)
pbaspect([2 1 1])
saveas(gcf, 'output/dvn-spectrogram.png')


audiowrite('output/dvn-varying.wav',dvnVaryingNorm,fs);









