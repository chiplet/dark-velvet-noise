function [s_out] = normalizeLoudness(s_in,fs)
    [loudness, LRA] = integratedLoudness(s_in,fs);
    target = -19;
    gaindB = target - loudness;
    gain = 10^(gaindB/20);
    s_out = s_in.*gain;
end

