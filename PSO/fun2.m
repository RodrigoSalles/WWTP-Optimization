% Objetive function
function output = fun2(X)
x1 = X(:,1); x2 = X(:,2); 

% 'DO', 'XND', 'SND', 'SNH', 'Ss', 'AE' 
% A1 = [XND, SND, SNH, Ss];
% A2 = [DO] dados pela fórmula

global A1
A2 = (A1(3)*x1+x2); 
C = horzcat(A2,A1);
 
% Predictions with ANN model
fx = teste_pso_ann(C);

% Define all constraints(must be converted into <= form)
Con = [];
Con(:,1) = 2*x1 + x2 - 2.5;
Con(:,2) = -2*x1 - x2 + 0.4;

% Defining penalty for each constraint
for i = length(Con)
    if Con(i)>0
        Pen(i)=1;
    else
        Pen(i)=0;
    end
end
Penalty = 1000;
output = fx + Penalty*sum(Pen);