function [x_min,y_min] = PLS_lowest_xy(xb,yb,xe,ye,lambda,Pmax)
%PLS_lowest_xy @find the lowest xy in APF
%   x_min y_min    @location


% xb=200 ; yb=0;
% xe=0 ; ye=0;
% lambda=0.5;
H=100;
snr0=10^8;



syms x y;
r=[x-xb, y-yb];r0=norm(r);
re=[x-xe,y-ye];re0=norm(re);



At=snr0/(r0^2+H^2);
Bt=snr0/(re0^2+H^2);
Z=(1/2/At-1/2/Bt)^2-1/log(2)/lambda*(1/At-1/Bt);

% Z_val = double(Z);
% if Z_val < 0
%     disp('Warning: Z is negative, taking real part');
%     Z_val = max(Z_val, 0);
% end

if lambda~=0
    P_critial = -1/2/At-1/2/Bt+sqrt(Z);
    P_l=P_critial;  % P=Pmax可以求解
    
    
    delta_A=-2*snr0/(r0^2+H^2)^2*r;
    delta_B=-2*snr0/(re0^2+H^2)^2*re;
    P_A=1/2/At^2+1/2/sqrt(Z)/At^2*(1/log(2)/lambda-1/2/At+1/2/Bt);
    P_B=1/2/Bt^2+1/2/sqrt(Z)/Bt^2*(-1/log(2)/lambda+1/2/At-1/2/Bt);
    R_A=-1/(1+At*P_l)/log(2)*(P_l+At*P_A)+1/(1+Bt*P_l)/log(2)*(Bt*P_A)+lambda*P_A;
    R_B=-1/(1+At*P_l)/log(2)*(At*P_B)+1/(1+Bt*P_l)/log(2)*(P_l+Bt*P_B)+lambda*P_B;
    gx=-R_A*delta_A(1)-R_B*delta_B(1);
    gy=-R_A*delta_A(2)-R_B*delta_B(2);
        
    
    [x_sol, y_sol] = vpasolve([gx == 0, gy == 0], [x, y], [-100, 300; -100, 100]);
    % solve([gx == 0, gy == 0], [x, y]);
    
    
    
    x_min = double(x_sol);
    y_min = double(y_sol);
else
    P_l=Pmax;  
    delta_A=-2*snr0/(r0^2+H^2)^2*r;
    delta_B=-2*snr0/(re0^2+H^2)^2*re;
    R_A=-Pmax/(1+At*Pmax)/log(2);
    R_B=Pmax/(1+Bt*Pmax)/log(2);
    gx=-R_A*delta_A(1)-R_B*delta_B(1);
    gy=-R_A*delta_A(2)-R_B*delta_B(2);
    if xb>0
        [x_sol, y_sol] = vpasolve([gx == 0, gy == 0], [x, y], [0, 300; -100, 100]);
    else
        [x_sol, y_sol] = vpasolve([gx == 0, gy == 0], [x, y], [-100, 300; -100, 100]);
    end
    
    x_min = double(x_sol);
    y_min = double(y_sol);
end



% R_values = zeros(size(x_min)); % 存储所有解对应的 R 值
% 
% for i = 1:length(x_min)
%     % 计算 R 值
%     r0_i = norm([x_min(i) - xb, y_min(i) - yb]);
%     re0_i = norm([x_min(i) - xe, y_min(i) - ye]);
%     At_i = snr0 / (r0_i^2 + H^2);
%     Bt_i = snr0 / (re0_i^2 + H^2);
%     Zt_i =(1/2/At_i-1/2/Bt_i)^2-1/log(2)/lambda*(1/At_i-1/Bt_i);
%     P_critial_i = -1/2 /At_i - 1/2 /Bt_i + sqrt(Zt_i);
%     P_l_i = max(0,P_critial_i);
%     % 计算 R 值
%     R_values(i) = -log2(1 + At_i * P_l_i) + log2(1 + Bt_i * P_l_i) + lambda * P_l_i;
% end
% 
% % 选择最优解
% [~, idx] = min(R_values);  % 找到最小 R 值的索引
% x_opt = x_min(idx);
% y_opt = y_min(idx);

% fprintf('Optimal solution: x = %.4f, y = %.4f, R_min = %.4f\n', x_opt, y_opt, R_values(idx));

    
end