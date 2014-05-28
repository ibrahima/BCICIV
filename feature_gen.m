load('data/sub1_comp.mat');

f_s = 1000;
overlap = .75; % Percent overlap
NFFT=256;
windowlen = 100;
NW=2.5;

%
datalength = size(train_data, 1);
numchannels = size(train_data, 2);
deltaN = windowlen * (1 - overlap);

tic;
features_x = extract_features(train_data, windowlen, NW, NFFT, f_s, ...
                              overlap);
toc;