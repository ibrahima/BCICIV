function X = gammafeature(timesegment, f_s)
% GAMMAFEATURE - Calculates a feature vector based on gamma band power
%  
    
    NFFT = size(timesegment,2);
    NW = 4;
    bandstarts = 66:12:114;
    bins = freqtobin(bandstarts, f_s, NFFT);
    psd = pmtm(timesegment, NW);
    X = mean(psd(bins(1):bins(end)));
end
