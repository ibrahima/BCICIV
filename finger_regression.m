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
timeoffset = 150; % Offset from movement to brain activity
finger = 1;
M = size(channels, 2); % number of features
channels = [1 40 43 21 42 23]; % 

windowlen = 40;
featurelen = datalength/windowlen;
%%
fprintf(['| Finger | MSE | R | Max coeff channel | Max ' ...
         'coefficient | MSE 1-channel | \n']);
fprintf(['|---------+-----+-------------------+-----------------|\' ...
         'n']);
Bs = zeros(numchannels-1, numchannels);
nfold = 10;

L_features = 10*log10(m_l_features);
H_features = 10*log10(m_h_features);

corrs = zeros(20,5);
for j = -10:10
    timeoffset = -j*windowlen;
    T = (1:featurelen)*windowlen-timeoffset;
    % Lazy way to avoid out of bounds indices
    T = min(max (T, ones(size(T))), datalength*ones(size(T))); 
    finger_positions = train_dg(T, :);
    for finger = 1:5
        Y = finger_positions(:, finger);
        X = H_features(:, :);
        % Cut up data into training and validation sets
        cross_val_length = round(featurelen/nfold);
        training_length = featurelen - cross_val_length;
        
        xval_X = X((training_length+1):end, :);
        xval_Y = Y((training_length+1):end, :);
        Y = Y(1:training_length, :);
        X = X(1:training_length, :);

        % Perform least squares
        [b, mse] = ls_mse(X, Y);
        % Bs(:, channel) = b; % Store coefficients
        [maxb, maxi] = max(abs(b));
        % Cross validate
        xval_yhat = xval_X*b;
        cross_val_mse = mean((xval_yhat-xval_Y).^2);
        p = corr(xval_yhat, xval_Y);
        corrs(j+11,finger) = p;
        % Train using only max channel
        Xb = L_features(1:(training_length), maxi);
        xval_Xb = L_features((training_length+1):end, maxi);
        bb = ls_mse(Xb, Y);
        maxchan_mse = mean((xval_Xb*bb-xval_Y).^2);
        
        fprintf('| %d | %.2e | %.2f | %d | %.2f | %.2e | \n', finger, cross_val_mse, ...
                p, maxi, maxb, maxchan_mse);    
    end

end

figure;
plot(corrs);