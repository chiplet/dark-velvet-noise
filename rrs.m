function [rrs_obj] = rrs(M, eps)
% Creates RRS filter object with the given params

    % feedforward path
    b = zeros(1,M);
    b(1) = 1;
    b(M+1) = -(1-eps)^M;

    % feedback path
    a = [1 -(1-eps)];

    rrs_obj = dsp.IIRFilter('Numerator',b,'Denominator',a);
end
