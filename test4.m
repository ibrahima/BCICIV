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

% % Calculate common average over time
% ca = sum(train_data,2)/numchannels;
% % Subtract common average from all channels
% train_data = train_data - repmat(ca, 1, numchannels);

% bb = beta_bandpass();

% gb = hf_butterworth();

% btime = filter(bb, train_data);
% gtime = filter(gb, train_data);

featurelen = datalength/windowlen;
m_l_features = zeros(featurelen, M);
m_h_features = zeros(featurelen, M);
for t = 1:featurelen % Calculate features at each point in time
    from = (t-1)*windowlen + 1;
    to = t*windowlen;
    
    window = train_data(from:to, :);
    X = psdfeature(window, f_s, channels);
    m_l_features(t, :) = X(1, :);
    m_h_features(t, :) = X(2, :);
    if mod(t, featurelen/100) == 0
        fprintf('.')
    end
end

% for k = 1:windowlen:(datalength-windowlen)
% end

%% EM-like algorithm

% consider channel 1, 40

% observations
M_L_1 = m_l_features(:, 1);
M_L_2 = m_l_features(:, 2);

M_H_1 = m_h_features(:, 1);
M_H_2 = m_h_features(:, 2);

% Initialize hidden vars
G_1 = M_H_1;
G_2 = M_H_2;
B = mean(m_l_features(:,1:2), 2);

S_B_1 = 1;
S_G_1 = 1;

S_B_2 = 1;
S_G_2 = 1;

for l = 1:100
    % 'E' step
    G_1 = M_H_1/S_G_1;
    G_2 = M_H_2/S_G_2;
    
    B = ((M_L_1 - S_G_1*G_1)./S_B_1 + (M_L_2 - S_G_2*G_2)./S_B_2)/2;
    
    % 'M' step
    % This is quite clearly broken
    S_B_1 = mean((M_L_1 - S_G_1*G_1)./B);
    S_B_2 = mean((M_L_2 - S_G_2*G_2)./B);
    
    S_G_1 = mean((M_H_1 - S_B_1*B)./G_1);
    S_G_2 = mean((M_H_2 - S_B_2*B)./G_2);
    S_G_1
end
    