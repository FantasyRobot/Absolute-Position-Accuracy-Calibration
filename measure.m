clear all;

joint_file =  xlsread('joint.xlsx');

err1_file = xlsread('err1.xlsx'); 
mx1 = err1_file(:,1);
my1 = err1_file(:,2);
mz1 = err1_file(:,3);
cx1 = err1_file(:,5);
cy1 = err1_file(:,6);
cz1 = err1_file(:,7);

err3_file = xlsread('err3.xlsx'); 
mx3 = err3_file(:,3);
my3 = err3_file(:,4);
mz3 = err3_file(:,5);
cx3 = err3_file(:,7);
cy3 = err3_file(:,8);
cz3 = err3_file(:,9);

figure(1)
grid on;
subplot(3,2,1);
plot(joint_file(:,1),'o-');
title("(a) 1关节角度曲线");
xlabel("测试点");
ylabel("角度(°)");

grid on;
subplot(3,2,2);
plot(joint_file(:,2),'o-');
title("(b) 2关节角度曲线");
xlabel("测试点");
ylabel("角度(°)");

grid on;
subplot(3,2,3);
plot(joint_file(:,3),'o-');
title("(c) 3关节角度曲线");
xlabel("测试点");
ylabel("角度(°)");

% figure(2)
grid on;
subplot(3,2,4);
plot(joint_file(:,4),'o-');
title("(d) 4关节角度曲线");
xlabel("测试点");
ylabel("角度(°)");

grid on;
subplot(3,2,5);
plot(joint_file(:,5),'o-');
title("(e) 5关节角度曲线");
xlabel("测试点");
ylabel("角度(°)");

grid on;
subplot(3,2,6);
plot(joint_file(:,6),'o-');
title("(f) 6关节角度曲线");
xlabel("测试点");
ylabel("角度(°)");
grid on;

figure(3)
scatter3(mx1,my1,mz1);
xlabel("x轴(m)");
ylabel("y轴(m)");
zlabel("z轴(m)");
hold on;
%origin = [0 0 0];
%for i = 1:90
%    currentPoint = [mx1(i) my1(i) mz1(i)];
%    plot3([origin(1) currentPoint(1)], [origin(2) currentPoint(2)], [origin(3) currentPoint(3)], 'k--');
%end

figure(4)
delta1 = sqrt((mx1-cx1).*(mx1-cx1)+(my1-cy1).*(my1-cy1)+(mz1-cz1).*(mz1-cz1));
plot(delta1.*1000,'o-');
hold on;
delta3 = sqrt((mx3-cx3).*(mx3-cx3)+(my3-cy3).*(my3-cy3)+(mz3-cz3).*(mz3-cz3));
plot(delta3.*1000, 'o-');
legend('标定前位置误差','标定后位置误差','location',"best");
grid on;

figure(5)
h1 = histfit(delta1.*1000);
hold on;
h2 = histfit(delta3.*1000);
hold on;
legend([h1(1), h2(1)],'标定前位置误差概率分布', '标定后位置误差概率分布','location',"best");
xlabel("误差(mm)");
ylabel("次数");
grid on;