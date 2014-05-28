fprintf(['| Channel | MSE | Max coeff channel | Max ' ...
         'coefficient | MSE 1-channel | MSE gamma | \n']);
fprintf(['|---------+-----+-------------------+-----------------|\' ...
         'n']);
Bs = zeros(numchannels-1, numchannels);
nfold = 10;
featurelen = datalength/windowlen;
for channel = 1:numchannels
    Y = m_l_features(:, channel);
    X = m_l_features;
    X(:, channel) = []; % Delete the column for the channel
    cross_val_length = round(featurelen/nfold);

    xval_X = X((featurelen-cross_val_length+1):end, :);
    xval_Y = Y((featurelen-cross_val_length+1):end, :);
    Y = Y(1:(featurelen-cross_val_length), :);
    X = X(1:(featurelen-cross_val_length), :);

    [b, mse] = ls_mse(X, Y);
    Bs(:, channel) = b;
    [maxb, maxi] = max(b);
    xval_yhat = xval_X*b;
    cross_val_mse = mean((xval_yhat-xval_Y).^2);
    
    % Train using only max channel
    Xb = m_l_features(1:(featurelen-cross_val_length), maxi);
    xval_Xb = m_l_features((featurelen-cross_val_length+1):end, maxi);
    bb = ls_mse(Xb, Y);
    maxchan_mse = mean((xval_Xb*bb-xval_Y).^2);
    
    % 
    Xg = m_h_features(1:(featurelen-cross_val_length), channel);
    xval_Xg = m_h_features((featurelen-cross_val_length+1):end, channel);
    bg = ls_mse(Xg, Y);
    
    mse_g = mean((xval_Xg*bg - xval_Y).^2);
    fprintf('| %d | %.2e | %d | %.2f | %.2e | %.2e | \n', channel, cross_val_mse, ...
            maxi, maxb, maxchan_mse, mse_g);
    
    
end

