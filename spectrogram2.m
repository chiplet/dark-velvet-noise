function [] = spectrogram2(s,fs)
%SPECTROGRAM2 Plot audio spectrogram
    
    figure;
    nfft = 2^10;
    noverlap = 2^9;
    nfreq = 2^12;
    [s,f,t]=spectrogram(s, nfft, noverlap, nfreq, fs, 'yaxis');

    % normalize
%     s = s ./ max(abs(s));

    surf(t,f,abs(s),'EdgeColor','none')
    view([0 90])
    axis tight

    ylabel('PSD [dB/Hz]','Interpreter','latex')
    set(gca,'YScale','log')
    yticks([100, 1000, 10000])
    yticklabels({'100', '1k', '10k'})
    ylim([20, 20000])

    xlabel('Time [s]','Interpreter','latex')
    colorbar
    colormap hot
end