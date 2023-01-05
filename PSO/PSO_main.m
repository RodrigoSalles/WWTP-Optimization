% "Dynamic Setpoint Optimization Using Metaheuristic Algorithms for
% Wastewater Treatment Plants." 
% DOI: https://doi.org/10.1109/IECON49645.2022.9968617

% Program to optimize the functioning of a WWTP represented by the BSM2
% simulator. The objective of the program is to reduce energy consumption 
% by the aeration system, represented by an artificial neural network."

% Optimization with PSO
% Minimize f(x) = model_ann_AE3.h5
% Input x1 and x2
% Subject to: definir as restrições

% Phase 1: define objetive function
% Phase 2: PSO parameters
% Phase 3: initialization of position and velocity
% Phase 4: function evaluation
% Phase 5: compute pbest and gbest
% Phase 6: update velocity and position
%               handling boundary constraints
% Pahse 7: store best value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%format short
%clear all
%clc

% To run the program, click on the simulink block 
% "To Workspace" so get_pamam gets the four correct values

% Load model trained in Python/Keras
tic
global net A1 setpoint 
modelfile = 'model_ann_AE3.h5';
net = importKerasNetwork(modelfile);

% Collect values from the BSM2 simulator in real time
rto = get_param(gcbh,'RuntimeObject');
A11 = rto.InputPort(1).Data;
A1 = [A11(1) A11(2) A11(3) A11(4)]


% Phase 2: PSO parameters
LB = [0 0 ]; % Lower bound 
UB = [10 10]; % Upper bound
m = 2; % Number of variables
n = 20; % Population size(swarm size)
wmax = 0.9; % Inertia weight maximum
wmin = 0.4; % Inertia weight mininum
c1 = 2.05; % Acceleration factor
c2 = 2.05; % Acceleration factor
Maxiter = 20; % maximum number of iteration 


for run = 1:100
    % Phase 3: initialization of position and velocity
    % Create a 10x2 matrix(inicial test)
    for i=1:n
        for j=1:m
            pos(i,j) = LB(j) + rand.*(UB(j) - LB(j));
        end
    end
    vel = 0.1.*pos; 

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Phase 4: function evaluation

    for i=1:n
        out(i,1) = fun2(pos(i,:));
    end
    % Initial pbest
    pbestval = out;
    pbest = pos;

    % Initial gbest
    [fminval,index] = min(out);
    gbest = pbest(index,:);

    iter = 1;
    while iter <= Maxiter
        w = wmax - (iter/Maxiter).*(wmax - wmin);
        
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Phase 5: compute pbest and gbest
    X = pos;
    for i=1:n
        Out(i,1) = fun2(pos(i,:));
    end
    
    
    % Update pbest values
        Har = find(out<=pbestval); % New min pbestvals
        pbest(Har,:) = X(Har,:); % update pbest position
        pbestval(Har) = out(Har); % update pbestval

        % Update gbest values
        [fbestval,ind1] = min(pbestval);
        if fbestval <= fminval
            fminvalue = fbestval;
            gbest = pbest(ind1,:);
        end   
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Phase 6: update velocity and position

        for i=1:n
            for j=1:m
                % Update velocity
                vel(i,j) = w.*vel(i,j) + c1.*rand().*(pbest(i,j)-pos(i,j))...
                    + c2.*rand().*(gbest(1,j)-pos(i,j));
                % Update position
                pos(i,j) = vel(i,j) + pos(i,j);

                % Boundary constraints
                if pos(i,j) < LB(j)
                    pos(i,j) = LB(j);
                elseif pos(i,j) > UB(j)
                    pos(i,j) = UB(j);
                end
            end
        iter = iter + 1;
        end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Pahse 7: store best value

    F_ans(run) = fun2(gbest); % Store best value in each run
    F_gbest(run,:) = gbest; % Store best position value

    end
end


[bestFUN, bestRUN] = min(F_ans);
Best_X = F_gbest(bestRUN,:)

setpoint = Best_X(1)*A1(3) + Best_X(2) 

D = horzcat(setpoint,A1);

AE = teste_pso_ann(D);

SO4ref = setpoint 

set_param('OTZ_bsm2_cl','SimulationCommand','Update')

plot(F_ans)
xlabel('Iteration')
ylabel('Fitness function value')
title('PSO convergence graph');
toc


