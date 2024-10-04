
% Run iteratively the updated examples for v1.8.2
% -> comment 'clear all' in the main LCO/St file 
% -> comment 'Tmax' in the main LCO/St file 
% -> comment every example path in the main LCO/St file 
% -> check the name of the zip file (for Turbsim files) in the main LCO/st file

clear all
TMax = 2800;  
path = '../Examples/Lift_pitch_15d_18sto_MPPT/';
RUN_LiftControl_Stabilization_v1_8_2;

clear all
TMax = 3000; 
path = '../Examples/Lift_pitch_15d_13sto_MPPT/';
RUN_LiftControl_Stabilization_v1_8_2;

clear all
TMax = 3000; 
path = '../Examples/Lift_pitch_15d_sto13/';
RUN_LiftControl_Stabilization_v1_8_2;

clear all
TMax = 3000; 
path = '../Examples/OpenLoop/';
RUN_LiftControl_Stabilization_v1_8_2;

clear all
TMax = 3000; 
path = '../Examples/Lift_pitch_15d/';
RUN_LiftControl_Stabilization_v1_8_2;

%%% END