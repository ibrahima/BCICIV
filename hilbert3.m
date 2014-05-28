%%
clc;
clear;
close all;
%%
load('data/sub1_comp.mat');

% parameters
f_s = 1000;

neighborhood = 4096; % Time area around a movement to sample data
NFFT = 256;
overlap = .875; % Percent overlap
datalength = size(train_data, 1);
numchannels = size(train_data, 2);
samplesperhood = (neighborhood - NFFT*overlap)/(NFFT*(1-overlap));
deltaN = NFFT * (1 - overlap);
channel = 43;
channels = [1 40 43 21 42 23]; % 
timeoffset = 50; % Offset from movement to brain activity
finger = 1;
M = size(channels, 2); % number of features

%% Preprocessing

% Calculate common average over time
ca = sum(train_data,2)/numchannels;
% Subtract common average from all channels
train_data = train_data - repmat(ca, 1, numchannels);

hilbert_data = hilbert(train_data);

%% Butterworth Filtering - doesn't seem to work? o_O
% Wp = [12 20]/(f_s/2); Ws = [1 30]/(f_s/2);
% Rp = 3; Rs = 40; % pass band ripple, stop band attenuation
% [n,Wn] = buttord(Wp,Ws,Rp,Rs); % Calculates filter order and cutoffs
% bf = butter(n, Wn, 'bandpass'); % 3rd order 12-20hz filter as

% figure,plot(bf)
% % used in Miller et al
% NFFTa=1024;
% f = -0.5:1/NFFTa:(0.5-1/NFFTa);

% figure;
% plot(f, fftshift(abs(fft(bf, NFFTa))))

%%
beta_equiripple = beta_bandpass();

beta_timedata = filter(beta_equiripple, train_data);

gbf = hf_bandpass();
hf_timedata = filter(gbf, train_data);
beta_hilbert = hilbert(train_data);
%%
beta_phase = angle(beta_hilbert);
% figure,plot(angle(beta_hilbert(:,1)))

%%
K = 24;
step=2*pi/K;
bins = -pi:step:pi;
timezones=zeros(datalength,numchannels,K);

for k=1:K
    timezones(:,:,k) = beta_phase > bins(k) & beta_phase < bins(k+ ...
                                                      1);
end
