function errors = offset_sweep(features, labels, T, offsets, folds)
% OFFSET_SWEEP - Evaluates a series of offsets and returns the cross
%   validation error as a function of offset

    errors = zeros(size(offsets));
    for i = 1:length(offsets)
        offset = offsets(i);
        Y = labels(T+offset);
        [b, mse] = ls_mse(features, Y);
        errors(i) = mse;
    end
end

