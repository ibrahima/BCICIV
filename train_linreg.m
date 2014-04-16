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
samplesperhood = (neighborhood - NFFT*overlap)/(NFFT*(1-overlap));
deltaN = NFFT * (1 - overlap);
channel = 43;
channels = [1 40 43 21 42 23]; % 
timeoffset = 50; % Offset from movement to brain activity
finger = 1;
M = size(channels, 2); % number of features

%%

% Let's just look at channel 39 and 43 to start with
% Channel 55 for finger 3 stands out, huh..
% For each 100ms time period:
% - Calculate power spectrum for segment
% - 

% use whole dataset
% remove low frequency drift from finger data
% sweep lag to see if it works
% how to implement algorithms in real time - long term, next quarter

% Do what Liang did, keep multiple points back in time and multiple features
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
    
    for i = 1:samplesperhood
        beg = from + (i-1)*deltaN;
        en = beg + NFFT - 1;
        if(en > datalength)
            break;
        end
        X = multigammafeature(train_data(beg:en, :), f_s, channels);
        n = (k-1)*samplesperhood + i;
        features(n, :) = X;
        t = beg + timeoffset;
        values(n) = train_dg(t , finger);
        T(n) = t;
    end
end

%%
x = [features];
y = values;

b = pinv(x' * x)*x'*y;

yhat = x*b;
figure;
hold all;
plot(y, '-+');
plot(yhat, '--o');
yresid = yhat - y;
ydemean = y - mean(y);

legend('Actual position', 'Estimated Position (OLS)');

% r = 1 - sum(yresid.^2)/sum(ydemean.^2);

r = corr(x,y)
figure;
plotyy(T, values, T, features);
legend('values', 'features');

%%
% sweep offset
T = T - timeoffset;
blah=0;
foo2=0;
i=1;
offsetsweep = -300:10:300;
for timeoffset = offsetsweep
    Tx = T + timeoffset;
    values = train_dg(Tx, finger);
    rrr = sum(abs( corr (features,values)));
    
    x = [features];
    y = values;

    b = pinv(x' * x)*x'*y;

    yhat = x*b;

    blah(i) = rrr;
    foo(i) = corr(yhat, y);
    i = i + 1;
end

figure;
plot(offsetsweep, blah);
figure;
plot(offsetsweep, foo);
title('correlation between prediction and actual')
%%
Tx = T + 270;
values = train_dg(Tx, finger);

x = [features];
y = values;

b = pinv(x' * x)*x'*y;

yhat = x*b;
figure;
hold all;
plot(y, '-+');
plot(yhat, '--o');
yresid = yhat - y;
ydemean = y - mean(y);

%%

% for c = 1:62
%     [feats, vals, Tn] = extract_features(train_data, train_dg, 1, ...
%                                          2048, NFFT, c, ...
%                                          timeoffset, f_s);

%     rho = corr(feats, vals);
%     fprintf('Channel %d: rho=%f\n', c, rho);
% end


%%

Ta = 1:40:(datalength-40);
allfeatures = zeros(size(Ta,2), M);
nn = 1;
for t=Ta

    beg = t;
    en = beg + NFFT - 1;
    if(en > datalength)
        break;
    end
    X = multigammafeature(train_data(beg:en, :), f_s, channels);
    allfeatures(nn, :) = X;
    nn = nn + 1;
end

values = train_dg(Ta, finger);

yallhat = features*b;
