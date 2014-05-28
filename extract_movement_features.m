function [features, values, T] = extract_movement_features(train_data, train_vals, finger, ...
                                     neighborhood, NFFT, channel, ...
                                                  timeoffset, f_s)
% EXTRACT_FEATURES - Extracts band limited power features from input signals based on periods of activity
%   


    [pks, idxs] = findpeaks(train_vals(:, finger), 'MINPEAKHEIGHT', ...
                        0.5, 'MINPEAKDISTANCE', neighborhood/2);
    numpeaks = size(pks,1);
    finger_movements = zeros(neighborhood, numpeaks);
    samplesperhood = neighborhood/NFFT;
    features = zeros(numpeaks*samplesperhood, 1);
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
            values(n) = train_vals(t , finger);
            T(n) = t;
        end
    end

end
