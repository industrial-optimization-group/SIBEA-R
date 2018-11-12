function outcome_sets = find_supremal(Population)
[m,n] = size(Population);

lb = [0.8, -inf];
ub = [1.4, inf];
x0 = [0.8,10];


options.Algorithm = 'sqp';
A = [];
b = [];
Aeq = [];
beq = [];
outcome_sets = zeros(m, 12);
for i = 1:m 
    %DTLZ2
    funf1 = @(x) (1+sum(( Population(i,1:end)-0.5).^2))*cos(x(1)*Population(i,1)*pi/2)*-1;
    funf2 = @(x) (1+sum((Population(i, 1:end)-0.5).^2))*sin(x(1)*Population(i,1)*pi/2)*-1;

    x = fmincon(funf1,x0,A,b, Aeq, beq, lb, ub, [], options);
    %x = ga(funf1, 2, A, b, Aeq, beq, lb, ub);
    payoff(:,1) = evaluate(Population(i,:), x);
    
    x = fmincon(funf2,x0,A,b, Aeq, beq, lb, ub, [], options);
   %x = ga(funf2, 2, A, b, Aeq, beq, lb, ub);
    payoff(:,2) = evaluate(Population(i,:), x);
   
    nad = max(payoff);
    ideal = diag(payoff);
    [noref, ReferencePoints] = ReferenceVectorGenerator(5,0,2);
    
   
    sol = [];
    for j = 1: noref
        
        ReferencePoints(j,:) = ReferencePoints(j,:).*(nad-ideal') + ideal';
        ref = ReferencePoints(j,:);
       
        w1 = 1/6 * (j-1);
       w2 = 1-w1;
       w = [w1, w2];
      
       
        fun = @(x) x(2) +  0.01 * (w(1)*((1+sum((Population(i, 1:end)-0.5).^2))*cos(x(1)*Population(i,1)*pi/2)*-1) +...
             w(2)*((1+sum(( Population(i, 1:end)-0.5).^2))*sin(x(1)*Population(i,1)*pi/2)*-1));

        nonlcon = @(x)constr(Population(i,:), ReferencePoints(j,:), x,  w);
%         rng default % For reproducibility
%         ms = MultiStart;
%     
%         problem = createOptimProblem('fmincon','x0',x0,...
%     'objective',fun,'lb',lb,'ub',ub, 'nonlcon', nonlcon, 'options', options);
% [x,fval,exitflag,outpt,solutions] = run(ms,problem,30);
        x = fmincon(fun,x0,A,b, Aeq, beq, lb, ub, nonlcon, options);
        
        sol = [sol , evaluate(Population(i,:), x)];
        
        
    end
    outcome_sets(i,:) = sol;  
end
%outcome_sets
outcome_sets = outcome_sets.*-1;





function f = evaluate(Population, x)
%DTLZ2

g = sum((Population(1:end)-0.5).^2);
f1 = (1+g)*cos(x(1)*Population(1)*pi/2)*-1;
f2 = (1+g)*sin(x(1)*Population(1)*pi/2)*-1;

f = [f1, f2];



function [c,ceq] = constr(Population, ReferencePoint, x, w)

 g = sum(( Population(1:end)-0.5).^2);
 f1 = (1+g)*cos(x(1)*Population(1)*pi/2)*-1;
 f2 = (1+g)*sin(x(1)*Population(1)*pi/2)*-1;

c(1) = w(1)*(f1- ReferencePoint(1))-x(2);
c(2) = w(2)*(f2- ReferencePoint(2))-x(2);
ceq = [];
