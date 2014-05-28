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
