
% Revised in v1.5.0 -> must include the complete setup of the (wind & ref.) trajectories for better readability
% Namz switched to 'SimulationKernel_vA' in v1.8 

    %%%%%%%%%%%

    % The 'Reference_point' are defined in the input_file (or re-defined in
    % the openLoop_surface file)
    % same for the wind profile that is defined in the input_file

        Reference_point_1 = Point_Ref_1; % 
        Reference_point_2 = Point_Ref_2; % 
        Reference_point_3 = Point_Ref_3; % 
        Reference_point_4 = Point_Ref_3; %

        TrajDef = [Reference_point_1  Reference_point_1   Reference_point_2  Reference_point_2  ...
                    Reference_point_2   Reference_point_3   Reference_point_3   Reference_point_4   Reference_point_4 ];
    
        [ time_base, TrajectoryReference ] = BuildCustomizedRef_ ( 0:(TMax/6):TMax , TrajDef, DT, TMax, coeff_pitch);


            % if ( IPC_mode == 0)
            % % Initialization of the IPC trajectory to something blank
            % TrajectoryReference_IPC_1 = -1;
            % TrajectoryReference_IPC_2 = -1;
            % TrajectoryReference_IPC_3 = -1;
            % end
            

    % Inflow wind speed profile / 'WriteWindProfile' function is obsolete
    % in v1.4.1b -> updated to v2

    WriteWindProfile_v2(wind_speed_t, wind_speed_x, FAST_InputPath, LCOS_rootFolder, PwrLaw);
          
    % Select SlX file : Open-Loop or Closed-loop
    if SelectTrajectoryComputation == 1 || OpenLoopCalibrationMode == 1
    

        fprintf('Using SLX file for the Open-Loop : %s \n', OpenLoop_SLXfile);
   
        sim(OpenLoop_SLXfile);
    
    else
    
        fprintf('\n\n *************** Starting Closed-loop mode (processing v2-WTSlx) *************** \n')

       
        sim(ClosedLoop_SLXfile__Cont);   
    
    
    end

    
    % new in v1.5.0
    % it initalizes properly all Slx variables from the 'sum' file obtained
    % via the Init. of openFAST Slx file
    ProcessingSlxData_v5_cell

