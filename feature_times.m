function T = feature_times(datalength, windowlen, overlap)
% FEATURE_TIMES - Computes the start of each time window in which PSD features were computed
%   
    deltaN = windowlen * (1-overlap);
    T = 1:deltaN:(datalength-windowlen+1);
end

