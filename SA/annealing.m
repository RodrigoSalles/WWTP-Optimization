% "Dynamic Setpoint Optimization Using Metaheuristic Algorithms for
% Wastewater Treatment Plants." 
% DOI: https://doi.org/10.1109/IECON49645.2022.9968617

% Program to optimize the functioning of a WWTP represented by the BSM2
% simulator. The objective of the program is to reduce energy consumption 
% by the aeration system, represented by an artificial neural network."


% Load model trained in Python/Keras
tic
global net A1  
modelfile = 'model_ann_AE3.h5';
net = importKerasNetwork(modelfile);

% Collect values from the BSM2 simulator in real time
rto = get_param(gcbh,'RuntimeObject');
A11 = rto.InputPort(1).Data;
A1 = [A11(1) A11(2) A11(3) A11(4)]

% SA parameters 
lb = [0 -5]; % Lower bound
ub = [10 10]; % Upper bound

% function evaluation
ObjectiveFunction = @simple_objective5;
x0 = [0.5 0.5];   % Starting point
rng default % For reproducibility
options = optimoptions('simulannealbnd','PlotFcns',...
          {@saplotbestx,@saplotbestf,@saplotx,@saplotf});
[x,fval,exitFlag,output] = simulannealbnd(ObjectiveFunction,x0,lb,ub,options)

% Reference for the DO
SO4_ref = 2*x(1) + x(2)

toc                       
