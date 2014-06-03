function [features] = extract_features(train_data, windowlen, NW, ...
                                       NFFT, f_s, overlap)
% EXTRACT_FEATURES - Extracts band limited power features from input signals based on periods of activity
%   

%%

% parameters
datalength = size(train_data, 1);
numchannels = size(train_data, 2);
deltaN = windowlen * (1 - overlap);
channels = 1:numchannels;
M = size(channels, 2); % number of features at each timestep

featurelen = (datalength - windowlen*overlap)/deltaN;
m_l_features = zeros(featurelen, M);
m_h_features = zeros(featurelen, M);
psd_features = cell(1, numchannels);
for c=channels
    psd_features{c} = zeros(featurelen, NFFT/2+1);
end
tStart = tic;
for t = 1:featurelen % Calculate features at each point in time
    from = (t-1)*deltaN + 1;
    to = from + windowlen - 1;
    
    window = train_data(from:to, :);
    [X, psd] = psdfeature(window, f_s, channels, NW, NFFT);
    for c=channels
        psd_features{c}(t,:) = psd(c,:);
    end
    m_l_features(t, :) = X(1, :);
    m_h_features(t, :) = X(2, :);
    if mod(t, round(featurelen/100)) == 0
        fprintf('.')
    end
    
    if mod(t, round(featurelen/10)) == 0
        tTenPercent = toc(tStart);
        tStart = tic;
        fprintf(' - %.1f seconds\n', tTenPercent)
    end
end
features = struct('low_features', m_l_features, 'high_features', ...
                  m_h_features, 'psd_features', psd_features, 'NW', NW, 'windowlen', windowlen, ...
                  'overlap', overlap);

end
