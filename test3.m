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

%% Preprocessing

% Calculate common average over time
ca = sum(train_data,2)/numchannels;
% Subtract common average from all channels
train_data = train_data - repmat(ca, 1, numchannels);

%%
bf = butter(8, [2*1/f_s, 2*50/f_s]);
gf = butter(14, [2*66/f_s, 2*200/f_s]);
hgf = butter(8, [2*100/f_s, 2*200/f_s]);

btime = filter(bf, 1, train_data);
gtime = filter(gf, 1, train_data);
hgtime = filter(hgf, 1, train_data);

c1 = btime(:,1);
c1bf = buffer(c1, 40);
c1bx = sum(c1bf.^2);

c40 = btime(:, 40);
c40bf = buffer(c40, 40);
c40bx = sum(c40bf.^2);
c40g = gtime(:, 40);
c40gf = buffer(c40g, 40);
c40gx = sum(c40gf.^2);
T = 1:size(c40bx, 2);
figure,plot(T, c1bx, T, c40bx, T, c40gx);
legend('c1 beta', 'c40 beta', 'c40 gamma');
