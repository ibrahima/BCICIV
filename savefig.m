function savefig(fig, num)
% SAVEFIG - Saves a figure to PNG
%   
    print(fig, sprintf('fig%d.png', num), '-dpng');
    % hgexport(fig, sprintf('fig%d.png', num), hgexport('factorystyle'), 'Format', 'png');
end