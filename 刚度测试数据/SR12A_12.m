function P= SR12A_12(x, q)
    %% 杆长参数
    %model_param = [185.292; 600.504; 201.003; 649.846; 105]; 
    model_param = [x(1); x(2); x(3); x(4); x(5)]; 
    for i=1:10
        x(i)=0;
    end
    %% 6轴坐标系转换法栏坐标系
    trans_to_tool=diag([1,1,1,1]);
%     trans_to_tool(1,4) = 9.9332;
%     trans_to_tool(2,4) = 50.1597;
%     trans_to_tool(3,4) = 66.1777;
    %% 误差参数占位
    abs_err = [ 0,0,0,0,0,0,...
                0,0,0,0,0,0, ...
                0,0,0,0,0,0, ...
                0,0,0,0,0,0, ...
                0,0,0,0,0,0, ...
                0,0,0,0,0,0];    
     abs_err = abs_err';
     
     P= T12B_14(x, q(1,1),q(2,1),q(3,1),q(4,1),q(5,1),q(6,1),model_param, abs_err, trans_to_tool);       
end