addpath('./audio');

frameLength = 256;
frameLength = 64;
fileReader = dsp.AudioFileReader( ...
    'gunshot_dry.wav', ...
    'SamplesPerFrame',frameLength);

% fileReader = audioDeviceReader;
playRec = audioPlayerRecorder;
deviceWriter = audioDeviceWriter( ...
    'SampleRate',fileReader.SampleRate);

scope = timescope( ...
    'SampleRate',fileReader.SampleRate, ...
    'TimeSpan',2, ...
    'BufferLength',fileReader.SampleRate*2*2, ...
    'YLimits',[-1,1], ...
    'TimeSpanOverrunAction',"Scroll");

reverb = reverberator( ...                  %<--- new lines of code
    'SampleRate',fileReader.SampleRate, ... %<---
    'PreDelay',0, ...                     %<---  
    'WetDryMix',0.4);                       %<---

tic
while toc < 10
% while ~isDone(fileReader)
%     signal = fileReader();
%     reverbSignal = reverb(signal);          %<---
% %     outSignal = filter(b,a,signal);
%     deviceWriter(reverbSignal);             %<---
    audioToDevice = reverb(audioFromDevice);
    audioFromDevice = playRec(audioToDevice);
    scope([audioFromDevice,mean(audio,2)])    %<---
end

% release(fileReader)
% release(deviceWriter)
release(playRec)
release(reverb)                             %<---
release(scope)