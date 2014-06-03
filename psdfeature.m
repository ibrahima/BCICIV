function [X, psds] = psdfeature(timesegment, f_s, channels, NW, NFFT)
% MULTIGAMMAFEATURE - Calculates a feature vector based on gamma
% band power, multiple channels
%  
% timesegment is an N x M matrix, where M is the number of channels
% and N is the length of the timeseries

    bands = [12 40; 66 114];
    numbands = size(bands, 1);
    numchannels = size(channels, 2);
    X = zeros(numbands, numchannels);
    psds = zeros(numchannels, NFFT/2+1);
    bins = freqtobin(bands, f_s, NFFT);
    for k = 1:numchannels;
        channel = channels(k);
        [psd, f] = pmtm(timesegment(:, channel), NW, NFFT, f_s);
        % TODO Use f instead of freqtobin
        psds(k,:) = psd';
        for b = 1:numbands
            X(b, k) = mean(psd(bins(b,1):bins(b,2)));
        end
    end
end
