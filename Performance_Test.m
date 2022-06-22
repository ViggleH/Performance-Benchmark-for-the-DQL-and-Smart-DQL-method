clearvars;

k = 16; %Number of strategies
p = 59; %Number of problems

step_switch = [1 0 0; 1 0 1; 1 0 2; 1 0 3; 1 0 4; 1 1 0; 1 1 1; 1 1 2; 1 1 3; 1 1 4; 1 2 0; 1 2 1; 1 2 2; 1 2 3; 1 2 4; 2 3 5];
step = 10;
eps1 = 10^(-3);
eps2 = 10^(-12);
eps3 = 10^(-6);
max_calls = 10000;

fmincon_Result = table2array(readtable('fmincon_test', 'range', append('D2:D', num2str(p + 1))));
%Obtain Gradient

load('Gradient.mat')

for t = 2:10
    filename = 'Test-' + string(t) + '.xls';
    timer1 = tic;
    for j = 1:15
        
        disp('Test:' + string(t) +  ': Benchmarking Strategy ' + string(j));
        timer2 = tic;
        
        direct_switch = step_switch(j,1);
        quadratic_switch = step_switch(j,2);
        linear_switch = step_switch(j,3);
        
        writecell({'Direct Switch', 'Quadratic Switch', 'Linear Switch', 'StepTolerance-1', 'StepTolerance-2', 'OptimalityTolerance', 'InitalStep', 'MaxFunctionCalls'} , filename, 'Sheet', j, 'Range', 'A1');
        writecell({direct_switch, quadratic_switch, linear_switch, eps1, eps2, eps3, step, max_calls} , filename, 'Sheet', j, 'Range', 'A2');
        A = {'function', 'Result', 'Time', 'Best Function Value', 'First Order Optimality', 'Final Step', 'Function Calls', 'Iterations', 'True Gradient', 'Gradient Test', 'fmincon Test'};
        writecell(A, filename, 'Sheet', j, 'Range', 'A3');
        
        
        B = cell(p,11);
        
        parfor i = 1:p
            warning('off','all');
            prob = testProblem(i);
            [Point_List, x_best_index, stop, time, s, calls, iter] = DQL(prob.Objective, prob.x_0, step, eps1, eps2, eps3, max_calls, direct_switch, quadratic_switch, linear_switch);
            true_grad = norm(g{i}(Point_List(x_best_index(end)).Point), inf);
            %true_grad = 'N/A';
            dim = size(prob.x_0, 1);
            B(i,:) = {prob.Name, stop, time, Point_List(x_best_index(end)).Value, norm(Point_List(x_best_index(end)).Gradient, inf), s, calls, iter, true_grad, true_grad <= eps3,  Point_List(x_best_index(end)).Value - eps1 * true_grad * sqrt(dim) <= fmincon_Result(i)};
        end
        
        writecell(B, filename, 'Sheet', j, 'Range', 'A4');
        
        disp(string(toc(timer2)) + ' s');
    end
    
    disp('Total Time: ' + string(toc(timer1)) + ' s');
end
