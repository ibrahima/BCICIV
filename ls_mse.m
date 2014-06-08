function [b,  mse] = ls_mse(X, Y)
% LS_MSE - Calculates the least squares regression of Y on X
%   

    
    b = pinv(X' * X)*X'*Y;
    b = pinv(X)*Y; % Not sure which is right
    yhat = X*b;
    
    mse = mean((Y-yhat).^2);
 
end

