classdef FingerDataVizGui < handle
    properties
        train_data
        train_dg
        NFFT =  256
        finger
        channel
        f_s
        fig
        slider
        edit_n
        from = 1
        to = 256
    end
    
    methods
        function obj = FingerDataVizGui(train_data, train_dg, NFFT, finger, ...
                                        channel, f_s)
            obj.train_data = train_data;
            obj.train_dg = train_dg;
            obj.NFFT = NFFT;
            obj.finger = finger;
            obj.channel = channel;
            obj.f_s = f_s;
            obj.fig = figure;
            numchannels = size(train_data, 2);
            maxval = floor(size(train_data,1)/NFFT);
            obj.slider = uicontrol('Style', 'slider', 'Min',1,'Max',maxval, ...
                                   'Value',1, 'Units', 'normalized', 'Position', ...
                                   [0 0 1 .05], 'SliderStep', [1/maxval .05], ...
                                   'Callback', {@(src, event) ...
                                obj.slider_callback( src, event)});
            obj.edit_n = uicontrol('Style', 'edit', 'String','1', 'Units', 'normalized', ...
                                   'Position', [0 .05 .1 .05], 'Callback', {@(src, event) ...
                                obj.edit_n_callback(src, event)});
            uicontrol('Style', 'text', 'String', num2str(maxval), 'Units', 'normalized', ...
                      'Position', [0.9 .05 .1 .05]);
            uicontrol('Style', 'text', 'String', 'Finger', 'Units', 'normalized', ...
                      'Position', [0 .95 .1 .05]);

            uicontrol('Style', 'popup', 'Units', 'normalized', ...
                      'String', '1|2|3|4|5', 'Position', [0 0.9 0.1 0.05],...
                      'Callback', {@(src, event) obj.set_finger(src, event)}); 
            
            uicontrol('Style', 'text', 'String', 'Channel', 'Units', 'normalized', ...
                      'Position', [0.9 .95 .1 .05]);
                        
            uicontrol('Style', 'popup', 'Units', 'normalized', ...
                      'String', 1:numchannels', 'Position', [0.9 0.9 0.1 0.05],...
                      'Callback', {@(src, event) obj.set_channel(src, event)}); 
                        
        end
        
        function paint_gui(obj)
            figure(obj.fig);
            cla;
            psd = pmtm(obj.train_data(obj.from:obj.to, obj.channel) );
            timedata = obj.train_dg(obj.from:obj.to, obj.finger)';
            npsd = size(psd,1);
            [ax,h1,h2] = plotyy((1:npsd)/npsd*1000/2, psd, 1:(obj.NFFT), ...
                                timedata);
            set(ax(2), 'ylim', [-1 7]);
            set(ax(2), 'YTick', -1:7);
        end
        
    end
    methods (Access=private)
        function set_finger(obj, src, event)
            val = get(src, 'Value');
            obj.finger = val;
            obj.paint_gui();
        end

        function set_channel(obj, src, event)
            val = get(src, 'Value');
            obj.channel = val;
            obj.paint_gui();
        end

        function edit_n_callback(obj, src, event)
            str = get(src, 'String');
            val = str2num(str);
            obj.from = 1 + obj.NFFT*(val-1);
            obj.to = obj.NFFT*val;
            set(obj.slider, 'Value', val);
            obj.paint_gui()
        end
                
        function slider_callback(obj, src, event)
            val = int32(get(src, 'Value'));
            obj.from = 1 + obj.NFFT*(val-1);
            obj.to = obj.NFFT*val;
            set(obj.edit_n, 'String', val)
            obj.paint_gui()
        end
    end
    
end
