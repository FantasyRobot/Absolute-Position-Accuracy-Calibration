clc;clear all; close all;

theta = zeros(1,6);

%%创建机器人T12A_14
theta1 = 0;     D1 = 0; A1 = 0.185; alpha1 = -pi/2;  offset1 = 0;
theta2 = -pi/2; D2 = 0;     A2 = 0.6;   alpha2 = 0;      offset2 = pi/2;
theta3 = 0;     D3 = 0;     A3 = 0.2;   alpha3 = -pi/2;  offset3 = 0;
theta4 = 0;     D4 = 0.65;  A4 = 0;     alpha4 = pi/2;   offset4 = 0;
theta5 = 0;      D5 = 0;    A5 = 0;     alpha5 = -pi/2;  offset5 = 0;
theta6 = 0;     D6 = 0.105; A6 = 0;     alpha6 = 0;      offset6 = 0;
L(1) = Link([theta1, D1, A1, alpha1, offset1], 'standard');
L(2) = Link([theta2, D2, A2, alpha2, offset2], 'standard');
L(3) = Link([theta3, D3, A3, alpha3, offset3], 'standard');
L(4) = Link([theta4, D4, A4, alpha4, offset4], 'standard');
L(5) = Link([theta5, D5, A5, alpha5, offset5], 'standard');
L(6) = Link([theta6, D6, A6, alpha6, offset6], 'standard');

angle=pi/180;  %转化为角度制
L(1).qlim =[-180*angle, 180*angle];
L(2).qlim =[-180*angle, 180*angle];
L(3).qlim =[-180*angle, 180*angle];
L(4).qlim =[-180*angle, 180*angle];
L(5).qlim =[-180*angle, 180*angle];
L(6).qlim =[-180*angle, 180*angle];

t12a_mdh = SerialLink(L);

%%超参数
m =70; %标定位型总数

%%初始值
joint_set = zeros(m,6);
t12a_jacobi = zeros(m*6,6);
for i = 1: 6
    joint_set(:,i) = unifrnd(L(i).qlim(1), L(i).qlim(2),m,1);
end

for i=1:m
   t12a_jacobi((i-1)*6+1:(i-1)*6+6,:)=t12a_mdh.jacob0(joint_set(i,:));
end

%SVD分解
o_sum = 1;
[U,V,S]=svd(t12a_jacobi);
for i=1:m*6
    for j=1:6
        if (V(i,j) ~= 0)
            o_sum = o_sum*V(i,j);
        end
    end
end

