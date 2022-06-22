clearvars;


n = 16; %Number of strategies
p = 59; %Number of problems
test = 10; % Number of Test
T = zeros(p, n, test);
success_count = test * ones(p, 15);
for t = 1:test
    filename = 'Test-' + string(t) + '.xls';
    k = 0;
    
    
    for j = 1:15
        
        k = k + 1;
        T(:, k, t) = table2array(readtable(filename, 'Sheet', 'Sheet' + string(j), 'range', append('G4:G', num2str(3 + p))));
        stop = table2array(readtable(filename, 'Sheet', 'Sheet' + string(j), 'range', append('B4:B', num2str(3 + p))));
        true_grad = table2array(readtable(filename, 'Sheet', 'Sheet' + string(j), 'range', append('J4:J', num2str(3 + p))));
           
        for i = 1:p
            if(true_grad(i) ~= 1)
                success_count(i,j) = success_count(i,j) - 1;
            end
        end
        
        
    end
    
    
    for j = 16
        k = k + 1;
        T(:, k, t) = table2array(readtable('Test-1.xls', 'Sheet', 'Sheet' + string(j), 'range', append('G4:G', num2str(3 + p))));
        stop = table2array(readtable('Test-1.xls', 'Sheet', 'Sheet' + string(j), 'range', append('B4:B', num2str(3 + p))));
        true_grad = table2array(readtable('Test-1.xls', 'Sheet', 'Sheet' + string(j), 'range', append('J4:J', num2str(3 + p))));
                
        for i = 1:23
            
            if(true_grad(i) ~= 1)
                T(i, k, t) = 0;
            end
            
        end
    end
end

T = mean(T, 3);


for i  = 1:size(success_count, 1)
    for j = 1:size(success_count, 2)
        if success_count(i, j) == 0
            T(i, j) = 0;
        else
            T(i, j) = (test / success_count(i,j)) * T(i, j);
        end
    end
end

for h = 1:n
    
    str = table2array(readtable('Test-1.xls', 'Sheet', 'Sheet' + string(h), 'range', 'A2:C2'));
    if str(1) == 2
        s1 = 'S';
    else
        s1 = str(1);
    end
    if str(2) == 3
        s2 = 'S';
    else
        s2 = str(2);
    end
    if str(3) == 5
        s3 = 'S';
    else
        s3 = str(3);
    end
        
    
    leg(h) = 'Strategy ' + string(s1) + string(s2) + string(s3);
end


writematrix(leg, 'T.xls', 'Sheet', 1, 'range', 'A1');
writematrix(T, 'T.xls', 'Sheet', 1, 'range', 'A2');
%{
perf(T, leg, 1);
set(gca,'fontsize',14);
gca.XAxisLocation = 'origin';
gca.YAxisLocation = 'origin';
set(gcf, 'Position',  [0, 0, 1280, 720]);
%title('Disable/ Original/ Line Search');
%}

