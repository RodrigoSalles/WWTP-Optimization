% Function that sets the restrictions to the problem
function [c, ceq] = simple_constraint5(x)

c = [-5 + 2*x(1) + x(2);
     0.4 - 2*x(1) - x(2)];

ceq = [];