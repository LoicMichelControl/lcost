    
    fprintf('\n\n ************ EXTRA PLOTTING SECTION ************ \n\n')
    
    ft_size = 40;
    
    Result_index_png = sprintf('_%d_results.png', ind_wind);
    
    Result_index_fig = sprintf('_%d_results.fig', ind_wind);
    
    
    file_name_0 = save_project_name + '_plot_0';
    file_name_1 = save_project_name + '_plot_1';
    file_name_2 = save_project_name + '_plot_2';
    file_name_3 = save_project_name + '_plot_3';
    file_name_4 = save_project_name + '_plot_4';
    file_name_5 = save_project_name + '_plot_5';
    file_name_5b = save_project_name + '_plot_5b';
    file_name_6 = save_project_name + '_plot_6';
    file_name_6b = save_project_name + '_plot_6b';
    file_name_6c = save_project_name + '_plot_6c';
    file_name_7 = save_project_name + '_plot_7';
    file_name_8 = save_project_name + '_plot_8';
    file_name_9 = save_project_name + '_plot_9';
    file_name_10 = save_project_name + '_plot_10';
    file_name_11 = save_project_name + '_plot_11';
    
    file_name_0_png = file_name_0 + Result_index_png;
    file_name_1_png = file_name_1 + Result_index_png;
    file_name_2_png = file_name_2 + Result_index_png;
    file_name_3_png = file_name_3 + Result_index_png;
    file_name_4_png = file_name_4 + Result_index_png;
    file_name_5_png = file_name_5 + Result_index_png;
    file_name_5b_png = file_name_5b + Result_index_png;
    file_name_6_png = file_name_6 + Result_index_png;
    file_name_6b_png = file_name_6b + Result_index_png;
    file_name_6c_png = file_name_6c + Result_index_png;
    file_name_7_png = file_name_7 + Result_index_png;
    file_name_8_png = file_name_8 + Result_index_png;
    file_name_9_png = file_name_9 + Result_index_png;
    file_name_10_png = file_name_10 + Result_index_png;
    file_name_11_png = file_name_11 + Result_index_png;
    
    file_name_0_fig = file_name_0 + Result_index_fig;
    file_name_1_fig = file_name_1 + Result_index_fig;
    file_name_2_fig = file_name_2 + Result_index_fig;
    file_name_3_fig = file_name_3 + Result_index_fig;
    file_name_4_fig = file_name_4 + Result_index_fig;
    file_name_5_fig = file_name_5 + Result_index_fig;
    file_name_5b_fig = file_name_5b + Result_index_fig;
    file_name_6_fig = file_name_6 + Result_index_fig;
    file_name_6b_fig = file_name_6b + Result_index_fig;
    file_name_6c_fig = file_name_6c + Result_index_fig;
    file_name_7_fig = file_name_7 + Result_index_fig;
    file_name_8_fig = file_name_8 + Result_index_fig;
    file_name_9_fig = file_name_9 + Result_index_fig;
    file_name_10_fig = file_name_10 + Result_index_fig;
    file_name_11_fig = file_name_11 + Result_index_fig;
    
    cd(path)
    mkdir results_extra
    cd ./results_extra
    
    delete *.png
    delete *.fig
    
    length_ClosedLoop = length( Results(uu).Time(beg:end) );
    
    % plot *** #1 - Wind1VelX (over 1200 s)
    
    
    if ( length( ResultFound ) > 1)
    
        fprintf('plot *** #1 - Wind1VelX_out (over 1200 s) \n')
    
        figure(10)
        plot ( R1(uu).Results.Time(le_fy-lift_seg:le_fy), R1(uu).Results.Wind1VelX_out(le_fy-lift_seg:le_fy), 'LineWidth',2 )
        grid on
        ylabel('Wind1VelX [m/s]')
        set(gcf,'Color','w');
        set(gca,'FontSize',ft_size);
    
        saveas(gcf,file_name_1_png)
        saveas(gcf,file_name_1_fig)
    
    
        %   this part concerns C_L and C_d plots - to be used later ;)
        %         %%%%%%%%%%%%%%%%%%%%
        %         %%%%%%%%%%%%%%%%%%%%
        %
        %
        %     % figure(100)
        %     % figure('units','normalized','outerposition',[0 0 1 1])
        %     % subplot(4,1,1)
        %     % plot( Results(uu).Time(le_fy-lift_seg:le_fy), Results(uu).B1N1Cl_out(le_fy-lift_seg:le_fy), 'b', 'linewidth', 2)
        %     % ylabel('Cl #1')
        %     % set(gcf,'Color','w');
        %     % set(gca,'FontSize',20);
        %     % subplot(4,1,2)
        %     % plot( Results(uu).Time(le_fy-lift_seg:le_fy), Results(uu).B1N1Cd_out(le_fy-lift_seg:le_fy), 'b', 'linewidth', 2)
        %     % ylabel('Cd #1')
        %     % set(gcf,'Color','w');
        %     % set(gca,'FontSize',20);
        %     % subplot(4,1,3)
        %     % plot( Results(uu).Time(le_fy-lift_seg:le_fy), Results(uu).B1N1Cl_out(le_fy-lift_seg:le_fy) ./ Results(uu).B1N1Cd_out(le_fy-lift_seg:le_fy), 'b', 'linewidth', 2)
        %     % ylabel('Cl / Cd')
        %     % set(gcf,'Color','w');
        %     % set(gca,'FontSize',20);
        %     % subplot(4,1,4)
        %     % plot( Results(uu).Time(le_fy-lift_seg:le_fy), Results(uu).B1N1Alpha_out(le_fy-lift_seg:le_fy), 'b', 'linewidth', 2)
        %     % xlabel('Time [sec]')
        %     % ylabel('Angle of Attack')
        %     % set(gcf,'Color','w');
        %     % set(gca,'FontSize',20);
        %     %
        %     % if (save_plot == 1)
        %     % saveas(gcf,file_name_5b_png)
        %     % end
    
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
        % plot *** #2 - AVG Fl + pitch angle #1 (over 1200 s)
    
        fprintf('plot *** #2 - AVG Fl + pitch angle #1 (over 1200 s) \n')
    
        figure(11)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,1,1)
        hold on
        plot ( R1(uu).Results.Time(le_fy-lift_seg:le_fy)- R1(uu).Results.Time(le_fy-lift_seg), R1(uu).Results.BTN1Fl_out(le_fy-lift_seg:le_fy), 'c', 'LineWidth',2 )
        plot ( R1(uu).Results.Time(le_fy-lift_seg:le_fy)- R1(uu).Results.Time(le_fy-lift_seg), R1(uu).Results.Avg_B1N1Fl_out(le_fy-lift_seg:le_fy), 'b', 'LineWidth',2 )
    
        if ( strcmp(ClosedLoop_SLXfile_Lift,'ClosedLoop_Kernel_LiftCntrl_1B' ))
            plot ( R1(uu).Results.Time(le_fy-lift_seg:le_fy)- R1(uu).Results.Time(le_fy-lift_seg), R1(uu).Results.B1N1Fl_ref_out(le_fy-lift_seg:le_fy), '--k', 'LineWidth',2 )
        else
            plot ( R1(uu).Results.Time(le_fy-lift_seg:le_fy)- R1(uu).Results.Time(le_fy-lift_seg), R1(uu).Results.TrajectoryReference(le_fy-lift_seg:le_fy), '--r' , 'LineWidth',2 )
        end
    
        grid on
        ylabel('Fl [N/m]')
        legend('controlled OpenFAST output', 'averaged', 'tracking reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',ft_size);
        %  title(title_graph)
        subplot(2,1,2)
        plot ( R1(uu).Results.Time(le_fy-lift_seg:le_fy)- R1(uu).Results.Time(le_fy-lift_seg), R1(uu).Results.BldPitch1_out(le_fy-lift_seg:le_fy), 'LineWidth',2 )
        ylim([0, 10]);
        grid on
        xlabel('Time [sec]')
        ylabel('pitch angle [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',ft_size);
    
        saveas(gcf,file_name_2_png)
        saveas(gcf,file_name_2_fig)
    
    
    
        % plot *** #3 - AVG Fl + pitch angle #1 (full 3000 s)
    
        fprintf('plot *** #3 - AVG Fl + pitch angle #1 (full 3000 s) \n')
    
        figure(12)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,1,1)
        hold on
        plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.BTN1Fl_out(1:le_fy), 'c', 'LineWidth',2 )
        plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.Avg_B1N1Fl_out(1:le_fy), 'b', 'LineWidth',2 )
    
        if ( strcmp(ClosedLoop_SLXfile_Lift,'ClosedLoop_Kernel_LiftCntrl_1B' ))
            plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.B1N1Fl_ref_out, '--k', 'LineWidth',2 )
        else
            plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.TrajectoryReference(1:le_fy), '--r' , 'LineWidth',2 )
        end
    
        %
        grid on
        xlabel('Time [sec]')
        ylabel('Fl [N/m]')
        legend('normal output', 'averaged output','reference');
        set(gcf,'Color','w');
        set(gca,'FontSize',ft_size);
        %  title(title_graph)
        subplot(2,1,2)
        plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.BldPitch1_out(1:le_fy), 'LineWidth',2 )
        grid on
        xlabel('Time [sec]')
        ylabel('pitch angle #1 [deg]')
        set(gcf,'Color','w');
        set(gca,'FontSize',ft_size);
    
        saveas(gcf,file_name_3_png)
        saveas(gcf,file_name_3_fig)
    
    
        % plot *** #4 - AVG Fl + pitch angle #1 (full 3000 s)
    
        fprintf('plot *** #4 - AVG Fl + pitch angle #1 (full 3000 s) \n')
    
        figure(13)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,1,1)
        hold on
        plot ( R1(1).Results.Time(1:le_fy), R1(1).Results.Avg_B1N1Fl_out(1:le_fy), 'b', 'LineWidth',3 )
        plot ( R1(2).Results.Time(1:le_fy), R1(2).Results.Avg_B1N1Fl_out(1:le_fy), 'm', 'LineWidth',3 )
    
        if ( length( ResultFound ) > 2)
            plot ( R1(3).Results.Time(1:le_fy), R1(3).Results.Avg_B1N1Fl_out(1:le_fy), 'g', 'LineWidth',3 )
        end
    
        if ( strcmp(ClosedLoop_SLXfile_Lift,'ClosedLoop_Kernel_LiftCntrl_1B' ))
            plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.B1N1Fl_ref_out, '--k', 'LineWidth',3 )
        else
            plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.TrajectoryReference(1:le_fy), '--r' , 'LineWidth',3 )
        end
    
        %
        grid on
     %   xlabel('Time [s]')
        ylabel('Fl [N]', 'interpreter', 'latex')
    
        if ( length( ResultFound ) > 2)
          hl =  legend('averaged output - wind profile 1', 'averaged output - wind profile 2', 'averaged output - wind profile 3', 'reference');
        else
          hl =  legend('averaged output - wind profile 1', 'averaged output - wind profile 2', 'reference');
        end

        set(hl, 'Interpreter','latex')
    
        set(gcf,'Color','w');
        set(gca,'FontSize',ft_size);
        %  title(title_graph)
        subplot(2,1,2)
        plot ( R1(1).Results.Time(1:le_fy), R1(1).Results.BldPitch1_out(1:le_fy), 'b', 'LineWidth',3 )
        hold on
        plot ( R1(2).Results.Time(1:le_fy), R1(2).Results.BldPitch1_out(1:le_fy), 'm', 'LineWidth',3 )
    
        if ( length( ResultFound ) > 2)
            plot ( R1(3).Results.Time(1:le_fy), R1(3).Results.BldPitch1_out(1:le_fy), 'g', 'LineWidth',3 )
        end
    
    
        grid on
        xlabel('Time [s]', 'interpreter', 'latex')
        ylabel('pitch angle - blade 1 [deg]', 'interpreter', 'latex')
    
        if ( length( ResultFound ) > 2)
          hm =  legend('wind profile 1', 'wind profile 2', 'wind profile 3');
        else
          hm =  legend('wind profile 1', 'wind profile 2');
        end
        set(hm, 'Interpreter','latex')

        set(gcf,'Color','w');
        set(gca,'FontSize',ft_size);
    
        saveas(gcf,file_name_4_png)
        saveas(gcf,file_name_4_fig)
    
    else
    
        fprintf('plot *** #4 - AVG Fl + pitch angle #1 (full 3000 s) \n')
    
        figure(13)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(2,1,1)
        hold on
        % plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.BTN1Fl_out(1:le_fy), 'c', 'LineWidth',2 )
        plot ( R1(1).Results.Time(1:le_fy), R1(1).Results.Avg_B1N1Fl_out(1:le_fy), 'b', 'LineWidth',2 )
    
    
        if ( strcmp(ClosedLoop_SLXfile_Lift,'ClosedLoop_Kernel_LiftCntrl_1B' ))
            plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.B1N1Fl_ref_out, '--k', 'LineWidth',2 )
        else
            plot ( R1(uu).Results.Time(1:le_fy), R1(uu).Results.TrajectoryReference(1:le_fy), '--r' , 'LineWidth',3 )
        end
    
        %
        grid on
     %   xlabel('Time [s]')
        ylabel('Fl [N]', 'interpreter', 'latex')
    
        legend('averaged output',  'reference', 'interpreter', 'latex');
    
    
        set(gcf,'Color','w');
        set(gca,'FontSize',ft_size);
        %  title(title_graph)
        subplot(2,1,2)
        plot ( R1(1).Results.Time(1:le_fy), R1(1).Results.BldPitch1_out(1:le_fy), 'LineWidth',2 )
    
        grid on
        xlabel('Time [s]', 'interpreter', 'latex')
        ylabel('pitch angle [deg]', 'interpreter', 'latex')
    
      %  legend('wind profile');
    
        set(gcf,'Color','w');
        set(gca,'FontSize',ft_size);
    
        saveas(gcf,file_name_4_png)
        saveas(gcf,file_name_4_fig)
    
    end
    
    
    cd(LCOS_rootFolder)

