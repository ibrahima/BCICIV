classdef FingerDataVizGui
    properties
        train_data
        train_dg
        NFFT =  256
        finger
        channel
        f_s
        fig
        from = 1
        to = 256
    end
    
    methods
        function obj = FingerDataVizGui(train_data, train_dg, NFFT, ...
                                        finger, channel, f_s)
            obj.train_data = train_data;
            obj.train_dg = train_dg;
            obj.NFFT = NFFT;
            obj.finger = finger;
            obj.channel = channel;
            obj.f_s = f_s;
            obj.fig = figure;

            maxval = size(train_data,1)/NFFT;
            uicontrol('Style', 'slider',...
                      'Min',1,'Max',maxval,'Value',1,...
                      'Position', [20 10 1800 20],...
                      'Callback', {@(src, event) set_time(obj, src, ...
                                                               event)});           
        end
        
        function paint_gui(obj)
            figure(obj.fig);
            cla;
            psd = pmtm(obj.train_data(obj.from:obj.to, obj.channel) );
            timedata = obj.train_dg(obj.from:obj.to, obj.finger)';
            npsd = size(psd,1);
            plotyy((1:npsd)/npsd*1000/2, psd, 1:(obj.NFFT), timedata);
        end
        
    end
    methods (Access=private)
        function set_time(obj, src, event)
            val = int32(get(src, 'Value'));
            obj.from = 1 + obj.NFFT*(val-1);
            obj.to = obj.NFFT*val;
    
            obj.paint_gui()
        end
    end
    
end
