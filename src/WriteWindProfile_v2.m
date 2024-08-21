
%   0.000000   10   0.000000   0          0.000000   0.300000   0.000000   0.000000      0
% 50.000000    10   0.000000   0          0.000000   0.300000   0.000000   0.000000      0
% 500.000000   9   0.000000   0          0.000000   0.300000   0.000000   0.000000      0

function WriteWindProfile_v2( time_spec, wind_x, FAST_InputPath, LCOS_rootFolder, PwrLaw )

cd(FAST_InputPath)

%cd IEA-15-240-RWT-UMaineSemi

    fileID = fopen('wind_profile.dat','w');

    if ( length( time_spec ) == 1)

          time_spec(2) =  500;
          wind_x(2) = wind_x(1);

    end
    
    for ii = 1:length( time_spec )
    fprintf(fileID,'%6.6f \t %6.6f \t %6.6f \t %d \t %6.6f \t %6.6f \t %6.6f \t %6.6f \t %d \n', time_spec(ii), wind_x(ii), 0, 0, 0, PwrLaw, 0, 0, 0);
    
    end
    
    fclose(fileID);

cd(LCOS_rootFolder)

end


