clear all;
clc;
close all;

x = 1.22;

% x=0.25;
X = [0 0.5 1.0 1.5 2.0];
% X = [0.1 0.2 0.3 0.4];
Y = [0 0.191 0.341 0.433 0.477];
% Y = [0.3162 0.4472 0.5477 0.6325];
dt = zeros(length(X), length(X) + 1);


% difference table
for i = 1:length(X)
    dt(i, 1) = X(i);
    dt(i, 2) = Y(i);
end
n = length(X) - 1;
for j = 3:length(X) + 1
    for i = 1:n
        dt(i, j) = dt((i + 1), (j - 1)) - dt(i, (j - 1));
    end
    n = n - 1;
end

% finding x0 in table
x0Index = interp1(X, 1:length(X), x, 'nearest');
differences = (diff(X));
h = differences(1);
t = term(x,X,length(X),h);
p = (x - X(x0Index)) / h;

% find interpolation using Stirling's formula
global vaues;
if (t==(length(X)+1)/2) && (rem(length(X),2)~=0)
    f = StirlingMethod(Y,length(X),t,p);
end

get(0, 'ScreenSize')
f = figure;
table = uitable(f,'Data',dt,'Position',[20 20 262 204]);

% Select cell programmatically
jUIScrollPane = findjobj(table);
jUITable = jUIScrollPane.getViewport.getView;

hightLightStartColumns = 2;
jUITable.changeSelection(x0Index-1,0, true, false);
jUITable.changeSelection(x0Index-1,1, true, false);
% vaues
temp = 1;
for i = 1: length(X) + 1
    vaues(i,2)
    i
    if i == length(X) + 1
        row_index = find(dt(:,i)==vaues(i,2))
    else
        if length(X) + 1 > i+2
            row_index = find(dt(:,i+2)==vaues(i,2))
        end
    end
    
    temp = row_index;
    if(isempty(row_index) == 0)
        if rem(i,2)~=0
    %         i    
            jUITable.changeSelection((temp-2),i+1, true, false);
            jUITable.changeSelection((temp-1),i+1, true, false);
        else
    %         i
            jUITable.changeSelection((temp-1),i+1, true, false);
        end
    end
        
end

%   jUITable.changeSelection(3,4, true, false);
%   jUITable.changeSelection(2,5, true, false);


function f = StirlingMethod(y,n,t,p)
global vaues;
    f = 0;
    k = p;
    j = 0;
    for i=1:n-1
        d = diff(y,i);
        if rem(i,2)~=0
%             i
%             vala = d(t-j)
%             valb = d(t-(j+1))
            tempArr = [i d(t-j)];
            vaues = [vaues; tempArr];
            tempArr = [i d(t-(j+1))];
            vaues = [vaues; tempArr];

            f = f+k*(1/factorial(i))*(d(t-j)+d(t-(j+1)))/2;
            j = j+1;
        else

%             i
%             valc = d(t-j)
            tempArr = [i d(t-j)];
            vaues = [vaues; tempArr];
            f = f+p*k*(1/factorial(i))*d(t-j);
            k = k*(p^2-j^2);
        end
    end
    f = y(t)+f;
end

function t = term(a,x,n,h)
    d = abs(a-x);
    for i = 1:n
        j = i;
        if d(j)<=h
            if j>(n+1)/2
                j=j+1;
            end
            break
        end
    end
    t = j;
end
         