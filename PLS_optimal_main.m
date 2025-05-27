%% simulation setup



% PLS_setup;


disp('...........................................');
disp('Parameters:');
disp(['distance=' num2str(norm([x1-x0 y1-y0])) 'm']);
disp(['total length=' num2str(V*T) 'm']);
disp(['max path=' num2str(norm([x0-xb y0-yb])+norm([x1-xb y1-yb])) 'm']);
% disp(['changflag=' num2str(changflag)]);
% disp(['convert rho= ' num2str(rho)]);
disp('...........................................');
if norm([x1-x0 y1-y0])>V*T
    disp('Not feasible');
    disp('...........................................');
else
    if V*T>=norm([x0-xb y0-yb])+norm([x1-xb y1-yb])
        disp('Sufficient length.');
        disp('...........................................');
        tic;
        PLS_sufficient_optimal;
        toc;
        disp(['Optimal result -- ' num2str(R_opt)]);
        disp('...........................................');
    else
        disp('Insufficient length ... ');
        disp('...........................................');
        %disp('SCP solution:')
        if abs(norm([x0-xb y0-yb])+norm([x1-xb y1-yb])-V*T)/V/T<0.01
            disp('The length is too close to the sufficient length.');
            disp('The result may be inaccurate, due to computational accuracy limit.');
            tic;
            Rician_sufficient_optimal;
            toc;
            disp(['Optimal result -- ' num2str(R_opt)]);
            disp('...........................................');
        else
            tic;
            PLS_insufficient_optimal;
            toc;
            disp(['Optimal result -- ' num2str(R_opt)]);
            disp('...........................................');
        end
    end
end