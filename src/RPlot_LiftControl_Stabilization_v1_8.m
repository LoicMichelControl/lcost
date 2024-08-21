    
    %%===========================================================================================
    %%
    %%
    %%  LCO/St - Lift Control OpenFAST & Stabilization / Plot Module - Dec 2023 - Aug 2024
    %%                                   v1.8.0
    %%            L. Michel (CN/LS2N UMR 6004 - 1 rue de la Noë, 44300 Nantes)
    %%
    %%
    %%===========================================================================================

    clear all
    close all
    clc

    mw5_case = 1;
    % path = '../Examples/Lift_1/'; % Example of closed-loop / lift control #1

    % path = '../Examples/Lift_2/'; % Example of closed-loop / lift control #2

    % path = '../Examples/RBM_1/'; % Example of closed-loop / RBM control #1

    % path = '../Examples/RBM_2/'; % Example of closed-loop / RBM control #2
    
    % path = '../Examples/LiftIncremental_1/'; % Example of closed-loop / lift control - step-up #1

    % path = '../Examples/LiftIncremental_2/'; % Example of closed-loop / lift control - step-down #2

    % path = '../Examples/IPC_control/'; % Example of closed-loop / lift control - IPC mode

    %==============================================
    %==============================================
    %==============================================
    ver_ = 180;
    LCOS_rootFolder = pwd;
    
   
    fprintf('\n\n === LCO/St - Lift Control OpenFAST & Stabilization / Plot Module - v1.8.0 (Aug. 2024) === \n\n')
    fprintf('L. Michel (CN/LS2N UMR 6004) \n');

    save_plot = 0;
    
    % Check if the result file exists
    cd(path)  
    ResultFound = dir('*_results.mat');
    
    if ( isempty(ResultFound) == 0 )
        fprintf('Found %s... \n',  ResultFound.name)
        save_generator = ResultFound.name;
    else
        fprintf('No result-mat file found !')
        pause
    end
    
    OpenLoopCalibrationMode = 0;
    
    InputFound = dir('*.m');
    
    InputFound_name = InputFound.name;
    
    fileInput_to_open = [path, InputFound_name];
    
    fprintf('Reading Input file %s in "%s" ... \n', InputFound.name, path)
    
    InputName = InputFound_name(1:length(InputFound_name)-2);
    
    eval(InputName)
    
    
    % Load the result file   
    R1 = load(save_generator);
    
    cd(LCOS_rootFolder)
    
    % Display
    Param = R1.Param 
    R1.Cntrl 
    
    
    fprintf('Checking... \n');
    pause(5)
  
    save_plot = 0;
    
    beg = 1; 
    wind_speed_x = R1.Param.wind_speed_x;
    
    buf_wind  = sprintf('Node = %d -  inflow:[%f -> %f -> %f]', R1.Config_.NodeLift_Index_cntrl, wind_speed_x(1), wind_speed_x(2), wind_speed_x(3) );
    title_graph = convertCharsToStrings( buf_wind );
    
    %%%%%%%%%%% plot module
    uu = 1;      
    Results = R1.Results;
    ModulePlot_vA;
    %%%%%%%%%%%%%%%%%%%%%%%

    pause(10)
    
    cd(LCOS_rootFolder)
    
    close all

    %%%%%%%%%%%%%%%%%%%%%%%%%
    % End of the program
    %%%%%%%%%%%%%%%%%%%%%%%%%
