%%
load 'data/sub1_comp_features_w40_NW1.5_o50_NFFT256_c1.mat'

%%
neighborhood = 4000;

fx = concat_features(features);

[trialized_features, T] = trialize_features(fx, train_dg(:,1), 1, ...
                                            neighborhood, ...
                                            features.windowlen, ...
                                            features.overlap );
offsets = 0:10:200;
errp = offset_sweep(trialized_features, train_dg(:,1), T, offsets, ...
                    10);

%%

figure;
plot(offsets, errp);