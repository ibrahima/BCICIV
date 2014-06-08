function [trial_features, T] = trialize_features(features, train_labels, ...
                                                 activity, neighborhood, ...
                                                 windowlen, overlap)
% TRIALIZE_FEATURES - Turns feature vectors into trials based on activity in the training labels
%   
    [peaks, idxs] = findpeaks(train_labels, 'MinPeakHeight', 0.5, ...
                              'MinPeakDistance', neighborhood/2);
    numpeaks = size(peaks,1);
    numfeatures = size(features, 2);
    maxT = length(train_labels);
    trial_labels = zeros(numpeaks, neighborhood);
    feature_trials = zeros(numpeaks, neighborhood);
    deltaN = windowlen * (1-overlap);
    fx_per_neighborhood = round(neighborhood/deltaN);
    trial_features = zeros(numpeaks*fx_per_neighborhood, ...
                           numfeatures);
    T = zeros(numpeaks*fx_per_neighborhood, 1);
    
    for k=1:numpeaks
        from = idxs(k)-neighborhood/2;
        to = min(idxs(k) + neighborhood/2-1, maxT);
        ifrom=round(from/deltaN);
        ito = round(to/deltaN)-1;
        kfrom = (k-1)*fx_per_neighborhood + 1;
        kto = k*fx_per_neighborhood;
        trial_features(kfrom:kto, :) = features(ifrom:ito, :);
        T(kfrom:kto) = from:deltaN:to;
    end
    
end

