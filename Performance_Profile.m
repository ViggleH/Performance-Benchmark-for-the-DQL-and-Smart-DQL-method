clearvars;

%Compare candidates
%n = 1:8;   %mods benchmark
%n = 2:4;   %Linear
%n = 6:8;   %Linear
%n = [13 15];    %Direct
%n = [12 14 16]     %Direct
%n = [1 5 9];    %DH Quad
%n = 1:12;      %DH Quad
%n = 15:17;      %DH Linear
%n = [17 18];   %DH Direct?
%n = [1:18];
%n = [1:12];
%n = [1 5 9 13];
%n = [2 6 10 14];
%n = [3 7 11 15];
%n = [4 8 12 16];
%n = [13:17];
n = [1:16];
max_calls = 10000;


h = 1;
for i = n
    T(:, h) = table2array(readtable('T.xls', 'Sheet', 'Sheet1', 'range', append(char(i + 64), '2:', char(i + 64), '60')));
    for j = 1:size(T, 1)
        if T(j, h) == 0 || T(j, h) > max_calls
            T(j, h) = inf;
        end
    end
    leg(h) = readcell('T.xls', 'Sheet', 'Sheet1', 'range', append(char(i + 64), '1:', char(i + 64), '1'));
    h = h + 1;    
end

%colors = [[0.7 0 0]; [0 0 0.7]; [1 0 0]; [0 0 1]];
%colors = [[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5];[0 0 0];[0 0 0];[0 0 0];[0 0 0]];


colors  = [ [0 0 0];[0 0 0.7];[0 0.7 0];[0 0.7 0.9];[1 0.4 0.1];
            [0 0 0];[0 0 0.7];[0 0.7 0];[0 0.7 0.9];[1 0.4 0.1];
            [0 0 0];[0 0 0.7];[0 0.7 0];[0 0.7 0.9];[1 0.4 0.1];
            [0.9 0.9 0]];


%colors  = [[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5];[0.5 0.5 0.5];[0 0 0];[0 0 0];[0 0 0];[0 0 0]];


perf(T, leg, colors, 1);
set(gca,'fontsize',14);
gca.XAxisLocation = 'origin';
gca.YAxisLocation = 'origin';
set(gcf, 'Position',  [0, 0, 1280, 720]);
%title('Performace Profile for the $DQL$ Methods with Different Strategy Combinations', 'Interpreter','latex');
%title('Performace Profile for the Quadratic Step Strategies of $DQL$ Methods', 'Interpreter','latex');
%title('Performace Profile for the Linear Step Strategies of $DQL$ Methods', 'Interpreter','latex');
title('Performace Profile for the $sDQL$ Method and the $DQL$ Methods', 'Interpreter','latex');

