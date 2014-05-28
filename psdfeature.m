function X = psdfeature(timesegment, f_s, channels, NW)
% MULTIGAMMAFEATURE - Calculates a feature vector based on gamma
% band power, multiple channels
%  
% timesegment is an N x M matrix, where M is the number of channels
% and N is the length of the timeseries

    bands = [12 40; 66 114];
    numbands = size(bands, 1);
    numchannels = size(channels, 2);
    X = zeros(numbands, numchannels);
    for k = 1:numchannels;
        channel = channels(k);
        NFFT = size(timesegment,1);
        bins = freqtobin(bands, f_s, NFFT);
        psd = pmtm(timesegment(:, channel), NW);
        for b = 1:numbands
            X(b, k) = mean(psd(bins(b,1):bins(b,2)));
        end
    end
end
