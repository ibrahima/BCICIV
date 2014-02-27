%%
clc;
clear;
close all;
%%
load('data/sub1_comp.mat');

% parameters
f_s = 1000;

neighborhood = 2048; % Time area around a movement to sample data
NFFT = 128;
samplesperhood = neighborhood/NFFT;
channel = 43;
timeoffset = 0; % Offset from movement to brain activity
finger = 1;
M = 1; % number of features
%%

% Let's just look at channel 39 and 43 to start with
% Channel 55 for finger 3 stands out, huh..
% For each 100ms time period:
% - Calculate power spectrum for segment
% - 


[pks, idxs] = findpeaks(train_dg(:, finger), 'MINPEAKHEIGHT', ...
                        0.5, 'MINPEAKDISTANCE', neighborhood/2);
numpeaks = size(pks,1);
finger_movements = zeros(neighborhood, numpeaks);
features = zeros(numpeaks*samplesperhood, M);
values = zeros(numpeaks*samplesperhood, 1);
% calculating power spectrum for each period of motion
T = zeros(1, numpeaks*samplesperhood);
for k=1:numpeaks
    from = idxs(k)-neighborhood/2;
    to = idxs(k) + neighborhood/2-1;
    dataframes = buffer(train_data(from:to, channel), NFFT);
    for i = 1:size(dataframes, 2);
        X = gammafeature(dataframes(:,i), f_s);
        n = (k-1)*samplesperhood + i;
        features(n) = X;
        t = idxs(k) + (i-1)*NFFT/2 - timeoffset;
        values(n) = train_dg(t , finger);
        T(n) = t;
    end
end

%%
x = [features];
y = values;

b = (x' * x)\x'*y;

yhat = x*b;
figure;
hold all;
plot(y, '-+');
plot(yhat, '--o');
plot(y-yhat, '-*');
yresid = yhat - y;
ydemean = y - mean(y);

legend('Actual position', 'Estimated Position (OLS)');

% r = 1 - sum(yresid.^2)/sum(ydemean.^2);

r = corr(x,y)