%%
% clc;
% clear;
% close all;
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

windowlen = 40;
%% Preprocessing

% Calculate common average over time
ca = sum(train_data,2)/numchannels;
% Subtract common average from all channels
train_data = train_data - repmat(ca, 1, numchannels);

bb = beta_bandpass();

gb = hf_butterworth();

btime = filter(bb, train_data);
gtime = filter(gb, train_data);

featurelen = datalength/windowlen;
features = zeros(featurelen, M);
for C = 1:M % For each channel
    features(:, C) = sum(buffer(train_data(:,channels(C)).^2, ...
                                windowlen) );
end

% for k = 1:windowlen:(datalength-windowlen)
% end