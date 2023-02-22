% Testbench for RRS filter
clear; clc; close all;

% unit impulse input at n=10
s = zeros(100,1);
s(10) = 1;
s(30) = -1;
s(50) = 0.3;
figure(1);

subplot(1,2,1)
stem(s);

rrs_obj = rrs(8, 1e-3);

subplot(1,2,2)
stem(rrs_obj(s));
