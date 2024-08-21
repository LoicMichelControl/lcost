
    save_results = save_project_name + buf_wind + '_Results.mat';

    cd(path)
    
    save(save_results, "Config_", "Results", "Param", "Cntrl"); 
    
    cd ..

