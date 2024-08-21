        
        % introduced in v1.2.1
        % revised in v1.3.0
        % revised in v1.4.1.b
        % revised in v1.5.0 (v3) -> includes management of the 'sum' output
        % revised again in v1.5.0 (v4) -> add the variables
        % revised in v1.7.2 -> simply remove the fileOutputChannelsNames
        % revised in v1.8 -> complete review and simplification of the code
        
        
        function [ line_nb, ExtractedData, ExtractedDataSweeping, ListingSum, SlxParameterRange, checkOL_init] = ExtractData_v1(checkOL_init, ListIndex, TMax, LCOS_rootFolder, path, filename, key, key_end, select_sum_output, DisplayInfo)
        
        line_nb = 0;
        %  line = 0;
        ExtractedData = -1;
        stop_read_line = 0;
        ListingSum = -1;
        start_reading = 2;
        line_sub_count = 1;
        
        SlxOutVarRange.name = [];
        SlxOutVarRange.number = [];
        
        %  ExtractedDataSweeping = []; wrong format !
        
        % check if the 'sum' file exists
        if ~exist(filename,'file')
        
            fprintf('\n\n The file <%s> does not exist ! \n', filename)
            fprintf(' Set ''True'' in the output SumPrint in the ''fst'' file ! \n')
            fprintf(' Abort the program \n')
            return
        
        else
        
            %   fprintf('Found %s ... \n', filename);
        
        end
        
        [fid,msg] = fopen(filename,'rt');
        
        % improve the line end detection (through a stop search)
        while(  stop_read_line == 0)
            line = fgetl(fid);
        
            if ( line == -1)
                stop_read_line = 1;
            end
        
            line_nb = line_nb + 1;
        
        end
        
        line_nb = line_nb - 1;
        
        fclose(fid);
        
        [fid,msg] = fopen(filename,'rt');
        
        %%%%%%%%%%%%%%
        
        % Extract Data from the input files or the sum file ( select_sum_output = 1 )
        if ( select_sum_output == 0)
        
        
            for tt = 1:line_nb
        
                tline = fgetl(fid);
        
                fseek(fid,ftell(fid),'bof');
                Cell_line = textscan(fid, '%s %s %s %s %s %s %s', 1);
        
                for index_cell = 2:5
        
                    if ( strcmp(key_end,'') && strcmp( key, cell2mat( Cell_line{index_cell} ) ) )
                        ExtractedData = {};
                        ExtractedData = struct('Cell_line_1', cell2mat( Cell_line{1} ), ...
                            'Cell_line_2', cell2mat( Cell_line{2} ), ...
                            'Cell_line_3', cell2mat( Cell_line{3} ), ...
                            'Cell_line_4', cell2mat( Cell_line{4} ), ...
                            'index_cell', index_cell );
                    end
        
                    % the goal is to list recursively keywords associated to their status :
                    % first : make a cell capture if '-' is detected
                    % sec.  : start counting if the first 'key' is captured
                    % third : stop counting if the final 'key_final' is reached
        
                    if ( ~strcmp(key_end,'') && start_reading > 0)
        
                        if ( strcmp( '-', cell2mat( Cell_line{index_cell} ) )  || start_reading == 1 )
        
                            if ( strcmp( key, cell2mat( Cell_line{index_cell-1} ) ) || start_reading == 1 )
        
                                ExtractedDataSweeping(line_sub_count) = struct('Cell_line_1', cell2mat( Cell_line{1} ), ...
                                    'Cell_line_2', cell2mat( Cell_line{2} ), ...
                                    'Cell_line_3', cell2mat( Cell_line{3} ), ...
                                    'Cell_line_4', cell2mat( Cell_line{4} ), ...
                                    'index_cell', index_cell );
        
                                % fprintf("=====================")
                                %
                                % cell2mat( Cell_line{1} )
                                % cell2mat( Cell_line{2} )
                                % cell2mat( Cell_line{3} )
                                % cell2mat( Cell_line{4} )
                                % fprintf("=====================")
        
                                start_reading = 1;
        
                            end
        
                            %pause
        
                            if ( strcmp( key_end, cell2mat( Cell_line{index_cell} ) ) )
        
                                start_reading = 0;
        
                            end
        
                        end
        
                    else
        
                        %   ExtractedDataSweeping = -1; % not used since it
                        %   creates conflicts
        
                    end
        
                    if ( index_cell == 5 && start_reading == 1 )
                        line_sub_count = line_sub_count + 1;
                    end
                end
        
            end
        
        else
        
            ExtractedDataSweeping = -1;
            StartExtracting = 0;
        
            % Read available output channels from the 'sum' file ->
            % 'ConfigOutputChannels' must be present in the directory
        
      %      cd(path)
      %      SelectTrajectoryComputation = -1;
      %      OpenLoopCalibrationMode = -1;

     %       input_file;
     %       cd(LCOS_rootFolder)
        
            ListingSum = {};
            RunListingSumParse = 0;
            cntLine = 0;
        
            if ( DisplayInfo == 1)
                fprintf('\n -------------------------------------------------------- \n')
                fprintf('Reading Channels (from the "sum" file)...   \n');
            end
        
            SlxOutVarRangeId = 0;
            index_node = 0;
            index_channel = 0;
        
            for tt = 1:line_nb
        
                tline = fgetl(fid);
        
                % read every line of the 'sum' file
                fseek(fid,ftell(fid),'bof');
                Cell_line = textscan(fid, '%s %s %s %s %s %s %s', 1);
        
                if  RunListingSumParse == 1
        
                    if( (strcmp(cell2mat( Cell_line{1} ), '1') & strcmp(cell2mat( Cell_line{2} ), 'Time') ) ||  StartExtracting == 1)
        
                        StartExtracting = 1;
        
                        cntLine = cntLine + 1;
        
                        % fprintf('========== \n')
                        % Cell_line{1}
                        % Cell_line{2}
        
                        if isempty( Cell_line{1} ) == 0
        
                            ListingSum(cntLine).name = cell2mat( Cell_line{2} ); % channel name
                            ListingSum(cntLine).number = str2num(cell2mat( Cell_line{1} )); % channel #
        
                            % If a vectorized output param is present (with the
                            % prefix 'AB1'),
                            % 1/ check which param it is compared with the
                            % OutputChannelsNames -> index_channel
                            % 2/ Save the channel info (number & name) into the
                            % VectorChannel & VectorChannelName incremented by index_node
        
                            if ( strcmp(ListingSum(cntLine).name(1:3), 'AB1') )
        
                                index_node = index_node + 1;
        
                                % Self extraction of the channel name: the
                                % nomenclature is AB1N001XX for the first
                                % channel of evey vectorized node -> simply
                                % extract the (8:end) chars.
                                if ( strcmp(ListingSum(cntLine).name(1:7), 'AB1N001')  )
                                    index_channel = index_channel + 1;
                                    SaveVectorizedListingSumName =  (ListingSum(cntLine).name(8:end));
                                    VectorChannelName( index_channel, index_node).name = SaveVectorizedListingSumName; %ListingSum(cntLine).name(8:end); %SaveVectorizedListingSumName; %OutputChannelsNames( index_channel );

                                end

                                 VectorChannel( index_channel, index_node) = ListingSum(cntLine).number;
                                

                            else
        
                                if ( strcmp(ListingSum(cntLine).name(1:2), 'AB') == 0)
        
                                    if strcmp(cell2mat( Cell_line{3} ), 'INVALID')
                                        ListingSum(cntLine).invalid = 1; % not used
                                        fprintf('[%s -> %d] (INVALID) \n', ListingSum(cntLine).name , ListingSum(cntLine).number )
                                    else
                                        ListingSum(cntLine).invalid = 0; % not used
        
                                        % ASSIGN TO THE INPUT INDEX
                                        strListingSumName = [ListingSum(cntLine).name, '_index'];
                                        assignin('base',strListingSumName, ListingSum(cntLine).number)
        
                                        fprintf('[%s -> %s = %d] \n', ListingSum(cntLine).name , strListingSumName, ListingSum(cntLine).number )
                                    end
        
                                end
        
                            end
        
                        end
        
                    end
        
                end
        
                % Start Parsing from 'Time' line (maybe not necessary)
                if strcmp('Time', cell2mat( Cell_line{2} ) )
        
                    ListingSum = struct('number', cell2mat( Cell_line{1} ), ...
                        'name', cell2mat( Cell_line{2}), ...
                        'index_outfile', -1);
        
                    RunListingSumParse = 1;
                end
        
            end
        
            for ( SlxOutVarRangeId = 1:length( VectorChannel(:,1) ) )
        
                index_ = find( VectorChannel(SlxOutVarRangeId,:) > 0);
        
                if ( isempty(index_) == 0)
        
                    SlxParameterRange(SlxOutVarRangeId).name =  VectorChannelName( SlxOutVarRangeId, min(index_) ).name;
                    SlxParameterRange(SlxOutVarRangeId).number = [VectorChannel(SlxOutVarRangeId, min(index_) ), VectorChannel(SlxOutVarRangeId, max(index_) )];
        
                    % ASSIGN TO THE INDEX
                    SlxOutVarRange_1 = sprintf('SlxParameterRange_%d_A', SlxOutVarRangeId );
                    SlxOutVarRange_2 = sprintf('SlxParameterRange_%d_B', SlxOutVarRangeId );
        
                    assignin('base', SlxOutVarRange_1, VectorChannel(SlxOutVarRangeId, min(index_) ) );
                    assignin('base', SlxOutVarRange_2, VectorChannel(SlxOutVarRangeId, max(index_) )  );
        
                    % Display channel name and channel #range
                    if ( DisplayInfo == 1)
                        fprintf('[%s -> (%s = %d):(%s = %d)] \n',  SlxParameterRange(SlxOutVarRangeId).name, SlxOutVarRange_1, VectorChannel(SlxOutVarRangeId, min(index_) ), SlxOutVarRange_2, VectorChannel(SlxOutVarRangeId, max(index_) ) );
                    end
        
                else
        
                    fprintf('WARNING : An output parameter is missing from the ConfigFile ! \n')
        
                end
        
            end
        
            % Check the full 'sum' list and verify if any Simulink
            % 'index'variable (declared in openFASTinit.m ) are not present in the 'sum' list indicated that
            % SLX index are missing!
            BlackListElement = [];
            ttt = 0;
            tttt = 0;
            for ( i_Sum = 1 : length( ListingSum ) )
        
                Verrou_ListElement = 0;
                for ( i_Index = 1 : length( ListIndex ) )
        
                    if ( strcmp( ListIndex(i_Index).name, [ListingSum(i_Sum).name, '_index'] ) || Verrou_ListElement == 1 )
        
                        Verrou_ListElement = 1;
        
                    end
        
                end
        
                str_ListingSum = ListingSum(i_Sum).name;
        
                if ( Verrou_ListElement == 0 && strcmp( str_ListingSum(1:2), 'AB') == 0 && strcmp(str_ListingSum, 'Time') == 0 )
        
                    ttt = ttt + 1;
                    % Outputs index that are missing in Simulink
                    NotPresentSimulink(ttt).name = ListingSum(i_Sum).name;
                end
                
                if ( Verrou_ListElement == 1 && strcmp( str_ListingSum(1:2), 'AB') == 0 && strcmp(str_ListingSum, 'Time') == 0)
        
                    % Outputs index that are present in Simulink
                    tttt = tttt + 1;
                    OKListElement(tttt).name = ListingSum(i_Sum).name;
        
                end
        
            end
        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
            ttt = 0;
            tttt = 0;
            for ( i_Index = 1 : length( ListIndex ) )
        
                Verrou_ListElement = 0;
        
                for ( i_OK = 1 : length( OKListElement ) )
        
                    if ( strcmp( ListIndex(i_Index).name, [OKListElement(i_OK).name, '_index'] ) || Verrou_ListElement == 1 )
        
                        Verrou_ListElement = 1;
        
                    end
        
                end
        
                % That's the difference between the SLX index list (declared in openFASTinit.m ) and
                % the 'sum' list -> gives the index that have not been
                % requested in the 'sum' file.
                if ( Verrou_ListElement == 0 )
        
                    ttt = ttt + 1;
                    % Not requested in the 'sum' file
                    NotAssignedSimulink(ttt).name = ListIndex(i_Index).name;
                end
        
            end

            if ( checkOL_init == 1)
        
                fprintf('\n\n ------------ WARNING: the following outputs (from the ''sum'' file) HAVE NOT been assigned in SLX: \n');
            
                cnt_plot = 0;
                for yyy = 1:length( NotPresentSimulink )
            
                    fprintf('[%s]', NotPresentSimulink(yyy).name);
            
                    if ( cnt_plot <= 6)
                        fprintf('\t');
                        cnt_plot = cnt_plot + 1;
                    else
                        fprintf('\n');
                        cnt_plot = 0;
                    end
                end
            
            
                fprintf('\n\n ------------ WARNING: the following outputs (may contain extra output) have not been requested in the ''sum'' file: \n');
            
                cnt_plot = 0;
                for yyy = 1:length( NotAssignedSimulink )
            
                    fprintf('[%s]', NotAssignedSimulink(yyy).name);
            
                    if ( cnt_plot <= 6)
                        fprintf('\t');
                        cnt_plot = cnt_plot + 1;
                    else
                        fprintf('\n');
                        cnt_plot = 0;
                    end
                end

                checkOL_init = 0;
            end
        
        
            if ( DisplayInfo == 1)
                fprintf('\n\n Reading Done \n\n');
                % fprintf('\n -------------------------------------------------------- \n')
            end
        
        end
        
        fclose(fid);

