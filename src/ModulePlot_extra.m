    
    fprintf('\n\n ************ EXTRA PLOTTING SECTION ************ \n\n')
    
    
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
    
    file_name_0_png = file_name_0 + '_results.png';
    file_name_1_png = file_name_1 + '_results.png';
    file_name_2_png = file_name_2 + '_results.png';
    file_name_3_png = file_name_3 + '_results.png';
    file_name_4_png = file_name_4 + '_results.png';
    file_name_5_png = file_name_5 + '_results.png';
    file_name_5b_png = file_name_5b + '_results.png';
    file_name_6_png = file_name_6 + '_results.png';
    file_name_6b_png = file_name_6b + '_results.png';
    file_name_6c_png = file_name_6c + '_results.png';
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
    file_name_6b_fig = file_name_6b + '_results.fig';
    file_name_6c_fig = file_name_6c + '_results.fig';
    file_name_7_fig = file_name_7 + '_results.fig';
    file_name_8_fig = file_name_8 + '_results.fig';
    file_name_9_fig = file_name_9 + '_results.fig';
    file_name_10_fig = file_name_10 + '_results.fig';
    file_name_11_fig = file_name_11 + '_results.fig';
    
    cd(path)
    mkdir results_extra
    cd ./results_extra
    
    delete *.png
    delete *.fig
    
    length_ClosedLoop = length( Results(uu).Time(beg:end) );
    
    % plot *** #1 - Wind1VelX (over 1200 s)
    
    fprintf('plot *** #1 - Wind1VelX_out (over 1200 s) \n')
    
    figure(1)
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy), Results(uu).Wind1VelX_out(le_fy-lift_seg:le_fy), 'LineWidth',2 )
    grid on
    ylabel('Wind1VelX [m/s]')
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    
    saveas(gcf,file_name_1_png)
    saveas(gcf,file_name_1_fig)
    
    % plot *** #2 - GenPwr + Gen Tq + RotSpeed (over 1200 s)
    
    fprintf('plot *** #2 - GenPwr + Gen Tq + RotSpeed (over 1200 s) \n')
    
    figure(2)
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(3,1,1)
    plot ( Results(uu).Time(1:end), Results(uu).GenPwr_out(1:end), 'LineWidth',2 )
    grid on
    ylabel('GenPwr [kW]')
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
 %   title(title_graph)
    subplot(3,1,2)
    plot ( Results(uu).Time(1:end), Results(uu).GenTq_out(1:end), 'LineWidth',2 )
    grid on
    ylabel('GenTq [kN-m]')
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    subplot(3,1,3)
    plot ( Results(uu).Time(1:end), Results(uu).RotSpeed_out(1:end), 'LineWidth',2 )
    grid on
    xlabel('Time [sec]')
    ylabel('RotSpeed [rpm]')
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    
    saveas(gcf,file_name_2_png)
    saveas(gcf,file_name_2_fig)
    
    % plot *** #3 - Fl - Fl#2 - Fl#3 (over 1200 s)

    if ( strcmp(ClosedLoop_SLXfile_Lift,'ClosedLoop_Kernel_LiftCntrl_1B' ) == 0)
    
    fprintf('plot *** #3 - Fl - Fl#2 - Fl#3 (over 1200 s) \n')
    
    figure(3)
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(3,1,1)
    hold on
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).BTN1Fl_out(le_fy-lift_seg:le_fy), 'c', 'LineWidth',2 )
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).Avg_B1N1Fl_out(le_fy-lift_seg:le_fy), 'b', 'LineWidth',2 )
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).TrajectoryReference(le_fy-lift_seg:le_fy), '--k' , 'LineWidth',2 )
    grid on
    ylabel('Fl#1 [N/m]')
    legend('OpenFAST output', 'averaged', 'tracking reference');
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
 %   title(title_graph)
    subplot(3,1,2)
    hold on
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).BTN1Fl_out(le_fy-lift_seg:le_fy), 'c', 'LineWidth',2 )
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).Avg_B2N1Fl_out(le_fy-lift_seg:le_fy), 'b', 'LineWidth',2 )
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).TrajectoryReference(le_fy-lift_seg:le_fy), '--k' , 'LineWidth',2 )
    grid on
    ylabel('Fl#2 [N/m]')
    legend('OpenFAST output', 'averaged', 'tracking reference');
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    subplot(3,1,3)
    hold on
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).BTN1Fl_out(le_fy-lift_seg:le_fy), 'c', 'LineWidth',2 )
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).Avg_B3N1Fl_out(le_fy-lift_seg:le_fy), 'b', 'LineWidth',2 )
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).TrajectoryReference(le_fy-lift_seg:le_fy), '--k' , 'LineWidth',2 )
    grid on
    xlabel('Time [sec]')
    ylabel('Fl#3 [N/m]')
    legend('controlled OpenFAST output', 'averaged', 'tracking reference');
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    
    saveas(gcf,file_name_3_png)
    saveas(gcf,file_name_3_fig)

    end
    
    % plot *** #4 - Fl + Fl#2 + Fl#3 (zoom on the last 1500 points)
    
    fprintf('plot *** #4 - Fl + Fl#2 + Fl#3 (zoom on the last 1500 points)');
    
    lift_seg_save = lift_seg;
    lift_seg = 1500;
    
    figure(4)
    figure('units','normalized','outerposition',[0 0 1 1])
    hold on
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).B1N1Fl_out(le_fy-lift_seg:le_fy), 'b', 'LineWidth',2 )
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).B2N1Fl_out(le_fy-lift_seg:le_fy), 'r', 'LineWidth',2 )
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy) - Results(uu).Time(le_fy-lift_seg), Results(uu).B3N1Fl_out(le_fy-lift_seg:le_fy), 'g', 'LineWidth',2 )
    legend('Fl#1','Fl#2','Fl#3')
    xlabel('Time [sec]')
    ylabel('Fl [N/m]')
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    
    saveas(gcf,file_name_4_png)
    saveas(gcf,file_name_4_fig)
    
    
    lift_seg = lift_seg_save;
    
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
    
    
    % plot *** #5 - AVG Fl + pitch angle #1 (over 1200 s)
    
    fprintf('plot *** #5 - AVG Fl + pitch angle #1 (over 1200 s) \n')
    
    figure(5)
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1)
    hold on
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy)- Results(uu).Time(le_fy-lift_seg), Results(uu).BTN1Fl_out(le_fy-lift_seg:le_fy), 'c', 'LineWidth',2 )
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy)- Results(uu).Time(le_fy-lift_seg), Results(uu).Avg_B1N1Fl_out(le_fy-lift_seg:le_fy), 'b', 'LineWidth',2 )
    
    if ( strcmp(ClosedLoop_SLXfile_Lift,'ClosedLoop_Kernel_LiftCntrl_1B' ))
        plot ( Results(uu).Time(le_fy-lift_seg:le_fy)- Results(uu).Time(le_fy-lift_seg), Results(uu).B1N1Fl_ref_out(le_fy-lift_seg:le_fy), '--k', 'LineWidth',2 )
    else
        plot ( Results(uu).Time(le_fy-lift_seg:le_fy)- Results(uu).Time(le_fy-lift_seg), Results(uu).TrajectoryReference(le_fy-lift_seg:le_fy), '--r' , 'LineWidth',2 )
    end
    
    grid on
    ylabel('Fl [N/m]')
    legend('controlled OpenFAST output', 'averaged', 'tracking reference');
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
  %  title(title_graph)
    subplot(2,1,2)
    plot ( Results(uu).Time(le_fy-lift_seg:le_fy)- Results(uu).Time(le_fy-lift_seg), Results(uu).BldPitch1_out(le_fy-lift_seg:le_fy), 'LineWidth',2 )
    ylim([0, 10]);
    grid on
    xlabel('Time [sec]')
    ylabel('pitch angle [deg]')
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    
    saveas(gcf,file_name_5_png)
    saveas(gcf,file_name_5_fig)
    
    
    
    % plot *** #6 - AVG Fl + pitch angle #1 (full 3000 s)
    
    fprintf('plot *** #6 - AVG Fl + pitch angle #1 (full 3000 s) \n')
    
    figure(6)
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,1,1)
    hold on
    plot ( Results(uu).Time(1:le_fy), Results(uu).BTN1Fl_out(1:le_fy), 'c', 'LineWidth',2 )
    plot ( Results(uu).Time(1:le_fy), Results(uu).Avg_B1N1Fl_out(1:le_fy), 'b', 'LineWidth',2 )
    
    	if ( strcmp(ClosedLoop_SLXfile_Lift,'ClosedLoop_Kernel_LiftCntrl_1B' ))
        plot ( Results(uu).Time(1:le_fy), Results(uu).B1N1Fl_ref_out, '--k', 'LineWidth',2 )
        else
        plot ( Results(uu).Time(1:le_fy), Results(uu).TrajectoryReference(1:le_fy), '--r' , 'LineWidth',2 )
    	end
    
    %
    grid on
    xlabel('Time [sec]')
    ylabel('Fl [N/m]')
    legend('OpenFAST output', 'averaged', 'tracking reference');
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
  %  title(title_graph)
    subplot(2,1,2)
    plot ( Results(uu).Time(1:le_fy), Results(uu).BldPitch1_out(1:le_fy), 'LineWidth',2 )
    grid on
    xlabel('Time [sec]')
    ylabel('pitch angle #1 [deg]')
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    
    saveas(gcf,file_name_6_png)
    saveas(gcf,file_name_6_fig)
    
    
    
    cd(LCOS_rootFolder)

