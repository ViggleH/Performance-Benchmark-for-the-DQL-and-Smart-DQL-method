function perf(T, leg, colors, logplot)
%PERF    Performace profiles
%
% PERF(T,logplot)-- produces a performace profile as described in
%   Benchmarking optimization software with performance profiles,
%   E.D. Dolan and J.J. More', 
%   Mathematical Programming, 91 (2002), 201--213.
% Each column of the matrix T defines the performance data for a solver.
% Failures on a given problem are represented by a NaN.
% The optional argument logplot is used to produce a 
% log (base 2) performance plot.
%
% This function is based on the perl script of Liz Dolan.
%
% Jorge J. More', June 2004

if (nargin < 4) logplot = 0; end

%colors  = ['m' 'b' 'r' 'g' 'c' 'k' 'y'];
%{
colors  = [ [0 0 0];[0 0 1];[0 1 0];[0 1 1];[1 0 0];[1 0 1];
            [0 0 0.5];[0 0.5 0];[0 0.5 0.5];[0.5 0 0];[0.5 0 0.5];[0.5 0.5 0];
            [0.3 0.9 0.5];[0.7 0.3 0.5];[0.5 0.3 0.5];[0.3 0.3 0.7];[0.2 0.5 0.9];[0.1 0.4 0.3];[0.1 1 0.5];[0.2 0.1 0.5];[0.8 0.3 1];[0.1 0.3 0.4];[0.2 0.5 0.7];[0.1 0.8 0.3];[1 0 0];[0 0 1];[0 1 0];[1 0 0];[0 0 1];[0 1 0];[1 0 0];[0 0 1];[0 1 0]
          ];
%}
%lines   = cellstr(char( '-.', '--', ':', '-'));
lines   = [ '-.' '--' ':' '-'];
markers = ['x' '>'  'o' 'v' 's' 'd' '*' '+' '.' '^' 'v' '>' '<' 'p' 'h' 'none' 'x' '>' ];

[np,ns] = size(T);

% Minimal performance per solver

minperf = min(T,[],2);

% Compute ratios and divide by smallest element in each row.

r = zeros(np,ns);
for p = 1: np
  r(p,:) = T(p,:)/minperf(p);
end

if (logplot) r = log2(r); end

max_ratio = max(max(r));

% Replace all NaN's with twice the max_ratio and sort.

r(find(isnan(r))) = 2*max_ratio;
r = sort(r);

% Plot stair graphs with markers.
clf;
max_xs = 0;
for s = 1: ns
 [xs,ys] = stairs(r(:,s),[1:np]/np); 
 for i = 1:xs(end)
     if isinf(xs(i))
         break;
     end
 end
if xs(i-1) > max_xs
    max_xs =  xs(i - 1);
end
end

for s = 1: ns
 [xs,ys] = stairs(r(:,s),[1:np]/np); 
 temp = floor((s-1)./5)+1;
 %set(gca, 'LineStyle', '-');
 for i = 1:xs(end)
     if isinf(xs(i))
         break;
     end
 end
 xs = xs(1:i);
 ys = ys(1:i);
 xs(end) = max_xs;
 ys(end) = ys(i);
 plot(xs,ys,'Color', colors(s,:),'LineWidth' ,1.3, 'Marker', markers(temp), 'LineStyle', '-');

 hold on;
end

legend(leg, 'Location', 'northeast', 'Interpreter','latex');
%legend('Strategy 100','Strategy 101','Strategy 102','Strategy 103','Strategy 110','Strategy 111','Strategy 112','Strategy 113', 'Strategy 120','Strategy 121','Strategy 122','Strategy 123','Strategy 200','Strategy 201', 'Strategy 202','Strategy 203','Strategy 210','Strategy 211','Strategy 212','Strategy 213','Strategy 220','Strategy 221','Strategy 222','Strategy 223','Strategy 320', 'Strategy 420', 'Strategy 224');
%legend('Strategy10','Strategy11','Strategy12','Strategy13','Strategy14', 'Strategy15','Strategy16','Strategy17','Strategy18');
%legend('QBB', 'QBN',	'QBS',	'QNB',	'QNN',	'QNS',	'QSB',	'QSN',	'QSS',	'NBB',	'NBN',	'NBS',	'NNB',	'NNN',	'NNS',	'NSB',	'NSN',	'NSS');
%legend('NBB',	'NBN',	'NBS',	'NNB',	'NNN',	'NNS',	'NSB',	'NSN',	'NSS');
%legend('QBB', 'QBN',	'QBS',	'QNB',	'QNN',	'QNS',	'QSB',	'QSN',	'QSS');
%legend('QB',	'QN',	'QS',	'NB',	'NN',	'NS');
%legend('rqlif', 'disable quadratic step', 'disable linear step', 'disable quadratic/linear step');

if (logplot) 
    %{
    xlabel(strcat('log_{2}(\tau)')); 
    ylabel('\rho_s(log_{2}(\tau))');
    %}
    xlabel('$\log_{2}$ Ratio of Function Calls Used Compared to Best Method', 'Interpreter','latex'); 
    ylabel('Portion of Problems Solved', 'Interpreter','latex');
else
    xlabel('Ratio of Function Calls Used Compared to Best Method');
    ylabel('Portion of Problems Solved');
end


% Axis properties are set so that failures are not shown,
% but with the max_ratio data points shown. This highlights
% the "flatline" effect.

axis([ 0 1.1*max_ratio 0 1 ]);

% Legends and title should be added.