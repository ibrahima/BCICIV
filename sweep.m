%%
% clc;
% clear;
% close all;
%%
load('data/sub1_comp.mat');

% parameters
f_s = 1000;

neighborhood = 4000; % Time area around a movement to sample data
NFFT = 100;
samplesperhood = neighborhood/NFFT;
channel = 43;
timeoffset = -50; % Offset from movement to brain activity
finger = 1;
M = 1; % number of features
N = size(train_data, 1);
%%

[pks, idxs] = findpeaks(train_dg(:, finger), 'MINPEAKHEIGHT', ...
                        0.5, 'MINPEAKDISTANCE', neighborhood/2);
numpeaks = size(pks,1);
finger_movements = zeros(neighborhood, numpeaks);
features = zeros(numpeaks*samplesperhood, M);
values = zeros(numpeaks*samplesperhood, 1);
% calculating power spectrum for each period of motion
fprintf('[');
for channel = 1:62
    T = zeros(1, numpeaks*samplesperhood);
    for k=1:numpeaks
        from = idxs(k)-neighborhood/2;
        to = idxs(k) + neighborhood/2-1;
        dataframes = buffer(train_data(from:to, channel), NFFT);
        for i = 1:size(dataframes, 2);
            X = gammafeature(dataframes(:,i), f_s);
            n = (k-1)*samplesperhood + i;
            features(n) = X;
            t = min(max(from + (i-1)*NFFT - timeoffset, 1), N);
            values(n) = train_dg(t , finger);
            T(n) = t;
        end
    end

    %%
    x = [features];
    y = values;

    b = (x' * x)\x'*y;

    yhat = x*b;
    r = corr(x,y);
    fprintf('%d %f;\n', channel, r);
end
fprintf(']\n');
%%

% for c = 1:62
%     [feats, vals, Tn] = extract_features(train_data, train_dg, 1, ...
%                                          2048, NFFT, c, ...
%                                          timeoffset, f_s);

%     rho = corr(feats, vals);
%     fprintf('Channel %d: rho=%f\n', c, rho);
% end