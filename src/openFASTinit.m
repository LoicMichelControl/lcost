    
    % LCO/St Variable initialization
    
    
    % USER-DATA that can be changed :
    
    %==== A/ SLX input parameters
    
    GenTorque = 800; % not used since the motor is driven by a Pw-Tq algorithm (v1.8.2)
    ElectTorque = 500; % not used since the motor is driven by a Pw-Tq algorithm (v1.8.2)
    MotorScale = 8; % Scales the output power of the generator 

    YawPosition = 0;
    YawRate = 0;
    
    AirfoilCommand = zeros(1,3)';
    CableDelta_Commande = zeros(1,20)';
    CableDelta_dot_Commande = zeros(1,20)';
    ShaftBreaking = 0;
    
    %==== B/ OpenFAST paths
    
    if ( mw5_case == 1 )  % 5 MW

        % run TPO config

        FAST_InputPath = './NREL-5MW_TPOconfig/5MW_OC4Semi/'; % -main directory

        FAST_InputPath_2 = './NREL-5MW_TPOconfig/5MW_Baseline/'; %-sec. directory

        FAST_aerodyn = '*AeroDyn_blade.dat';

        FAST_inflow = '*InflowWind.dat';
    
        % run standard config

        % FAST_InputPath = './NREL-5MW/5MW_OC4Semi/'; % -main directory
        % 
        % FAST_InputPath_2 = './NREL-5MW/5MW_Baseline/'; %-sec. directory
        % 
        % FAST_aerodyn = '*AeroDyn_blade.dat';
        % 
        % FAST_inflow = '*InflowWind_Steady8mps.dat';
    
    end
    
    if ( mw15_case == 1 )  % 15 MW
        
        FAST_InputPath = './IEA-15MW/IEA-15-240-RWT-UMaineSemi/'; % -main directory
        
        FAST_InputPath_2 = './IEA-15MW/IEA-15-240-RWT/'; %-sec. directory
    
        FAST_aerodyn = '*AeroDyn15_blade.dat';

        FAST_inflow = '*InflowFile.dat';
        

    end
    
    %==== C/ Initialize the SLX variables
    
    Wind1VelX_index = 1;
    Azimuth_index = 1;
    RotSpeed_index = 1;
    BldPitch1_index = 1;
    BldPitch2_index = 1;
    BldPitch3_index = 1;
    PtfmRoll_index = 1;
    PtfmPitch_index = 1;
    PtfmYaw_index = 1;

    GenSpeed_index = 1;
    GenPwr_index = 1;
    GenTq_index = 1;

    B1N1Fl_index = 1;
    B2N1Fl_index = 1;
    B3N1Fl_index = 1;
    B1N2Fl_index = 1;
    B2N2Fl_index = 1;
    B3N2Fl_index = 1;
    B1N3Fl_index = 1;
    B2N3Fl_index = 1;
    B3N3Fl_index = 1;
    B1N1Alpha_index = 1;
    
    B1N1Cl_index = 1;
    B2N1Cl_index = 1;
    B3N1Cl_index = 1;
    
    RootMyc1_index = 1;
    RootMyc2_index = 1;
    RootMyc3_index = 1;
    
    RootMyb1_index = 1;
    RootMyb2_index = 1;
    RootMyb3_index = 1;

    %=== D / Switch to enable the Python script.
    UsePython = 1;
    
    
    % Do not change below ------------------------------------------
    % --------------------------------------------------------------
    % --------------------------------------------------------------
    
    addpath('./lib');
    
    
    tMax_user = TMax; % Save the TMax saved by the user since the init. of the Slx file
    % requieres just 1 s of calculation
    
    % new in v1.4.0
    LCOS_rootFolder = pwd;
    
    internalPython_Path = './internalPython/';
    
    % Bizarrerie : le pitch d'entrée doit être mis à l'échelle pour
    % obtenir la bonne valeur de pitch en sortie -> conversion rad -> deg
    % ok - pas clair dans la doc
    coeff_pitch = 180/(pi);
    
    % Verification de BO en premier
    OpenLoopCalibrationMode = 1;
    checkOL_init = 1;

            % Initialization of the IPC trajectories``
            % (even if IPC_mode = 0 since all trajectories are stored in
            % the Result vector)
            TrajectoryReference_IPC_1 = -1;
            TrajectoryReference_IPC_2 = -1;
            TrajectoryReference_IPC_3 = -1;

    % modélisation premier ordre pour test contrôle PMC
    A_ = 1000;
    % index début lecture résultats
    beg = 1;
    
    %%
    Stat_vector = [];
    IndexSurfaceComputation = 0;
    
    
    % initialize 'ranged' variables for the SLX file -> updated later using the correct assignations from the 'sum' file
    
    % We do intialize the Range variable over, say, 10 variables
    for  SlxOutVarRangeId = 1:10
    
        SlxOutVarRange_1 = sprintf('SlxParameterRange_%d_A', SlxOutVarRangeId );
    
        SlxOutVarRange_2 = sprintf('SlxParameterRange_%d_B', SlxOutVarRangeId );
    
        rg_1 = 1;
        MaxNumberNodes = 19;
        assignin('base', SlxOutVarRange_1, 1);
        assignin('base', SlxOutVarRange_2, MaxNumberNodes);
    
        SlxParameterRange_Size = sprintf('SlxParameterRange_Size');
    
        assignin('base', SlxParameterRange_Size, MaxNumberNodes - rg_1 + 1);
    
    end

    % Create the 'out' variables (and =0) from the 'index' variables

    Cell_workspace = who();

    for index_work = 1:length( Cell_workspace )

        if ( length(Cell_workspace{index_work}) >= 7 )
    
            if ( strcmp( Cell_workspace{index_work}( length(Cell_workspace{index_work})-5:length(Cell_workspace{index_work} ) ), '_index') )
    
              Cell_workspace_base = Cell_workspace{index_work}( 1:length(Cell_workspace{index_work})-6 );
    
                var_assign = sprintf('%s_out', Cell_workspace_base);
    
                    assignin('base', var_assign, 0);
    
              %  pause
    
            end

        end

    end

    clear SlxOutVarRangeId
 
    clear Cell_workspace Cell_workspace_base

    % Reading the 'sum' file will be done after the first OL simulation in
    % order to update variable channels
    % Setting first the SlxOutVarRange_number matrix to allow OL simulation
    
    % SlxOutVarRange_(1,:) = [1, 2];
    % SlxOutVarRange_(2,:) = [1, 2];
    % SlxOutVarRange_(3,:) = [1, 2];
    % SlxOutVarRange_(4,:) = [1, 2];
    % SlxOutVarRange_(5,:) = [1, 2];
    
    %%%%%%%%%%%% Define the control type AND read the input_file
    
    cd(path)
    
    InputFound = dir('*.m');
    
    InputFound_name = InputFound.name;
    
    fileInput_to_open = [path, InputFound_name];
    
    fprintf('Reading Input file %s in "%s" ... \n', InputFound.name, path)
    
    InputName = InputFound_name(1:length(InputFound_name)-2);
    
    eval(InputName)

     save_project_name = save_project_name + '_';
    
    
    cd(LCOS_rootFolder)
    
    

