    
    
function [Stat_vector, IndexSurfaceComputation] = ComputeLiftSurface_v2b (NumBlNds, IndexSurfaceComputation, SurfaceMaxTime, NodeLift_Index_cntrl, Results, ResultsLiftdata, path, Stat_vector, PitchBlade_0, WindSpeed_0, BladeNodePosition )
    
% SurfaceMaxTime nor really used (seems to be time consuming ??)... see later if necessary ?

  % create a 2D array Fl(node) vs. Time as well as Fl(node) vs. Time( /2)
  %                   Fy(tan)(node) vs. Time as well as Fy(tan)(node) vs. Time( /2)
    
 % tic 
IndexSurfaceComputation = IndexSurfaceComputation + 1;

    % Time vector : create a reduced time base vector [TMax/2:SurfaceMaxTime]
    Time_x = Results.Time;
 
 %   IndMaxSubTime = max( find ( Time_x <= SurfaceMaxTime ) ); %#ok<MXFND>

    % Compute the reduced Time vector from [length / 2 -> length/ 2 + IndMaxSubTime]
    ReducedTimeVector = floor(length(Results.Time) / 2): floor(length(Results.Time)); % + floor(IndMaxSubTime);

    Time_Reduced_x = Time_x(ReducedTimeVector);

    NodeRange = (1:1:NumBlNds)';

    fprintf('\n ----- Computing the lift surface (takes few minutes) -> statistics : ');
    
    % 1/ F_l matrix computation / submatrix over ReducedTimeVector
    
    for qq = 1:length(ResultsLiftdata)  %length(ResultsLiftdata(end).Fl_node_data-1)
        ComputeFl(:,qq) = ResultsLiftdata(qq).Fl_node_out; %#ok<AGROW>
    end   
        SubComputeFl = ComputeFl(:, ReducedTimeVector) ;
    
    % Extract the lift at the 'NodeLift_Index_cntrl': directly from Slx
    % (F1y_1) and from the 'SubComputeFl' matrix to be sure that both are
    % identical
    F1y_1_ = Results.BldPitch1_out( ReducedTimeVector );
    F1y_1_fromArray = SubComputeFl(NodeLift_Index_cntrl,:);

    % Extract the averaged lift of each node
    ComputSize = size(SubComputeFl);
    
    for dd = 1:ComputSize(1)
        SubComputeAVGFl(dd) = mean(SubComputeFl(dd,:)); %#ok<AGROW>
    end


    % 2/ F_y (tangente) matrix computation / submatrix over ReducedTimeVector

    for qq = 1:length(ResultsLiftdata)  %length(ResultsLiftdata(end).Fl_node_data-1)
        ComputeFy(:,qq) = ResultsLiftdata(qq).Fy_node_out; %#ok<AGROW>
    end

    SubComputeFy = ComputeFy(:, ReducedTimeVector) ;

    % Extract the averaged F_y(tan) of each node
    ComputSize = size(SubComputeFy);

    for dd = 1:ComputSize(1)
        SubComputeAVGFy(dd) = mean(SubComputeFy(dd,:)); %#ok<AGROW>
    end

    % 3/ Compute the integral momentum
    % for indFyTime = 1:length(ReducedTimeVector)
    % 
    % IntegralMomentum(indFyTime) = trapz( BladeNodePosition, ComputeFy(:, indFyTime )' );
    % 
    % end
    % 
    % AVGIntegralMomentum = IntegralMomentum(end);
  
    %----------- STATISTICS for the lift & the power

    %- MAXIMUM

    % Maximum and index of the averaged-lift
    [maxLiftAvg, IndexMaxAvg] = max(SubComputeAVGFl);
    Stat_vector(IndexSurfaceComputation).LiftMaxNode = maxLiftAvg;

     % Maximum and index of the averaged-Y
    % [maxYAvg, IndexMaxYAvg] = max(SubComputeAVGFy);
    % Stat_vector(IndexSurfaceComputation).YMaxNode = maxYAvg;

    %- CNTRL NODE

    % averaged-Lift at the 'NodeLift_Index_cntrl' node 
    LiftAVGCntrlNode = SubComputeAVGFl(NodeLift_Index_cntrl); %taken at the cntrl point
    Stat_vector(IndexSurfaceComputation).LiftAVGCntrlNode = LiftAVGCntrlNode;

    % averaged-Y at the 'NodeLift_Index_cntrl' node 
 %   YAVGCntrlNode = SubComputeAVGFl(NodeLift_Index_cntrl); %taken at the cntrl point
 %   Stat_vector(IndexSurfaceComputation).YAVGCntrlNode = YAVGCntrlNode;

    Stat_vector(IndexSurfaceComputation).PitchBlade = PitchBlade_0;
    Stat_vector(IndexSurfaceComputation).WindSpeed = WindSpeed_0;
 %   Stat_vector(IndexSurfaceComputation).IntegralMomentum = AVGIntegralMomentum;
    Stat_vector(IndexSurfaceComputation).LiftAVGCntrlNode = LiftAVGCntrlNode;
    Stat_vector(IndexSurfaceComputation).PitchBlade = PitchBlade_0;
    Stat_vector(IndexSurfaceComputation).WindSpeed_vector = Results.Wind1VelX_out;
    Stat_vector(IndexSurfaceComputation).omega = Results.RotSpeed_out(end);
 %   Stat_vector(IndexSurfaceComputation).TSR = ( BladeNodePosition(end) * Results.omega(end) ) / Results.wind_x(end);
  
    LiftMaxLine = IndexMaxAvg*ones(1,length( Time_x ));

  %  YMaxLine = IndexMaxYAvg*ones(1,length( Time_x ));
    
    LiftCntrlLine = NodeLift_Index_cntrl*ones(1,length( Time_x ));
    


    Y_LiftNode = sprintf( 'Lift - Node #%d', NodeLift_Index_cntrl );


%%%%%%%%%%%%%%%%%%%%
           
file_name_SC_Fl = sprintf('SurfaceLift_Fl_pitch_%f_windSpeed_%f.png', PitchBlade_0, Results.Wind1VelX_out(end)  );
    
title_name_SC_Fl = sprintf('Fl-Py / pitch = %f - windSpeed = %f', Results.BldPitch1_out(end), Results.Wind1VelX_out(end) );
    
%%%%%%%%%%%%%%%%%%%%

cd(path)

    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(2,2,[1,3])
    imagesc(Time_x(ReducedTimeVector), NodeRange, SubComputeFl)
    hold on
    plot(Time_x(ReducedTimeVector), LiftMaxLine(ReducedTimeVector), '--m', 'linewidth', 3)
    plot(Time_x(ReducedTimeVector), LiftCntrlLine(ReducedTimeVector), '.k', 'linewidth', 3)
    title('$[F_l]$', 'Interpreter','Latex')
    xlabel('Time (s)')
    ylabel('Node #')
    set(gcf,'Color','w');
    colorbar
    set(gca,'FontSize',20);
    subplot(2,2,[2,4])
    imagesc(Time_x(ReducedTimeVector), NodeRange, SubComputeFy)
    hold on
    plot(Time_x(ReducedTimeVector), LiftCntrlLine(ReducedTimeVector), '.k', 'linewidth', 3)
    title('$[F_y]$', 'Interpreter','Latex')
    xlabel('Time (s)')
    ylabel('Node #')
    set(gcf,'Color','w');
    colorbar
    set(gca,'FontSize',20);
    set(gcf,'Color','w');
    saveas(gcf,file_name_SC_Fl);
  %  sgtitle(title_name_SC_Fl, 'FontSize',20)
    

    
    fprintf('Pitch angle : %f - [#%d] -> (Fl: %f) -- Max Fl: [#%d -> %f] -- wind x: %f ** \n\n',  PitchBlade_0, NodeLift_Index_cntrl, LiftAVGCntrlNode, IndexMaxAvg, maxLiftAvg, mean( Results.Wind1VelX_out ) );

  %  pause

    close all
 %   fid = fopen('WindPitchLooping.txt','a');
 %   fprintf('Pitch angle : %f - [#%d] -> (Fl: %f) -- Max Fl: [#%d -> %f] -- wind x: %f ** \n\n',  PitchBlade_0, NodeLift_Index_cntrl, LiftAVGCntrlNode, IndexMaxAvg, maxLiftAvg, mean( Results.Wind1VelX_out ) );
 %   fclose all;

   % toc


