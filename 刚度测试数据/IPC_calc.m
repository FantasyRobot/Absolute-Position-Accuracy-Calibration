clc; clear all;

data_num = 50;
empty_err=zeros(data_num, 1);
full_err=zeros(data_num, 1);
full_cor_err=zeros(data_num, 1);
x=zeros(10,1);
x(1)=185;x(2)=600;x(3)=200;x(4)=650;x(5)=105;

figure (1)
subplot(2,1,1);
empty_meas = xlsread('空载初始误差.xlsx')*1000;
full_meas = xlsread('满载初始误差.xlsx')*1000;
full_cor_meas = xlsread('满载补偿空载几何参数初始误差.xlsx')*1000;
for i=1: data_num
    empty_err(i,1) = sqrt(empty_meas(i,1)^2+empty_meas(i,2)^2+empty_meas(i,3)^2);
    full_err(i,1) = sqrt(full_meas(i,1)^2+full_meas(i,2)^2+full_meas(i,3)^2);
    full_cor_err(i,1) = sqrt(full_cor_meas(i,1)^2+full_cor_meas(i,2)^2+full_cor_meas(i,3)^2);
end
plot(empty_err, '--o');
hold on;
plot(full_err, '--*');
legend('空载初始误差', '满载初始误差');
title('(a) 初始误差');
axis on;
grid on;

subplot(2,1,2);
empty_opt = xlsread('空载补偿几何参数后误差.xlsx')*1000;
full_opt = xlsread('满载补偿满载几何参数后误差.xlsx')*1000;

plot(empty_opt, '--o');
hold on;
plot(full_opt, '--*');
legend('空载补偿后误差', '满载补偿后误差');
title('(b) 补偿后误差');
axis on;
grid on;

%% 空载、满载时补偿几何参数后误差
figure (2)
subplot(2,1,1);
plot(empty_err, '--o');
hold on;
plot(empty_opt, '--^');
legend('空载初始误差', '空载补偿后误差');
title('(a) 空载误差');
axis on;
grid on;

subplot(2,1,2);
plot(full_err, '--o');
hold on;
plot(full_opt, '--^');
legend('满载初始误差', '满载补偿后误差');
title('(b) 满载误差');
axis on;
grid on;

%% 满载时刚度补偿后误差
figure (3)
full_com_opt = xlsread('满载补偿空载几何误差再补偿刚度参数后误差.xlsx')*1000;

subplot(3,1,1)
plot(full_err, '--o');
hold on;
plot(full_opt, '--^');
legend('满载初始误差', '满载补偿满载参数后误差');
title('(a) 满载参数');
axis on;
grid on;

subplot(3,1,2)
plot(full_err, '--o');
hold on;
plot(full_cor_err, '--*');
legend('满载初始误差', '满载补偿空载参数后误差');
title('(b) 空载参数');
axis on;
grid on;

subplot(3,1,3)
plot(full_err, '--o');
hold on;
plot(full_com_opt, '-->');
legend('满载初始误差', '满载补偿刚度后误差');
title('(c) 空载+刚度参数');
axis on;
grid on;

% subplot(2,1,2);
% hold on;
% plot(full_opt, '--^');
% plot(full_com_opt, '--*');
% legend( '满载补偿后误差', '满载补偿刚度参数后误差');
% title('(a) 满载误差');
% axis on;
% grid on;

%% 各轴空载和满载时实际转矩
figure (4)
full_torq = xlsread('满载转矩.xlsx');
empty_torq = xlsread('空载转矩.xlsx');

subplot(4,1,1);
plot(full_torq(:,2), '--o');
hold on;
plot(empty_torq(:,2), '--*');
axis on;
grid on;
legend('满载', '空载');
title('(a)2轴实际转矩');

subplot(4,1,2);
plot(full_torq(:,3), '--o');
hold on;
plot(empty_torq(:,3), '--*');
axis on;
grid on;
legend('满载', '空载');
title('(b)3轴实际转矩');

subplot(4,1,3);
plot(full_torq(:,4), '--o');
hold on;
plot(empty_torq(:,4), '--*');
axis on;
grid on;
legend('满载', '空载');
title('(c)4轴实际转矩')

subplot(4,1,4);
plot(full_torq(:,5), '--o');
hold on;
plot(empty_torq(:,5), '--*');
axis on;
grid on;
legend('满载', '空载');
title('(d)5轴实际转矩')