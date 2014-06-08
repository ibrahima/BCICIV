function fig = avg_psd(psds)
% AVG_PSD - Plots average spectrum
%   
    avg = mean(psds);
    stddev = std(psds);
    fig = figure;
    hold all;
    plot(avg);
    plot(avg+stddev, '-r');
    plot(avg-stddev, '-r');
end

