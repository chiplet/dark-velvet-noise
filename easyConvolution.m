function [output] = easyConvolution(IR,input,fs)
%UNTITLED Summary of this function goes here
targetLoudness = -23;

%   Detailed explanation goes here
nfft = length(input) + length(IR) - 1;

% calculate IR
H = fft(IR, nfft, 1);

% Zero-padded input spectrum
X = fft(input, nfft, 1);

Y = H .* X;

% back to time-domain
output = real(ifft(Y));

end