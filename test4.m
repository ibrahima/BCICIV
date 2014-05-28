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
channels = 1:numchannels;
timeoffset = 50; % Offset from movement to brain activity
finger = 1;
M = size(channels, 2); % number of features

windowlen = 100;
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

% foo    

%% Do some regressions, cross validate

% regress channel 1 beta against others
X = m_l_features(:, 2:end);
Y = m_l_features(:, 1);

[b, mse] = ls_mse (X, Y);

% regress channel 1 beta against gamma

[b1, mse1] = ls_mse(m_l_features(:, 1), m_h_features(:,1));

load('data/sub1_testlabels.mat');
%% Cross validation
fprintf(['| Channel | MSE | Max coeff channel | Max ' ...
         'coefficient |\n']);
fprintf(['|---------+-----+-------------------+-----------------|\' ...
         'n']);
Bs = 0;
nfold = 10;
for channel = 1:numchannels
    Y = m_l_features(:, channel);
    X = m_l_features;
    X(:, channel) = []; % Delete the column for the channel
    cross_val_length = round(featurelen/nfold);

    Y = Y(1:(featurelen-cross_val_length), :);
    X = X(1:(featurelen-cross_val_length), :);
    xval_X = X((featurelen-cross_val_length+1):end, :);
    xval_Y = Y((featurelen-cross_val_length+1):end, :);
    [b, mse] = ls_mse(X, Y);
    %Bs(:, channel) = b
    [maxb, maxi] = max(b);
    xval_yhat = xval_X*b;
    cross_val_mse = (xval_yhat-xval_Y).^2/cross_val_length
    fprintf('| %d | %.2e | %d | %.2f |\n', channel, cross_val_mse, maxi, maxb);
end