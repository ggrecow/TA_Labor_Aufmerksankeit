function [outputSignal, fs] = adjustSPL(inputSignal, desiredSPL, plot_figs)
%
% function [outputSignal, fs] = adjustSPL(inputSignal, desiredSPL, plot_figs)
%
% 1) load <inputSignal> and calculate total time duration, time vector, and compute SPL based on the
%     rms value of the entire input signal's length
%
% 2) calculate a <levelCorrectionFactor>, which is merely a scalar factor necessary to adjust the
%     SPL of <inputSignal> to a <desiredSPL>.
%
% 3) apply the <levelCorrectionFactor> to the <inputSignal> in order to obtain
%     <outputSignal>
%
% 4) plot the signals in time and frequency domain (optional)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUTS
%
%   inputSignal : string
%           - complete path of WAV input signal
%
%   desiredSPL : scalar
%           - desired level, in dB SPL, to adjust the level of <inSignal>
%
%   plot_figs : boolean
%           - option to plot the figures (1=yes and 0=no)
%
% OUTPUTS
%
%   outSignal : [Ntime,1] vector
%           - output sound file, which is a version of <inSignal>, but
%             adjusted to have a <desiredSPL>
%
%   fs : scalar
%           - sampling frequency of the input=output sound file
%
%
%  Gil Felix Greco, Braunschweig 06.02.2024
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% reference sound pressure (Pa)
pref = 2e-5;

%% Input signal

% load input signal
[inputSignal, fs] = audioread(inputSignal);

% input signal is stereo, keep just one. This needs to be adjusted if the
% two signals are desired
inputSignal = inputSignal(:,1);


% total time duration of the input signal
totalLength = length(inputSignal)./fs;

% time step of the input signal
dt = 1/fs;

% time vector of the input signal
timeVector = transpose(0:dt:totalLength-dt);

% RMS value of the input signal (Pa)
inputSignalRMS = rms(inputSignal);

% SPL of input signal based on the RMS value of the entire signal's length
inputSPL = 20.*log10(inputSignalRMS./pref);

%% compute level correction factor to adjust the SPL of the input signal to a desired SPL

levelCorrectionFactor =  10.^( (desiredSPL-inputSPL) /20 );

%% Output signal

% apply correction factor to input signal to get output signal
outputSignal = inputSignal.*levelCorrectionFactor;

% RMS value of the output signal (Pa)
outputSignalRMS = rms(outputSignal);

% check the SPL of the output signal
outputSPL = 20.*log10(outputSignalRMS./pref);

%% plots (pressure over time, amplitude in linear scale)

if plot_figs == 1
    
    figure('name','Signals in time domain');
    h = gcf;
    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])   % necessary to save figs in pdf format in the correct page size
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot input signal
    subplot(2,1,1)
    
    plot(timeVector,inputSignal);
    a=yline(inputSignalRMS,'r--');
    
    legend( a, sprintf( '$p_{\\mathrm{in,rms}}=%.2g$ (Pa) or SPL=%.2g (dB)', inputSignalRMS, inputSPL ), 'Location', 'NorthEast', 'Interpreter', 'Latex');
    
    ylabel('Sound pressure, $p$ (Pa)', 'Interpreter', 'Latex');
    xlabel('Time, $t$ (s)', 'Interpreter', 'Latex');
    
    
    title('Input signal');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot output signal
    subplot(2,1,2)
    
    plot(timeVector,outputSignal);
    a=yline(outputSignalRMS,'r--');
    
    legend( a, sprintf( '$p_{\\mathrm{out, rms}}=%.2g$ (Pa) or SPL=%.2g (dB)', outputSignalRMS, outputSPL), 'Location', 'NorthEast', 'Interpreter', 'Latex');
    
    ylabel('$p$ (Pa)','Interpreter','Latex');
    xlabel('Time, $t$ (s)', 'Interpreter', 'Latex');
    
    title('Output signal');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    set(gcf,'color','w');
    
else
end

end