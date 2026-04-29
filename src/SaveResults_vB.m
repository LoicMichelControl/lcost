
    Result_index = sprintf('_%d_Results.mat', ind_wind);

    save_results = save_project_name + Result_index;

    cd(path)

    % Update the param profile

    Param.wind_speed_x = wind_speed_x(ind_wind,:);
    Param.wind_speed_t = wind_speed_t(ind_wind,:);
    
    save(save_results, "Config_", "Results", "Param", "Cntrl"); 
    
    cd ..

