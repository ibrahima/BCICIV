function fig = dbmag(ft, titlestring)
% DBMAG - dB magnitude plot
%   
    NFFT = size(ft,2);
    if mod(NFFT,2) == 0 % twosided psd
        f = -0.5:1/NFFT:0.5-1/NFFT;
    else % onesided psd
        f = 0:1/(2*(NFFT-1)):0.5;
    end
    fig = figure;
    plot(f, 10*log(abs(fftshift(ft))));
    title(titlestring);
    xlabel('f (cycles/sample)');
    ylabel('Magnitude (dB)');
end