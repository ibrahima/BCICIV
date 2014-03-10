function X = gammafeature(timesegment, f_s)
% GAMMAFEATURE - Calculates a feature vector based on gamma band power
%  
    
    NFFT = size(timesegment,2);
    NW = 6;
    bands = [66 114];
    bins = freqtobin(bands, f_s, NFFT);
    psd = pmtm(timesegment, NW);
    X = median(psd(bins(1):bins(end))); %!!!!!!!!!!!!!!
end
