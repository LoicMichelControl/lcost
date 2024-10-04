%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%config-file for LCO/S (v1.8.0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Example of Cl curve computation (in open-loop)
save_project_name = "Example_OpenLoop";


%%% Select the open-loop pitch:

Openloop_pitch = 0;


%1. ================ Modification of the OpenFAST input files 

    selectModififyConfigFile = 1;

    % -0 Ignore modifications
    % -1 Run modifications
    % -2 the user selects which option

%2. ================ Closed-loop Trajectories settings

    SelectTrajectoryComputation = 0; %
    
    % =0 - open-loop incl. computing surface (if ComputeSurface > 0) -> set the pitch angle as trajectory
    % =1 - closed-loop with external (lift or RBM) trajectory -> set the (lift or RBM) as trajectory
    % =2 - closed-loop with internal (lift or RBM) trajectory based on open-loop prior computation (generator file) -> set the pitch angle as trajectory
    
    LiftTrajectoryRef = 3;
    RBMTrajectoryRef = 0;
    ControlledNode = 9;

    % =0 - not used
    % =1 - normal
    % =2 - AVG
    % =3 - CONST

    IPC_mode = 0; % select the IPC mode (only available if SelectTrajectoryComputation = 2)

    LiftStepRef = 50; % Lift-step (increases the lift by value of 'LiftStepRef')
    LiftStepRef_stepTime = 500; % period of step

%3. ================ Wind Speed settings

	wind_speed_x = [13 13 13 13];
	wind_speed_t = [0, 1000, 2000, 3000];
    
    PwrLaw = 0.3;

%4. ================ Trajectory Definition

% SelectTrajectoryComputation = 0 / Definition A - Pitch trajectory definition for the Open-Loop

    Point_OpenLoop_Pitch_1 = Openloop_pitch;
    Point_OpenLoop_Pitch_2 = Openloop_pitch;
    Point_OpenLoop_Pitch_3 = Openloop_pitch;

% SelectTrajectoryComputation = 1 / Definition B - Lift / RBM trajectory ref. definition for Closed-Loop
    
    Point_ClosedLoop_Lift_1 = 2100;
    Point_ClosedLoop_Lift_2 = 2000;
    Point_ClosedLoop_Lift_3 = 2200;

    Point_ClosedLoop_RBM_1 = 5000;
    Point_ClosedLoop_RBM_2 = 5000;
    Point_ClosedLoop_RBM_3 = 6000;

% SelectTrajectoryComputation = 2 / Definition C - Pitch trajectory for Closed-Loop
  
    Point_ClosedLoop_Pitch_1 = 1;
    Point_ClosedLoop_Pitch_2 = 2;
    Point_ClosedLoop_Pitch_3 = 2;

    PitchBlade_0 = 15; % Initial Condition of the pitch
    
    
%5. ================ Lift Surface Computation

ComputeSurface = 0;

%ComputeSurface = 1 : allows computing the surface
%ComputeSurface = 0 no surfaceComputing

%6. ================ Closed-loop settings

% PMC parameters
IO_gain = 1e-3;
Kp_1 = 1;
Kint_1 = 1;
K_alpha_1 = 1e-2;
K_beta_1 = 1e-1;
K_divide_1 = 1e4;
h_sam = 1e-6;


Filter_K = 1/10; % time-constant filtering for output AVG
ratePitchLimit = 8; % rate-limiter for the pitch


%7. ================ Which output(s) to plot?

    Start_time_plotting = 20000;

    plot_1 = 1; % plot 1 - Wind1VelX + pitch angle #1 + Traj. Profile 
    plot_2 = 1; % plot 2 - GenPwr + Gen Tq + GenSpeed
    plot_3 = 1; % plot 3 - Azimuth + Ptfm angles
    plot_4 = 1; % plot 4 - Fl#1 + pitch angle 
    plot_5 = 1; % plot 5 - Fl#1 - Fl#2 - Fl#3
    plot_5b = 1; % plot 5b - Fl#1 + Fl#2 + Fl#3
    plot_6 = 1; % plot 6 - AVG Fl#1 + pitch angle
    plot_7 = 1; % plot 7 - pitch angle #1 - #2 - #3
    plot_8 = 1; % plot 8 - RootMyb #1 + blade pitch 
    plot_9 = 1; % plot 9 - RootMyb #1 - RootMyb #2 - RootMyb #3
    plot_10 = 1; % plot 10 - AVG Fl#1 - AVG Fl#2 - AVG Fl#3
    plot_11 = 1; % Cl_curves

%8. ================ Set of input parameters to be modified


  % Warning: Initial condition of the blade pitch is not
  % considered in the 'InputSettings' list, but will be managed during the
  % simulation

    cnt_Input = 1; % do not change

% The original input files (prefixed with 'TPO') are properly set to
% run the simulation and
% -> simply switch between uniform wind type and stochastic wind type
% (incl. the .bts file to specify)

% The user is free to modify them according to its needs ;)


   % FST file
% InputSettings(cnt_Input,:) =   ["CompElast","1"]; cnt_Input = cnt_Input + 1; % 
%    %-------------------
% InputSettings(cnt_Input,:) =   ["CompInflow","1"]; cnt_Input = cnt_Input + 1;%
%    %-------------------
% InputSettings(cnt_Input,:) =   ["CompAero","2"]; cnt_Input = cnt_Input + 1;%
%    %-------------------
% InputSettings(cnt_Input,:) =   ["CompServo","1"]; cnt_Input = cnt_Input + 1;%
%    %-------------------
% InputSettings(cnt_Input,:) =   ["CompHydro","0"]; cnt_Input = cnt_Input + 1;%
%    %-------------------
% InputSettings(cnt_Input,:) =   ["CompSub","0"]; cnt_Input = cnt_Input + 1;%
%    %-------------------
% InputSettings(cnt_Input,:) =   ["CompMooring","0"]; cnt_Input = cnt_Input + 1;%
%    %-------------------
% InputSettings(cnt_Input,:) =   ["CompIce","0"]; cnt_Input = cnt_Input + 1;%
%    %-------------------
% InputSettings(cnt_Input,:) =   ["MHK","0"]; cnt_Input = cnt_Input + 1;%   

  % ELASTODYN
% InputSettings(cnt_Input,:) = ["FlapDOF1", "True"]; cnt_Input = cnt_Input + 1;%    
% %-------------------
% InputSettings(cnt_Input,:) = ["FlapDOF2", "True"]; cnt_Input = cnt_Input + 1;%
% %-------------------
% InputSettings(cnt_Input,:) = ["EdgeDOF", "True"]; cnt_Input = cnt_Input + 1;% 
% %-------------------
% InputSettings(cnt_Input,:) = ["TeetDOF", "False"]; cnt_Input = cnt_Input + 1;%
% %-------------------
% InputSettings(cnt_Input,:) = ["DrTrDOF", "False"]; cnt_Input = cnt_Input + 1;%
% %-------------------
% InputSettings(cnt_Input,:) = ["GenDOF", "False"]; cnt_Input = cnt_Input + 1;% 
% %-------------------
% InputSettings(cnt_Input,:) = ["YawDOF", "False"]; cnt_Input = cnt_Input + 1;% 
% %-------------------
% InputSettings(cnt_Input,:) = ["TwFADOF1", "False"]; cnt_Input = cnt_Input + 1;%
% %-------------------
% InputSettings(cnt_Input,:) = ["TwFADOF2", "False"]; cnt_Input = cnt_Input + 1;%   
% %-------------------
% InputSettings(cnt_Input,:) = ["TwSSDOF1", "False"]; cnt_Input = cnt_Input + 1;% 
% %-------------------
% InputSettings(cnt_Input,:) = ["TwSSDOF2", "False"]; cnt_Input = cnt_Input + 1;% 
% %-------------------
% InputSettings(cnt_Input,:) = ["PtfmSgDOF", "False"]; cnt_Input = cnt_Input + 1;%  
% %-------------------
% InputSettings(cnt_Input,:) = ["PtfmSwDOF", "False"]; cnt_Input = cnt_Input + 1;% 
% %-------------------
% InputSettings(cnt_Input,:) = ["PtfmHvDOF", "False"]; cnt_Input = cnt_Input + 1;%
% %-------------------
% InputSettings(cnt_Input,:) = ["PtfmRDOF", "False"]; cnt_Input = cnt_Input + 1;% 
% %-------------------
% InputSettings(cnt_Input,:) = ["PtfmPDOF", "False"]; cnt_Input = cnt_Input + 1;% 
% %-------------------
% InputSettings(cnt_Input,:) = ["PtfmYDOF", "False"]; cnt_Input = cnt_Input + 1;%           
% %-------------------
% InputSettings(cnt_Input,:) = ["RotSpeed", "7.55"]; cnt_Input = cnt_Input + 1;%
%-------------------

    % SERVODYN
% InputSettings(cnt_Input,:) = ["PCMode", "4"]; cnt_Input = cnt_Input + 1;%
% %-------------------
% InputSettings(cnt_Input,:) = ["VSContrl", "0"]; cnt_Input = cnt_Input + 1;%
% %-------------------
% InputSettings(cnt_Input,:) = ["GenModel", "1"]; cnt_Input = cnt_Input + 1;%


    % AERODYN15
% InputSettings(cnt_Input,:) = ["TwrPotent", "1"]; cnt_Input = cnt_Input + 1;% ( should be in effect =1 )
% 
% InputSettings(cnt_Input,:) = ["TwrShadow", "1"]; cnt_Input = cnt_Input + 1;% ( should be in effect =1 )
% 
% InputSettings(cnt_Input,:) = ["TwrAero", "True"]; cnt_Input = cnt_Input + 1;% ( should be in effect = True )

    % INFLOW WIND
    
InputSettings(cnt_Input,:) = ["WindType", "2"]; cnt_Input = cnt_Input + 1;% ( should be in effect =1 )

InputSettings(cnt_Input,:) = ["FileName_BTS", """TurbSim_13_TPO.bts"""]; % do not update the counter if this is the last item


%9. ================ SIMULINK FILES

      OpenLoop_SLXfile = 'OpenLoop_Kernel_1B';

      ClosedLoop_SLXfile_Lift = 'ClosedLoop_Kernel_LiftCntrl_1A';

      ClosedLoop_SLXfile_Lift_IPC = 'ClosedLoop_Kernel_Lift_IPCCntrl_1A'; %OK

      ClosedLoop_SLXfile_RBM = 'ClosedLoop_Kernel_RBMCntrl_1A';

%10. =============== PLOT THE C_L curve

    % plot the Cl curve
    Cl_curve_min = 63;
    Cl_curve_Max = 120;

% def. of the Cl curve for the Node #9 taken from the DU25_A17.dat
Cl_curve_Node = [ -180.00    0.000   0.0202   0.0000  ;
-175.00    0.368   0.0324   0.1845  ;
-170.00    0.735   0.0943   0.3701  ;
-160.00    0.695   0.2848   0.2679  ;
-155.00    0.777   0.4001   0.3046  ;
-150.00    0.828   0.5215   0.3329  ;
-145.00    0.850   0.6447   0.3540  ;
-140.00    0.846   0.7660   0.3693  ;
-135.00    0.818   0.8823   0.3794  ;
-130.00    0.771   0.9911   0.3854  ;
-125.00    0.705   1.0905   0.3878  ;
-120.00    0.624   1.1787   0.3872  ;
-115.00    0.530   1.2545   0.3841  ;
-110.00    0.426   1.3168   0.3788  ;
-105.00    0.314   1.3650   0.3716  ;
-100.00    0.195   1.3984   0.3629  ;
 -95.00    0.073   1.4169   0.3529  ;
 -90.00   -0.050   1.4201   0.3416  ;
 -85.00   -0.173   1.4081   0.3292  ;
 -80.00   -0.294   1.3811   0.3159  ;
 -75.00   -0.409   1.3394   0.3017  ;
 -70.00   -0.518   1.2833   0.2866  ;
 -65.00   -0.617   1.2138   0.2707  ;
 -60.00   -0.706   1.1315   0.2539  ;
 -55.00   -0.780   1.0378   0.2364  ;
 -50.00   -0.839   0.9341   0.2181  ;
 -45.00   -0.879   0.8221   0.1991  ;
 -40.00   -0.898   0.7042   0.1792  ;
 -35.00   -0.893   0.5829   0.1587  ;
 -30.00   -0.862   0.4616   0.1374  ;
 -25.00   -0.803   0.3441   0.1154  ;
 -24.00   -0.792   0.3209   0.1101  ;
 -23.00   -0.789   0.2972   0.1031  ;
 -22.00   -0.792   0.2730   0.0947  ;
 -21.00   -0.801   0.2485   0.0849  ;
 -20.00   -0.815   0.2237   0.0739  ;
 -19.00   -0.833   0.1990   0.0618  ;
 -18.00   -0.854   0.1743   0.0488  ;
 -17.00   -0.879   0.1498   0.0351  ;
 -16.00   -0.905   0.1256   0.0208  ;
 -15.00   -0.932   0.1020   0.0060  ;
 -14.00   -0.959   0.0789  -0.0091  ;
 -13.00   -0.985   0.0567  -0.0243  ;
 -13.00   -0.985   0.0567  -0.0243  ;
 -12.01   -0.953   0.0271  -0.0349  ;
 -11.00   -0.900   0.0303  -0.0361  ;
  -9.98   -0.827   0.0287  -0.0464  ;
  -8.98   -0.753   0.0271  -0.0534  ;
  -8.47   -0.691   0.0264  -0.0650  ;
  -7.45   -0.555   0.0114  -0.0782  ;
  -6.42   -0.413   0.0094  -0.0904  ;
  -5.40   -0.271   0.0086  -0.1006  ;
  -5.00   -0.220   0.0073  -0.1107  ;
  -4.50   -0.152   0.0071  -0.1135  ;
  -4.00   -0.084   0.0070  -0.1162  ;
  -3.50   -0.018   0.0069  -0.1186  ;
  -3.00    0.049   0.0068  -0.1209  ;
  -2.50    0.115   0.0068  -0.1231  ;
  -2.00    0.181   0.0068  -0.1252  ;
  -1.50    0.247   0.0067  -0.1272  ;
  -1.00    0.312   0.0067  -0.1293  ;
  -0.50    0.377   0.0067  -0.1311  ;
   0.00    0.444   0.0065  -0.1330  ;
   0.50    0.508   0.0065  -0.1347  ;
   1.00    0.573   0.0066  -0.1364  ;
   1.50    0.636   0.0067  -0.1380  ;
   2.00    0.701   0.0068  -0.1396  ;
   2.50    0.765   0.0069  -0.1411  ;
   3.00    0.827   0.0070  -0.1424  ;
   3.50    0.890   0.0071  -0.1437  ;
   4.00    0.952   0.0073  -0.1448  ;
   4.50    1.013   0.0076  -0.1456  ;
   5.00    1.062   0.0079  -0.1445  ;
   6.00    1.161   0.0099  -0.1419  ;
   6.50    1.208   0.0117  -0.1403  ;
   7.00    1.254   0.0132  -0.1382  ;
   7.50    1.301   0.0143  -0.1362  ;
   8.00    1.336   0.0153  -0.1320  ;
   8.50    1.369   0.0165  -0.1276  ;
   9.00    1.400   0.0181  -0.1234  ;
   9.50    1.428   0.0211  -0.1193  ;
  10.00    1.442   0.0262  -0.1152  ;
  10.50    1.427   0.0336  -0.1115  ;
  11.00    1.374   0.0420  -0.1081  ;
  11.50    1.316   0.0515  -0.1052  ;
  12.00    1.277   0.0601  -0.1026  ;
  12.50    1.250   0.0693  -0.1000  ;
  13.00    1.246   0.0785  -0.0980  ;
  13.50    1.247   0.0888  -0.0969  ;
  14.00    1.256   0.1000  -0.0968  ;
  14.50    1.260   0.1108  -0.0973  ;
  15.00    1.271   0.1219  -0.0981  ;
  15.50    1.281   0.1325  -0.0992  ;
  16.00    1.289   0.1433  -0.1006  ;
  16.50    1.294   0.1541  -0.1023  ;
  17.00    1.304   0.1649  -0.1042  ;
  17.50    1.309   0.1754  -0.1064  ;
  18.00    1.315   0.1845  -0.1082  ;
  18.50    1.320   0.1953  -0.1110  ;
  19.00    1.330   0.2061  -0.1143  ;
  19.50    1.343   0.2170  -0.1179  ;
  20.00    1.354   0.2280  -0.1219  ;
  20.50    1.359   0.2390  -0.1261  ;
  21.00    1.360   0.2536  -0.1303  ;
  22.00    1.325   0.2814  -0.1375  ;
  23.00    1.288   0.3098  -0.1446  ;
  24.00    1.251   0.3386  -0.1515  ;
  25.00    1.215   0.3678  -0.1584  ;
  26.00    1.181   0.3972  -0.1651  ;
  28.00    1.120   0.4563  -0.1781  ;
  30.00    1.076   0.5149  -0.1904  ;
  32.00    1.056   0.5720  -0.2017  ;
  35.00    1.066   0.6548  -0.2173  ;
  40.00    1.064   0.7901  -0.2418  ;
  45.00    1.035   0.9190  -0.2650  ;
  50.00    0.980   1.0378  -0.2867  ;
  55.00    0.904   1.1434  -0.3072  ;
  60.00    0.810   1.2333  -0.3265  ;
  65.00    0.702   1.3055  -0.3446  ;
  70.00    0.582   1.3587  -0.3616  ;
  75.00    0.456   1.3922  -0.3775  ;
  80.00    0.326   1.4063  -0.3921  ;
  85.00    0.197   1.4042  -0.4057  ;
  90.00    0.072   1.3985  -0.4180  ;
  95.00   -0.050   1.3973  -0.4289  ;
 100.00   -0.170   1.3810  -0.4385  ;
 105.00   -0.287   1.3498  -0.4464  ;
 110.00   -0.399   1.3041  -0.4524  ;
 115.00   -0.502   1.2442  -0.4563  ;
 120.00   -0.596   1.1709  -0.4577  ;
 125.00   -0.677   1.0852  -0.4563  ;
 130.00   -0.743   0.9883  -0.4514  ;
 135.00   -0.792   0.8818  -0.4425  ;
 140.00   -0.821   0.7676  -0.4288  ;
 145.00   -0.826   0.6481  -0.4095  ;
 150.00   -0.806   0.5264  -0.3836  ;
 155.00   -0.758   0.4060  -0.3497  ;
 160.00   -0.679   0.2912  -0.3065  ;
 170.00   -0.735   0.0995  -0.3706  ;
 175.00   -0.368   0.0356  -0.1846  ;
 180.00    0.000   0.0202   0.0000 ];

% End of the config file
