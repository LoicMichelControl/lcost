    
    %new in v141 : Post-processing data using vectorized cells
    
    uu = 1;
    clear Data_vec Time_vec_sampled Index_vec_Sample Data_vec
    
    Time_ = Time_vec_struct.time;
    
    % store every variable name from the Workspace
    CellWorkspace = who();
    
    %% UNDERSAMPLING NOT OK !!!!!!!!!!!!!!!!!!!!!!!
    
    Results.Time = Time_;
    
    plot_cnt = 0;
    
    fprintf('\n --------------------------------------------------\n')
    fprintf('Available output Slx variables (from the workspace): \n ');
    
    if ( SelectTrajectoryComputation > 0 && ComputeSurface > 0)
    
        fprintf('Warning: no save of the TimeArray variables (set SelectTrajectoryComputation = 0 and ComputeSurface > 0)... \n')
    
    end
    
    %ListIndex = [];
    
    ttt = 1;
    for ii = 1:length( CellWorkspace )
    
    
        % List of _index variables from the config file
    
        le_CellWorkspace = length( CellWorkspace{ii} );
    
    
        if ( le_CellWorkspace >= 7)
    
            str_CellWorkspace = cell2mat(CellWorkspace(ii));
    
            if ( strcmp( str_CellWorkspace(le_CellWorkspace-5:le_CellWorkspace), '_index'))
    
                ListIndex(ttt).name = str_CellWorkspace; %(1:le_CellWorkspace-6);
    
                ttt = ttt + 1;
            end
    
        end
    
    
    
        if ( length(CellWorkspace{ii}) >= 5 )
    
            if ( strcmp( CellWorkspace{ii}( length(CellWorkspace{ii} )-3:length(CellWorkspace{ii} ) ), '_out') )
    
    
                if ( debugMode == 1 )
                    CellWorkspace(ii)
                end
    
                Vec_Data_single_dim = -99;
    
                % For debug
                if ( isa(eval(cell2mat(CellWorkspace(ii))),'timeseries') && debugMode == 1)
                    fprintf('timeseries');
                end
    
                if isa(eval(cell2mat(CellWorkspace(ii))),'timeseries')
    
                    Data = eval(cell2mat(CellWorkspace(ii)));
    
                    Data_vec = Data.Data;
    
                else
    
                    Data_vec = eval(CellWorkspace{ii});
    
                end
    
                % The problem is that 'Data_vec' seems to be of
                % dimension 3! The correct 1D assignation depends on the "rank"
                % that is determined by the size
    
                % Warning size() gives an 'infinite' vector [1, 1, 1, 1 ...] for
                % the 'sx' association
                [s_1, s_2, s_3] = size( Data_vec );
    
    
                % Check which dimension is 'enabled'
                id = find ( [s_1, s_2, s_3] > 1 );
    
    
                % Case of TimeTable -- new in v1.5.0 -> allows recording range of data for the lift
    
                if istimetable(Data_vec) == 1
    
                    if ( SelectTrajectoryComputation == 0)
    
                        for ind_ = 1 : max( size(Data_vec) )
    
                            Data_vec_cell = Data_vec(ind_,:);
                            Data_vec_cell2 = Data_vec_cell{1,1};
                            Data_vec_array = Data_vec_cell2{1,1};
    
                            ResultsLiftdata(ind_).( CellWorkspace{ii} ) = Data_vec_array;
                        end
    
                        % Indicate the length of the vector 'Data_vec_array'
                        ResultsLiftdata(ind_+1).( CellWorkspace{ii} ) = max( size(Data_vec ) );
    
                        RecordedCell = CellWorkspace{ii};
    
                        fprintf('[Timetable: %s] \n', RecordedCell )
    
                    end
    
    
                else
    
                    % Case of a 1D vector of output data -- new in v1.5.0: excludes
                    % 'OutputChannels' variable that is processed directly in another
                    % switching condition
    
                    if isempty( id ) == 0 && length(id) == 1 && ~strcmp(CellWorkspace{ii},'OutputChannels')
    
                        RecordedCell = "";
    
                        switch id
    
                            case 1
    
                                if ( length( Data_vec(:,1,1) ) == length(Time_) )
    
                                    % Read the s_1 dimension
                                    for oo = 1:length( Data_vec(:,1,1) )
                                        Vec_Data_single_dim(oo) = Data_vec(oo,1,1);
                                    end
    
                                    Results.( CellWorkspace{ii} ) = Vec_Data_single_dim;
    
                                    RecordedCell = CellWorkspace{ii};
    
                                    % For debug
                                    if ( debugMode == 1 )
                                        fprintf('Case 1 \n')
                                    end
    
                                end
    
                            case 2
    
                                if ( length( Data_vec(1,:,1) ) == length(Time_) )
    
                                    % Read the s_2 dimension
                                    for oo = 1:length( Data_vec(1,:,1) )
                                        Vec_Data_single_dim(oo) = Data_vec(1,oo,1);
                                    end
    
                                    Results.(CellWorkspace{ii} ) = Vec_Data_single_dim;
    
                                    RecordedCell = CellWorkspace{ii};
    
                                    % For debug
                                    if ( debugMode == 1 )
                                        fprintf('Case 2 \n')
                                    end
                                end
    
                            case 3
    
                                if ( length( Data_vec(1,1,:) ) == length(Time_) )
    
                                    % Read the s_3 dimension
    
                                    for oo = 1:length( Data_vec(1,1,:) )
                                        Vec_Data_single_dim(oo) = Data_vec(1,1,oo);
                                    end
    
                                    Results.( CellWorkspace{ii} ) = Vec_Data_single_dim;
    
                                    RecordedCell = CellWorkspace{ii};
    
                                    % For debug
                                    if ( debugMode == 1 )
                                        fprintf('Case 3 \n')
                                    end
                                end
    
                        end
    
                        % only for display purpse
                        if ( ~strcmp( RecordedCell, "") )
    
                            fprintf('[%s] ', RecordedCell )
                            plot_cnt = plot_cnt + 1;
    
                        end
    
                        if ( plot_cnt >= 5 )
                            fprintf('\n');
                            plot_cnt = 0;
    
                        end
    
                        % for debug
                        if ( length( Vec_Data_single_dim ) == length(Time_) )
                        end
    
                    else
    
    
                    end
    
                end
    
            end
    
        end
    
    end
    
    clear ttt
    
    fprintf('Done \n');
    
    % Read available output channels from the 'sum' file -> provides the range number
    
    % DisplayInfo -> TMax (allows displaying only if Tmax == 1 while configuring)
    
    % v3_2b & v4 deprecated -> switch to refreshed ExtractData_v1 ;)
    
    [ cp, cell_,  ExtractedDataSweeping, Listing,  SlxParameterRange, checkOL_init] = ExtractData_v1(checkOL_init, ListIndex, TMax, LCOS_rootFolder, path, full_FAST_OutputSum, '', '', 1, TMax);
    %    fprintf('\n ==== SLX intended channels / Internal variables ==== \n');
    
    % The 'SlxOutVarRange' variable defines the bounds of each channel for SLX.
    
    
    Results.TrajectoryReference = TrajectoryReference;

    Results.TrajectoryReference_IPC_1 = TrajectoryReference_IPC_1;
    Results.TrajectoryReference_IPC_2 = TrajectoryReference_IPC_2;
    Results.TrajectoryReference_IPC_3 = TrajectoryReference_IPC_3;
    
    clear Data Data_vec_cell Data_vec_cell2  Data_vec_array Data_vec  RecordedCell CellWorkspace
    
    
    % Cntrl
    % Cntrl.t_start_cntr_1 = t_start_cntr_1 ;
    % Cntrl.t_start_cntr_2 = t_start_cntr_2 ;
    % Cntrl.t_start_cntr_3 = t_start_cntr_3 ;
    %  Cntrl.multiple_pitch_control = multiple_pitch_control;
