% Function that sets the DO reference
function y = simple_objective5(x) 
global net
x1 = x(1);
x2 = x(2);

global A1
A2 = (A1(3)*x1+x2); 
C = horzcat(A2,A1);

% Prediction of K and B values
y =predict(net,C);

do_ref = 2*x1 + x2;

% Penalty for out-of-scope values
if do_ref > 4 | do_ref < 0
    y = y*100000;
end
