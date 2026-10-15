%% 误差参数雅可比计算
clc;
clear all;
close all;

pi_to=pi/180.0;

%% 2\3\5轴限值调整前
% joint_max=[180,90,150,180,145,360];
% joint_min=[-180,-170,-90,-180,-160,-360];
%% 2\3\5轴限值调整后
joint_max=[180,170,90,180,160,360];
joint_min=[-180,-90,-150,-180,-145,-360];

%% 随机生成50组关节值
%joint_data = xlsread('关节值.xlsx');
joint_data=zeros(50,6);
for i=1:6
    joint_data(:,i) = unifrnd(joint_min(i), joint_max(i), [50,1]); 
end

q=zeros(6,1);
x=zeros(10,1);
J=zeros(length(joint_data), 10);
P=zeros(length(joint_data), 3);

%% 根据关节值计算雅可比矩阵和末端位置
for i=1:length(joint_data)
    q(1,1) = joint_data(i,1)*pi_to;
    q(2,1) = -joint_data(i,2)*pi_to;
    q(3,1) = -joint_data(i,3)*pi_to;
    q(4,1) = joint_data(i,4)*pi_to;
    q(5,1) = -joint_data(i,5)*pi_to;
    q(6,1) = joint_data(i,6)*pi_to;
    
    J(1+3*(i-1):3+3*(i-1),:)=T12B_14_Jacobian(q);
    
    PP = T12B_14_2(x,q);
    P(i,1)=PP(1,4);P(i,2)=PP(2,4);P(i,3)=PP(3,4);
end
J0=J;

%% 雅可比矩阵标准化
scale= zeros(10,1);
for i = 1:10	  
    for j =1:3*50
        if scale(i,1) < abs (J(j,i)) 
            scale(i,1) = abs (J(j,i)) ;
        end
    end
end

for j=1:3*50
    for i=1:10
        summ = 0;
        for k=1:10
            if k == i && (scale(k,1) ~= 0)
                temp_div = 1.0 / scale(k,1); 
                summ = summ + J(j,i) * temp_div;
            end
        end
        J(j,i) = summ;
    end
end

%% 1\计算可观测指数
S=svd(J);
observa_1 = prod(S.*1000)^(1/10)/(50^(1/2))

%% 2\计算全局性能指数
Pm=sum(P,1)/50;
Pm_std = norm(Pm-P)/50