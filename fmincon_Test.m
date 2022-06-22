clearvars;

filename = 'fmincon_test.xls';
p = 59; %number of problems
step = 10;
eps2 = 10^(-12);
eps3 = 10^(-6);
max_calls = 10000;

timer1 = tic;

disp('Benchmarking fmincon');

A = {'function', 'Time', 'Result', 'Best Function Value', 'First Order Optimality', 'Function Calls', 'Iterations'};
writecell(A, filename, 'Sheet', 1, 'Range', 'A1');

B = cell(p,7);

parfor i = 1:p
    prob = testProblem(i);
    options = optimoptions('fmincon','Display', 'off', 'MaxFunctionEvaluations', max_calls, 'StepTolerance', eps2, 'OptimalityTolerance', eps3);
    timer2 = tic;
    [~, f_best, result, output, ~, grad] = fmincon(prob.Objective, prob.x_0,[],[],[],[],[],[],[],options);
    time = toc(timer2);
    B(i,:) = {prob.Name, time, result, f_best, norm(grad, inf), output.funcCount, output.iterations};
end

writecell(B, filename, 'Sheet', 1, 'Range', 'A2');

display('Total Time: ' + string(toc(timer1)) + ' s');

