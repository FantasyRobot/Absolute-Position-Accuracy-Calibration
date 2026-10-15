%% 误差参数辨识优化目标函数
%% 10个误差参数
function [result] = T12B_14_opt_cost(Xc, plot_flag)
    %% 杆长参数
    model_param = [0.185; 0.6; 0.2; 0.65; 0.105]; 
    %% 测量坐标系转换机座坐标系
    %trans_to_base=[-0.1115,-0.9937,-0.0093,3.21682;0.9937,-0.1114,-0.0110,-1.21366; 0.0099,-0.0104,0.9999, 0.0053410];
    trans_to_base=[Xc(11),Xc(12),Xc(13),Xc(14);Xc(15),Xc(16),Xc(17),Xc(18); Xc(19),Xc(20),Xc(21), Xc(22)];
    %% 6轴坐标系转换法栏坐标系
    %trans_to_tool=[1,0,0,0.0346328;0,1,0,0.0033292;0,0,1,0.0680271;0,0,0,1];
    trans_to_tool=[1,0,0,Xc(23);0,1,0,Xc(24);0,0,1,Xc(25);0,0,0,1];
    %% 误差参数占位
    abs_err = [ 0,0,0,0,0,0,...
                0,0,0,0,0,0, ...
                0,0,0,0,0,0, ...
                0,0,0,0,0,0, ...
                0,0,0,0,0,0, ...
                0,0,0,0,0,0];
    abs_err = abs_err';

    pi_to=pi/180.0;
    T=ones(4,1);
    
    %% 读取测试数据
    joint_data = xlsread('关节值.xlsx');
    measure_data = xlsread('跟踪仪XYZ.xlsx')./1000.0;

    %% 根据正向运动学计算测量误差
    for i=1:length(joint_data)
        P=T12B_14(Xc,...
                  joint_data(i,1)*pi_to,-joint_data(i,2)*pi_to,-joint_data(i,3)*pi_to, ...
                  joint_data(i,4)*pi_to,-joint_data(i,5)*pi_to,joint_data(i,6)*pi_to, ...
                  model_param, abs_err, trans_to_tool);

        T(1,1)=measure_data(i,1);T(2,1)=measure_data(i,2);T(3,1)=measure_data(i,3);    
        T1=trans_to_base*T;

        cost(i,1)=sqrt((P(1,4)-T1(1,1))^2+(P(2,4)-T1(2,1))^2+(P(3,4)-T1(3,1))^2);
    end
    
    %% 测量误差均值
    mean_error = cost(1,1);
    for i=2:length(joint_data)
        mean_error = mean_error+cost(i,1);
    end
    mean_error =  mean_error/length(cost);

    %% 测量误差最大值作为优化目标
    max_error = cost(1,1);
    for i=2:length(joint_data)
        if (cost(i,1) > max_error)
        max_error = cost(i,1);
    end
    
    X=['mean error:', num2str(mean_error),' max error:', num2str(max_error)];
    disp(X);
    
    result = max_error;
    
    %% 绘制曲线
    if (plot_flag == 0)
        plot(cost,'--dg');
    end
    
    if (plot_flag == 2)
        plot(cost,'--dr');
    end
end

