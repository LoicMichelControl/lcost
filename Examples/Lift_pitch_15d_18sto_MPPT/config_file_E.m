%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%config-file for LCO/S (v1.8.0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Example of closed-loop / lift control at 15 degree of pitch
save_project_name = "Example_lift_15d_MPPT";


%1. ================ Modification of the OpenFAST input files 

    selectModififyConfigFile = 1;

    % -0 Ignore modifications
    % -1 Run modifications
    % -2 the user selects which option

%2. ================ Closed-loop Trajectories settings

    SelectTrajectoryComputation = 1; %
    
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
    Delta_MPPT = 0.1;

    LiftStepRef = 0; % Lift-step (increases the lift by value of 'LiftStepRef')
    LiftStepRef_stepTime = 500; % period of step

%3. ================ Wind Speed settings

	wind_speed_x = [13 13 13 13];
	wind_speed_t = [0, 1000, 2000, 3000];
    
    PwrLaw = 0.3;

%4. ================ Trajectory Definition

% SelectTrajectoryComputation = 0 / Definition A - Pitch trajectory definition for the Open-Loop

    Point_OpenLoop_Pitch_1 = 1;
    Point_OpenLoop_Pitch_2 = 5;
    Point_OpenLoop_Pitch_3 = 2;

% SelectTrajectoryComputation = 1 / Definition B - Lift / RBM trajectory ref. definition for Closed-Loop
    
    Point_ClosedLoop_Lift_1 = 1500;
    Point_ClosedLoop_Lift_2 = 1500;
    Point_ClosedLoop_Lift_3 = 1500;

    Point_ClosedLoop_RBM_1 = 5000;
    Point_ClosedLoop_RBM_2 = 5000;
    Point_ClosedLoop_RBM_3 = 6000;

% SelectTrajectoryComputation = 2 / Definition C - Pitch trajectory for Closed-Loop
  
    Point_ClosedLoop_Pitch_1 = 15;
    Point_ClosedLoop_Pitch_2 = 15;
    Point_ClosedLoop_Pitch_3 = 15;

    PitchBlade_0 = 0; % Initial Condition of the pitch
    
    
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

%Optional to add extra plots
extra_plot = "ModulePlot_extra";
lift_seg = 240000;
% The optional module contains an extra statement to plot the self-adjusted reference
% instead of the trajectory reference (from LCO/S).
% It checks if the file 'ClosedLoop_Kernel_LiftCntrl_1B' is used.
% See l. 221-225.


    plot_1 = 1; % plot 1 - Wind1VelX + pitch angle #1 + Traj. Profile 
    plot_2 = 1; % plot 2 - GenPwr + Gen Tq + GenSpeed
    plot_3 = 1; % plot 3 - Azimuth + Ptfm angles
    plot_4 = 1; % plot 4 - Fl#1 + pitch angle 
    plot_5 = 0; % plot 5 - Fl#1 - Fl#2 - Fl#3
    plot_5b = 1; % plot 5b - Fl#1 + Fl#2 + Fl#3
    plot_6 = 1; % plot 6 - AVG Fl#1 + pitch angle
    plot_6b = 1;
    plot_7 = 1; % plot 7 - pitch angle #1 - #2 - #3
    plot_8 = 0; % plot 8 - RootMyb #1 + blade pitch 
    plot_9 = 0; % plot 9 - RootMyb #1 - RootMyb #2 - RootMyb #3
    plot_10 = 1; % plot 10 - AVG Fl#1 - AVG Fl#2 - AVG Fl#3

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
 InputSettings(cnt_Input,:) = ["GenDOF", "False"]; cnt_Input = cnt_Input + 1;% 
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
 InputSettings(cnt_Input,:) = ["VSContrl", "0"]; cnt_Input = cnt_Input + 1;%
% %-------------------
% InputSettings(cnt_Input,:) = ["GenModel", "1"]; cnt_Input = cnt_Input + 1;%


    % AERODYN15
% InputSettings(cnt_Input,:) = ["TwrPotent", "1"]; cnt_Input = cnt_Input + 1;% ( should be in effect =1 )
% 
% InputSettings(cnt_Input,:) = ["TwrShadow", "1"]; cnt_Input = cnt_Input + 1;% ( should be in effect =1 )
% 
% InputSettings(cnt_Input,:) = ["TwrAero", "True"]; cnt_Input = cnt_Input + 1;% ( should be in effect = True )

    % INFLOW WIND
    
InputSettings(cnt_Input,:) = ["WindType", "3"]; cnt_Input = cnt_Input + 1;% ( should be in effect =1 )

InputSettings(cnt_Input,:) = ["FileName_BTS", """TurbSim_18_TPO.bts"""]; % do not update the counter if this is the last item

% Unzip the .bts files (sampled version - the high resolution shall be
% regenerated) to the NREL/5MW_OC4Semi directory

if ( exist('TurbSim_zip_name'))
unzip(['../../', TurbSim_zip_name],'../../src/NREL-5MW_TPOconfig/5MW_OC4Semi');
end

%9. ================ SIMULINK FILES

      OpenLoop_SLXfile = 'OpenLoop_Kernel_1A';

      ClosedLoop_SLXfile_Lift = 'ClosedLoop_Kernel_LiftCntrl_1B';

      ClosedLoop_SLXfile_Lift_IPC = 'ClosedLoop_Kernel_Lift_IPCCntrl_1A'; %OK

      ClosedLoop_SLXfile_RBM = 'ClosedLoop_Kernel_RBMCntrl_1A';

% End of the config file
