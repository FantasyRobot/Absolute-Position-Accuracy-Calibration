clc;clear;close all;

empty_data = xlsread('empty/RobotJoint.xlsx')
empty_meas = xlsread('full/TrackerData.xlsx');

full_data = xlsread('empty/RobotJoint.xlsx')
full_meas = xlsread('full/TrackerData.xlsx');

empty_joint = empty_data*pi/180.0;
full_joint = full_data*pi/180.0;
meas_num = 50;

 % ����ʱ�����ߺ�ת������
empty_tool=diag([1,1,1,1]);
%empty_tool(1,4)=9.9332; empty_tool(2,4)=50.1597; empty_tool(3,4)=66.1777; 
empty_tool(1,4)=-9.9332; empty_tool(2,4)=-50.1597; empty_tool(3,4)=66.1777;
empty_base_trans=diag([1,1,1,1]);
empty_base_trans(1,1)=-0.1633;empty_base_trans(2,1)=0.9866;empty_base_trans(3,1)=0.0005;    % <N>
empty_base_trans(1,2)=-0.9865;empty_base_trans(2,2)=-0.1633;empty_base_trans(3,2)=-0.0084;  % <O>
empty_base_trans(1,3)=-0.0082;empty_base_trans(2,3)=-0.0019;empty_base_trans(3,3)=1.0000;   % <A>
empty_base_trans(1,4)=3604.7441;empty_base_trans(2,4)=1022.2203;empty_base_trans(3,4)=9.9105; % <P>

 % ����ʱ�����ߺ�ת������
full_tool=diag([1,1,1,1]);
%full_tool(1,4)=8.8600; full_tool(2,4)=15.7413; full_tool(3,4)=148.5297; 
%���������������ϵZ��ǰ��X���ϣ�������ģ�͵ķ�������Z��ǰ��X����
full_tool(1,4)=-8.8600; full_tool(2,4)=-15.7413; full_tool(3,4)=148.5297; 
full_base_trans=diag([1,1,1,1]);
full_base_trans(1,1)=-0.1632;full_base_trans(2,1)=0.9866;full_base_trans(3,1)=0.0005;
full_base_trans(1,2)=-0.9866;full_base_trans(2,2)=-0.1632;full_base_trans(3,2)=-0.0086;
full_base_trans(1,3)=-0.0084;full_base_trans(2,3)=-0.0018;full_base_trans(3,3)=1.0000;
full_base_trans(1,4)=3604.6543;full_base_trans(2,4)=1021.7632;full_base_trans(3,4)=10.8116;

%���ر궨ǰ���
empty_meas_data=diag([1,1,1,1]);
empty_model_data =diag([1,1,1,1]);
q=zeros(6,1);
x=zeros(10,1);
empty_P_err=zeros(meas_num,1);
x(1)=185;x(2)=600;x(3)=200;x(4)=650;x(5)=105;
for i=1:meas_num
    empty_meas_data(1,4) = empty_meas(i,1);  empty_meas_data(2,4) = empty_meas(i,2); empty_meas_data(3,4) = empty_meas(i,3);
    P_mes = empty_base_trans*empty_meas_data;
    q(1,1)=empty_joint(i,1);q(2,1)=-empty_joint(i,2);q(3,1)=-empty_joint(i,3);q(4,1)=empty_joint(i,4);q(5,1)=-empty_joint(i,5);q(6,1)=empty_joint(i,6);
    empty_model_data(1:3,:) = SR12A_12(x,q);
    P_model=empty_model_data*empty_tool;
    empty_P_err(i,1)=((P_mes(1,4)-P_model(1,4))^2+(P_mes(2,4)-P_model(2,4))^2+(P_mes(3,4)-P_model(3,4))^2)^0.5;
end

% ���ر궨�����
%[185.2681; 600.396; 200.294; 649.7108; 105]; 
x(1)=185.2681;x(2)=600.396;x(3)=200.294;x(4)=649.7108;x(5)=105;
empty_zeros=[0, 0.0207871, -0.0512292, 0.00635283, -0.0385474, 0];
empty_joint = empty_data-empty_zeros;
empty_joint = empty_joint*pi/180.0;
empty_Po_err=zeros(meas_num,1);
for i=1:meas_num
    empty_meas_data(1,4) = empty_meas(i,1);  empty_meas_data(2,4) = empty_meas(i,2); empty_meas_data(3,4) = empty_meas(i,3);
    P_mes = empty_base_trans*empty_meas_data;
    q(1,1)=empty_joint(i,1);q(2,1)=-empty_joint(i,2);q(3,1)=-empty_joint(i,3);q(4,1)=empty_joint(i,4);q(5,1)=-empty_joint(i,5);q(6,1)=empty_joint(i,6);
    empty_model_data(1:3,:) = SR12A_12(x,q);
    P_model=empty_model_data*empty_tool;
    empty_Po_err(i,1)=((P_mes(1,4)-P_model(1,4))^2+(P_mes(2,4)-P_model(2,4))^2+(P_mes(3,4)-P_model(3,4))^2)^0.5;
end

%���ر궨ǰ���
full_meas_data=diag([1,1,1,1]);
full_model_data =diag([1,1,1,1]);
q=zeros(6,1);
full_P_err=zeros(meas_num,1);
full_flange = zeros(meas_num,3);

x(1)=185;x(2)=600;x(3)=200;x(4)=650;x(5)=105;
for i=1:meas_num
    full_meas_data(1,4) = full_meas(i,1);  full_meas_data(2,4) = full_meas(i,2); full_meas_data(3,4) = full_meas(i,3);
    P_mes = full_base_trans*full_meas_data;
    P_mes_flange = full_tool/P_mes;
    full_flange(i,:) = P_mes_flange(1:3,4)';
    q(1,1)=full_joint(i,1);q(2,1)=-full_joint(i,2);q(3,1)=-full_joint(i,3);q(4,1)=full_joint(i,4);q(5,1)=-full_joint(i,5);q(6,1)=full_joint(i,6);
    full_model_data(1:3,:) = SR12A_12(x,q);
    P_model=full_model_data*full_tool;
    full_P_err(i,1)=((P_mes(1,4)-P_model(1,4))^2+(P_mes(2,4)-P_model(2,4))^2+(P_mes(3,4)-P_model(3,4))^2)^0.5;
end

% ���ر궨�����
x(1)=185.526;x(2)=600.6893;x(3)=201.0940;x(4)=649.205;x(5)=105;
full_zeros=[0, 0.0658279, 0.050603, -0.0324289, -0.0307646, 0];
full_joint = full_data-full_zeros;
full_joint = full_joint*pi/180.0;
full_Po_err=zeros(meas_num,1);
full_Po_comp_err=zeros(meas_num,1);
for i=1:meas_num
    full_meas_data(1,4) = full_meas(i,1);  full_meas_data(2,4) = full_meas(i,2); full_meas_data(3,4) = full_meas(i,3);
    P_mes = full_base_trans*full_meas_data;
    P_mes_flange = full_tool/P_mes;
    full_flange(i,:) = P_mes_flange(1:3,4)';
    
    q(1,1)=full_joint(i,1);q(2,1)=-full_joint(i,2);q(3,1)=-full_joint(i,3);q(4,1)=full_joint(i,4);q(5,1)=-full_joint(i,5);q(6,1)=full_joint(i,6);
    full_model_data(1:3,:) = SR12A_12(x,q);
    P_model=full_model_data*full_tool;
    full_Po_err(i,1)=((P_mes(1,4)-P_model(1,4))^2+(P_mes(2,4)-P_model(2,4))^2+(P_mes(3,4)-P_model(3,4))^2)^0.5;
end

figure (2)
subplot(2,1,1);
plot(empty_P_err, '--o');
hold on;
plot(empty_Po_err, '--*');
legend('����У׼ǰ���','����У׼�����');
xlim([1,50]);
title('(a) ���ر궨ǰ�����')
axis on;
grid on;

subplot(2,1,2);
plot(full_P_err, '--o');
hold on;
plot(full_Po_err, '--*');

legend('����У׼ǰ���','����У׼�����');
xlim([1,50]);
title('(b) ���ر궨ǰ�����')
axis on;
grid on;

% subplot(2,1,2);
% full_torq = xlsread('����ת��.xlsx');
% plot(full_torq(:,2));
% hold on;
% plot(full_torq(:,3));
% plot(full_torq(:,5));
% legend('�ؽ�2��������', '�ؽ�3��������', '�ؽ�5��������');
% axis on;
% grid on;


%% ���ؼ��β���+�նȲ���
full_torque = xlsread('����ת��.xlsx');
empty_torque = xlsread('����ת��.xlsx');
compliance=[0,-0.0000222588,0.0000642829,0.0000296263,-0.000000000466413,0];
% �ն�ϵ����Ӧ����
full_comp_joint = zeros(meas_num,6);    
empty_comp_joint = zeros(meas_num,6);   
for i=1:50
    for j=1:6
        full_comp_joint(i,j)=full_torque(i,j)*compliance(j)/15;
        empty_comp_joint(i,j)=empty_torque(i,j)*compliance(j)/15;
    end
end

x(1)=185.2681;x(2)=600.396;x(3)=200.294;x(4)=649.7108;x(5)=105;
empty_zeros=[0, 0.0207871, -0.0512292, 0.00635283, -0.0385474, 0];
full_joint = full_data-empty_zeros;
full_joint = full_joint*pi/180.0;

for i=1:meas_num
    full_meas_data(1,4) = full_meas(i,1);  full_meas_data(2,4) = full_meas(i,2); full_meas_data(3,4) = full_meas(i,3);
    P_mes = full_base_trans*full_meas_data;
    q(1,1)=full_joint(i,1);q(2,1)=-full_joint(i,2);q(3,1)=-full_joint(i,3);q(4,1)=full_joint(i,4);q(5,1)=-full_joint(i,5);q(6,1)=full_joint(i,6);
    full_model_data(1:3,:) = SR12A_12(x,q);
    P_model=full_model_data*full_tool;
    full_P_err(i,1)=((P_mes(1,4)-P_model(1,4))^2+(P_mes(2,4)-P_model(2,4))^2+(P_mes(3,4)-P_model(3,4))^2)^0.5;
end

%full_comp_joint = full_comp_joint-empty_comp_joint;
full_comp_joint = -full_comp_joint;
for i=1:meas_num
    full_meas_data(1,4) = full_meas(i,1);  full_meas_data(2,4) = full_meas(i,2); full_meas_data(3,4) = full_meas(i,3);
    P_mes = full_base_trans*full_meas_data;
    
    %q(1,1)=full_joint(i,1);q(2,1)=-full_joint(i,2);q(3,1)=-full_joint(i,3);q(4,1)=full_joint(i,4);q(5,1)=-full_joint(i,5);q(6,1)=full_joint(i,6);
    q(1,1)=full_joint(i,1)-full_comp_joint(i,1);
    q(2,1)=-full_joint(i,2)+full_comp_joint(i,2);
    q(3,1)=-full_joint(i,3)+full_comp_joint(i,3);
    q(4,1)=full_joint(i,4)-full_comp_joint(i,4);
    q(5,1)=-full_joint(i,5)+full_comp_joint(i,5);
    q(6,1)=full_joint(i,6)-full_comp_joint(i,6);
    
    full_model_data(1:3,:) = SR12A_12(x,q);
    P_model=full_model_data*full_tool;
    full_Po_comp_err(i,1)=((P_mes(1,4)-P_model(1,4))^2+(P_mes(2,4)-P_model(2,4))^2+(P_mes(3,4)-P_model(3,4))^2)^0.5;
end


figure (3)
plot(full_P_err, '--o');
hold on;
plot(full_Po_comp_err, '--*');
legend('���ز���У׼','�նȲ���');
xlim([1,50]);
title('����ʱʹ�ÿ��ز�������')
axis on;
grid on;