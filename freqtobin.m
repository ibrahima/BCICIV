function bin = freqtobin(freq, f_s, NFFT)
% FREQTOBIN - converts frequency to FFT bin
%  

    bin = int32(NFFT/2*(freq/(f_s/2))+1);
end

