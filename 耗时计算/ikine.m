clc;clear all;close all;
test_data = xlsread('kine.xlsx'); 

figure (1)

for i=1:6
    plot(test_data(:,i)*180/pi,'o-');
    hold on;
end
plot(test_data(:,i)-test_data(:,i),'^-');
%legend('测试关节角度','反解后关节误差','location',"best");
xlabel("测试点");
ylabel("角度(°)");
axis auto;
grid on;

figure (2)
plot(test_data(:,7),'o-');
hold on;
plot(test_data(:,8),'o-');
legend('解析反解运算耗时','迭代反解运算耗时','location',"best");
xlabel("测试点");
ylabel("时长(us)");
axis auto;
grid on;

figure(3)
plot(test_data(:,9),'o-');
hold on;
plot(test_data(:,8),'o-');
legend('有误差参数运算耗时','无误差参数运算耗时','location',"best");
xlabel("测试点");
ylabel("时长(us)");
axis auto;
grid on;