function fig = phaseplot(ft, titlestring)
% PHASEPLOT - Phase plot
%   
    NFFT = size(ft,2);
    f = -0.5:1/NFFT:0.5-1/NFFT;
    fig = figure;
    plot(f, angle(fftshift(ft)));
    title(titlestring);
    xlabel('f (cycles/sample)');
    ylabel('Phase (radians)');
end

