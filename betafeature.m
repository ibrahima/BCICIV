function betafeature = betafeature(timeseries, f_s)
% BETAFEATURE - Calculates mean beta band power in the given timeseries
%   
    NFFT = size(timesegment,2);
    NW = 6;
    bands = [12 30];
    bins = freqtobin(bands, f_s, NFFT);
    psd = pmtm(timesegment, NW);
    X = mean(psd(bins(1):bins(end))); %!!!!!!!!!!!!!!
end
