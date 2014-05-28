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
samplesperhood = (neighborhood - NFFT*overlap)/(NFFT*(1-overlap));
deltaN = NFFT * (1 - overlap);
channel = 43;
channels = [1 40 43 21 42 23]; % 
timeoffset = 50; % Offset from movement to brain activity
finger = 1;
M = size(channels, 2); % number of features

%%
[pks, idxs] = findpeaks(train_dg(:, finger), 'MINPEAKHEIGHT', ...
                        0.5, 'MINPEAKDISTANCE', neighborhood/2);
numpeaks = size(pks,1);
finger_movements = zeros(neighborhood, numpeaks);
features = zeros(numpeaks*samplesperhood, M);
betas = zeros(numpeaks*samplesperhood, M);
gammas = zeros(numpeaks*samplesperhood, M);
values = zeros(numpeaks*samplesperhood, 1);
% calculating power spectrum for each period of motion
T = zeros(1, numpeaks*samplesperhood);
for k=1:numpeaks
    from = idxs(k)-neighborhood/2;
    to = idxs(k) + neighborhood/2-1;
    
    for i = 1:samplesperhood
        beg = from + (i-1)*deltaN;
        en = beg + NFFT - 1;
        if(en > datalength)
            break;
        end
        X = psdfeature(train_data(beg:en, :), f_s, channels);
        n = (k-1)*samplesperhood + i;
        % features(n, :) = X;
        betas(n, :) = X(1, :);
        gammas(n, :) = X(2, :);
        t = beg + timeoffset;
        values(n) = train_dg(t , finger);
        T(n) = t;
    end
end

%% Train EM
% m_1 = s^b_c * B + s^g_c