%% 调用T2Model和标定数据，形成最小二乘目标函数
function F = myfun(x)

    pi_to=pi/180.0;
    pos=xlsread("XYZValue.xlsx");
    joint=xlsread("jointValue.xlsx");
    
    %% 测量坐标系到基座标系
    trans_M2B = [-0.1115,-0.9937,-0.0093,3216.8206;0.9937, -0.1114,-0.011,-1213.6612;0.0099,-0.0104,0.9999,5.3410;0,0,0,1];

    %% 法栏到工具TCP
    trans_F2T = eye(4,4);
    trans_F2T(1,4) = -3.3292;trans_F2T(2,4) = 34.6328;trans_F2T(3,4) = 68.0271;
    
    %% 杆长模型
    a1=0.185*1000.0;
    a3=0.2*1000.0;
    d0=0;
    d1=0;
    d2=0.6*1000.0;
    d3=0;
    d4=0.65*1000.0;                     
    d5=0.105*1000.0;
    
    for i = 1: length(pos)
        q1 =joint(i,1)*pi_to; q2= joint(i,2)*pi_to; q3=joint(i,3)*pi_to; q4=joint(i,4)*pi_to; q5=joint(i,5)*pi_to; q6=joint(i,6)*pi_to;
        [P, R] = T12Model(q1,q2,q3,q4,q5,q6,...
                           d0, d1, d2, d3, d4, d5, a1, a3,...
                           x(1), x(2), x(3), x(4), x(5), x(6),  x(7), x(8), x(9), ...
                            x(10), x(11), x(12), x(13), x(14), x(15),  x(16), x(17), x(18) ...
                           );       
          FlangeTCP = [R(1,1),R(1,2),R(1,3),P(1,1);
                       R(2,1),R(2,2),R(2,3),P(2,1);
                       R(3,1),R(3,2),R(3,3),P(3,1);
                       0,0,0,1];

         ToolTCP = FlangeTCP*trans_F2T;
         MeasTCP=inv(trans_M2B)*ToolTCP;
         F(i,:) = sum((MeasTCP(1,4)-pos(i,1)*1000.0)^2+ (MeasTCP(2,4)-pos(i,2)*1000.0)^2+(MeasTCP(3,4)-pos(i,3)*1000.0)^2);
    end
end
