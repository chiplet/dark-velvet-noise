addpath('./audio');
frameSize = 256;
%frameSize = 2048;
bufferSize = frameSize;

fileReader = dsp.AudioFileReader('guitar.wav', ...
    'SamplesPerFrame',frameSize);
fs = fileReader.SampleRate;

fileWriter = dsp.AudioFileWriter('guitar-PlaybackRecorded.wav', ...
    'SampleRate',fs);

%aPR = audioPlayerRecorder('SampleRate',fs);
aPR = audioPlayerRecorder('SampleRate',fs,'SupportVariableSize',true,'BufferSize',bufferSize);
% if windows computer, open asio settings
asiosettings(aPR.Device);

reverb = reverberator( ...                  %<--- new lines of code
    'SampleRate',fileReader.SampleRate, ... %<---
    'PreDelay',0, ...                     %<---  
    'WetDryMix',0.4); 

lastAudioRecorded = [1:frameSize].'*0;
%%
tic
while toc < 15
% while ~isDone(fileReader)
    audioToPlay = reverb(lastAudioRecorded);
    [audioRecorded,nUnderruns,nOverruns] = aPR(audioToPlay);

    lastAudioRecorded = audioRecorded;
    
    fileWriter(audioRecorded)
    
    if nUnderruns > 0
        fprintf('Audio player queue was underrun by %d samples.\n',nUnderruns);
    end
    if nOverruns > 0
        fprintf('Audio recorder queue was overrun by %d samples.\n',nOverruns);
    end
end
release(reverb)
release(fileReader)
release(fileWriter)
release(aPR)