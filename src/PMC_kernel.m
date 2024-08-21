function PMC_kernel(block)
% Level-2 MATLAB file S-Function for times two demo.

%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
  
  %% Register number of input and output ports
  block.NumInputPorts  = 7 + 5;


  block.NumOutputPorts = 7;

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

                PMC_Kp  = block.InputPort(8).Data; % 1;
                PMC_Kint  = block.InputPort(9).Data; % 1;
                PMC_K_alpha = block.InputPort(10).Data;  % = 1e2; 
                PMC_K_beta = block.InputPort(11).Data;  % = 0.01;
                PMC_FinalScale = block.InputPort(12).Data;  % = 1e4;


ii_1 = block.InputPort(1).Data;

para_u1 = block.OutputPort(2).Data;

para_trapz1 = block.OutputPort(3).Data;

para_G1 = block.OutputPort(4).Data;

y_ref_ = block.InputPort(5).Data;

y_mesure = block.InputPort(6).Data;

h_sam = block.InputPort(7).Data;

        ii_1  = ii_1  + 1;
    
        y_int  = PMC_K_alpha  * exp( - PMC_K_beta   *  ii_1  * h_sam  );

         para_exp_err  = (y_int  - y_mesure) ;
    
        para_stand_err1  = y_ref_  - y_mesure ;
    
         para_u1  = para_u1  + PMC_Kp  * para_exp_err;

   %     para_G1_1  = para_G1 ;
   %     para_G1  = PMC_Kint *para_stand_err1 ;

        para_trapz1  = para_trapz1  + h_sam*(PMC_Kint *para_stand_err1   + para_G1  )/2;
    
         para_u_final1  = para_u1 *para_trapz1 /PMC_FinalScale ;


  block.OutputPort(1).Data = ii_1 ;

  block.OutputPort(2).Data = para_u1 ;

  block.OutputPort(3).Data = para_trapz1 ;

  block.OutputPort(4).Data = para_G1;

  block.OutputPort(5).Data = para_u_final1;

  block.OutputPort(6).Data = para_u1 ;

  block.OutputPort(7).Data = y_int;




  
%endfunction

