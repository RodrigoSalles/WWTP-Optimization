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

% Collect values from the simulator in real time
rto = get_param(gcbh,'RuntimeObject');
A11 = rto.InputPort(1).Data;
A1 = [A11(1) A11(2) A11(3) A11(4)]

problem.options.PlotFcns = @gaplotbestf;

% Objective function
ObjectiveFunction = @simple_objective5;

% Limits considered for the variables of the problem
lb = [0 -10];   % Lower bounds
ub = [10 10];  % Upper bounds

% Constraints
ConstraintFunction = @simple_constraint5;

% Number of variables
nvars = 2;

% Options tested in the problem
%opts.InitialPopulationRange = [-1 0; 1 2];
%options = optimoptions(options,'StallGenerations',50,'MaxGenerations',1000);
%options = optimoptions('ga','PlotFcn','Display',{@gaplotbestf},@outputFcn_global);

% Optimization
options=gaoptimset('PopulationSize',20,'Generations',200,'StallGenLimit',200,'SelectionFcn', @selectionroulette,'CrossoverFcn',@crossovertwopoint,'Display', 'iter','PlotFcns', {@gaplotbestf @gaplotbestindiv});
rng default % For reproducibility
[x,fval, exitFlag,Output] = ga(ObjectiveFunction,nvars,[],[],[],[],lb,ub,[], options);

%SO4ref = 2*x(1) + x(2)

toc