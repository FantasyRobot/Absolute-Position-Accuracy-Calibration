clear all;clc;close all;

%% 测量坐标系
% meas=[1,0,0,4.4;
%       0,1,0,-0.42;
%       0,0,1,1.1;
%       0,0,0,1];
% rot_meas=[cos(-pi),-sin(-pi),0,0;
%            sin(-pi),cos(-pi),0,0;
%            0,0,1,0;
%            0,0,0,1];
% meas=rot_meas*meas;

%% 工具坐标系
TOOL_FRAME=zeros(7,1);
TOOL_FRAME(1,1) = 0.183424;
TOOL_FRAME(2,1) =  -0.072539;
TOOL_FRAME(3,1) = 0.384362;
TOOL_FRAME(4,1) = 1;
    
x=zeros(36,1);
sum = 0;
joint_data =  xlsread('joint_data.xlsx');
measure_data =  xlsread('measure_data_convert.xlsx');%%此处数据以转换到基坐标系

for i=1:90
    %关节角度
    theta = joint_data(i,:)*pi/180;
    
    %正运动学法栏位姿
    [P2,R2] = abs_calib_model(theta', x);
    POSE=zeros(7,1);
    POSE(1:3,1) = P2;
    POSE(4:7,1) = R2;
    
    %工具末端位姿
    POSE=pose_mult(POSE, TOOL_FRAME);
    POSE_TOOL=eye(4,4);
    POSE_TOOL(1:3,4)=POSE(1:3,1);
    POSE_TOOL(1:3,1:3)=quat2dcm([POSE(4,1) POSE(5,1) POSE(6,1) POSE(7,1)]);
    %计算值与测量值二次范数求和
    sum = sum+((POSE_TOOL(1,4)-measure_data(i,1))^2+(POSE_TOOL(2,4)-measure_data(i,2))^2+(POSE_TOOL(3,4)-measure_data(i,3))^2)^0.5;
end