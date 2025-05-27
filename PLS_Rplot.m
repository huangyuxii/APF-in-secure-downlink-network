% 绘制secure APF 的力场向量图
% 内含 势能场图
% clear; clc;

% xb=200 ; yb=0;
% xe=0 ; ye=0;
xb=200 ; yb=0;
xe=0 ; ye=0;

lambda=0;  %%%% change %%%%%
H=100;
snr0=10^8;
Pmax=10^-1;  %%%% change %%%%%


% 功率初始化
P_l=0;
% 最低点初始化
R_min=0;
x_min=0; y_min=0;
% interesting task area
boundary=[-600 600 -600 600];
b_step=1;


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
        P_critial = -1/2/At-1/2/Bt+sqrt(Z); 
        if At>=Bt
            P_l(xi,yi)=min(Pmax, max(0,P_critial));
            R(xi,yi)=-log2(1+At*P_l(xi,yi))+log2(1+Bt*P_l(xi,yi))+lambda*P_l(xi,yi);
        else
            P_l(xi,yi)=0;
            R(xi,yi)=0;
        end
%         disp(num2str(P_l(xi,yi)));

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
x= boundary(1):b_step:boundary(2) ;
y= boundary(3):b_step:boundary(4) ;
xlabel('x[m]');
ylabel('y[m]');
[Y,X]=meshgrid(y,x);
% % 绘制势能场图
h = contour(X, Y, R, 50, 'LineWidth',1.2);hold on;
plot(xb, yb,"k"+"^",'MarkerFaceColor','k','markersize',7);hold on;
plot(xe, ye,'or','markersize',12,'LineWidth',2);hold on;
plot(x_min, y_min,'x','markersize',10,'LineWidth',2);hold on;
% % legend('{R}','{Bob}','{Willie}', '','','Location','northwest');
% 
% % line plot between (x,y) and (x1,y1)
% test_we=x1:1:xe;
% k=(ye-y1)/(xe-x1);
% test_yy1e=k*(test_we-xe)+ye;
% plot(test_we,test_yy1e);

