function X = multigammafeature(timesegment, f_s, channels)
% MULTIGAMMAFEATURE - Calculates a feature vector based on gamma
% band power, multiple channels
%  
% timesegment is an N x M matrix, where M is the number of channels
% and N is the length of the timeseries

    bands = [66 114];
    X = zeros(size(channels));
    for k = 1:size(channels, 2);
        channel = channels(k);
        NFFT = size(timesegment,1);
        NW = 6;

        bins = freqtobin(bands, f_s, NFFT);
        psd = pmtm(timesegment(:, channel), NW);
        X(k) = median(psd(bins(1):bins(end))); %!!!!!!!!!!!!!!
    end
end
