% r @无人机到用户的水平距离
% H @无人机的固定飞行高度

clear all;

x=[1 2];
y=3*x

%%
clear all;clc;
[gx, gy, P_lambda]=PLS_force([1, 50], [100,100], 100, 10, 10, 5, 0.1, 0.05)
G=[1, 0, 0];
G=PLS_force(1, 1, 100, 1, 10, 5, 0.1, 0.05)

%%
T=130; PLS_insufficient_optimal_case2;
T=140; PLS_insufficient_optimal_case2;
T=150; PLS_insufficient_optimal_case2;

%%
xb=200 ; yb=0;
x0=600 ; y0=600;
angle(x-x0+1j*(y-y0))>angle(x_min-x0+1j*(y_min-y0))

%% 单项参数调试 指定lambda
clc;
clear all;
PLS_setup;
T=130;
E=5;
lambda=0;
% xb=0 ; yb=0;
% xe=200 ; ye=200;
P_dbm=linspace(-15,15,7);
% P_list= 4*10.^(P_dbm / 10) * 1e-3;
P_list= [0.0005, 0.001, 0.003, 0.01, 0.05, 0.1];
Pmax=P_list(6);
PLS_insufficient_optimal_case1;
% PLS_sufficient_optimal_lambda;


%% 最优轨迹测试 最优lambda
clc;
clear all;
PLS_setup;
T=130;
E=5;
% lambda=5;
Pmax=0.1;
PLS_optimal_main; 

%%
legend('Bob','Eve','T=130s','','T=150s','','','T=200s','','T=200s (BCD)');
xlim([-600 600]);
ylim([-30 600]);

%% 
legend('T=160s,Pmax=0.1W','','T=130s,Pmax=0.1W','','T=160s,Pmax=0.05W','T=160s,Pmax=0.08W');
%%  P_t
PLS_setup;
E=3;
T=130;
Pmax=0.1;
error_E=10e-4;
PLS_optimal_main; 
%%

% figure;
PP_opt(1)=PP_opt(2);
xp=(1:1:length(PP_opt))*10e-4;
plot(xp,PP_opt);hold on;
figure;
PP_best(1)=PP_best(2);
xp=(1:1:length(PP_best))*10e-4;
plot(xp,PP_best);hold on;


%%  test
x=600;
y=200;
r0=((x-xb)^2+(y-yb)^2)^0.5;
re0=((x-xe)^2+(y-ye)^2)^0.5;
r=[x-xb,y-yb];
re=[x-xe,y-ye];
[gx,gy,P_lambda]=PLS_force(r,re,100,0.5,0.1)
-PLS_R(r,re,100,0.5,P_lambda)
-PLS_R(r,re,100,0.5,0.1)

%% E=5J T=160s  

P_list= [0.0005, 0.001, 0.003, 0.01, 0.05, 0.1];
R_list= [24.9491, 35.3369, 51.8263, 65.1701, 71.4642, 71.5505];
plot(P_list,R_list);hold on;

%% E=5J T=180s

%%
legend('Bob','Eve','Pmax=1e-3W','','Pmax=5e-3W','','Pmax=1e-1W','');
xlim([-600 600]);
ylim([0 600]);