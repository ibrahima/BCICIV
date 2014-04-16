function Hd = lf_bandpass
%LF_BANDPASS Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.1 and the Signal Processing Toolbox 6.19.
% Generated on: 16-Apr-2014 02:33:39

Fstop1 = 1;     % First Stopband Frequency
Fpass1 = 10;    % First Passband Frequency
Fpass2 = 50;    % Second Passband Frequency
Fstop2 = 60;    % Second Stopband Frequency
Astop1 = 60;    % First Stopband Attenuation (dB)
Apass  = 1;     % Passband Ripple (dB)
Astop2 = 60;    % Second Stopband Attenuation (dB)
Fs     = 1000;  % Sampling Frequency

h = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', Fstop1, Fpass1, ...
    Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);

Hd = design(h, 'equiripple', ...
    'MinOrder', 'any');


