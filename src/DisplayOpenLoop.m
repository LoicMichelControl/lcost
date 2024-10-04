    
    
    file_name_save_ref_png_1 = save_project_name + '_openloop_reference_1.png'; % used in DisplayOpenLoop script
    file_name_save_ref_png_2 = save_project_name + '_openloop_reference_2.png'; % used in DisplayOpenLoop script
    file_name_save_ref_png_2b = save_project_name + '_openloop_reference_2b.png'; % used in DisplayOpenLoop script
    file_name_save_ref_png_3 = save_project_name + '_openloop_reference_3.png'; % used in DisplayOpenLoop script
    
    cd(path)
    
    % should be deleted in futre version - not relevant ?
    % fprintf('Warning : the plot sampling has been set to %d sec \n', PlotSampling);
    
    fprintf('Plotting the open-loop dynamics... \n')
    
    % TitleGraph = sprintf('Averaged wind = %f', mean(R1.Results(uu).wind_x));
    
    % may be osolete !
    % if ( strcmp(OpenLoop_SLXfile(end-2:end), 'sin') == 0 )
    % 
    %     buf_wind_ol  = sprintf('Open-Loop dynamics : Node = %d -  inflow:[%f -> %f -> %f] -- pitch:[%f -> %f -> %f -> %f]', NodeLift_Index_cntrl, wind_speed_x(1), wind_speed_x(2), wind_speed_x(3), ...
    %         Reference_point_1, Reference_point_2, Reference_point_3, Reference_point_4);
    %     title_graph = convertCharsToStrings( buf_wind_ol );
    % 
    % else
    % 
    %     buf_wind_ol  = sprintf('Open-Loop dynamics : Node = %d -  inflow: %f -- pitch: sine function', NodeLift_Index_cntrl, mean(R1.Results(uu).wind_x ));
    %     title_graph = convertCharsToStrings( buf_wind_ol );
    % 
    % end
        
    %keep the same buffer to show the Node
   % title_graph = convertCharsToStrings( buf_wind_ol );
    
    figure(1)
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(3,1,1)
    hold on
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).BldPitch1_out(beg:end), 'LineWidth',2 )
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).BldPitch2_out(beg:end), 'LineWidth',2 )
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).BldPitch3_out(beg:end), 'LineWidth',2 )
    legend('#1', '#2', '#3')
    grid on
    ylabel('pitch angle [degree]')
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    subplot(3,1,2)
    hold on
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).B1N1Fl_out(beg:end),  'b', 'LineWidth',2 )
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).B2N1Fl_out(beg:end),  'c', 'LineWidth',2 )
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).B3N1Fl_out(beg:end),  'r', 'LineWidth',2 )
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).Avg_B1N1Fl_out(beg:end),  '--k', 'LineWidth',2 )
    grid on
    ylabel('Fl [N/m]')
    legend('#1', '#2', '#3');
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    subplot(3,1,3)
    hold on
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).RootMyb1_out(beg:end),  'b', 'LineWidth',2 )
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).RootMyb2_out(beg:end),  'c', 'LineWidth',2 )
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).RootMyb3_out(beg:end),  'r', 'LineWidth',2 )
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).Avg_RootMyb1_out(beg:end),  '--k', 'LineWidth',2 )
    grid on
    xlabel('Time [sec]')
    ylabel('RootMyb1 [kN-m]')
    legend('#1', '#2', '#3');
 %   sgtitle(title_graph);
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    saveas(gcf,file_name_save_ref_png_1)
    
    
    figure(2)
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(3,1,1)
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).B1N1Fl_out(beg:end),  'b', 'LineWidth',2 )
     set(gca,'FontSize',20);
     ylabel('Fl [N/m] #1')
    subplot(3,1,2)
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).B2N1Fl_out(beg:end),  'c', 'LineWidth',2 )
     set(gca,'FontSize',20);
     ylabel('Fl [N/m] #2')
    subplot(3,1,3)
    plot ( R1.Results(uu).Time(beg:end), R1.Results(uu).B3N1Fl_out(beg:end),  'r', 'LineWidth',2 )
     set(gca,'FontSize',20);
    grid on
    xlabel('Time [sec]')
    ylabel('Fl [N/m] #3')
    set(gcf,'Color','w');
    set(gca,'FontSize',20);
    saveas(gcf,file_name_save_ref_png_2)


        figure(4)
        figure('units','normalized','outerposition',[0 0 1 1])
        subplot(3,1,1)
        plot ( Results(uu).Time(beg:end), Results(uu).GenPwr_out(beg:end), 'LineWidth',2 )
        grid on
        ylabel('GenPwr [kW]')
        set(gcf,'Color','w');
        set(gca,'FontSize',20);
     %   title(title_graph)
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
        saveas(gcf,file_name_save_ref_png_2b)


    if( exist('Cl_curve_Node','var') == 1 )

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
    saveas(gcf,file_name_save_ref_png_3)

    end
   
    uu = 1;
    
    fprintf('\n\n Averaged wind = %f \n', mean(R1.Results(uu).Wind1VelX_out ))
    
    cd(LCOS_rootFolder)


    fprintf('GenPwr(end) = %f \n', Results.GenPwr_out(end) );

    fprintf('GenTq(end) = %f \n', Results.GenTq_out(end) );
