    
    %%===========================================================================================
    %%
    %%
    %%  LCO/St - Lift Control OpenFAST & Stabilization / Plot Module - Dec 2023 - May 2025
    %%                                   v1.8.3
    %%            L. Michel (CN/LS2N UMR 6004 - 1 rue de la Noë, 44300 Nantes)
    %%
    %%
    %%===========================================================================================
    
    clear all
    close all
    clc
    
    mw5_case = 1;
    
    % A/ updated examples (v1.8.2)
    %
    % path = '../Examples/Lift_pitch_15d_18sto_MPPT/';
    %
    % path = '../Examples/Lift_pitch_15d_13sto_MPPT/';
    %
    % path = '../Examples/Lift_pitch_15d_sto13/';
    %
    % path = '../Examples/Lift_pitch_15d/';
    %
    % 
    % 
        
        %   path = '../Examples/B_Lift_1500/';

        %  path = '../Examples/C_Lift_2000/';

        %   path = '../Examples/D1_Lift_1500_sto13/';

        %   path = '../Examples/D2_Lift_1500_sto12/';

        %  path = '../Examples/E1_Lift_2000_sto13/';

        %   path = '../Examples/E2_Lift_2000_sto12/';

        %  path = '../Examples/F1_Lift_sto13_MPPT/';

           path = '../Examples/F2_Lift_sto14_MPPT/';

    
    % B/ old simulation cases (v1.8.0)
    %
    % path = '../Examples/Lift_1/'; % Example of closed-loop / lift control #1
    
    % path = '../Examples/Lift_2/'; % Example of closed-loop / lift control #2
    
    % path = '../Examples/RBM_1/'; % Example of closed-loop / RBM control #1
    
    % path = '../Examples/RBM_2/'; % Example of closed-loop / RBM control #2
    
    % path = '../Examples/LiftIncremental_1/'; % Example of closed-loop / lift control - step-up #1
    
    % path = '../Examples/LiftIncremental_2/'; % Example of closed-loop / lift control - step-down #2
    
    % path = '../Examples/IPC_control/'; % Example of closed-loop / lift control - IPC mode
    
    
    Start_time_plotting = 500;
    lift_seg = 0.96e5;
    
    %==============================================
    %==============================================
    %==============================================
    ver_ = 183;
    LCOS_rootFolder = pwd;
    ResultFoundFlag = 1;
    
    fprintf('\n\n === LCO/St - Lift Control OpenFAST & Stabilization / Plot Module - v1.8.3 (May 2025) === \n\n')
    fprintf('L. Michel (CN/LS2N UMR 6004) \n');
    
    % Check if the result file exists
    cd(path)
    ResultFound = dir('*_results.mat');
    
    if ( isempty(ResultFound) == 0 )
        fprintf('Found %s... \n',  ResultFound.name)
    
        for yy = 1:length( ResultFound )
            Result_read(yy,:) = ResultFound(yy).name;
        end

    else
    
        % fprintf('No result-mat file found... checking if generator-mat exists... \n')
        %
        % ResultFoundFlag = 0; % to avoid displaying control param
        %
        %      ResultFound = dir('*_generator.mat');
        %
        %      if ( isempty(ResultFound) == 0 )
        %     fprintf('Found %s... \n',  ResultFound.name)
        %     save_generator = ResultFound.name;
        %      else
        %          fprintf('No file found ! \n')
        %          fprintf('Abort ! \n')
        %          pa
        %      end
    
        fprintf('No file found ! \n')
        fprintf('Abort ! \n')
    
    end
    
    if ( isempty( ResultFound ) == 0 )
    
        OpenLoopCalibrationMode = 0;
    
        InputFound = dir('*.m');
    
        InputFound_name = InputFound.name;
    
        fileInput_to_open = [path, InputFound_name];
    
        fprintf('\n\n Reading Input file %s in "%s" ... \n\n\n', InputFound.name, path)
    
        InputName = InputFound_name(1:length(InputFound_name)-2);
    
        eval(InputName)
    
    
        % Load the result file
        for yy = 1:length( ResultFound )
            R1(yy) = load(Result_read(yy,:));
    
    
            fprintf('========= Parameters for the #%d index:', yy)
            % Display
            R1(yy).Param
    
            R1(yy).Cntrl
    
        end
    
        cd(LCOS_rootFolder)
    
    
        result_to_plot = input('Please select which résult to plot? (default "1") [extra plot will plot all]? \n');
    
        if isempty(result_to_plot) == 1
            result_to_plot = 1;
        end
    
    
        fprintf('Checking... \n');
        pause(5)
    
        beg = Start_time_plotting;
        wind_speed_x = R1(result_to_plot).Param.wind_speed_x;
        save_fig = 1;
    
        save_project_name = save_project_name + '_';
    
        buf_wind  = sprintf('Node = %d -  inflow:[%f -> %f -> %f]', R1(result_to_plot).Config_.NodeLift_Index_cntrl, wind_speed_x(1), wind_speed_x(2), wind_speed_x(3) );
        title_graph = convertCharsToStrings( buf_wind );
    
        %%%%%%%%%%% plot module
        uu = 1;
        Results = R1(result_to_plot).Results;
    
        % Update to v2beta -> vA
        %%%%%%%%%%% plot module
    
        le_fy = length( Results(uu).Time );
    
        Plot_check = input('Do you want to save and erase the previous plots (default "0") ?');
    
    
        if (Plot_check > 0)
            save_plot = 1;
        else
            save_plot = 0;
        end
    
        ind_wind = 1;
        ModulePlot_vB;
    
        close all;
    
        % Additional plot (by reading the script whose name is assigned to
        % 'extra_plot')
        if (extra_plot == 1)
    
                    fprintf('\n\n Additional plots requested from %s ...', extra_plot);
    
                    ind_wind = 1;

                    ModulePlot_extra_vB;

                    % if ( length( ResultFound ) > 1)
                    % ModulePlot_extra_vB;
                    % else
                    % ModulePlot_extra;
                    % end
    
        end    
    
    
        %%%%%%%%%%%%%%%%%%%%%%%
    
        if ( save_plot == 0)
            pause(10)
        end
    
        cd(LCOS_rootFolder)
    
    end
    
    close all
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % End of the program
    %%%%%%%%%%%%%%%%%%%%%%%%%
