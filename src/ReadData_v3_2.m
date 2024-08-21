    
    % introduced in v1.2.1
    % revised in v1.3.0
    % revised in v1.4.1.b
    % revised in v1.5.0 (v3) -> includes management of the 'sum' output
    % revised again in v1.5.0 (v4) -> add the
    % variables
    
    function [ line_nb, ExtractedData, ExtractedDataSweeping, Listing, SlxOutVarRange] = ReadData_v3_2( filename, key, key_end, select_sum_output, DisplayInfo)
    
    line_nb = 0;
    %  line = 0;
    ExtractedData = -1;
    stop_read_line = 0;
    Listing = -1;
    start_reading = 2;
    line_sub_count = 1;

    SlxOutVarRange = -1;
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
    
        % Read available output channels from the 'sum' file ->
        % 'ConfigOutputChannels' must be present in the directory
    
        ConfigOutputChannels;
    
        Listing = {};
        RunListingParse = 0;
        cntLine = 0;
        plot_cnt = 0;
    
        if ( DisplayInfo == 1)
            fprintf('\n -------------------------------------------------------- \n')
            fprintf('Reading ''ConfigOutputChannels'' external vector config...   \n');
        end
    
        SlxOutVarRangeId = 0;
        for tt = 1:line_nb
    
            tline = fgetl(fid);
    
            % read every line of the 'sum' file
            fseek(fid,ftell(fid),'bof');
            Cell_line = textscan(fid, '%s %s %s %s %s %s %s', 1);
    
            if  RunListingParse == 1
    
    
                % Verify if a Channel is inside our list -> record the #channel
                if ( isempty(find( strcmp(cell2mat( Cell_line{2} ), OutputChannelsNames(:,1) ) ) ) == 0)
    
                    id = find( strcmp(cell2mat( Cell_line{2} ), OutputChannelsNames(:,1) ) );
    
                    cntLine = cntLine + 1;
    
                    Listing(cntLine).number = str2num(cell2mat( Cell_line{1} )); % channel #
                    Listing(cntLine).name = cell2mat( Cell_line{2} ); % channel name
                    
    
                    if ( OutputChannelsNames(id,2) == "n" )
    
                        % Display channel name and channel #
                        if ( DisplayInfo == 1)

                            if strcmp(cell2mat( Cell_line{3} ), 'INVALID')
                                Listing(cntLine).invalid = 1; % not used
                                fprintf('[%s -> %d] (INVALID)', Listing(cntLine).name , Listing(cntLine).number )
                            else
                                Listing(cntLine).invalid = 0; % not used
                                fprintf('[%s -> %d] ', Listing(cntLine).name , Listing(cntLine).number )
                            end



                        end
    
                    end
    
                    % Compute the range of variables : from 's' -> 'e'
                    if ( OutputChannelsNames(id,2) == "s" )
    
    
                        id_start = Listing(cntLine).number; % channel range start
    
                    end
    
                    if ( OutputChannelsNames(id,2) == "e" )
    
                        SlxOutVarRangeId = SlxOutVarRangeId + 1;
    
                        id_end = Listing(cntLine).number; % channel range end
    
                        SlxOutVarRange(SlxOutVarRangeId).name = Listing(cntLine).name;
                        SlxOutVarRange(SlxOutVarRangeId).number = [id_start,id_end];
    
                        clear id_start
                        clear id_end
    
                        % Display channel name and channel #range
                        if ( DisplayInfo == 1)
                            fprintf('[%s -> %d:%d] ',  Listing(cntLine).name, SlxOutVarRange(SlxOutVarRangeId).number(1), SlxOutVarRange(SlxOutVarRangeId).number(2) )
                        end
    
                    end
    
                    plot_cnt = plot_cnt + 1;
                end
    
            end
    
    
            if ( plot_cnt >= 5 && DisplayInfo == 1 )
    
                fprintf('\n');
    
                plot_cnt = 0;
    
            end
    
            % Start Parsing from 'Time' line
            if strcmp('Time', cell2mat( Cell_line{2} ) )
    
                Listing = struct('number', cell2mat( Cell_line{1} ), ...
                    'name', cell2mat( Cell_line{2}), ...
                    'index_outfile', -1);
    
                RunListingParse = 1;
            end
    
        end
    
        if ( DisplayInfo == 1)
            fprintf('Reading Done \n');
            fprintf('\n -------------------------------------------------------- \n')
        end
    
    end
    
    fclose(fid);

