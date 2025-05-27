



%% 寻找最佳lambda
lambda_max=1; % snr0*( (x0-xe)^2+(y0-ye)^2-((x0-xb)^2+(y0-yb)^2))/H^4/log(2);

if E>Pmax*T/2
    lambda=0;
    disp(['find optimal lambda!' num2str(lambda)]);
    if xb>xe
        PLS_insufficient_optimal_case1;
    else
        PLS_insufficient_optimal_case2;
    end
else
    lambda_range=[0, lambda_max];
    while 1
        
        lambda=mean(lambda_range);
        disp(['current lambda range: ' num2str(lambda_range)]);
        % find trajectory
        if xb>xe
            PLS_insufficient_optimal_case1;
        else
            PLS_insufficient_optimal_case2;
        end
        if abs(E_opt-E)>error_E
            if E_opt<E
                lambda_range(2)=lambda;
            elseif E_opt>E
                lambda_range(1)=lambda;
            end
        else  
            lambda_opt=lambda;
            disp(['find optimal lambda!' num2str(lambda_opt)]);
            break;
        end
    end
end

% 找到lambda_opt
% if xb>xe
%     PLS_insufficient_optimal_case1;
% else
%     PLS_insufficient_optimal_case2;
% end





