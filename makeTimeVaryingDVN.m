function [dvn, dvn_eNorm] = makeTimeVaryingDVN(paramWidth, paramDens,fs,t)
% MAKETIMEVARYINGDVN
%
% INPUT
% paramWidth = [2 x n]  row 1 contains time samples, row 2 contains a
%                       percentage in range [0,1] of Td, describing the 
%                       max pulse width at time in row 1.
% paramDens = [2 x n]   row 1 contains time samples, row 2 contains
%                       pulse density at time in row 1. 
% fs = samples/second   Sampling frequency
% t = seconds           Velvet noise targetted duration

% Parse inputs to usable
wPercentTime = round(paramWidth(1,:)*fs);
wPercent = paramWidth(2,:);        % see docstring above, a percentage of Td. 
TdTime = round(paramDens(1,:)*fs);
Td = round(fs./paramDens(2,:));    % Avg distance btw impulses, in samples
Nd = round(paramDens(2,:));        % Pulse Density

maxPulseWidth = max(Td);
maxNumPulses = round(max(paramDens(2,:))*t);

%%%% Initialize variables %%%%
% outputs
dvn = zeros(fs*t+maxPulseWidth,1);
dvn_eNorm = zeros(fs*t+maxPulseWidth,1);
k = zeros(maxNumPulses,1);
% constants
w_min = 1;
% variables
blocksize = Td(1);
blockDensity = Nd(1);
wp = wPercent(1);
% counters
traversed = 0;
m = 1;

while traversed < length(dvn)

    k_m = round(rand*blocksize);
    k(m) = traversed + k_m; % starting index of pulse
    m = m+1;

    w_max = max(round(wp*blocksize),w_min);
    w = round(rand*(w_max-w_min) + w_min); % width of pulse

    s = 2*round(rand)-1;    % sign of pulse
    sNorm = s* 1000/(sqrt(w_max* blockDensity));

    if w + k_m <= blocksize
        dvn(traversed + k_m : traversed + k_m + w) = s;
        dvn_eNorm(traversed + k_m : traversed + k_m + w) = sNorm;
    else
        dvn(traversed + k_m : traversed + blocksize) = s;
        dvn_eNorm(traversed + k_m : traversed + blocksize) = sNorm;
    end

    traversed = traversed + blocksize;  % increment number of traversed samples
    
    % Get block size and pulse width percentage for next pulse
    i_block = find(TdTime < traversed,1,"last");
    blocksize = Td(i_block);
    blockDensity = Nd(i_block);
    i_pWidth = find(wPercentTime < traversed,1,"last");
    wp = wPercent(i_pWidth);
end
dvn_eNorm = dvn_eNorm/max(abs(dvn_eNorm));

% Plotting 
figure
tiledlayout(2,1)
nexttile
stem(dvn_eNorm,"filled")
set(gca,"XLim",[0 400])
set(gca,"YLim",[-1.2 1.2])
title("First 400 Samples")
nexttile
stem(dvn_eNorm,"filled")
set(gca,"XLim",[length(dvn)-400 inf])
set(gca,"YLim",[-1.2 1.2])
title("Last 400 Samples")

