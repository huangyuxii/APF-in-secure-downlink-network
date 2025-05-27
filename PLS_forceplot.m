% 绘制secure APF 的力场向量图
% 内含 势能场图

clear all;clc;


% [xe,ye] 窃听者坐标 
% [xb yb] 用户坐标
% global xe;
% global ye;

xb=0 ; yb=0;
xe=200 ; ye=200;


% Pmax lambda
Pmax=0.1;
lambda_range=[0 5];
lambda=mean(lambda_range);

% channel link
H=100;
snr0=10^8;  % snr0=beta0/sigma^2;



% beta0=10^(-4); 


% 功率初始化
P_lambda=0;
% 最低点初始化
R_min=0;
x_min=0; y_min=0;
% x_boundary y_boundary
x_bound=0; y_bound=0;

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% change %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
% interesting task area
boundary=[-600 600 -600 600];
b_step=60;


xi=1;yi=1;si=1;si0=1;
tic;

for x= boundary(1):b_step:boundary(2) 
    for y= boundary(3):b_step:boundary(4)
%         tic;
        r=[x-xb,y-yb];
        r0=norm(r);
        re=[x-xe,y-ye];
        re0=norm(re);
        At=snr0/(r0^2+H^2);
        Bt=snr0/(re0^2+H^2);
        Z=(1/2/At-1/2/Bt)^2-1/log(2)/lambda*(1/At-1/Bt);
        P_critial = -1/2/At-1/2/Bt+sqrt(Z); %(1/2/At-1/2/Bt)^2-1/log(2)/lambda*(1/At-1/Bt)
        if At>=Bt
            P_lambda(xi,yi)=min(Pmax, max(0,P_critial));
%             disp(['P_critial:' num2str(P_critial)  'P_lambda:' num2str(P_lambda(xi,yi))]); 
            if P_lambda(xi,yi)==0
                gx(xi,yi)=0;
                gy(xi,yi)=0;
            else 
                delta_A=-2*snr0/(r0^2+H^2)^2*r;
                delta_B=-2*snr0/(re0^2+H^2)^2*re;
                if P_lambda(xi,yi)==Pmax
                    R_A=-Pmax/(1+At*Pmax)/log(2);
                    R_B=Pmax/(1+Bt*Pmax)/log(2);
                elseif P_lambda(xi,yi)==P_critial
                    P_A=1/2/At^2+1/2/sqrt(Z)/At^2*(1/log(2)/lambda-1/2/At+1/2/Bt);
                    P_B=1/2/Bt^2+1/2/sqrt(Z)/Bt^2*(-1/log(2)/lambda+1/2/At-1/2/Bt);
                    R_A=-1/(1+At*P_critial)/log(2)*(P_critial+At*P_A)+1/(1+Bt*P_critial)/log(2)*(Bt*P_A)+lambda*P_A;
                    R_B=-1/(1+At*P_critial)/log(2)*(At*P_B)+1/(1+Bt*P_critial)/log(2)*(P_critial+Bt*P_B)+lambda*P_B;
                end
                gx(xi,yi)=-R_A*delta_A(1)-R_B*delta_B(1);
                gy(xi,yi)=-R_A*delta_A(2)-R_B*delta_B(2);
            end
            R(xi,yi)=-log2(1+At*P_lambda(xi,yi))+log2(1+Bt*P_lambda(xi,yi))+lambda*P_lambda(xi,yi);
        else
            P_lambda(xi,yi)=0;
            gx(xi,yi)=0;
            gy(xi,yi)=0;
            R(xi,yi)=0;
            
        end
        if R(xi,yi)<R_min
            R_min=R(xi,yi);
            x_min=x; y_min=y;
        end

        yi=yi+1;
        

%         disp('------------------------------------one Calculation ends--------------------------------------------------------');
%         toc;

    end
    yi=1;
    xi=xi+1;
end

toc;

%% 2D
figure;

% 绘制向量图
xx= boundary(1):b_step:boundary(2) ;
yy= boundary(3):b_step:boundary(4) ;
xlabel('x[m]');
ylabel('y[m]');
[Y,X]=meshgrid(yy,xx);
quiver(X,Y,gx,gy);hold on;
plot(xb, yb,"k"+"^",'MarkerFaceColor','k','markersize',7);hold on;
plot(xe, ye,'or','markersize',12,'LineWidth',2);hold on;
plot(x_min, y_min,"k"+"^",'MarkerFaceColor','k','markersize',7);hold on;

% set(gca,'xtick',[],'ytick',[],'xcolor','w','ycolor','w') % 隐藏坐标轴的刻度和颜色


%% 绘制Rn——w的图
% figure;
% x= boundary(1):b_step:boundary(2) ;
% y= boundary(3):b_step:boundary(4) ;
% xlabel('x[m]');
% ylabel('y[m]');
% [Y,X]=meshgrid(yy,xx);
% % % 绘制势能场图
% h = contour(X, Y, R, 50, 'LineWidth',1.2);hold on;
% plot(xb, yb,"k"+"^",'MarkerFaceColor','k','markersize',7);hold on;
% plot(xe, ye,'or','markersize',12,'LineWidth',2);hold on;
% legend('{R}','{Bob}','{Willie}', '','','Location','northwest');



