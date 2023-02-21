function [] = psd(s,fs)
    nfft = 512;
    noverlap = 256;
    [pxx,f] = pwelch(s,nfft,noverlap,nfft,fs);

    % omit DC offset
    pxx = pxx(3:end);
    f = f(3:end);

    figure(1)
    semilogx(f,10*log10(pxx))
    xlabel('Frequency (Hz)')
    ylabel('PSD [dB/Hz]')
    grid("on")
    xticks([10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000])     
end