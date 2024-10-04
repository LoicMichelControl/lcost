    
    fprintf('\n\n ************ PLOTTING SECTION ************ \n\n')
    
    if ( save_plot == 1 )
    
        file_name_0 = save_project_name + '_plot_0';
        file_name_1 = save_project_name + '_plot_1';
        file_name_2 = save_project_name + '_plot_2';
        file_name_3 = save_project_name + '_plot_3';
        file_name_4 = save_project_name + '_plot_4';
        file_name_5 = save_project_name + '_plot_5';
        file_name_5b = save_project_name + '_plot_5b';
        file_name_6 = save_project_name + '_plot_6';
        file_name_7 = save_project_name + '_plot_7';
        file_name_8 = save_project_name + '_plot_8';
        file_name_9 = save_project_name + '_plot_9';
        file_name_10 = save_project_name + '_plot_10';
        file_name_11 = save_project_name + '_plot_11';
    
        file_name_0_png = file_name_0 + '_results.png';
        file_name_1_png = file_name_1 + '_results.png';
        file_name_2_png = file_name_2 + '_results.png';
        file_name_3_png = file_name_3 + '_results.png';
        file_name_4_png = file_name_4 + '_results.png';
        file_name_5_png = file_name_5 + '_results.png';
        file_name_5b_png = file_name_5b + '_results.png';
        file_name_6_png = file_name_6 + '_results.png';
        file_name_7_png = file_name_7 + '_results.png';
        file_name_8_png = file_name_8 + '_results.png';
        file_name_9_png = file_name_9 + '_results.png';
        file_name_10_png = file_name_10 + '_results.png';
        file_name_11_png = file_name_11 + '_results.png';

                file_name_0_fig = file_name_0 + '_results.fig';
                file_name_1_fig = file_name_1 + '_results.fig';
                file_name_2_fig = file_name_2 + '_results.fig';
                file_name_3_fig = file_name_3 + '_results.fig';
                file_name_4_fig = file_name_4 + '_results.fig';
                file_name_5_fig = file_name_5 + '_results.fig';
                file_name_5b_fig = file_name_5b + '_results.fig';
                file_name_6_fig = file_name_6 + '_results.fig';
                file_name_7_fig = file_name_7 + '_results.fig';
                file_name_8_fig = file_name_8 + '_results.fig';
                file_name_9_fig = file_name_9 + '_results.fig';
                file_name_10_fig = file_name_10 + '_results.fig';
                file_name_11_fig = file_name_11 + '_results.fig';
      
    end
    
    cd(path)
    
    
    
    length_ClosedLoop = length( Results(uu).Time(beg:end) );
    
    
    if ( plot_1 == 1)  % plot 1 - Wind1VelX + pitch angle #1 + Traj. Profile
    
        fprintf('plot 1 - Wind1VelX + pitch angle #1 + trajectory Profile \n')
    
        figure(1)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(3,1,1)
        plot ( Results(uu).Time(beg:end), Results(uu).Wind1VelX_out(beg:end), 'LineWidth',2 )
        grid on
        ylabel('Wind1VelX [m/s]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
       % title(title_graph)
        subplot(3,1,2)
        plot ( Results(uu).Time(beg:end), Results(uu).BldPitch1_out(beg:end), '--r', 'LineWidth',2 )
        grid on
        ylabel('pitch angle #1 [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        subplot(3,1,3)
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), 'linewidth', 2)
        grid on
        xlabel('Time [sec]')
        ylabel('Internal Trajectory Profile')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        if (save_plot == 1)
            saveas(gcf,file_name_1_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_1_fig)
            end
        end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( plot_2 == 1)  % plot 2 - GenPwr + Gen Tq + GenSpeed
    
        fprintf('plot 2 - GenPwr + Gen Tq + RotSpeed \n')
    
        figure(2)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(3,1,1)
        plot ( Results(uu).Time(beg:end), Results(uu).GenPwr_out(beg:end), 'LineWidth',2 )
        grid on
        ylabel('GenPwr [kW]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
      %  title(title_graph)
        subplot(3,1,2)
        plot ( Results(uu).Time(beg:end), Results(uu).GenTq_out(beg:end), 'LineWidth',2 )
        grid on
        ylabel('GenTq [kN-m]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        subplot(3,1,3)
        plot ( Results(uu).Time(beg:end), Results(uu).RotSpeed_out(beg:end), 'LineWidth',2 )
        grid on
        xlabel('Time [sec]')
        ylabel('RotSpeed [rpm]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
    
        if (save_plot == 1)
            saveas(gcf,file_name_2_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_2_fig)
            end
        end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( plot_3 == 1)  % plot 3 - Azimuth + Ptfm angles
    
        fprintf('plot 3 - Azimuth + Ptfm angle \n')
    
        figure(3)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,1,1)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).Azimuth_out(beg:end), 'LineWidth',2 )
        grid on
        ylabel('Azimuth [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
      %  title(title_graph)
        subplot(2,1,2)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).PtfmRoll_out(beg:end), 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).PtfmPitch_out(beg:end),  'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).PtfmYaw_out(beg:end), 'LineWidth',2 )
        grid on
        xlabel('Time [sec]')
        ylabel('Ptfm (Roll + Pitch + Yaw) angles [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
    
        if (save_plot == 1)
            saveas(gcf,file_name_3_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_3_fig)
            end
        end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( plot_4 == 1 ) % plot 4 - Fl#1 + pitch angle
    
        fprintf('plot 4 - Fl#1 + pitch angle #1 \n')
    
        figure(4)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,1,1)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).B1N1Fl_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), '--r' , 'LineWidth',2 )
        grid on
        ylabel('Fl#1 [N/m]')
        legend('simulation', 'reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
      %  title(title_graph)
        subplot(2,1,2)
        plot ( Results(uu).Time(beg:end), Results(uu).BldPitch1_out(beg:end), 'LineWidth',2 )
        grid on
        xlabel('Time [sec]')
        ylabel('pitch angle #1 [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
    
        if (save_plot == 1)
            saveas(gcf,file_name_4_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_4_fig)
            end
        end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    if ( plot_5 == 1 ) % plot 5 - Fl#1 - Fl#2 - Fl#3
    
        fprintf('plot 5 - Fl#1 - Fl#2 - Fl#3  \n')
    
        figure(5)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(3,1,1)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).B1N1Fl_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), '--r' , 'LineWidth',2 )
        grid on
        grid on
        ylabel('Fl#1 [N/m]')
        legend('simulation', 'reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
     %   title(title_graph)
        subplot(3,1,2)
        hold on
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).B2N1Fl_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), '--r' , 'LineWidth',2 )
        grid on
        grid on
        ylabel('Fl#2 [N/m]')
        legend('simulation', 'reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        subplot(3,1,3)
        hold on
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).B3N1Fl_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), '--r' , 'LineWidth',2 )
        grid on
        xlabel('Time [sec]')
        ylabel('Fl#3 [N/m]')
        legend('simulation', 'reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        if (save_plot == 1)
            saveas(gcf,file_name_5_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_5_fig)
            end
        end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( plot_5b == 1 ) % plot 5b - Fl#1 + Fl#2 + Fl#3
    
        fprintf('plot 5b - Fl#1 + Fl#2 + Fl#3  \n')
    
        le_fy = length( Results(uu).Time );
        lift_seg = 2000;
    
    
        figure(55)
        figure('units','normalized','outerposition',[0 0 1 1])
        hold on
        plot ( Results(uu).Time(le_fy-lift_seg:le_fy), Results(uu).B1N1Fl_out(le_fy-lift_seg:le_fy), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(le_fy-lift_seg:le_fy), Results(uu).B2N1Fl_out(le_fy-lift_seg:le_fy), 'r', 'LineWidth',2 )
        plot ( Results(uu).Time(le_fy-lift_seg:le_fy), Results(uu).B3N1Fl_out(le_fy-lift_seg:le_fy), 'g', 'LineWidth',2 )
        legend('Fl#1','Fl#2','Fl#3')
        xlabel('Time [sec]')
        ylabel('Fl [N/m]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        if (save_plot == 1)
            saveas(gcf,file_name_5b_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_5b_fig)
            end
        end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( plot_6 == 1 ) % plot 6 - AVG Fl#1 + pitch angle
    
        fprintf('plot 6 - AVG Fl#1 + pitch angle #1 \n')
    
        figure(6)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,1,1)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).Avg_B1N1Fl_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), '--r' , 'LineWidth',2 )        
        grid on
        grid on
        ylabel('AVG Fl#1')
        legend('simulation', 'reference (base)', 'auto ref.');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
     %   title(title_graph)
        subplot(2,1,2)
        plot ( Results(uu).Time(beg:end), Results(uu).BldPitch1_out(beg:end), 'LineWidth',2 )
        grid on
        xlabel('Time [sec]')
        ylabel('pitch angle #1 [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        if (save_plot == 1)
            saveas(gcf,file_name_6_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_6_fig)
            end
        end
    
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( plot_7 == 1 ) % plot 7 - pitch angle #1 - #2 - #3
    
        fprintf('plot 7 - pitch angle #1 - #2 - #3 \n')
    
        figure(7)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(3,1,1)
        plot ( Results(uu).Time(beg:end), Results(uu).BldPitch1_out(beg:end), 'LineWidth',2 )
        grid on
        ylabel('pitch angle #1 [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
     %   title(title_graph)
        subplot(3,1,2)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).BldPitch2_out(beg:end), 'LineWidth',2 )
        grid on
        ylabel('pitch angle #2 [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        subplot(3,1,3)
        plot ( Results(uu).Time(beg:end), Results(uu).BldPitch3_out(beg:end), 'LineWidth',2 )
        grid on
        xlabel('Time [sec]')
        ylabel('pitch angle #3 [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
    
        if (save_plot == 1)
            saveas(gcf,file_name_7_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_7_fig)
            end
        end
    
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( plot_8 == 1 ) % plot 8 - RootMyb #1 + blade pitch
    
        fprintf('plot 8 - RootMyb #1 + pitch angle #1 \n')
    
        figure(8)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,1,1)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).RootMyb1_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), '--r' , 'LineWidth',2 )
        grid on
        ylabel('RootMyb #1 [kN-m]')
        legend('simulation', 'reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
      %  title(title_graph)
        subplot(2,1,2)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).BldPitch1_out(beg:end), 'LineWidth',2 )
        grid on
        xlabel('Time [sec]')
        ylabel('pitch angle #1 [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
    
        if (save_plot == 1)
            saveas(gcf,file_name_8_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_8_fig)
            end
        end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( plot_9 == 1 ) % plot 9 - RootMyb #1 - RootMyb #2 - RootMyb #3 
    
        fprintf('plot 9 - RootMyb #1 - RootMyb #2 - RootMyb #3  \n')
    
        figure(9)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(3,1,1)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).RootMyb1_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), '--r' , 'LineWidth',2 )
        grid on
        ylabel('RootMyb #1 [kN-m]')
        legend('simulation','reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
     %   title(title_graph)
        subplot(3,1,2)
        hold on
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).RootMyb2_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), '--r' , 'LineWidth',2 )
        grid on
        ylabel('RootMyb #2 [kN-m]')
        legend('simulation','reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        subplot(3,1,3)
        hold on
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).RootMyb3_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference(beg:end), '--r' , 'LineWidth',2 )
        grid on
        xlabel('Time [sec]')
        ylabel('RootMyb #3 [kN-m]')
        legend('simulation','reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
    
        if (save_plot == 1)
            saveas(gcf,file_name_9_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_9_fig)
            end
        end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( plot_10  == 1 & IPC_mode == 1) % plot 10 - AVG Fl#1 - AVG Fl#2 - AVG Fl#3
    
        fprintf('plot 10 - AVG Fl#1 - AVG Fl#2 - AVG Fl#3  \n')
    
        figure(10)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(3,1,1)
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).Avg_B1N1Fl_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference_IPC_1(beg:end), '--r' , 'LineWidth',2 )
        grid on
        grid on
        ylabel('AVG Fl#1')
        legend('simulation', 'reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
     %   title(title_graph)
        subplot(3,1,2)
        hold on
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).Avg_B2N1Fl_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference_IPC_2(beg:end), '--r' , 'LineWidth',2 )
        grid on
        grid on
        ylabel('AVG Fl#2')
        legend('simulation', 'reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        subplot(3,1,3)
        hold on
        hold on
        plot ( Results(uu).Time(beg:end), Results(uu).Avg_B2N1Fl_out(beg:end), 'b', 'LineWidth',2 )
        plot ( Results(uu).Time(beg:end), Results(uu).TrajectoryReference_IPC_3(beg:end), '--r' , 'LineWidth',2 )
        grid on
        grid on
        xlabel('Time [sec]')
        ylabel('AVG Fl#3')
        legend('simulation', 'reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
        if (save_plot == 1)
            saveas(gcf,file_name_10_png)

            if ( save_fig == 1)
            saveas(gcf,file_name_10_fig)
            end
        end
    
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if ( exist('Cl_curve_Node','var') == 1 && exist('plot_11','var') == 1)

        if ( plot_11 == 1 )
    
            fprintf('plot 11 - Cl curves  \n')
    
            figure(3)
            figure('units','normalized','outerposition',[0 0 1 1])
            subplot(3,1,1)
            scatter( Results(uu).B1N1Alpha_out(beg:end), Results(uu).B1N1Cl_out(beg:end) , 'r')
            hold on
            plot( Cl_curve_Node([Cl_curve_min:Cl_curve_Max],1), Cl_curve_Node([Cl_curve_min:Cl_curve_Max],2), '--k', 'linewidth', 2)
            ylabel('Cl#1')
            set(gcf,'Color','w');
            set(gca,'FontSize',20);
            subplot(3,1,2)
            scatter( Results(uu).B1N1Alpha_out(beg:end), Results(uu).B2N1Cl_out(beg:end), 'b' )
            hold on
            plot( Cl_curve_Node([Cl_curve_min:Cl_curve_Max],1), Cl_curve_Node([Cl_curve_min:Cl_curve_Max],2), '--k', 'linewidth', 2)
            ylabel('Cl#2')
            set(gcf,'Color','w');
            set(gca,'FontSize',20);
            subplot(3,1,3)
            scatter( Results(uu).B1N1Alpha_out(beg:end), Results(uu).B3N1Cl_out(beg:end), 'g' )
            hold on
            plot( Cl_curve_Node([Cl_curve_min:Cl_curve_Max],1), Cl_curve_Node([Cl_curve_min:Cl_curve_Max],2), '--k', 'linewidth', 2)
            xlabel('Angle of Attack')
            ylabel('Cl#3')
            set(gcf,'Color','w');
            set(gca,'FontSize',20);
    
                if (save_plot == 1)
                saveas(gcf,file_name_11_png)

                    if ( save_fig == 1)
                    saveas(gcf,file_name_11_fig)
                    end
                end
    
        end
        
    end
    
    cd(LCOS_rootFolder)

