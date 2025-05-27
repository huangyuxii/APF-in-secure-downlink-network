function R = PLS_real_R(r,re,H,P)
%artificial force calculation
%   F is the absolute value of potential's derivative in r 

% input:der 为力场求x,y的偏导，=1 x;=2 y
% input:r 为(x,y)到用户的向量 (x-xb,y-yb)
% input:re  为(x,y)到窃听者的向量 （x-xe,y-ye）
% input:H 为无人机飞行高度
% input: At Bt 表示信道ue ub link的中间变量
% input:P 当前功率



snr0=10^8; 
r0=norm(r);
re0=norm(re);

At=snr0/(r0^2+H^2);
Bt=snr0/(re0^2+H^2);
if At>Bt
    R=log2(1+At*P)-log2(1+Bt*P);
else
    R=0;
end