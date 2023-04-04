function [] = psd(s,fs)
    nfft = 512;
    noverlap = 256;
    [pxx,f] = pwelch(s,nfft,noverlap,nfft,fs);

    % omit DC offset
    pxx = pxx(3:end);
    f = f(3:end);

    % normalize to 0dB
    pxx=pxx./max(pxx);

    semilogx(f,10*log10(pxx))
    title('Power Spectral Density','Interpreter','latex','FontSize',20)
    xlabel('Frequency (Hz)','Interpreter','latex','FontSize',18)
    ylabel('PSD [dB/Hz]','Interpreter','latex','FontSize',18)
    grid("on")
    xticks([10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000])     
end