function [Output, Boundary] = P_objective(Operation, M, Input)

switch Operation
    case 'init'
        D = 2; %number of decision variables
        MaxValue   = ones(1,D);
        MaxValue(1:2) = 1;
        MinValue   = zeros(1,D);
        MinValue(1:2) = 0;
        Population = rand(Input,D);
        Population = Population.*repmat(MaxValue,Input,1)+(1-Population).*repmat(MinValue,Input,1);   
        Output   = Population;
        Boundary = [MaxValue;MinValue];
    case 'value'
        Population = Input;
        outcome_sets = find_supremal(Population);
        %outcome_sets = find_sup_dis(Population);
        FunctionValue = outcome_sets;
        Output = FunctionValue;
        
end