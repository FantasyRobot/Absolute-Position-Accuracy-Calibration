 clc;
 clear;
 close all;
 m = 10;
 n = 6;
 p = 36;
 
 CostFunction = @(x) evaluate_objective(x);     %目标函数ZDT1
 nVar = 6*70;                                      %变量个数:6个关节，每个关节70组数据
 VarSize = [1 nVar];                            %变量矩阵大小
 VarMin = 0;                                    %变量值定义域
 VarMax = 1;                                    %注意: 该函数变量不能出现负值
 MaxIt = 800;                                   %最大迭代次数
 N = 100;                                        %种群规模
 nRep = 100;                                     %档案库大小
 w = 0.9;                                       %惯性权重系数
 wdamp = 0.99;                                  %惯性权重衰减率
 c1 = 1.7;                                      %个体学习因子
 c2 = 1.8;                                      %全局学习因子
 nGrid = 5;                                     %每一维的分格数
 alpha = 0.1;                                   %膨胀率
 beta = 2;                                      %最佳选择压
 gamma = 2;                                     %删除选择压
 mu = 0.1;                                      %变异概率
 empty_particle.Position = [];                  %粒子位置向量
 empty_particle.Velocity = [];                  %粒子速度向量
 empty_particle.Cost = [];                      %粒子目标值向量
 empty_particle.Best.Position = [];             %粒子最佳位置向量
 empty_particle.Best.Cost = [];                 %粒子最佳目标值向量
 empty_particle.IsDominated = [];               %粒子被支配个体向量
 empty_particle.GridIndex = [];                 %粒子栅格索引向量
 empty_particle.GridSubIndex = [];              %粒子栅格子索引向量
 pop = repmat(empty_particle,N,1);              %粒子初始空矩阵      
 init_pos=zeros(N, nVar);
 for i = 1:N  %初始化N个个体
     % 产生服从均匀分布, VarSize大小的位置矩阵
     pop(i).Position = unifrnd(VarMin,VarMax,VarSize);
     init_pos(i,:)= pop(i).Position; 
     % pop(i).Position = zeros(VarSize);
     pop(i).Velocity = zeros(VarSize);
     pop(i).Cost = CostFunction(pop(i).Position);
     pop(i).Best.Position = pop(i).Position;
     pop(i).Best.Cost = pop(i).Cost;
 end
 
 pop = DetermineDomination(pop);
 rep = pop(~[pop.IsDominated]);
 Grid = CreateGrid(rep,nGrid,alpha);
 for i = 1:numel(rep)
     rep(i) = FindGridIndex(rep(i),Grid);
     % GridIndex = 绝对位置，.GridSubIndex = 坐标位置
 end
 
 %MOPSO主循环
 for it = 1:MaxIt
     for i = 1:N %逐一个体更新速度和位置，0.5的概率发生变异
         leader = SelectLeader(rep,beta);   %从支配个体轮盘赌选出全局最佳个体
         pop(i).Velocity = w*pop(i).Velocity + ...
             c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position)+ ...
             c2*rand(VarSize).*(leader.Position-pop(i).Position);    %速度更新
         pop(i).Position = pop(i).Position+pop(i).Velocity;   %位置更新
         pop(i).Position = limitToPosition(pop(i).Position,VarMin,VarMax);   %限制变量变化范围
         pop(i).Cost = CostFunction(pop(i).Position);   %计算目标函数值
         %应用变异策略
         pm = (1-(it-1)/(MaxIt-1)^(1/mu));  % 变异概率逐渐变小
         NewSol.Position = Mutate(pop(i).Position,pm,VarMin,VarMax);
         NewSol.Cost = CostFunction(NewSol.Position);   % 计算变异后的目标值
         if Dominates(NewSol,pop(i))
             pop(i).Position = NewSol.Position;
             pop(i).Cost  = NewSol.Cost;
         else %以0.5的概率决定是否接受变异
             if rand < 0.5
                 pop(i).Position = NewSol.Position;
                 pop(i).Cost = NewSol.Cost;
             end
         end
         
         if Dominates(pop(i),pop(i).Best)   % 如果当前个体优于先前最佳个体,则替换之
             pop(i).Best.Position = pop(i).Position;
             pop(i).Best.Cost = pop(i).Cost;
         else %以0.5的概率替换个体最佳
             if rand <0.5
                 pop(i).Best.Position = pop(i).Position;
                 pop(i).Best.Cost = pop(i).Cost;
             end
         end
         
     end   %每个个体
     
     rep = [rep;pop(~[pop.IsDominated])];   %把更新后的rank=1的粒子再加到rep
     rep =  DetermineDomination(rep);
     rep = rep(~[rep.IsDominated]);
     Grid = CreateGrid(rep,nGrid,alpha); 
    for i =1:numel(rep) 
        rep(i) = FindGridIndex(rep(i),Grid); 
    end 
    if numel(rep) > nRep 
        Extra = numel(rep)-nRep; 
        for e = 1:Extra 
            rep = DeleteOneRepMemebr(rep,gamma); 
        end 
    end 
     
    disp(['迭代次数 = ',num2str(it)]); 
    w = w*wdamp; 
end 

figure(1); 
location = [rep.Cost];   %取最优结果 
 
%scatter(location(1,:),location(2,:),'filled','b'); 
plot(location(1,:),location(2,:),'o');
xlabel('f_1(x)=O_1(q)');ylabel('f_2(x)=D(q)'); 
%title('Pareto solutions'); 
box on; 
%============================= 
%计算目标函数值 
%============================= 
function f =evaluate_objective(x) 
        pi_to=pi/180.0;
        f = []; 
        q=zeros(6,1);
        J=zeros(length(x/6), 10);
        P=zeros(length(x/6), 3);
%         joint_max=[180,170,90,180,160,360];
%         joint_min=[-180,-90,-150,-180,-145,-360];
        joint_max=[120,80,80,160,90,180]*pi_to;
        joint_min=[-120,-60,-80,-160,-90,-180]*pi_to;
        %% 根据关节值计算雅可比矩阵和末端位置
        for i=1:70
            for j=1:6
                q(j,1) = (joint_min(1,j) +(joint_max(1,j) - joint_min(1,j))*x(1,j+6*(i-1)));
            end

            J(1+3*(i-1):3+3*(i-1),:)=T12B_14_Jacobian(q);

            PP = T12B_14_2(x,q);
            P(i,1)=PP(1,4);P(i,2)=PP(2,4);P(i,3)=PP(3,4);
        end


        %% 雅可比矩阵标准化
        scale= zeros(10,1);
        for i = 1:10	  
            for j =1:3*70
                if scale(i,1) < abs (J(j,i)) 
                    scale(i,1) = abs (J(j,i)) ;
                end
            end
        end

        for j=1:3*70
            for i=1:10
                summ = 0;
                for k=1:10
                    if k == i && (scale(k,1) ~= 0)
                        temp_div = 1.0 / scale(k,1); 
                        summ = summ + J(j,i) * temp_div;
                    end
                end
                J(j,i) = summ;
            end
        end

        %% 1\计算可观测指数
        S=svd(J);
        observa_1 = prod(S)^(1/10)/(70^(1/2));

        %% 2\计算全局性能指数
        px=sum(P(:,1))/70;
        py=sum(P(:,2))/70;
        pz=sum(P(:,3))/70;
        Pm_std = 0;
        for i=1:70
            Pm_std = Pm_std+((P(i,1)-px)*(P(i,1)-px)+(P(i,2)-py)*(P(i,2)-py)+(P(i,3)-pz)*(P(i,3)-pz));
        end
        Pm_std = (Pm_std/70)^0.5;%% 中心
        
        %% 3\计算均匀指数
        d_min = ones(70,1)*2000;
        d_tmp = 0;
        for i= 1:70
            for j=1:70
                d_tmp = ((P(i,1)-P(j,1))*(P(i,1)-P(j,1))+(P(i,2)-P(j,2))*(P(i,2)-P(j,2))+(P(i,3)-P(j,3))*(P(i,3)-P(j,3)))^0.5;
                if i ~= j
                    if d_tmp < d_min(i,1) && d_tmp ~= 0
                        d_min(i,1) = d_tmp;
                    end
                end
            end
        end
        d_sup=max(d_min);
        UA=Pm_std/d_sup;
        %%  4\返回指数
        % f = [observa_1;Pm_std]; 
        f = [observa_1;UA]; 
end 


%============================= 
%判断全局支配状况,返回0 = 非支配解 
%============================= 
function pop =DetermineDomination(pop) 
        nPop = numel(pop); 
        for i =1:nPop 
            pop(i).IsDominated = false;   %初始化为互不支配 
        end 
        for i = 1:nPop-1 
            for j = i+1:nPop 
                if Dominates(pop(i),pop(j)) 
                    pop(j).IsDominated = true; 
                end 
                    if Dominates(pop(j),pop(i)) 
                        pop(i).IsDominated = true; 
                    end 
            end 
        end 
end 
%============================= 
%判断两个目标值x,y的支配状态 
% x支配y,返回1;y支配x,返回0 
%============================= 
function b = Dominates(x,y) 
        if isstruct(x) 
            x=x.Cost; 
        end 
        if isstruct(y) 
            y=y.Cost; 
        end 
        b=all(x>=y) && any(x>y); 
end 
%============================= 
%创建栅格矩阵 
%============================= 
function Grid = CreateGrid(pop,nGrid,alpha) 
        c = [pop.Cost]; 
        cmin = min(c,[],2); 
        cmax = max(c,[],2); 
        dc = cmax-cmin; 
        cmin = cmin-alpha*dc; 
        cmax = cmax+alpha*dc; 
        nObj = size(c,1); 
        empty_grid.LB = []; 
        empty_grid.UB = []; 
        Grid = repmat(empty_grid,nObj,1); 
         
        for j = 1:nObj 
            cj = linspace(cmin(j),cmax(j),nGrid+1); 
            Grid(j).LB = [-inf cj]; 
            Grid(j).UB = [cj +inf]; 
        end 
end 
%============================= 
%栅格索引定位 
%============================= 
function particle = FindGridIndex(particle,Grid) 
        nObj = numel(particle.Cost); 
        nGrid = numel(Grid(1).LB); 
        particle.GridSubIndex = zeros(1,nObj); 
        for j = 1:nObj 
            particle.GridSubIndex(j) = find(particle.Cost(j)<=Grid(j).UB,1,'first'); 
            %从左到右找到第一个目标值小于栅格值的位置 
        end 
        particle.GridIndex = particle.GridSubIndex(1); 
        for j = 2:nObj   % 左上角开始数到右下角，先数行再换行继续数 
            particle.GridIndex = particle.GridIndex-1; 
            particle.GridIndex = nGrid*particle.GridIndex; 
            particle.GridIndex = particle.GridIndex + particle.GridSubIndex(j); 
        end 
end 
%============================= 
%从全局支配个体中找出一个最佳个体 
%============================= 
function leader = SelectLeader(rep,beta) 
        GI = [rep.GridIndex]; 
        OC = unique(GI); 
        %一个栅格可能被多个支配解占用 
        N = zeros(size(OC)); 
        for k =1:numel(OC) 
            N(k) = numel(find(GI == OC(k))); 
        end 
        % 计算选择概率,为了增加多样性,尽量不选多次出现的个体 
        % 如果N大P就小, 即多次出现的栅格点被选中的概率小 
        P = exp(-beta*N); 
        P = P/sum(P);  
        sci = RouletteWheelSelection(P);   %轮盘赌策略选择 
        sc = OC(sci);   % 轮盘赌选择的栅格点 
        SCM = find(GI==sc); 
        smi = randi([1 numel(SCM)]); 
        sm = SCM(smi); 
        leader = rep(sm);   %当前全局最佳位置点 
end 
%============================= 
%轮盘赌选择一个较好的支配个体 
%============================= 
function i = RouletteWheelSelection(P) 
        r = rand; 
        C = cumsum(P); 
        i = find(r<=C,1,'first'); 
end 
%============================= 
%限制变量变化范围在定义域内 
%============================= 
function Position = limitToPosition(Position,VarMin,VarMax)     
        for i =1:size(Position,2) 
            if Position(i)<VarMin 
                Position(i) = VarMin; 
            elseif Position(i) > VarMax 
                Position(i) = VarMax; 
            end 
        end 
end 
%============================= 
%删除档案库中的一个个体 
%============================= 
function rep = DeleteOneRepMemebr(rep,gamma) 
        GI = [rep.GridIndex]; 
        OC = unique(GI); 
        N = zeros(size(OC)); 
        for k = 1:numel(OC) 
            N(k) = numel(find(GI == OC(k))); 
        end 
        P = exp(gamma*N); 
        P = P/sum(P); 
        sci = RouletteWheelSelection(P); 
        sc = OC(sci); 
        SCM = find(GI == sc); 
        smi = randi([1 numel(SCM)]); 
        sm = SCM(smi); 
        rep(sm) = []; 
end 
%============================= 
%使用变异策略 
%============================= 
function xnew = Mutate(x,pm,VarMin,VarMax) 
        nVar = numel(x); 
        j = randi([1 nVar]); 
        dx = pm*(VarMax-VarMin); 
        lb = x(j)-dx; 
        if lb<VarMin 
            lb=VarMin; 
        end 
        ub = x(j)+dx; 
        if ub > VarMax 
            ub = VarMax; 
        end 
        xnew = x; 
        xnew(j) = unifrnd(lb,ub); 
end