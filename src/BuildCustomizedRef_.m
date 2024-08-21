

function [ time_base, TrajectoryReference ] = BuildCustomizedRef_ ( time_ref, traj , DT, TMax, coeff_pitch)

   % TrajectoryReference
    
    time_base = [0:DT:TMax];
    
    time_ref = [time_ref, 1e9];

    ii = 1;
    time_ = 0;

    x0 = 0;

    for ( kk = 1:length( time_base ) )
    
        time_ = time_base( kk );
    
        if ( time_ >= time_ref( ii ) && ii < length( time_ref )-1 )
     
        %    fprintf("--------")
    
        % Compute 
            A_coeff = ( traj( ii+1 ) - traj( ii ) )/ ( time_ref( ii+1 ) - time_ref( ii ) );
    
            xt = time_ref( ii );
    
            yt = traj( ii );
    
            A_coeff;
    
            func_linear = @( x, B_coeff )( A_coeff * x + B_coeff );
    
            func_solve = @(xx)( (yt - func_linear(xt,xx)).^2 );
    
            b_ = fminsearch( (func_solve), x0);

            x0 = b_;
    
       %     fprintf("========")
    
            ii = ii + 1;
    
        end
    
       % time_vec(kk) = time_;
    
        TrajectoryReference(kk) = func_linear( time_, (b_) ) / coeff_pitch ;
    
        kk = kk + 1;
    
    end
    
   
    
    
    

