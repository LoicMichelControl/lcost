    
    %%===========================================================================================
    %%
    %%
    %%  LCO/St - Lift Control OpenFAST & Stabilization / Main Module - Dec 2023 - Aug 2024
    %%                                   v1.8.0
    %%            L. Michel (CN/LS2N UMR 6004 - 1 rue de la Noë, 44300 Nantes)
    %%
    %%
    %%===========================================================================================
        
    clear all %#ok<CLALL>
    close all
    clc
    warning off
    
    %==============================================
    %======== User parameters
    
    TMax = 3000;   
    OnlyReadingInput = 0;

    mw5_case = 1;

    % Please choose one example to simulate:

        path = '../Examples/Lift_1/';
        %
        % path = '../Examples/Lift_2/';
        % 
        % path = '../Examples/RBM_1/';
        % 
        % path = '../Examples/RBM_2/';
        % 
        % path = '../Examples/LiftIncremental_1/';
        % 
        % path = '../Examples/LiftIncremental_2/';
        % 
        % path = '../Examples/IPC_control/';
        % 
        % path = '../Examples/ComputeSurface/';

    
    mw15_case = 0; 
    % The 15 MW must be unzip (OpenFAST_models-LHEEA_UpdateAug24.zip) to be used 

    %==============================================
    %==============================================
    %==============================================
    %==============================================
    %==============================================
    %==============================================


    SaveOpenFASTOutputFile = 0;
    SaveFigMatlab = 0;
    ForceKeepOutData = 0; % debug only (must be always =0)
    debugMode = 0;
   

    fprintf('\n\n === LCO/St - Lift Control OpenFAST & Stabilization / Main Module - v1.8.0 (Aug. 2024) === \n\n')
    fprintf('L. Michel (CN/LS2N UMR 6004) \n');
    
    % To be updated with future versions of OpenFAST
    fprintf('Using OpenFAST-v3.5.3 -- Compiler: GCC version 14.1.0 \n\n');
    
    ver_ = 180;
    
    % Read the control type directly in the input_file -> easier to set the path ;)
    
    % !!! Reading the config file in openFASTinit
    % Direct assignation of the trajectory from the config file (new in v1.7) -> Assign
    % properly the pitch ref.
    openFASTinit;
    
    % Assign files -> auto-listing of the OpenFAST internal files (new in v1.5
    % revised completely in subversion v1.7b-1 and v1.7.2 : update of the FST modified file checking -> to be modified in the
    % main v1.7b version
    
    cd(FAST_InputPath_2)
    
    AeroDyn15_BladeFound = dir(FAST_aerodyn);
    
    if ( isempty(AeroDyn15_BladeFound) == 0 )
    
        % no need to copy !
        AeroDyn15_Blade = AeroDyn15_BladeFound.name;
    end
    
    cd(LCOS_rootFolder)
    
    
    cd(FAST_InputPath)
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ia. =========== Definition of the trajectory computation
    
    switch ( SelectTrajectoryComputation )
    
        case 0
    
            fprintf('Compute only the open-loop / lift surface! \n');
    
            LiftStepRef = 0; % disabled (used for SelectTrajectoryComputation == 1)
    
            Point_Ref_1 = Point_OpenLoop_Pitch_1;
            Point_Ref_2 = Point_OpenLoop_Pitch_2;
            Point_Ref_3 = Point_OpenLoop_Pitch_3;
    
        case 1
    
            if (LiftTrajectoryRef > 0 && RBMTrajectoryRef == 0)
    
                Point_Ref_1 = Point_ClosedLoop_Lift_1;
                Point_Ref_2 = Point_ClosedLoop_Lift_2;
                Point_Ref_3 = Point_ClosedLoop_Lift_3;
            end
    
            if (RBMTrajectoryRef > 0 && LiftTrajectoryRef == 0)
    
                Point_Ref_1 = Point_ClosedLoop_RBM_1;
                Point_Ref_2 = Point_ClosedLoop_RBM_2;
                Point_Ref_3 = Point_ClosedLoop_RBM_3;
    
            end
    
        case 2
    
            LiftStepRef = 0; % disabled (used for SelectTrajectoryComputation == 1)
    
            Point_Ref_1 = Point_ClosedLoop_Pitch_1;
            Point_Ref_2 = Point_ClosedLoop_Pitch_2;
            Point_Ref_3 = Point_ClosedLoop_Pitch_3;
    
    end
    
    if ( LiftTrajectoryRef == 0 && RBMTrajectoryRef == 0)
    
        fprintf("Problem with the RBMTrajectoryRef / RBMTrajectoryRef that should not be both set to 0 !")
        pause
    
    end
    
    if ( LiftTrajectoryRef == RBMTrajectoryRef)
    
        fprintf("Problem with the RBMTrajectoryRef or RBMTrajectoryRef that should not be equal !")
        pause
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Ib. =========== OpenFAST files MANAGEMENT / Python RE-BUILD & CHECKING
    
    % Edit the I/O files (may be activated manually) - updated to provide assign path in variables in v1.4.1b
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % A-part with the full modification / duplication of the input files
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    InflowFound = dir(FAST_inflow);
    %-------------------------------
    if ( isempty(InflowFound) == 0 )
    
        InFlow = InflowFound(1).name;
        if ( length( InflowFound ) >= 2 &&  strcmp('_', InflowFound(2).name(1) ) )
            Check_InFlow = InflowFound(2).name;
        end
    
    end
    
    %-------------------------------
    AeroDyn15Found = dir('*AeroDyn15.dat');
    if ( isempty(AeroDyn15Found) == 0 )
    
        AeroDyn15 = AeroDyn15Found(1).name;
        if ( length( AeroDyn15Found ) >= 2 &&  strcmp('_', AeroDyn15Found(2).name(1) ) )
            Check_AeroDyn15 = AeroDyn15Found(2).name;
        end
    
    end
    
    %-------------------------------
    ElastoDynFound = dir('*ElastoDyn.dat');
    if ( isempty(ElastoDynFound) == 0  )
    
        ElastoDyn = ElastoDynFound(1).name;
        if ( length( ElastoDynFound ) >= 2 &&  strcmp('_', ElastoDynFound(2).name(1) ) )
            Check_ElastoDyn = ElastoDynFound(2).name;
        end
    
    end
    
    %-------------------------------
    ServoDynFound = dir('*ServoDyn.dat');
    if ( isempty(ServoDynFound) == 0  )
    
        ServoDyn = ServoDynFound(1).name;
        if ( length( ServoDynFound ) >= 2 &&  strcmp('_', ServoDynFound(2).name(1) ) )
            Check_ServoDyn = ServoDynFound(2).name;
        end
    
    end
    
    %-------------------------------
    FSTFound = dir('*fst');
    if ( isempty(FSTFound) == 0  )
    
        FST_ = FSTFound(1).name;
        if ( length( FSTFound ) >= 2 &&  strcmp('_', FSTFound(2).name(1) ) )
            Check_FST = FSTFound(2).name;
        end
    
        FAST_FstFile = FSTFound.name;
        Check_FAST_SumFile = ['_', FST_(1:end-3), 'sum'];
    end
    
    % Check if a set of modified config files already exist (obsolete !)
    %ExistModifiedFile = exist(FSTFound.name,'file');
    
    fprintf('\n ----------------------------------------')
    fprintf('\n ----------------------------------------')
    fprintf('\n Internal files summary : \n\n');
    
    fprintf('** Initial files: \n')
    fprintf('Found %s... \n',  AeroDyn15_Blade);
    fprintf('Found %s... \n',  AeroDyn15);
    fprintf('Found %s... \n',  ElastoDyn);
    fprintf('Found %s... \n',  FAST_FstFile);
    %  fprintf('Found %s... \n',  Check_FAST_SumFile); a new one will be
    %  provided by the new simulation
    
    % If 'ReconstructOFFile' = 1 then a rebuild is requested otherwise the
    % existing file are OK
    
    % Check if the four modified files exist
    if ( exist('Check_AeroDyn15') & exist('Check_ElastoDyn') & exist('Check_ServoDyn') & exist('Check_FST') ) %#ok<AND2>
    
        fprintf('** Modified files: \n')
        %   fprintf('Found %s... \n',  Check_AeroDyn15_Blade);
        fprintf('Found %s... \n',  Check_AeroDyn15);
        fprintf('Found %s... \n',  Check_ElastoDyn);
        fprintf('Found %s... \n',  Check_FST);
        fprintf('Found %s... \n',  Check_FAST_SumFile);
    
        fprintf('\n ----------------------------------------')
        fprintf('\n ----------------------------------------')
    
        % No need of file modification (check later what the user decides)
        ReconstructOFFile = 0;
    
    else
        cd(LCOS_rootFolder)
        fprintf('OpenFAST modified internal file missing -> complete reconstruction !')
    
        % Rebuild necessary !
        ReconstructOFFile = 1;
    
    end
    
    cd(LCOS_rootFolder)
    
    if ( UsePython == 0)
        fprintf('\n The PYTHON SCRIPT IS DISABLED - please setup first your Python installation \n');
        ModifyOF_file_check = 0;
    else
    
        if ( ReconstructOFFile == 0 )
    
            switch selectModififyConfigFile
    
                % If the modified files are already present, the user decides if he
                % wants to reprocess the config files (selectModififyConfigFile == 2)
                case 2
    
                    fprintf('\n\n WARNING 1: Before processing the config files, make sure that all subscripts ''_'' have been added to the files \n');
                    fprintf(' WARNING 2: Before processing the config files, make sure that all outputs have been added! \n');
    
    
                    ModifyOF_file_check = input('Do you want to modify the openFAST files (w.r.t. the ''InputSettings'' vector) (default "0") ?');
    
                    % The user decided before in the config file (selectModififyConfigFile == 0 or 1)
                case 0 % -0 no modifications
    
                    fprintf('\n IGNORE the modification of the OpenFAST files (w.r.t. the ''InputSettings'' vector) \n')
                    ModifyOF_file_check = 0;
    
                case 1 % -1 forces the modifications
    
    
                    fprintf('\n RUN the modification of the OpenFAST files (w.r.t. the ''InputSettings'' vector) \n')
                    ModifyOF_file_check = 1;
    
            end
    
        else
    
            ModifyOF_file_check = 1;
    
        end
    
    end
    
    % Define every OpenFAST file directory
    
    % % -AeroDyn_Blade (not necessary to be modified)
    full_AeroDyn15_Blade          = [LCOS_rootFolder, FAST_InputPath_2(2:end), AeroDyn15_Blade];
    full_AeroDyn15_Blade_path     = [LCOS_rootFolder, FAST_InputPath_2(2:end)];
    %edit(full_AeroDyn15_Blade);
    
    % -Inflow
    InFlow_modified = ['_', InFlow];
    full_InFlow = [LCOS_rootFolder, FAST_InputPath(2:end), InFlow];
    full_InFlow_path = [LCOS_rootFolder, FAST_InputPath(2:end)];
    full_InFlow_modified = [LCOS_rootFolder, FAST_InputPath(2:end), InFlow_modified];
    %edit(full_InFlow);
    
    % -AeroDyn
    AeroDyn15_modified = ['_', AeroDyn15];
    full_AeroDyn15 = [LCOS_rootFolder, FAST_InputPath(2:end), AeroDyn15];
    full_AeroDyn15_path = [LCOS_rootFolder, FAST_InputPath(2:end)];
    full_AeroDyn15_modified = [LCOS_rootFolder, FAST_InputPath(2:end), AeroDyn15_modified];
    %edit(full_AeroDyn15)
    
    % -ElastoDyn
    ElastoDyn_modified = ['_', ElastoDyn];
    full_ElastoDyn = [LCOS_rootFolder, FAST_InputPath(2:end), ElastoDyn];
    full_ElastoDyn_path = [LCOS_rootFolder, FAST_InputPath(2:end)];
    full_ElastoDyn_modified = [LCOS_rootFolder, FAST_InputPath(2:end), ElastoDyn_modified];
    %edit(full_ElastoDyn)
    
    % -ServoDyn
    ServoDyn_modified = ['_', ServoDyn];
    full_ServoDyn = [LCOS_rootFolder, FAST_InputPath(2:end), ServoDyn];
    full_ServoDyn_path = [LCOS_rootFolder, FAST_InputPath(2:end)];
    full_ServoDyn_modified = [LCOS_rootFolder, FAST_InputPath(2:end),ServoDyn_modified];
    %edit(full_ServoDyn)
    
    % -FAST_FstFile
    FAST_FstFile_modified = ['_', FAST_FstFile];
    full_FAST_FstFile = [LCOS_rootFolder, FAST_InputPath(2:end), FAST_FstFile];
    full_FAST_FstFile_path = [LCOS_rootFolder, FAST_InputPath(2:end)];
    full_FAST_FstFile_modified = [LCOS_rootFolder, FAST_InputPath(2:end), FAST_FstFile_modified];
    %edit(full_FAST_FstFile)
    
    % -FAST_SumFile (not copied but needs to duplicate the name')
    
    full_FAST_OutputSum = [LCOS_rootFolder, FAST_InputPath(2:end), '_', FAST_FstFile(1:end-4), '.sum'];
    
    % Clean all output files in the working directory (path) and the input files directory
    
    cd(path)
    
    fprintf('\n\n');
    fprintf('Clean both the <%s> directory and glue-code directory... \n', path)
    
    delete *.txt
    delete *.fig
    delete *.png
    delete *.outb
    delete *.out
    delete *.sum
    
    cd(LCOS_rootFolder)
    
    cd(FAST_InputPath)
    
    delete *.txt
    delete *.fig
    delete *.png
    delete *.outb
    delete *.out
    delete *.sum
    
    cd(LCOS_rootFolder)
    
    
    % Modification of the file is necessary if no copied files already
    % present in the directory or the user decided to modify them (selectModififyConfigFile = 2 / yes or 1)
    if (ModifyOF_file_check > 0 & UsePython == 1) %#ok<OR2>
    
        cd internalPython/
    
        % Erase all copied files (to prevent from future conflicts)
        delete('*.dat')
        delete('*.fst')
        cd ..
    
        % copyfile(full_AeroDyn15_Blade,[internalPython_Path, AeroDyn15_Blade_modified]);
        copyfile(full_InFlow,[internalPython_Path, InFlow_modified]);
    
        copyfile(full_AeroDyn15,[internalPython_Path, AeroDyn15_modified]);
    
        copyfile(full_ElastoDyn,[internalPython_Path, ElastoDyn_modified]);
    
        copyfile(full_ServoDyn,[internalPython_Path, ServoDyn_modified])
    
        copyfile(full_FAST_FstFile,[internalPython_Path, FAST_FstFile_modified])
    
    
        cd(full_FAST_FstFile_path)
        delete('_*')
        cd(LCOS_rootFolder)
    
        fprintf('---- Starting first the modification of the OpenFAST files (may take few minutes)... \n')
    
        cd internalPython/
    
        k_ = 1;
        for ( cnt_Input = 1:length( InputSettings(:,1)) ) %#ok<NO4LP>
    
            % -ServoDyn
            run_python_fast_input_file = sprintf("python3 fast_input_file.py %s '%s' '%s' %s 0 ", ServoDyn_modified, [LCOS_rootFolder, '/internalPython/', ServoDyn_modified], InputSettings(cnt_Input,1), InputSettings(cnt_Input,2));
            system(run_python_fast_input_file);
    
            % -AeroDyn15
            run_python_fast_input_file = sprintf("python3 fast_input_file.py %s '%s' '%s' %s 0 ", AeroDyn15_modified, [LCOS_rootFolder, '/internalPython/', AeroDyn15_modified], InputSettings(cnt_Input,1), InputSettings(cnt_Input,2));
            system(run_python_fast_input_file);
    
            % -ElastoDyn
            run_python_fast_input_file = sprintf("python3 fast_input_file.py %s '%s' '%s' %s 0 ", ElastoDyn_modified, [LCOS_rootFolder, '/internalPython/', ElastoDyn_modified], InputSettings(cnt_Input,1), InputSettings(cnt_Input,2));
            system(run_python_fast_input_file);
    
            % -FAST_FstFile
            run_python_fast_input_file = sprintf("python3 fast_input_file.py %s '%s' '%s' %s 0 ", FAST_FstFile_modified, [LCOS_rootFolder, '/internalPython/', FAST_FstFile_modified], InputSettings(cnt_Input,1), InputSettings(cnt_Input,2));
            system(run_python_fast_input_file);
    
    
            if ( ( cnt_Input / length( InputSettings(:,1))*100 ) > 10*k_ )
    
                fprintf('%d%%  ', 10*k_);
    
                k_ = k_ + 1;
    
            end
    
        end
    
        % -FAST_FstFile
        run_python_fast_input_file = sprintf("python3 fast_input_file.py %s '%s' '%s' %s 0 ", FAST_FstFile_modified, [LCOS_rootFolder, '/internalPython/', FAST_FstFile_modified], 'SumPrint', 'True');
        system(run_python_fast_input_file);
    
        % -wind Inflow
        WindModification(1,:) = ["WindType", '2'];
        %-------------------
        WindModification(2,:) = ["Filename_Uni", '"wind_profile.dat"'];
        %-------------------
    
        for ( cnt_Input = 1:length( WindModification(:,1)) ) %#ok<NO4LP>
    
            run_python_fast_input_file = sprintf("python3 fast_input_file.py %s '%s' '%s' %s 0 ", InFlow_modified, [LCOS_rootFolder, '/internalPython/', InFlow_modified], WindModification(cnt_Input,1), WindModification(cnt_Input,2));
            system(run_python_fast_input_file);
    
        end
    
        fprintf('\n---- Done ! \n ');
    
        cd ..
    
        % Move each modified file to the original openFAST directory
        % ([v1.6.1b] except the ElastoDyn whose IC on the pitch may be modified again)
        %
        movefile([internalPython_Path, AeroDyn15_modified], full_AeroDyn15_path)
        %
        % (v1.8) the ElastoDyn will also move and will be copied again from
        % its orginal directory for the pitch matching
        movefile([internalPython_Path, ElastoDyn_modified], full_ElastoDyn_path)
        %
        movefile([internalPython_Path, ServoDyn_modified], full_ServoDyn_path)
        %
        movefile([internalPython_Path, FAST_FstFile_modified], full_FAST_FstFile_path)
        %
        movefile([internalPython_Path, InFlow_modified], full_InFlow_path)
    
        % movefile([internalPython_Path, AeroDyn15_Blade_modified],
        % full_AeroDyn15_Blade_path) not used
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % B-part with the I.C. + controlled node checking (always called)
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    TMax = 1; % Simply using a 1-sec simulation
    if ( OnlyReadingInput == 0 & UsePython == 1) % set pitch angle when SelectTrajectoryComputation == 1
    
        cd internalPython/
    
        delete('*.dat')
        delete('*.fst')
    
        cd ..
    
        fprintf('Initialize the Simulink file - set the pitch I.C. in ''ElastoDyn'' file) to %f \n', PitchBlade_0)
        %#ok<NASGU> % this value allows simply to initialize the Slx file without compting any open-loop  -> used also to display
        % the summary of variable assingement
        % Include the complete setup of the (wind & ref.) trajectories for better readability
    
        PitchBlade_0_str = sprintf("%.4f", PitchBlade_0);
    
        ControlledNode_str = sprintf("%d", ControlledNode);
    
        IPC_mode_str = sprintf("%d", IPC_mode);
    
        % copy of modified Elastodyn & AeroDyn15
        copyfile(full_ElastoDyn_modified ,[internalPython_Path, ElastoDyn_modified]);
    
        copyfile(full_AeroDyn15_modified ,[internalPython_Path, AeroDyn15_modified]);
    
        copyfile(full_ServoDyn_modified ,[internalPython_Path, ServoDyn_modified]);
    
        cd internalPython/
    
        ICPitchModification(1,:) = ["BlPitch(1)", PitchBlade_0_str];
        %-------------------
        ICPitchModification(2,:) = ["BlPitch(2)", PitchBlade_0_str];
        %-------------------
        ICPitchModification(3,:) = ["BlPitch(3)", PitchBlade_0_str];
    
    
        for ( cnt_Input = 1:length( ICPitchModification(:,1)) ) %#ok<NO4LP>
    
            % -ElastoDyn
            run_python_fast_input_file = sprintf("python3 fast_input_file.py %s '%s' '%s' %s  0 ", ElastoDyn_modified, [LCOS_rootFolder, '/internalPython/', ElastoDyn_modified], ICPitchModification(cnt_Input,1), ICPitchModification(cnt_Input,2));
            system(run_python_fast_input_file);
    
        end
    
        % -AeroDyn15
        run_python_fast_input_file = sprintf("python3 fast_input_file.py %s '%s' '%s' %s 0 ", AeroDyn15_modified, [LCOS_rootFolder, '/internalPython/', AeroDyn15_modified], "BlOutNd", ControlledNode_str);
        system(run_python_fast_input_file);
    
        % -Servodyn
        run_python_fast_input_file = sprintf("python3 fast_input_file.py %s '%s' '%s' %s 0 ", ServoDyn_modified, [LCOS_rootFolder, '/internalPython/', ServoDyn_modified], "Ptch_Cntrl", IPC_mode_str);
        system(run_python_fast_input_file);
    
        cd ..
    
        movefile([internalPython_Path, ElastoDyn_modified], full_ElastoDyn_path)
    
        movefile([internalPython_Path, AeroDyn15_modified], full_ElastoDyn_path)
    
        movefile([internalPython_Path, ServoDyn_modified], full_ElastoDyn_path)
    end
    
    cd(LCOS_rootFolder)
    
    PMC_variable_display = 1; %
    save_plot = 1; % allows saving plots
    
    fprintf('Pitch unit conversion (pitch input -> mesured pitch blade): %f \n', coeff_pitch)
    
    
    % everything should be factorized in the same file -> update of the 'WindTurbineSlx_v2'
    IC_lift_output_filter = 1; % IC for the lift ss-filter
    IC_RBM_output_filter = 1; % IC for the RBM ss-filter
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cd(LCOS_rootFolder) % Back to the root folder in oder to call the parameter checking script
    Parameters_checking; % modify the definition flag if IPC selected
    cd(LCOS_rootFolder)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2. =========== Reference Generator MANAGEMENT
    
    % Not used if 'OnlyReadingInput = 1'since it checks only the files
    
    % Except for (SelectTrajectoryComputation == 1) since the
    % trajectory is externally provided, check first if a 'trajectory
    % generator' file is found:
    % - if a Generator is found, the main info are displayed -> if the
    % user does not want to recompute, this file generator is used for
    % closed-loop computation, otherwise a new generator file is
    % computed (through an open-loop)
    % - if no Generator is found, a new generator file is
    % computed (through an open-loop)
    
    % The variable 'BuildRef_check' indicates if the Generator must me
    % recomputed (=1) or used from existing (=0)
    
    if ( OnlyReadingInput == 0 & ( SelectTrajectoryComputation == 0 || SelectTrajectoryComputation == 2 ) )
    
        cd(path)
        GeneratorFound = dir('*_generator.mat');
    
        if ( length( GeneratorFound ) == 1)
    
            % Verify the existing generator file and ask the user what to do ?
    
            if ( isempty(GeneratorFound) == 0 & SelectTrajectoryComputation > 0 )
                fprintf('Verify existing generator file: \n') % GeneratorFound.name
                read_generator = GeneratorFound.name;
    
    
                %Read Config param. of the Generator (new in v121)
                Rconfig = load(GeneratorFound.name);
    
                uu = 1;
                Rconfig.Config_
    
                %  Rconfig.Param
    
                fprintf('Trajectory reference points: %f %f %f \n', Rconfig.Param.reference_point_1 , ...
                    Rconfig.Param.reference_point_2 , ...
                    Rconfig.Param.reference_point_3 )
    
                BuildRef_check = input('\n Do you want to re-build the generator file (default "0") ?');
    
            else
    
                BuildRef_check = 1; % recompute the open-loop
    
            end
    
        else
    
            % In case no Generator is found or two much generator are
            % found -> recompute!
    
            if ( isempty(GeneratorFound) == 1 )
    
                fprintf('No generator found - starting open-loop computation \n');
            else
    
                fprintf('Too much files generators - restarting open-loop computation \n');
    
            end
    
            BuildRef_check = 1;
    
        end
    
        cd(LCOS_rootFolder)
    
    else
    
        BuildRef_check = 1;
    
    end
    
    % Not used if 'OnlyReadingInput = 1'since it checks only the files
    % Set the automatic re-build of the generator for 'SelectTrajectoryComputation = 2' and '=0'
    % Since it is open-loop: it is normal to recompute the generator
    if ( OnlyReadingInput == 0 & ( SelectTrajectoryComputation == 1 | SelectTrajectoryComputation == 0 | ( BuildRef_check > 0 & SelectTrajectoryComputation == 2) ) ) %#ok<AND2,OR2>
    
        cd(path)
    
        fprintf('Cleaning all "mat" files in "%s" ... \n', path);
    
        delete *.mat
    
        cd(LCOS_rootFolder)
    
    end
    
    clear Results
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 3. ===========  / Simulink initialization
    
    % WARNING : Update v5-6 of open-loop SLX file -> update to 1A in v1.8
    
    SimulationKernel_vA;
    
    if ( BuildRef_check == 1 )
    
        fprintf('Please verify that the channels / index / config are correct !  (10 s) \n\n')
        pause(10)
    
    end
    
    
    % the program stops here if OnlyReadingInput = 1 because it is not
    % necessary to evaluate initial conditions on the lift ...  the user
    % needs only to very (at least) that the files & index are correct
    if ( OnlyReadingInput == 1)
        TMax = tMax_user;
        fprintf('\n\n\n Checking only the parameters - End of the program - Abort !')
        return
    end
    
    fprintf('Restart a quick simulation to set up the initial conditions of the filter... \n')
    %  TMax = 10;
    SimulationKernel_vA;
    
    % For SLX file to set the I.C. on the ss-filters lift & RBM
    IC_lift_output_filter = Results.B1N1Fl_out(end);
    IC_RBM_output_filter =  Results.RootMyb1_out(end);
    
    fprintf('\n ...I.C. on lift / RBM (node #%d) = %f / %f \n\n',  NodeLift_Index_cntrl, Results.B1N1Fl_out(end),  Results.RootMyb1_out(end));
    
    % fprintf('Warning: Set IC-RBM as %f X IC-lift (seems a transient from zero on RBM before converging)... \n', IC_RBM_factor),
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 4. =========== Parameter formating & checking
    
    % update in v1.8 : 'WindTurbineSlx_v2' -> SimulationKernel_vA
    
    
    % Input settings
    Config_.wind_speed_x = wind_speed_x ;
    Config_.NodeLift_Index_cntrl = NodeLift_Index_cntrl;
    Config_.DT = DT;
    
    % updated in v1.4.0
    Param.wind_speed_x = wind_speed_x;
    Param.wind_speed_t = wind_speed_t;
    Param.reference_point_1 = Reference_point_1;
    Param.reference_point_2 = Reference_point_2;
    Param.reference_point_3 = Reference_point_3;
    Param.reference_point_4 = Reference_point_4;
    
    Cntrl.IO_gain = IO_gain;
    Cntrl.Kp_1 = Kp_1;
    Cntrl.Kint_1 = Kint_1;
    Cntrl.K_alpha_1 = K_alpha_1;
    Cntrl.K_beta_1 = K_beta_1;
    Cntrl.K_divide_1 = K_divide_1;
    
    fprintf('\n ----- Simulation parameters settings (from the config file)')
    
    %  Config_
    %  Input
    Param %#ok<NOPTS>
    
    
    fprintf('----- Expected control parameters (from the config file) \n')
    
    Cntrl %#ok<NOPTS>
    
    fprintf('Log command windows ... \n')
    
    
    % Save the terminal
    cd (path)
    
    % Warning : the following create some Java variables that prevent from
    %         using the cell-based pros-processing of the Slx records !!
    desktop = com.mathworks.mde.desk.MLDesktop.getInstance; %#ok<JAPIMATHWORKS>
    cmdWindow = desktop.getClient('Command Window');
    cmdWindowScrollPane = cmdWindow.getComponent(0);
    cmdWindowScrollPaneViewport = cmdWindowScrollPane.getComponent(0);
    cmdTextUI = cmdWindowScrollPaneViewport.getComponent(0);
    cmdText = cmdTextUI.getText;
    
    
    
    save_param = save_project_name + 'check_parameters.txt';
    
    fid = fopen(save_param, 'w');
    fprintf(fid, '%s', cmdText);
    
    clear desktop cmdWindow  cmdWindowScrollPane  cmdWindowScrollPaneViewport  cmdTextUI  cmdText
    
    cd(LCOS_rootFolder)
    
    fprintf('Please check everything ! (10 s) \n')
    pause(10)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 5a. =========== OPEN-LOOP COMPUTATION
    
    % restore TMax from the user
    TMax = tMax_user;
    
    % new in v1.6.2 -> compute only open-loop + lift surface (if selected)
    
    if (isempty(BuildRef_check) || BuildRef_check == 0)
        fprintf('Skip open-loop computation... \n');
    end
    
    % Preparation of the open-loop computation: create and plot the
    % trajectory references
    if ( ( SelectTrajectoryComputation == 0 || SelectTrajectoryComputation == 2 ) & BuildRef_check > 0 ) %#ok<AND2>
    
        % Initialize the reference of pitch
        time_ref = 0:(TMax/6):TMax;
    
        % The reference points are defined in the 'SimulationKernel_vA'
        TrajDef = [Reference_point_1  Reference_point_1   Reference_point_2  Reference_point_2  ...
            Reference_point_2   Reference_point_3   Reference_point_3   Reference_point_4   Reference_point_4 ];
    
        [ time_base, TrajectoryReference ] = BuildCustomizedRef_v2 ( time_ref, TrajDef , DT, TMax, coeff_pitch, LiftStepRef,  LiftStepRef_stepTime);
    
        %   file_name_save_pitch_fig = save_project_name + '_pitch.fig';
        file_name_save_pitch_png = save_project_name + '_pitch.png';
    
    
        cd(path)
    
        subplot(2,1,1)
        plot( wind_speed_t, wind_speed_x , 'g',  'linewidth', 2)
        ylabel('Expected wind profile [m/s] ')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        subplot(2,1,2)
        plot ( time_base, coeff_pitch * TrajectoryReference , 'linewidth', 2)
        xlabel('Time [sec]')
        ylabel('Expected pitch trajectory [degree]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        saveas(gcf,file_name_save_pitch_png)
    
        cd(LCOS_rootFolder)
    
        % Ask the user to check first if the reference is correct?
        fprintf('\n\n Agree with the pitch / lift variations and the global parameters ? (pause 10 s) \n')
        pause(10)
        close all
    
        %%%%%%%%%%%%%%%%%%%%%%%%
    
        % This previous section is obsolete in v1.5.0 -> replaced by
        % 'WindturbineSlx_v2' that includes all initializations,
        % execution and post-processing of the variables
    
        % It is necessary to initialize the simulation in order to get the
        % 'sum' file -> proper set of each Simulink variables
    
        SimulationKernel_vA; %  'from v1.6.0 : WindTurbineSlx_v2 invokes directly ProcessingSlxData_v5_cell'
    
        % The lift / RBM results are assigned to the ref. trajectory
        TrajectoryReference_Lift = Results.B1N1Fl_out;
        TrajectoryReference_Lift_AVG = Results.Avg_B1N1Fl_out;
    
        TrajectoryReference_RBM = Results.RootMyb1_out;
        TrajectoryReference_RBM_AVG = Results.Avg_RootMyb1_out;
    
        % new in subversion v1.7b-1 : introduce the possbility of
        % blocking the ref. trajectory to the average of the sec. half
        % part of the trajectory
    
        le_traj = length(TrajectoryReference_Lift);
        TrajectoryReference_LiftConst = mean(TrajectoryReference_Lift(floor(le_traj/2):end)) * ones(1, le_traj);
    
        cd(LCOS_rootFolder)
    
        if ( IPC_mode == 1 )
    
            TrajectoryReference_IPC_1 = Results.Avg_B1N1Fl_out;
            TrajectoryReference_IPC_2 = Results.Avg_B2N1Fl_out;
            TrajectoryReference_IPC_3 = Results.Avg_B3N1Fl_out;
    
        else
    
            TrajectoryReference_IPC_1 = -1;
            TrajectoryReference_IPC_2 = -1;
            TrajectoryReference_IPC_3 = -1;
    
    
        end
    
        % Save the generator file
        SaveGenerator;
    
        % Check if the generator file has been created
        cd(path)
        GeneratorFound = dir('*_generator.mat');
        fprintf('Create %s... \n',  GeneratorFound.name)
        cd(LCOS_rootFolder)
    
        % new in v1.5.0
        %ProcessingSlxData_v4_cell;
    
        file_name_SC_Fl = sprintf( save_project_name + 'SurfaceLift_Fl_pitch_%f_windSpeed_%f.png', Reference_point_1, Results.Wind1VelX_out(end)  );
        file_name_SC_Fy = sprintf( save_project_name + 'SurfaceLift_Fy_pitch_%f_windSpeed_%f.png', Reference_point_1, Results.Wind1VelX_out(end)  );
    
        title_name_SC_Fl = sprintf('Fl-(pitch : ref%f soft%f) - windSpeed%f', Reference_point_1, Results.BldPitch1_out(end), Results.Wind1VelX_out(end) );
        title_name_SC_Fy = sprintf('Fy-(pitch : ref%f soft%f) - windSpeed%f', Reference_point_1, Results.BldPitch1_out(end), Results.Wind1VelX_out(end) );
    
    
        cd(LCOS_rootFolder)
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 5b. =========== OPEN-LOOP COMPUTATION / Lift surface computing
    
        % SET but not operating in the v1.6.0 -> fully updated and simplified in v1.8.0
    
        %  fprintf('Compute the Lift Surface - set pitch to %f (should be changed directly in the config file) \n', Reference_point_1)
    
        if (SelectTrajectoryComputation == 0)
    
            if (ComputeSurface == 1)
    
                fprintf('Computing a Lift surface! \n\n')
    
                % last argument BladeNodePosition = 0 (not used)
                [Stat_vector, IndexSurfaceComputation] = ComputeLiftSurface_v2b (NumBlNds, IndexSurfaceComputation, 0, NodeLift_Index_cntrl, Results, ResultsLiftdata, path, Stat_vector, 0, 0 , 0 );
    
                cd(LCOS_rootFolder)
            else
    
                fprintf('No surface computing... \n');
    
            end
    
        end
    
    end
    
    % Lift/ RBM TrajectoryReference will be assigned directly to the reference in closed-loop
    if (SelectTrajectoryComputation == 1)
    
        % Initialize the reference of the ref.
        time_ref = 0:(TMax/6):TMax;
    
        Reference_point_1 = Point_Ref_1; %
        Reference_point_2 = Point_Ref_2; %
        Reference_point_3 = Point_Ref_3; %
        Reference_point_4 = Point_Ref_3; %
    
        TrajDef = [Reference_point_1  Reference_point_1   Reference_point_2  Reference_point_2  ...
            Reference_point_2   Reference_point_3   Reference_point_3   Reference_point_4   Reference_point_4 ];
    
        % TrajectoryReference will be assigned directly to the reference in closed-loop.
        [ time_base, External_TrajectoryReference ] = BuildCustomizedRef_v2 ( time_ref, TrajDef , DT, TMax, 1, LiftStepRef, LiftStepRef_stepTime);
    
        %   file_name_save_pitch_fig = save_project_name + '_pitch.fig';
        file_name_save_traj_png = save_project_name + '_traj_external.png';
    
        % Ask the user to check first if the reference is correct
        % Out_Reference is a simple vector in this case????
    
        cd(path)
    
        plot ( time_base, External_TrajectoryReference , 'linewidth', 2)
        xlabel('Time')
        ylabel('Lift Reference')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        saveas(gcf,file_name_save_traj_png)
    
        cd(LCOS_rootFolder)
    
    
        fprintf('Agree with the LIFT ref. variations and the global parameters ? (pause 10 s) \n')
        pause(10)
        close all
    
        % Process data field /ProcessingSlxData_AvgCase; -> obsolete in v141
    
        Time_ = Time_vec_struct.time;
    
        fprintf('End simulation time : %f over %d points \n', Time_(end), length(Time_));
    
        ProcessingSlxData_v5_cell;
    
        fprintf('No need to save data since the ref is external... \n');
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 6a. =========== PREPARATION OF THE CLOSED-LOOP COMPUTATION
    
    if (SelectTrajectoryComputation == 0 || SelectTrajectoryComputation == 2)
    
        fprintf('-----------------------------------------');
        % Load Reference from the generator file
    
        %%%%%%%%% This section is common to the complete generator build process and
        %%%%%%%%% the read of the generator file -> prevent from error in
        %%%%%%%%% parameters
    
        % 1/ Check if the generator file exists
        cd(path)
        GeneratorFound = dir('*_generator.mat');
    
        fprintf('\n\n Verify Generator data... \n') % GeneratorFound.name
        save_generator = GeneratorFound.name;
    
        clear Input Param Cntrl
    
        R1 = load(save_generator);
    
        cd(LCOS_rootFolder);
    
        % Plot open-loop trajectories
        DisplayOpenLoop;
    
        % Only necessary to display the reference for the
        % (SelectTrajectoryComputation == 2) control
        if ( SelectTrajectoryComputation == 2)
    
            file_name_save_traj_png = save_project_name + '_trajectory.png';
    
            close all
            if ( IPC_mode == 0 )
    
                cd(path)
    
                if ( LiftTrajectoryRef > 0)
    
                    plot ( R1.time_base, R1.TrajectoryReference_Lift, 'b',  'linewidth', 2)
                    hold on
                    plot ( R1.time_base, R1.TrajectoryReference_Lift_AVG , '--m', 'linewidth', 2)
                    plot ( R1.time_base, R1.TrajectoryReference_LiftConst, 'k', 'linewidth', 2)
                    xlabel('Time')
                    ylabel('Choice of Lift Reference Tracking');
                    legend('standard lift', 'AVG lift', 'CONST lift');
                    set(gca,'FontSize',20);
                    set(gcf,'Color','w');
                    saveas(gcf,file_name_save_traj_png)
                end
    
                if ( RBMTrajectoryRef > 0)
    
                    plot ( R1.time_base, R1.TrajectoryReference_RBM , 'b',  'linewidth', 2)
                    hold on
                    plot ( R1.time_base, R1.TrajectoryReference_RBM_AVG , '--m', 'linewidth', 2)
                    xlabel('Time')
                    ylabel('Choice of RBM Reference Tracking');
                    legend('standard RBM', 'AVG RBM', 'CONST RBM');
                    set(gcf,'Color','w');
                    set(gca,'FontSize',20);
                    saveas(gcf,file_name_save_traj_png)
                end
    
            else
    
                cd(path)
                subplot(3,1,1)
                plot ( R1.time_base, R1.TrajectoryReference_IPC_1 , 'b', 'linewidth', 2)
                xlabel('Time')
                ylabel('Lift possible Reference 1');
                subplot(3,1,2)
                plot ( R1.time_base, R1.TrajectoryReference_IPC_2 , 'r', 'linewidth', 2)
                xlabel('Time')
                ylabel('Lift possible Reference 2');
                subplot(3,1,3)
                plot ( R1.time_base, R1.TrajectoryReference_IPC_3 , 'g', 'linewidth', 2)
                xlabel('Time')
                ylabel('Lift possible Reference 2');
                set(gcf,'Color','w');
                %          set(gca,'FontSize',20);
                saveas(gcf,file_name_save_traj_png)
    
            end
    
        end
    
    
        fprintf('\n\n Check the lift / RBM reference (10 s)... \n');
        pause(10)
        close all
    
        if ( SelectTrajectoryComputation == 2)
    
            % 2/ Check if the parameters are identical between input source
    
            bool_1 = R1.Param.wind_speed_x == wind_speed_x;
            bool_2 = R1.Param.wind_speed_t == wind_speed_t;
            bool_3 = R1.Param.reference_point_1 == Reference_point_1;
            bool_4 = R1.Param.reference_point_2 == Reference_point_2;
            bool_5 = R1.Param.reference_point_3 == Reference_point_3;
            bool_6 = R1.Param.reference_point_4 == Reference_point_4;
            bool_7 = R1.Config_.NodeLift_Index_cntrl == NodeLift_Index_cntrl;
            bool_8 = R1.Config_.DT == DT;
    
            if (  mean(bool_1 & bool_2 & bool_3 & bool_4 & bool_5 & bool_6 & ...
                    bool_7 & bool_8 ) == 1 )
    
                fprintf('Parameters OK ... \n')
    
            else
    
                % Display a warning in case of problem with the
                % generator file
                fprintf('Warning: The Parameters from the generator file are NOT identical to the current config !\n')
                pause
            end
    
    
            % 3/ Clear all input parameters to avoid conflicts
    
            clear wind_speed_x
            clear wind_speed_t
    
            clear select_slope
            clear pitch_angle_initial
            clear pitch_angle_middle
            clear pitch_angle_final_step_
    
            clear slope_pitch
            clear pitch_angle_final_slope_
    
            clear pitch_switch_time_1
            clear pitch_switch_time_2
    
            % 4/ Deflating and assign the new parameters
            wind_speed_x = R1.Param.wind_speed_x ;
            wind_speed_t = R1.Param.wind_speed_t ;
    
            % Pitch ref. on open-loop only for display purpose
            Reference_point_1 = R1.Param.reference_point_1;
            Reference_point_2 = R1.Param.reference_point_2;
            Reference_point_3 = R1.Param.reference_point_3;
            Reference_point_4 = R1.Param.reference_point_4;
    
    
            % Assign the trajectory reference from the R1 loaded file WRONG !!
            %TrajectoryReference = R1.Config_.trajectoryReference ;
    
            %  if ( IPC_mode == 0 )
    
            if (LiftTrajectoryRef >= 1)
                switch LiftTrajectoryRef
    
                    case 1
                        TrajectoryReference = R1.TrajectoryReference_Lift;
                        fprintf('Using normal lift trajectory... \n')
    
                    case 2
                        TrajectoryReference = R1.TrajectoryReference_Lift_AVG;
                        fprintf('Using AVG lift trajectory... \n')
    
                    case 3
                        TrajectoryReference = R1.TrajectoryReference_LiftConst;
                        fprintf('Using CONST lift trajectory... \n')
    
                end
    
                ClosedLoop_SLXfile__Cont = ClosedLoop_SLXfile_Lift;
            end
    
    
            if (RBMTrajectoryRef >= 1)
    
                switch RBMTrajectoryRef
    
                    case 1
                        TrajectoryReference = R1.TrajectoryReference_RBM;
                        fprintf('Using normal RBM trajectory... \n')
    
                    case 2
                        TrajectoryReference = R1.TrajectoryReference_RBM_AVG;
                        fprintf('Using AVG RBM trajectory... \n')
    
                    case 3
                        TrajectoryReference = R1.TrajectoryReference_RBMConst;
                        fprintf('Using CONST RBM trajectory... \n')
    
                end
    
                ClosedLoop_SLXfile__Cont = ClosedLoop_SLXfile_RBM;
            end
    
            cd(LCOS_rootFolder)
    
            %%%%%%%%%
    
            uu = 1;
    
            % Display
            Param = R1.Param; % to be saved with the final results
    
        end
    
    end
    
    
    if ( SelectTrajectoryComputation == 1 & IPC_mode == 0 ) %#ok<AND2>
    
        if (LiftTrajectoryRef >= 1)
    
            ClosedLoop_SLXfile__Cont = ClosedLoop_SLXfile_Lift;
        end
    
    
        if (RBMTrajectoryRef >= 1)
    
            ClosedLoop_SLXfile__Cont = ClosedLoop_SLXfile_RBM;
        end
    
        % the trajectory has been defined in the open-loop section
        TrajectoryReference = External_TrajectoryReference;
    
        fprintf('Using External trajectory... \n')
    end
    
    if ( IPC_mode == 1 )
    
        clear Results
    
        fprintf('Using IPC-based trajectories... \n')
    
        %  TrajectoryReference = External_TrajectoryReference;
        TrajectoryReference_IPC_1 = R1.Results.Avg_B1N1Fl_out;
        TrajectoryReference_IPC_2 = R1.Results.Avg_B2N1Fl_out;
        TrajectoryReference_IPC_3 = R1.Results.Avg_B3N1Fl_out;
    
        ClosedLoop_SLXfile__Cont = ClosedLoop_SLXfile_Lift_IPC;
    
        TrajectoryReference_1 = -1;
        TrajectoryReference_2 = -1;
    
    end
    
    if ( SelectTrajectoryComputation > 0)
    
        clear Results
        %clear Config_ Input Results Param Cntrl
    
        clear F1y_1  F1y_2  F1y_3   F2y_1   F2y_2  F2y_3   F3y_1   F3y_2   F3y_3
    
        clear RootMyb1  RootMyb2   RootMyb3   RootMyc1
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 6b. =========== CLOSED-LOOP COMPUTATION
    
        TMax = tMax_user;
    
        % To muck complex for the moment since we have introduced Tables for
        % which the functions are specific... to be checked later ;)
        %    fprintf('Saving the Workspace variables... \n');
        %    ListWorkspaceVar;
    
        % new in v121
        fprintf('Updating the control gains... \n')
    
        % This section has been moved from the end of the open-loop
        Cntrl.IO_gain = IO_gain;
        %        Cntrl.offset_ref_init = offset_ref_init; obsolete
        %        Cntrl.time_constant_ref = time_constant_ref; obsolete
    
        Cntrl.Kp_1 = Kp_1;
        Cntrl.Kint_1 = Kint_1;
        Cntrl.K_alpha_1 = K_alpha_1;
        Cntrl.K_beta_1 = K_beta_1;
        Cntrl.K_divide_1 = K_divide_1;
    
        buf_wind  = sprintf('Node = %d -  inflow:[%f -> %f -> %f]', NodeLift_Index_cntrl, wind_speed_x(1), wind_speed_x(2), wind_speed_x(3) );
        title_graph = convertCharsToStrings( buf_wind );
    
    
        % The display on the cntrl parameters has been done previoulsy
        % while logging all parameters
    
        close all
    
        fprintf('Ready for the Closed-Loop simulation ! \n');
        fprintf('Using SLX file for the Closed-Loop : %s \n', ClosedLoop_SLXfile__Cont);
    
        pause(5)
    
        fprintf('\n\n *************** Starting Closed-loop mode (processing v2-WTSlx) *************** \n')
        sim(ClosedLoop_SLXfile__Cont);
    
    
        Time_ = Time_vec_struct.time;
    
        fprintf('End simulation time : %f over %d points \n', Time_(end), length(Time_));
    
        ProcessingSlxData_v5_cell;
    
        % Process data field !!! may be a bug with Results(uu).BladeAngle
        % !!! -> to be checked later
        % ProcessingSlxData;
    
        % new in V1.4.1
        DisplayInfo = 0; % disable the display for the variables
    
        % Save the results
        SaveResults;
    
        % Create and save final plots
        cd(LCOS_rootFolder)
    
        % Update to v2beta
        %%%%%%%%%%% plot module
        ModulePlot_vA;
        %%%%%%%%%%%%%%%%%%%%%%%
    
        fprintf('\n\n');
    
    end
    
    close all
    
    if ( SaveFigMatlab == 0 )
    
        delete *.fig
    
    end
    
    cd(LCOS_rootFolder)
    
    % Finalizing - cleaning files
    
    fprintf('Cleaning glue-code output files... \n')
    
    if ( ForceKeepOutData == 0 )
    
        cd(LCOS_rootFolder)
        fprintf('Saving ''sum'' output files... \n')
    
        movFILE_sum = [FAST_InputPath(1:end), Check_FAST_SumFile];
    
        movefile(movFILE_sum, [path, Check_FAST_SumFile ] );
    
        cd(LCOS_rootFolder)
        cd(FAST_InputPath)
    
        delete *.out
        delete *.outb
        delete *.sum
        cd(LCOS_rootFolder)
    
    end
    
    cd(LCOS_rootFolder)
    
    
    fprintf('End ! \n\n')
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % End of the program
    %%%%%%%%%%%%%%%%%%%%%%%%%
