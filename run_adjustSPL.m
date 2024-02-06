 clear all; close all; clc;
 
% name of the WAV files
fileName = { 'A1_alarmanlage', 'M1_auto', 'S1_polizei' };

% set a desired dB SPL to adjust signals
desiredSPL = 70;

% show plots ?
plot_figs = 1; % 1= yes; 0=no

for i = 1:length(fileName)
    
    % get input signal
    inputSignal = [pwd '\signals\' fileName{i} '.wav'];
    
    % get signals with adjusted SPL
    [outputSignal, fs] = adjustSPL(inputSignal, desiredSPL, plot_figs);
    
    % outputs are stored in a struct because they have different sizes adjust spl - (i.e. each column coresponds to a different signal)
    signals{i}.outputSignal = outputSignal;
    signals{i}.fs = fs;
    
end