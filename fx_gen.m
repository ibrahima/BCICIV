function fx_gen(datafile, windowlen, NW, f_s, overlap, NFFT, channels)
% FX_GEN - Generates PSD based features from data, serializes to file
%   
    load(datafile);    
    fprintf('Loaded %s', datafile);
    datalength = size(train_data, 1);
    numchannels = size(channels, 2);
    deltaN = windowlen * (1-overlap);
    
    tic;
    features = extract_features(train_data(:, channels), windowlen, NW, NFFT, f_s, ...
                              overlap);
    toc;
    T = feature_times(datalength, windowlen, overlap);
    outfile = sprintf('%s_features_w%d_NW%.1f_o%d_NFFT%d_c%d.mat', datafile, windowlen, NW, ...
                 round(overlap*100), NFFT, numchannels);
    save(outfile, '-v7.3');
    fprintf('Feature extraction completed, saved to %s', outfile);
end
