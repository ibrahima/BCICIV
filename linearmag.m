function fig = linearmag(ft, titlestring)
% LINEARMAG - Linear magnitude plot
%   
    NFFT = size(ft,2);
    f = -0.5:1/NFFT:0.5-1/NFFT;
    fig = figure;
    plot(f, abs(fftshift(ft)));
    title(titlestring);
    xlabel('f (cycles/sample)');
    ylabel('Magnitude');

end

