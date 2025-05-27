
%% optimal trajectory generation with given lambda
tic;

% find the lowest point with given lambda
[x_min,y_min]= PLS_lowest_xy(xb,yb,xe,ye,lambda,Pmax);
% disp(['lowest point in APF= ' num2str(x_min) ' , ' num2str(y_min) ]);

A_range=[angle(x0-x1+1j*(y0-y1)) angle(x0-x_min+1j*(y0-y_min))];
% A_range=[-1 0.7];
Q_range=[0 1000];
A=mean(A_range);
Q=mean(Q_range);


% 判定任务
ds=0.01; % 轨迹的步长
tra_ds=1; % 判定任务完成的误差
s_A=0; % A区域的飞行长度


opt_mark=0; 
ang_flag=0;

% 记录发射功率
P_lambda=0;
% 判断进入A区域
x_mid=(xe+xb)/2;
y_mid=(xe+xb)/2;
A_mark=0;  % 0 未进入 1进入 2已离开
% 记录进出A区域点
bound1=0;bound2=0;


% 


% pause;

while opt_mark==0    
    A1_aux=Q*cos(A);
    A2_aux=Q*sin(A);
    x=x0;
    y=y0;
    

    % 判断所需的条件
    dis_x1=0;
    last_dis_x1=100000;

    x_opt=x0;
    y_opt=y0;
    ii=1;
    s=0;
    
    while 1
        dx=-A1_aux/(A1_aux^2+A2_aux^2)^0.5;
        dy=-A2_aux/(A1_aux^2+A2_aux^2)^0.5;
        r=[x-xb,y-yb];
        re=[x-xe,y-ye];
        [gx,gy,P_lambda(ii+1)]=PLS_force(r,re,H,lambda,Pmax);


        if gx~=0 
            %判断进入区域 G~=0
             if A_mark==0
                bound1=[x,y];
%                 plot(bound1(1),bound1(2),'r*');hold on;
%                 disp([bound1(1),bound1(2)]);
             end
            A1_aux=A1_aux+ds/V*gx;
            A2_aux=A2_aux+ds/V*gy;
            A_mark=1;
        elseif gx==0 && A_mark==1
            % 离开A区域
            if A_mark==1
                bound2=[x,y];
%                 plot(bound2(1),bound2(2),'r*');hold on;
%                 disp([bound2(1),bound2(2)]);
                s_A=s;
            end
            A_mark=2;
        end

        x=x+dx*ds;
        y=y+dy*ds;
        s=s+ds;
        
        x_opt(ii+1)=x;
        y_opt(ii+1)=y;
        ii=ii+1;
        
        % different
        last_dis_x1=dis_x1;
        dis_x1=norm([x-x1 y-y1]);

        if dis_x1>tra_ds 
            % 绳子轨迹(x,y)还未接近目的点(x1,y1)
            % 最佳拉力范围的选择  Q↑ r(s)↓
            if angle(x-x0+1j*(y-y0))>angle(x_min-x0+1j*(y_min-y0)) & (y<0)
                % 远离终点的方向 需减小Q 所以Q在下1/2处
                Q_range(2)=Q;
                if abs(Q_range(1)-Q_range(2))<1e-6
                    Q_range=[Q/2 Q];
                end
                Q=mean(Q_range);
                break;
            end
            ang0 = angle(x0-x_min+1j*(y0-y_min));
            ang1 = pi-angle(x1-x0+1j*(y1-y0));
            ang_bac = ang0+ang1;
            ang_alpha = angle(x1-x0+1j*(y1-y0))-angle(x-x_min+1j*(y-y_min));
            r_min0 = norm([x0-x_min, y0-y_min]);
            r_temp = r_min0*sin(ang_bac)/sin(ang_alpha);
            if norm([x-x_min,y-y_min])>r_temp %r_temp>p_temp/cos(ang2_temp-ang1_temp)
                % 需增大Q 所以Q在上1/2处
%                 disp('...........................................');
%                 disp('increasing Q');
                Q_range(1)=Q;
                if abs(Q_range(1)-Q_range(2))<1e-6
                    Q_range=[Q Q*2];
                end               
                Q=mean(Q_range);
                break;
            elseif  angle(x-x_min+1j*(y-y_min))>angle(x1-x_min+1j*(y1-y_min)) %last_dis_x1<=dis_x1  %angle(x-xe+1j*(y-ye))>angle(x1-xe+1j*(y1-ye))  
                % 需减小Q 所以Q在下1/2处
%                 disp('...........................................');
%                     disp('decreasing Q');
                    Q_range(2)=Q;
                    if abs(Q_range(1)-Q_range(2))<1e-6
                        Q_range=[Q/2 Q];
                    end
                    Q=mean(Q_range);
                    break;
            end
        else
            % 绳子轨迹(x,y)接近目的点(x1,y1)
            if abs(s-V*T)>tra_ds
                % 绳长不满足条件 s=VT ，随着a↑ s↑
                % 最佳角度范围的选择
                if s>V*T
                    %需减小A 所以A在下1/2处
%                     disp('...........................................');
%                     disp('decreasing A');
                    A_range(2)=A;
%                     if abs(A_range(1)-A_range(2))<1e-6
%                         A_range=[A-0.001 A];
%                     end
                    A=mean(A_range);
                    Q_range=[0 Q*2];
                    break;
                else
                    %需增大A 所以A在上1/2处
%                     disp('...........................................');
%                     disp('increasing A');
                    A_range(1)=A;
                    if abs(A_range(1)-A_range(2))<1e-6
                            A_range=[A A+0.05];  % 区间大一些 %0.01
%                         end
                    end
                    A=mean(A_range);
                    Q_range=[0 Q*2];
                    break;
                end
            else
                % 绳长视为满足条件 s=VT
                % 结束循环
%                 disp('make a success');
                opt_mark=1;
                break;
            end
        end
    end

%     disp(['A:'  num2str(A_range)]);
%     disp(['Q:'  num2str(Q_range)]);
%     disp(['s:' num2str(s)]);
%     disp('------------------');
%     plot(x_opt,y_opt);hold on;
%     xlim([-600 600]);ylim([-600 600]);
%     pause;
end

disp('success !');
disp('......................................................................................');

% save('data/UAVtra_mat/trajectory_saveXopt_rho0.05_s100-step1.mat','x_opt');
% save('data/UAVtra_mat/trajectory_saveYopt_rho0.05_s100-step1.mat','y_opt');

% pause;

% 得到最佳 Q A 
%% 根据最佳拉力得到最优解
x_opt=x0;
y_opt=y0;
R_opt=0;
P_opt=0;
Q_opt=Q;
A_opt=A;
RR_opt=0;
PP_opt=0;

% 能量使用
E_opt=0;

x=x0;
y=y0;
A1_aux=Q*cos(A);
A2_aux=Q*sin(A);
s=0;

ii=1;
boi=1;

while 1
    dx=-A1_aux/(A1_aux^2+A2_aux^2)^0.5;
    dy=-A2_aux/(A1_aux^2+A2_aux^2)^0.5;
    % 带0是值 不带0是向量
    r0=((x-xb)^2+(y-yb)^2)^0.5;
    re0=((x-xe)^2+(y-ye)^2)^0.5;
    r=[x-xb,y-yb];
    re=[x-xe,y-ye];
    [gx,gy,P_lambda(ii+1)]=PLS_force(r,re,H,lambda,Pmax);
    A1_aux=A1_aux+ds/V*gx;
    A2_aux=A2_aux+ds/V*gy; 

    R_opt=R_opt+PLS_real_R(r,re,H,P_lambda(ii+1))*ds/V; % 正
    if s<=s_A
        E_opt=E_opt+P_lambda(ii+1)*ds/V;
    end

    x=x+dx*ds;
    y=y+dy*ds;
    s=s+ds;
    x_opt(ii+1)=x;
    y_opt(ii+1)=y;
    % change Rs Ps
    RR_opt(ii+1)=R_opt;  % R是人工势能场 RR是信息传输速率
    PP_opt(ii+1)=P_lambda(ii+1);
    ii=ii+1;

    if sqrt((x-x1)^2+(y-y1)^2)<=tra_ds
        break;
    end
end

% figure;
% plot([x0 x1],[y0 y1],'^');hold on;
plot(xb,yb,"k"+"^",'MarkerFaceColor','k','markersize',7);hold on;
plot(xe,ye,'or','markersize',12);hold on;
plot(x_opt,y_opt);hold on;
plot(bound2(1),bound2(2),'r*');hold on;
% disp([bound2(1),bound2(2)]);

toc;
disp(['Optimal result R-- ' num2str(R_opt)]);
disp(['Optimal result E-- ' num2str(E_opt)]);

% legend('Bob','Willie','APF,Rician channel, ds=1','','','APF,Rician channel, ds=10','','','APF,Rician channel, ds=20');

%% 各种画图
% figure;
% PP_opt(1)=PP_opt(2);
% xp=0:ds:s;
% plot(xp,PP_opt);hold on;
% xlim([0 130]);
% 
% Pmax_opt=linspace(0.1,0.1,s+1);
% plot(xp,Pmax_opt);hold on;
% xlim([0 130]);

% ylim([0 0.13]);
% xr=0:ds:s;
% plot(xr,RR_opt);hold on;
% xlim([0 130]);