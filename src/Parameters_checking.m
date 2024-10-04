


    % Re-assign the main fst file -> modified 

    % Clear the initial filenames to be sure of the new modified names
%    clear full_AeroDyn15_Blade
    clear full_InFlow 
    clear full_AeroDyn15 
    clear full_ElastoDyn 
    clear full_ServoDyn 
    clear full_FAST_FstFile 

    % - DT
    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'DT', '', 0, 0);
    DT = str2double((cell_.Cell_line_1));   

    % - NBlOuts
    [ ~, cell_ ] = ReadData_v3_2(full_AeroDyn15_modified,'NBlOuts', '', 0, 0);
    NBlOuts = str2double((cell_.Cell_line_1));
  

        if (NBlOuts == 1)
    % - BlOutNd
    [ ~, cell_ ] = ReadData_v3_2(full_AeroDyn15_modified,'BlOutNd', '', 0, 0);
    % Node indexing seems deprecated from the AeroDyn15 -- but re-use to
    % compute the three phase lift ;)
      NodeLift_Index = [str2double((cell_.Cell_line_1)), str2double((cell_.Cell_line_2)), str2double((cell_.Cell_line_3))];
        
      NodeLift_Index_cntrl = NodeLift_Index(1); % the control node corresponds to the output node
        Results.NodeLift_Index_cntrl = NodeLift_Index_cntrl;


        else

        fprintf('The number of Node output should be =1, please check the AeroDyn15 file, Abort ! \n')
        
        return
        pause  % return deos not seems to work here !
         
        end

    % - NumBlNds
     [ ~, cell_ ] = ReadData_v3_2(full_AeroDyn15_Blade,'NumBlNds', '', 0, 0);
      NumBlNds = [str2double((cell_.Cell_line_1))];

      % new in v1.6.2 ->  -> includes reading of the blade mesh -> rev.
      % it should not used for the moment 
      %
      %[ ~, cell_ ] = ReadData_v3_3(full_AeroDyn15_Blade,'(m)', '', 0, 0);
      % 
      % for yy = 2:length(cell_)-1
      % 
      %     BladeNodePosition(yy-1) = str2double(cell_(yy).Cell_line_1)
      % 
      % end


    fprintf('\n --------- SERVO-DYN VARIABLES --------- \n');

    % - PCMode
    [ ~, cell_ ] = ReadData_v3_2(full_ServoDyn_modified,'PCMode', '', 0, 0);
    PCMode = str2double((cell_.Cell_line_1));

    if ( PCMode ~= 4 )
    fprintf('ERROR : Co-simulation with Simulink disabled (set PCMode = 4 in ServoDyn) , Abort !')
    pa
    else
    fprintf('Checking the co-simulation with Simulink ... OK \n');   
    end

    % - VSContrl
    [ ~, cell_ ] = ReadData_v3_2(full_ServoDyn_modified,'VSContrl', '', 0, 0);
    VSContrl = str2double((cell_.Cell_line_1));

    % - GenModel
    [ ~, cell_ ] = ReadData_v3_2(full_ServoDyn_modified,'GenModel', '', 0, 0);
    GenModel = str2double((cell_.Cell_line_1));

    if ( VSContrl > 0 )
        fprintf('WARNING : VSContrl set to  %d - GenModel = %d \n', VSContrl, GenModel )
    else
        fprintf('WARNING : Variable-speed control disabled - GenModel = %d \n', GenModel)
    end

    % - Ptch_Cntrl
    [ ~, cell_ ] = ReadData_v3_2(full_ServoDyn_modified,'Ptch_Cntrl', '', 0, 0);
    Ptch_Cntrl = str2double((cell_.Cell_line_1));

    if ( Ptch_Cntrl > 0 )
        fprintf('WARNING : IPC mode selected (Ptch_Cntrl = %d) -> select SelectTrajectoryComputation = 2 \n', Ptch_Cntrl )
        SelectTrajectoryComputation = 2;
    else
        fprintf('WARNING : CPC mode selected (Ptch_Cntrl = %d) \n', Ptch_Cntrl )
    end

    pause(2)

    %fprintf('--------------------------------------- \n');

    % new readings in v1.5.0
    % Direct set of the NodeLift index from the AeroDyn15 File and defines
    % also the NodeLift_index_base from the input file

    fprintf('\n --------- AeroDyn15 Config --------- \n');

    
    [ ~, cell_ ] = ReadData_v3_2(full_AeroDyn15_modified,'TwrPotent', '', 0, 0);
    TwrPotent = str2double((cell_.Cell_line_1));

    [ ~, cell_ ] = ReadData_v3_2(full_AeroDyn15_modified,'TwrShadow', '', 0, 0);
    TwrShadow = str2double((cell_.Cell_line_1));

    [ ~, cell_ ] = ReadData_v3_2(full_AeroDyn15_modified,'TwrAero', '', 0, 0);
    TwrAero = ((cell_.Cell_line_1));


    fprintf('TwrPotent : %d \n', TwrPotent);

    fprintf('TwrShadow : %d \n', TwrShadow);

    fprintf('TwrAero : %s \n', TwrAero);


    fprintf('\n --------- Degrees of Freedom selected (in ElastoDyn file) --------- \n');

   [ ~, ~, cell_range ] = ReadData_v3_2(full_ElastoDyn_modified, 'FlapDOF1', 'PtfmYDOF', 0, 0 );

   
   for yy = 1:length(cell_range)
    fprintf('%s -> %s \n', cell_range(yy).Cell_line_2, cell_range(yy).Cell_line_1 );
   end

   if ( VSContrl > 0 & strcmp( cell_range(6).Cell_line_1, "False" ) )

       fprintf("ERROR : the GenDOF has not been activated and VSContrl > 0 \n")
       fprintf("Program abort ! \n")
       pa
   end

    % - ShftTilt
    [ ~, cell_ ] = ReadData_v3_2(full_ElastoDyn_modified, 'ShftTilt', '', 0, 0 );
    ShftTilt = str2double((cell_.Cell_line_1));
    
    % - PreCone(1)
    [ ~, cell_ ] = ReadData_v3_2(full_ElastoDyn_modified, 'PreCone(1)', '', 0, 0);
    PreCone_1 = str2double((cell_.Cell_line_1));
    
    % - PreCone(2)
    [ ~, cell_ ] = ReadData_v3_2(full_ElastoDyn_modified, 'PreCone(2)', '', 0, 0);
    PreCone_2 = str2double((cell_.Cell_line_1));
    
    % - PreCone(3)
    [ ~, cell_ ] = ReadData_v3_2(full_ElastoDyn_modified, 'PreCone(3)', '', 0, 0);
    PreCone_3 = str2double((cell_.Cell_line_1));

    % - BlPitch(1)
    [ ~, cell_ ] = ReadData_v3_2(full_ElastoDyn_modified, 'BlPitch(1)', '', 0, 0);
    BlPitch_1 = str2double((cell_.Cell_line_1));

    % - BlPitch(2)
    [ ~, cell_ ] = ReadData_v3_2(full_ElastoDyn_modified, 'BlPitch(2)', '', 0, 0);
    BlPitch_2 = str2double((cell_.Cell_line_1));

    % - BlPitch(3)
    [ ~, cell_ ] = ReadData_v3_2(full_ElastoDyn_modified, 'BlPitch(3)', '', 0, 0);
    BlPitch_3 = str2double((cell_.Cell_line_1));


    fprintf('\n --------- Current ElastoDyn Angles : \n ShftTilt = %f \n PreCone_1 = %f \n PreCone_2 = %f \n PreCone_3 = %f', ShftTilt, PreCone_1, PreCone_2, PreCone_3 );
    fprintf('\n --------- Current ElastoDyn IC Pitch : \n BlPitch(1) = %f \n BlPitch(2) = %f \n BlPitch(3) = %f \n\n', BlPitch_1, BlPitch_2, BlPitch_3);

    fprintf('\n\n --------- Coeff. of the power law (from the input file) %f \n', PwrLaw);

    % - RotSpeed
    [ ~, cell_ ] = ReadData_v3_2(full_ElastoDyn_modified, 'RotSpeed', '', 0, 0);
    RotSpeed = str2double((cell_.Cell_line_1));

    fprintf('\n --------- Current ElastoDyn RotorSpeed : %f \n\n', RotSpeed);

    fprintf('\n --------- Current DT selected : %f \n\n', DT);

      % - WindType
    [ ~, cell_ ] = ReadData_v3_2(full_InFlow_modified,'WindType', '', 0, 0);
    WindType = str2double((cell_.Cell_line_1));


    [ ~, cell_ ] = ReadData_v3_2(full_InFlow_modified,'FileName_BTS', '', 0, 0);
    BTS_file = cell_.Cell_line_1;

    fprintf('================================================ \n')
    if ( WindType == 2)
    fprintf('Current WindType = %d with ''Power Law coeff.'' = %f \n', WindType, PwrLaw);
    else
            cd(path)
            eval(InputName); % read again to unzip the bts files
            cd(LCOS_rootFolder)
        fprintf('Current WindType: STOCHASTIC WIND PROFILE : <%s> \n', BTS_file);    
    end
    fprintf('================================================ \n\n')

    pause(5)

    %fprintf('------------------------------------------------------------------- \n');
       
    % ============================ CHECK MODULE SELECTION
    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'CompElast', '', 0, 0);
    CompElast = str2double((cell_.Cell_line_1));
    b_ElastoDyn = CheckModifiedConfigFST(full_FAST_FstFile_modified, 'EDFile', ElastoDyn_modified );

    
    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'InflowFile', '', 0, 0);
    CompInflow = str2double((cell_.Cell_line_1));
    b_InflowFile = CheckModifiedConfigFST(full_FAST_FstFile_modified, 'InflowFile', InFlow_modified );



    %     [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile,'CompInflow', '', 0, 0);
    % CompInflow = str2double((cell_.Cell_line_1));
    % b_InflowFile = CheckModifiedConfigFST(full_FAST_FstFile_modified, 'InflowFile', InFlow_modified );


    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'CompInflow', '', 0, 0);
    CompInflow = str2double((cell_.Cell_line_1));
    b_InflowFile = CheckModifiedConfigFST(full_FAST_FstFile_modified, 'InflowFile', InFlow_modified );

    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'CompAero', '', 0, 0);
    CompAero = str2double((cell_.Cell_line_1));
    b_CompAero = CheckModifiedConfigFST(full_FAST_FstFile_modified, 'AeroFile', AeroDyn15_modified );

    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'CompServo', '', 0, 0);
    CompServo = str2double((cell_.Cell_line_1));
    b_CompServo = CheckModifiedConfigFST(full_FAST_FstFile_modified, 'ServoFile', ServoDyn_modified );

    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'CompHydro', '', 0, 0);
    CompHydro = str2double((cell_.Cell_line_1));

    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'CompSub', '', 0, 0);
    CompSub = str2double((cell_.Cell_line_1));

    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'CompMooring', '', 0, 0);
    CompMooring = str2double((cell_.Cell_line_1));

    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'CompIce', '', 0, 0);
    CompIce = str2double((cell_.Cell_line_1));

    [ ~, cell_ ] = ReadData_v3_2(full_FAST_FstFile_modified,'MHK', '', 0, 0);
     MHK = str2double((cell_.Cell_line_1));

    fprintf('---- Number of Nodes in the blade %d with %d Output Node(s) extracted (in AeroDyn15 file) : [%d] \n', NumBlNds, NBlOuts, NodeLift_Index(1) ); 
    fprintf('(WARNING : current nb of output nodes is limited to ''1'' (=NodeLift_Index_cntrl) due to the restricted AeroDyn15 file modification procedure) \n');
   
    %fprintf('------------------------------------------------------------------- \n');

    fprintf('--------- Current module configuration \n');
    
    fprintf('CompElast = %d \n', CompElast);
    
    fprintf('CompInflow = %d \n', CompInflow);
    
    fprintf('CompAero = %d \n', CompAero);
    
    fprintf('CompServo = %d \n', CompServo);
    
    fprintf('CompHydro = %d \n', CompHydro);
    
    fprintf('CompSub = %d \n', CompSub);
    
    fprintf('CompMooring = %d \n', CompMooring);
    
    fprintf('CompIce = %d \n', CompIce);
    
    fprintf('MHK = %d \n', MHK);
    
    clear cell_

    % Important to check if the correct MODIFIED FILES ARE DECLARED IN THE
    % FST FILE

    % b_ElastoDyn -> check of '_ElastoDyn' format
    % b_InflowFile -> check of '_InflowFile' format
    % b_CompAero -> check of '_AeroDyn15' format
    % b_CompServo -> check of 'ServoFile' format

    fprintf('\n --------- External Input parameters in the SLX file \n')
        
    fprintf('GenTorque = %f \n', GenTorque);
    fprintf('ElectTorque = %f \n', ElectTorque);
    
    fprintf('YawPosition = %f \n', YawPosition);
    fprintf('YawRate = %f \n', YawRate);
    fprintf('ShaftBreaking = %f \n', ShaftBreaking);
   

    if ( b_ElastoDyn && b_InflowFile && b_CompAero && b_CompServo )

        fprintf('\n --------- INPUT FILE CHECKING --------- \n\n');

%        fprintf('Found %s -> copied to %s ! \n',  AeroDyn15_Blade, AeroDyn15_Blade_modified);
        fprintf('Copied %s -> %s ! \n',  ServoDyn, ServoDyn_modified);
        fprintf('Copied %s -> %s ! \n',  AeroDyn15, AeroDyn15_modified);
        fprintf('Copied %s -> %s ! \n',  ElastoDyn, ElastoDyn_modified);
        fprintf('Copied %s -> %s ! \n',  FAST_FstFile, FAST_FstFile_modified);

        FAST_InputFileName = full_FAST_FstFile_modified;
     
        fprintf('======================= \n')
        fprintf('Using FAST InputFileName : %s \n', FAST_InputFileName)
        fprintf('======================= \n')

        fprintf('\n \n - - - OK with the modified files: proceed now with the simulation settings... \n \n')
        pause(2)

    else

        fprintf('Problem with the modified files: \n');
        fprintf('check that all sub-files *.dat are preceded with ''_'' in the fst file - Abort the program ! \n');
        b_ElastoDyn
        b_InflowFile
        b_CompAero
        b_CompServo

         pause
    end

    full_FAST_FstFile = full_FAST_FstFile_modified;
    full_AeroDyn15 = full_AeroDyn15_modified;
    full_ElastoDyn = full_ElastoDyn_modified;
 %   full_AeroDyn15_Blade = full_AeroDyn15_Blade_modified;
    full_ServoDyn = full_ServoDyn_modified;
    full_InFlow = full_InFlow_modified;
    
    fprintf('============== END OF THE PARAMETERS SETTINGS ============== \n');

%    pa

 %   return

