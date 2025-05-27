
%% fig.1 monotonic behavoir of lambda
T=160;
Pmax=0.08;
lambda_list=linspace(0,0.1,11);
E_list=linspace(0,0,11);
for i=1:length(lambda_list)
    lambda=lambda_list(i);
    PLS_insufficient_optimal_lambda;
    E_list(i)=E_opt;
end
figure;      
plot(lambda_list,E_list);hold on;
% plot(0.35938,5.0096,'r*');hold on;

%% fig.2 optimzied UAV trajectories with different T
clc;
clear all;
PLS_setup;
T=180;
E=5;
% lambda=5;
Pmax=0.1;
PLS_optimal_main; 


%% fig.3 optimized power P over time t with different E;

T_list=[130 145 200];
PLS_setup;
E=5;
for Ri=1:length(T_list)
    T=T_list(Ri)
    PLS_optimal_main; 
end


%% fig.4 Optimized achievable throughput R with varying operation duration T

clc; clear all;
PLS_setup;
E=5;
Pmax=0.05;
T_list=[130 140 150 160 180 190 200 210 220 230 240 250 300];
R_list=linspace(0,0,length(T_list));
for Ri=1:length(T_list)
    T=T_list(Ri)
    PLS_optimal_main;   % 注释其中PLS_setup;
    R_list(Ri)=R_opt;
    disp(['finishing the finds in ' num2str(Ri) '-th '])
end
figure;      
plot(T_list,R_list);hold on;

%% fig.5  Optimized achievable throughput R with varying power PMAX

clc; clear all;
PLS_setup;
E=5;
T=130;
% P_dbm=linspace(-10,20,7);
P_dbm=linspace(0.01,0.1,7);
P_list= 10.^(P_dbm / 10) * 1e-3;
R_list=linspace(0,0,length(P_list));
for pi=1:length(P_list)
    Pmax=P_list(pi)
    PLS_optimal_main;   % 注释其中PLS_setup;
    R_list(pi)=R_opt;
end
figure;      
plot(P_list,R_list);hold on;

%% case: E=5J T=160s  

P_list= [0.0005, 0.001, 0.003, 0.01, 0.05, 0.1];
R_list= [24.9491, 35.3369, 51.8263, 65.1701, 71.4642, 71.5505];
plot(P_list,R_list);hold on;
%% case: E=5J T=180s  

P_list= [0.0005, 0.001, 0.003, 0.01, 0.05, 0.1];
R_list= [56.881, 73.7431, 96.9487, 113.5909, 122.8227, 122.8902];
plot(P_list,R_list);hold on;

%% fig.6 optimzied UAV trajectories with insufficient T under different locations
clc;clear all;
PLS_setup;
x0=600; %100;%200; % 100 200                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
y0=300; %40; % 20 40
x1=-600; %50; %40;%0;
y1=600; %100;


% BOB and Eve
xb=0 ; yb=0;
xe=200 ; ye=200;

T=200;
Pmax=0.1;
lambda=0;
PLS_sufficient_optimal_lambda;
% PLS_insufficient_optimal_case2;
% PLS_optimal_main; 


%% fig.7 optimzied UAV trajectories with sufficient T under different Pmax
PLS_setup;
E=5;
T=200;
Pmax=0.0001;
PLS_optimal_main; 
% for Ri=1:length(T_list)
%     T=P_list(Ri)
%     PLS_optimal_main; 
% end

%% fig.8 performance comparison
yyaxis right
% tim bcd
ys=data(2,1:10); 
plot(x,ys,'-.s','LineWidth',2);hold on;
% tim apf
y=11.913631*linspace(1,1,N); 
plot(x,y,'-x','LineWidth',2,'MarkerSize',8);hold on;

yyaxis left
% thr apf
% y=data(6,1:10);
y=120.6086*linspace(1,1,N);
plot(x,y,'-x','LineWidth',2,'MarkerSize',8);hold on;
% thr bcd
ys=RR_scp; 
plot(x,ys,'-.s','LineWidth',2);hold on;
ylabel('Information throughput [bit/hz]')
ylim([0.64 0.645]);
%%
plot([600 -600],[300 600],'^');hold on;
