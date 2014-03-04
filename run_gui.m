%%
load('data/sub1_comp.mat');

clear fgui;

% parameters
f_s = 1000;

neighborhood = 4096; % Time area around a movement to sample data
NFFT = 256;
samplesperhood = neighborhood/NFFT;
channel = 43;
timeoffset = -50; % Offset from movement to brain activity
finger = 1;
M = 1; % number of features

fgui = FingerDataVizGui(train_data, train_dg, NFFT, finger, channel, ...
                        f_s);

fgui.paint_gui();