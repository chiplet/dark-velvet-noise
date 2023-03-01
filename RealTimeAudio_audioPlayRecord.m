addpath('./audio');
frameSize = 512;
%frameSize = 2048;
bufferSize = frameSize;

fileReader = dsp.AudioFileReader('guitar.wav', ...
    'SamplesPerFrame',frameSize);
% fs = fileReader.SampleRate;
[dvn,fs] = audioread("dvn_02.wav");

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
IR = dvn;
convolver = BlockConvolver_DSP(frameSize,1,length(IR));
convolver.setIRs(IR);

%%
tic
while toc < 15
% while ~isDone(fileReader)
    disp(size(lastAudioRecorded));
%     audioToPlay = reverb(lastAudioRecorded);
    reverberated = convolver.process(lastAudioRecorded(:,1));
    audioToPlay = [reverberated reverberated];
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