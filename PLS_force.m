function [gx, gy, P_lambda] = PLS_force(r,re,H,lambda,Pmax)
%artificial force calculation
%   F is the absolute value of potential's derivative in r 

% input:der 为力场求x,y的偏导，=1 x;=2 y
% input:r 为(x,y)到用户的向量 (x-xb,y-yb)
% input:re  为(x,y)到窃听者的向量 （x-xe,y-ye）
% input:H 为无人机飞行高度
% input: At Bt 表示信道ue ub link的中间变量
% input:Pmax 最大功率 P_critial保密功率


P_lambda=0;

snr0=10^8; 
r0=norm(r);
re0=norm(re);

At=snr0/(r0^2+H^2);
Bt=snr0/(re0^2+H^2);
Z=(1/2/At-1/2/Bt)^2-1/log(2)/lambda*(1/At-1/Bt);
P_critial = -1/2/At-1/2/Bt+sqrt(Z);
if At>Bt
    P_lambda=min(Pmax, max(0,P_critial));
    if P_lambda==0
        gx=0;
        gy=0;
    else 
        delta_A=-2*snr0/(r0^2+H^2)^2*r;
        delta_B=-2*snr0/(re0^2+H^2)^2*re;
        if P_lambda==Pmax
            R_A=-Pmax/(1+At*Pmax)/log(2);
            R_B=Pmax/(1+Bt*Pmax)/log(2);
        elseif P_lambda==P_critial
            P_A=1/2/At^2+1/2/sqrt(Z)/At^2*(1/log(2)/lambda-1/2/At+1/2/Bt);
            P_B=1/2/Bt^2+1/2/sqrt(Z)/Bt^2*(-1/log(2)/lambda+1/2/At-1/2/Bt);
            R_A=-1/(1+At*P_critial)/log(2)*(P_critial+At*P_A)+1/(1+Bt*P_critial)/log(2)*(Bt*P_A)+lambda*P_A;
            R_B=-1/(1+At*P_critial)/log(2)*(At*P_B)+1/(1+Bt*P_critial)/log(2)*(P_critial+Bt*P_B)+lambda*P_B;
        end
        gx=-R_A*delta_A(1)-R_B*delta_B(1);
        gy=-R_A*delta_A(2)-R_B*delta_B(2);
    end
else
    P_lambda=0;
    gx=0;
    gy=0;
end

end




