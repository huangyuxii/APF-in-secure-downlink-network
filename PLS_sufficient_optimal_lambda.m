
tic;

% find the lowest point with given lambda
[x_min,y_min]= PLS_lowest_xy(xb,yb,xe,ye,lambda,Pmax);
disp(['lowest point in APF= ' num2str(x_min) ' , ' num2str(y_min) ]);



% 设置步长
ds=0.01;
tra_ds=1;

% 从质点分为两段绳长分别检索
s_x0=0;

opt_mark_x0=0;
opt_mark_x1=0;
findflag=0;

% 轨迹瞬时值
x_best=0;
y_best=0;
x_save=0;
y_save=0;

% R and P 瞬时值
RR_best=0;
PP_best=0;
% R and P 累计值
R_opt=0;
P_opt=0;
E_opt=0;


 


% 判断所需的条件
dis_x0=0;
last_dis_x0=100000;
min_dis=100000;
dis_i=1;
A_mark=0;

% 绳索张力
Q=0;
A_range=[0.15, 1.95]; %[angle(x_min-x0+1j*(y_min-y0))-1.0 angle(x_min-x0+1j*(y_min-y0))+1.0];
A=mean(A_range);


%% 寻找到x0,y0的轨迹
while opt_mark_x0==0
    A1_aux=Q*cos(A);
    A2_aux=Q*sin(A);
    x=x_min;
    y=y_min;

    
    x_opt=x_min;
    y_opt=y_min;
    ii=1;
    s=0;
    while 1
       
        r=[x-xb,y-yb];
        re=[x-xe,y-ye];
        [gx,gy,P_lambda(ii+1)]=PLS_force(r,re,H,lambda,Pmax);
        if  s>=0 && s<5  % 避免一些初始值启动不了的情况
            A1_aux=A1_aux+ds/V*gx;
            A2_aux=A2_aux+ds/V*gy; 
            x=x+ds*cos(A);
            y=y+ds*sin(A);
        else
            dx=-A1_aux/(A1_aux^2+A2_aux^2)^0.5;
            dy=-A2_aux/(A1_aux^2+A2_aux^2)^0.5;
            if gx~=0 
                %判断进入区域 G~=0
                 if A_mark==0
                    bound1=[x,y];
                 end
                A1_aux=A1_aux+ds/V*gx;
                A2_aux=A2_aux+ds/V*gy;
                A_mark=1;
            elseif gx==0 && A_mark==1
                % 离开A区域
                if A_mark==1
                    bound2=[x,y];
                    s_A0=s;
                end
                A_mark=2;
            end
            x=x+dx*ds;
            y=y+dy*ds;
        end
        
        s=s+ds;     
        x_opt(ii+1)=x;
        y_opt(ii+1)=y;
        % change Rs Ps
        ii=ii+1; 

        % different
        last_dis_x0=dis_x0;
        dis_x0=norm([x-x0 y-y0]);
        if last_dis_x0<=dis_x0 & s>norm([x_min-x0 y_min-y0])
            min_dis(dis_i+1)=last_dis_x0;
            dis_i=dis_i+1;
            if min_dis(dis_i)>tra_ds
                ang_xy=angle(x-x_min+(y-y_min)*1j);
                ang_x0=angle(x0-x_min+(y0-y_min)*1j);
                if ang_xy>ang_x0
                    A_range(2)=A;
                    A=mean(A_range);
%                     disp('decreasing A');
                else
                    A_range(1)=A;
                    A=mean(A_range);
%                     disp('increasing A');
                end
              break;
            else
                % find
                disp('success! x0_find!');
                for i=1:length(x_opt)
                    x_best(i)=x_opt(length(x_opt)+1-i);
                    y_best(i)=y_opt(length(y_opt)+1-i);
%                     r=[x_best(i)-xb,y_best(i)-yb];
%                     re=[x_best(i)-xe,y_best(i)-ye];
%                     [gx,gy,P_opt]=PLS_force(r,re,H,lambda,Pmax);
%                     R_opt=R_opt+PLS_R(r,re,H,lambda,P_opt)*ds/V;
%                     RR_best(i)=R_opt;
%                     PP_best(i)=P_opt;
                end
                opt_mark_x0=1;
                if A_mark==1
                    s_A0=s;
                else
                    plot(bound2(1),bound2(2),'r*');hold on;
                end
                s_x0=s;
                break;
            end
        end

        
        
    end
%         pfigure;
%     PP_best(1)=PP_best(2);
%     xp=(1:1:length(PP_best))*10e-4;
%     plot(xp,PP_best);hold on; 
end
% disp(['s_A0:'  num2str(s_A0) ' s_x0:'  num2str(s_x0) ]);
% plot(x_opt,y_opt);hold on; 
% pause;

Q=0;
A_range=[1.15, 2.95];
A=mean(A_range);

% different
dis_x1=0;
last_dis_x1=100000;
min_dis=100000;
dis_i=1;
A_mark=0;


%% 寻找到x1,y1的轨迹
while opt_mark_x1==0
    A1_aux=Q*cos(A);
    A2_aux=Q*sin(A);
    x=x_min;
    y=y_min;
    
    x_opt=x_min;
    y_opt=y_min;
    ii=1;
    s=0;
    while 1
        r=[x-xb,y-yb];
        re=[x-xe,y-ye];
        [gx,gy,P_lambda(ii+1)]=PLS_force(r,re,H,lambda,Pmax);
        if  s>=0 && s<5  % 避免一些初始值启动不了的情况
            A1_aux=A1_aux+ds/V*gx;
            A2_aux=A2_aux+ds/V*gy; 
            x=x+ds*cos(A);
            y=y+ds*sin(A);
        else
            dx=-A1_aux/(A1_aux^2+A2_aux^2)^0.5;
            dy=-A2_aux/(A1_aux^2+A2_aux^2)^0.5;
            if gx~=0 
                %判断进入区域 G~=0
                 if A_mark==0
                    bound1=[x,y];
                 end
                A1_aux=A1_aux+ds/V*gx;
                A2_aux=A2_aux+ds/V*gy;
                A_mark=1;
            elseif gx==0 && A_mark==1
                % 离开A区域
                if A_mark==1
                    bound2=[x,y];
                    s_A1=s;
                end
                A_mark=2;
            end
            x=x+dx*ds;
            y=y+dy*ds;
        end      
        
        s=s+ds; 
        x_opt(ii+1)=x;
        y_opt(ii+1)=y;
        ii=ii+1;

%       % different
        last_dis_x1=dis_x1;
        dis_x1=norm([x-x1 y-y1]);

        if last_dis_x1<=dis_x1 & s>norm([x_min-x1 y_min-y1])
            min_dis(dis_i+1)=last_dis_x1;
            dis_i=dis_i+1;
            if min_dis(dis_i)>tra_ds
                ang_xy=angle(x-x_min+(y-y_min)*1j);
                ang_x1=angle(x1-x_min+(y1-y_min)*1j);
                if ang_xy>ang_x1
                    A_range(2)=A;
                    A=mean(A_range);
%                     disp('decreasing A');
                else
                    A_range(1)=A;
                    A=mean(A_range);
%                     disp('increasing A');
                end
                break;
            else
                % find
%                 disp('success! x1_find!');
                s_fly=s+s_x0;
                s_hover=V*T-s_fly;
%                 s_A=s_A1+s_A0+s_hover;  % when xb>xe
                if A_mark==1
                    s_A1=s;
                end
                s_A=s_A0+s_A1+s_hover;  % when xe>xb
                
                L_0=length(x_best);
                for i=1:1:s_hover/ds
                    x_best(L_0+i)=x_min;
                    y_best(L_0+i)=y_min;
                end
                L_1=length(x_best);
                for i=1:1:length(x_opt)
                    x_best(L_1+i)=x_opt(i);
                    y_best(L_1+i)=y_opt(i);
                end
                s_best=0;
                for i=1:1:length(x_best)
                    r=[x_best(i)-xb,y_best(i)-yb];
                    re=[x_best(i)-xe,y_best(i)-ye];
                    [gx,gy,P_opt]=PLS_force(r,re,H,lambda,Pmax);
                    R_opt=R_opt+PLS_real_R(r,re,H,P_opt)*ds/V;
                    RR_best(i)=R_opt;
                    PP_best(i)=P_opt;
                    s_best=s_best+ds;
                    if s_best<=s_A
                        E_opt=E_opt+P_opt*ds/V;
                    end
                end
                opt_mark_x1=1;
                break;
            end
        end
    end
%         plot(x_opt,y_opt);hold on; 
%         disp(['A:'  num2str(A_range)]);
%         pause;
end

% disp(['length A: ' num2str(s_A)]);
% plot(xb,yb,"k"+"^",'MarkerFaceColor','k','markersize',7);hold on;
% plot(xe,ye,'or','markersize',12);hold on;
plot(x_best,y_best,'LineWidth',1);hold on; 
plot(bound2(1),bound2(2),'r*');hold on;
toc;
disp(['Optimal result R-- ' num2str(R_opt)]);
disp(['Optimal result E-- ' num2str(E_opt)]);




            