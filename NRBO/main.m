clear
clc
close all

%%  参数设置
SearchAgents = 30;                        % population members 
Max_iterations = 50;                    % maximum number of iteration
number = 'F11';                            % 选定优化函数:F1~F23
[lb,ub,dim,fobj] = CEC2005(number);       % [lb,ub,D,y]上界，下界，维度，目标函数
disp(['Init Done ']);

%%  调用算法
disp(['PSO Start ']);
[Best_score,Best_pos,PSO_curve]=PSO(SearchAgents,Max_iterations,lb,ub,dim,fobj);  
disp(['NRBO Start ']);
[Alpha_score,Alpha_pos,NRBO_Convergence_curve]=NRBO(SearchAgents,Max_iterations,lb,ub,dim,fobj); 
disp(['PLOT Start ']);
display(['PSO在函数' [num2str(number)],'的最优为: ', num2str(Best_score)]);
display(['NRBO在函数' [num2str(number)],'的最优为: ', num2str(Alpha_score)]);

 %% Figure
figure1 = figure('Color',[1 1 1]);
G1=subplot(1,2,1,'Parent',figure1);
%func_plot(number)
title(number)
xlabel('x')
ylabel('y')
zlabel('z')
subplot(1,2,2)
G2=subplot(1,2,2,'Parent',figure1);
CNT=20;
k=round(linspace(1,Max_iterations,CNT)); %随机选CNT个点

iter=1:1:Max_iterations;
if ~strcmp(number,'F16')&&~strcmp(number,'F9')&&~strcmp(number,'F11')  &&~strcmp(number,'F24')
    semilogy(iter(k),PSO_curve(k),'m-*','linewidth',1);
    hold on
    semilogy(iter(k),NRBO_Convergence_curve(k),'r->','linewidth',1);
else
    plot(iter(k),PSO_curve(k),'m-*','linewidth',1);
    hold on
    plot(iter(k),NRBO_Convergence_curve(k),'r->','linewidth',1);
end
grid on;
title('Objective Space')
xlabel('Iteration');
ylabel('Best Fitness');
box on
legend('PSO','NRBO')
set (gcf,'position', [300,300,800,330])

