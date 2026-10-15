clc;
clear all;
pi_to=pi/180.0;
pos=xlsread("XYZValue.xlsx");
joint=xlsread("jointValue.xlsx");

%% 杆长模型
a1=0.185;
a3=0.2;
d0=0;
d1=0;
d2=0.6;
d3=0;
d4=0.65;                     
d5=0.105;

%% 测量坐标系到基座标系
trans_M2B = [-0.1115,-0.9937,-0.0093,3216.8206/1000.0;0.9937, -0.1114,-0.011,-1213.6612/1000.0;0.0099,-0.0104,0.9999,5.3410/1000.0;0,0,0,1];

%% 法栏到工具TCP
trans_F2T = eye(4,4);
trans_F2T(1,4) = -3.3292/1000.0;trans_F2T(2,4) = 34.6328/1000.0;trans_F2T(3,4) = 68.0271/1000.0;

% Demo1:验证理论数据与测量数据是否对应
%% 误差参数
% o_1x=0; o_1y=0; o_1z=0; o_2x=0; o_2y=0; o_2z=0; o_3x=0; o_3y=0; o_3z=0;
% o_4x=0; o_4y=0; o_4z=0; o_5x=0; o_5y=0; o_5z=0; o_6x=0; o_6y=0; o_6z=0;

% %% 计算测量坐标系下位置坐标
% for i = 1: length(pos)
%     q1 =joint(i,1)*pi_to; q2= joint(i,2)*pi_to; q3=joint(i,3)*pi_to; q4=joint(i,4)*pi_to; q5=joint(i,5)*pi_to; q6=joint(i,6)*pi_to;
%     [P1, R1] = T12Model(q1,q2,q3,q4,q5,q6,...
%                        d0, d1, d2, d3, d4, d5, a1, a3,...
%                        0, 0, 0, 0, 0, 0, 0, 0, 0, ...
%                        0, 0, 0, 0, 0, 0, 0, 0, 0 ...
%                        );
%     FlangeTCP1=eye(4,4);
%     FlangeTCP1(1:3,1:3) = R1;
%     FlangeTCP1(1:3,4) = P1;
%     ToolTCP1 = FlangeTCP1*trans_F2T
%     MeasTCP1=inv(trans_M2B)*ToolTCP1;
%     p1(i,1:3)=[ MeasTCP1(1,4),MeasTCP1(2,4), MeasTCP1(3,4) ];
% end
% 
% %% 计算测量误差
% for i = 1: length(pos)
%     delta1(1,i) = sum((p1(i,1)-pos(i,1))^2+(p1(i,2)-pos(i,2))^2+(p1(i,3)-pos(i,3))^2)^0.5;
% end
% %disp(delta1);

%% Demo2：最小二乘拟合误差参数,但没有成功
% syms o_1x o_1y o_1z;
% syms o_2x o_2y o_2z;
% syms o_3x o_3y o_3z;
% syms o_4x o_4y o_4z;
% syms o_5x o_5y o_5z;
% syms o_6x o_6y o_6z;
% for i = 1: length(pos)
%     q1 =joint(i,1)*pi_to; q2= joint(i,2)*pi_to; q3=joint(i,3)*pi_to; q4=joint(i,4)*pi_to; q5=joint(i,5)*pi_to; q6=joint(i,6)*pi_to;
%     [P, R] = T12Model(q1,q2,q3,q4,q5,q6,...
%                        d0, d1, d2, d3, d4, d5, a1, a3,...
%                        o_1x, o_1y, o_1z, o_2x, o_2y, o_2z, o_3x, o_3y, o_3z, ...
%                        o_4x, o_4y, o_4z, o_5x, o_5y, o_5z, o_6x, o_6y, o_6z ...
%                        );       
%       FlangeTCP = [R(1,1),R(1,2),R(1,3),P(1,1);
%                    R(2,1),R(2,2),R(2,3),P(2,1);
%                    R(3,1),R(3,2),R(3,3),P(3,1);
%                    0,0,0,1];
% 
%      ToolTCP = FlangeTCP*trans_F2T;
%      MeasTCP=inv(trans_M2B)*ToolTCP;
%      a(i,:)=[ MeasTCP(1,4),MeasTCP(2,4), MeasTCP(3,4) ];
% end
% 
% for i = 1: length(pos)
%     delta(1,i) = sum((a(i,1)-pos(i,1))^2+(a(i,2)-pos(i,2))^2+(a(i,3)-pos(i,3))^2);
% end

%disp(delta');

%% Demo3：最小二乘拟合误差参数,使用myfun
x0=zeros(1,18);
[x,resnorm,res,eflag,output] = lsqnonlin(@myfun,x0);

% result:
%   1 至 17 列
% 
%    -2.4256  -47.5449    6.0902   15.0521   13.5222    6.0902   -2.4418   10.0397  -13.3259  -20.0873   -7.3643   -3.8562  -19.2932  -29.7154   -4.2409   77.9085  -28.8104
% 
%   18 列
% 
%    -5.6774