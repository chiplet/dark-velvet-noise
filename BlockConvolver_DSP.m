classdef BlockConvolver_DSP < DSP
%BLOCKCONVOLVER_DSP Overlap-add convolution with variable filters.
% CFH 2020 
% PROVIDED %
    
    properties
        IRs  % [IRlength x nCH], stored by setIRs
        H  % Frequency domain, stored by setIRs
    end

    properties(Access = private)
        IRlength  % from constructor
        overlap  % from process()
    end

    
    methods
        function obj = BlockConvolver_DSP(blockSize, numChannels, IRlength)
            %BlockConvolver_DSP Initialize convolver.
            obj.blockSize = blockSize;
            obj.IRlength = IRlength;
            obj.numberOfInputs = numChannels;
            obj.numberOfOutputs = numChannels;

            % initialize with zeros
            obj.setIRs(zeros(IRlength, numChannels));
            obj.overlap = zeros(obj.IRlength - 1, obj.numberOfInputs);
        end
        
        function setIRs(obj, IRs)
            % SETIRS Set new set of filters.
            %   INPUT : [IRlength x nCH]
            assert(size(IRs, 1) == obj.IRlength, ...
                   "Check initialization")
            assert(size(IRs, 2) == obj.numberOfInputs, ...
                   "Check initialization")
            
            obj.IRs = IRs;
            % Pre-compute frequency domain representation
            nfft = (obj.blockSize + obj.IRlength) - 1;
            obj.H = fft(obj.IRs, nfft, 1);
        end
        
        function blockOutput = process(obj, input)
            % PROCESS Saves overlap and allows to interchange filters 
            % between calls with setIR().
            %   Input, Output : [blockSize x numCh]
            %   - call setIR() first.

            assert(size(input, 1) == obj.blockSize, ...
                   "BlockSize not " + num2str(obj.blockSize))
            assert(size(input, 2) == obj.numberOfInputs, ...
                   "NumChannels not " + num2str(obj.numberOfInputs))
            
            nfft = (obj.blockSize + obj.IRlength) - 1;
            
            % could precalculate in setIR
            %H = fft(obj.IRs, nfft, 1);
            
            % Zero-padded input spectrum
            X = fft(input, nfft, 1);
            
            Y = obj.H .* X;
            
            % back to time-domain
            y = real(ifft(Y));
            
            % overlap-add
            currentOut = y + cat(1, obj.overlap, ...
                                 zeros(obj.blockSize, obj.numberOfInputs));            
            % Extract block output
            blockOutput = currentOut(1:obj.blockSize, :);

            % Save new overlap
            obj.overlap = currentOut(obj.blockSize + 1 : end, :);
        end
        
        
    end
end

