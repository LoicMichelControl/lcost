
    % Updated in v1.5.0 with a new nomenclature

    buf_wind_ol  = sprintf('Open-Loop dynamics : Node = %d -  inflow:[%f -> %f -> %f] -- pitch:[%f -> %f -> %f -> %f]', NodeLift_Index_cntrl, wind_speed_x(1), wind_speed_x(2), wind_speed_x(3), ...
    Reference_point_1, Reference_point_2, Reference_point_3, Reference_point_4);
    
    save_generator = save_project_name + buf_wind_ol + '_generator.mat';

    cd(path)

    if ( exist('ResultsLiftdata') == 0)

        ResultsLiftdata = -1;

    end

    
    save(save_generator, "Config_", "Results", "ResultsLiftdata", "Param", "time_base", ...
        "TrajectoryReference_Lift", "TrajectoryReference_Lift_AVG", "TrajectoryReference_LiftConst", ...
        "TrajectoryReference_RBM", "TrajectoryReference_RBM_AVG", "TrajectoryReference_IPC_1", ...
        "TrajectoryReference_IPC_2", "TrajectoryReference_IPC_3"); 
    
    cd(LCOS_rootFolder)

