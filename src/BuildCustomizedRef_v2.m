    
    
    function [ time_base, TrajectoryReference ] = BuildCustomizedRef_v2 ( time_ref, traj , DT, TMax, coeff_pitch, LiftStepRef, LiftStepRef_stepTime)
    
    % TrajectoryReference

    time_base = [0:DT:TMax];
    
    if LiftStepRef == 0
    
        
    
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
    
    else
    
    
        ii = 1;
        level_ = traj(1);
    
        TrajectoryReference = traj(1);
    
        for ( kk = 2:length( time_base ) )
    
            if ( time_base(kk) >= ii*LiftStepRef_stepTime )
    
                level_ = level_ + LiftStepRef;
    
                ii = ii + 1;
            end
    
            TrajectoryReference(kk) = ( 1 - DT * 10 ) * TrajectoryReference(kk-1) + DT * 10 * level_;
    
    
        end
    
    end
    
    
    
    
    

