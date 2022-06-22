clearvars;
p = 59;

g = cell(1,p);
parfor i = 1:p
    prob = testProblem(i);
    dim = size(prob.x_0, 1);
    a = sym('a', [1 dim]);
    F = prob.Objective(a);
    g{i} = gradient(F, a);
    g{i} = matlabFunction(g{i}, 'vars', {a.'});
end
save Gradient.mat g;