        
        function MPPT_kernel_v1(block)
        % Level-2 MATLAB file S-Function
        
        %   Copyright 1990-2009 The MathWorks, Inc.
        
        setup(block);
        
        %endfunction
        
        function setup(block)
        
        %% Register number of input and output ports
        block.NumInputPorts  = 7;
        block.NumOutputPorts = 3;
        
        %% Setup functional port properties to dynamically
        %% inherited.
        block.SetPreCompInpPortInfoToDynamic;
        block.SetPreCompOutPortInfoToDynamic;
        
        block.InputPort(1).DirectFeedthrough = true;
        block.InputPort(2).DirectFeedthrough = true;
        block.InputPort(3).DirectFeedthrough = true;
        block.InputPort(4).DirectFeedthrough = true;
        block.InputPort(5).DirectFeedthrough = true;
        block.InputPort(6).DirectFeedthrough = true;
        block.InputPort(7).DirectFeedthrough = true;
        
        %% Set block sample time to inherited
        block.SampleTimes = [-1 0];
        
        %% Set the block simStateCompliance to default (i.e., same as a built-in block)
        block.SimStateCompliance = 'DefaultSimState';
        
        %% Run accelerator on TLC
        block.SetAccelRunOnTLC(true);
        
        %% Register methods
        block.RegBlockMethod('Outputs',                 @Output);
        
        %endfunction
        
        function Output(block)
        
        
        lift_mesure = block.InputPort(1).Data;
        Fupdate = block.InputPort(2).Data; %
        Q_pos = block.InputPort(3).Data; %
        Fgradient = block.InputPort(4).Data; %
        
        Delta = block.InputPort(5).Data; %
        
        alpha = block.InputPort(6).Data; %
        
        time_ = block.InputPort(7).Data; %
        
        Q_pos = Q_pos + 0;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Q_neg = Q_pos;
        Q_pos = lift_mesure;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        if ( time_ < 10 )
        
            Fgradient = 1;
        
        end
              
        if ( Q_pos > Q_neg)
        
            Fgradient = 1.2*Fgradient;
        
        end
        
        if ( Q_neg >  Q_pos)
        
            Fgradient = -Fgradient;
        
        end
             
        if ( alpha < 0 )
        
            Fgradient = -1.5;
        
        end
        
        
        Fupdate = Fupdate + Fgradient * Delta;
        
        
        
        block.OutputPort(1).Data = Fupdate;
        
        block.OutputPort(2).Data = Q_pos;
        
        block.OutputPort(3).Data = Fgradient;
        
        
        
        
        %endfunction
        
        

