function[a]=getCoeffs(path,timeViaPoints,xyz)

%% for reduced set of nodes do min_jerk
numNodes = size(path,1);
t=timeViaPoints;
%set of pieces for trajectory through via points
setPieces = numNodes-1;

%set of equations for minimum jerk = setPieces

%a = zeros(setPieces,6);
a = zeros(setPieces,4);

% do thrice for three dimensions
% for the x dimension
A = reshape(a',[],1);
knowns = zeros(size(A,1),1);
knowns(1:numNodes-1,1) = path(1:end-1,xyz);
knowns((numNodes):(numNodes + numNodes-2),1) = path(2:end,xyz);

invMtrix = zeros(size(A,1), size(knowns,1));
j = 0;
for i=1:numNodes-1
    invMtrix(i,j+1:j+4) = [ 1 ,t(i),t(i)^2, t(i)^3];% t(i)^4, t(i)^5];
    j = j+4;
end


j = 0;
for i=1:numNodes-1
    invMtrix(numNodes-1 + i, j+1:j+4) = [1 ,t(i+1),t(i+1)^2, t(i+1)^3];% t(i+1)^4, t(i+1)^5];
    j=j+4;
end

num = 2*numNodes -2;

invMtrix(end,1:4 )=[0   ,  1   ,2*t(1)  , 3*t(1)^2];% , 4*t(1)^3  5*t(1)^4]; 
%invMtrix(end,1:4 )=[ 0  ,   0   ,   2 ,    6*t(1)];% ,12*t(1)^2, 20*t(1)^3]; 
invMtrix(end-1,end-3:end )=[ 0  ,   1 ,  2*t(end)  , 3*t(end)^2];%  4*t(end)^3 , 5*t(end)^4];
%invMtrix(end,end-3:end)=[ 0  ,   0 ,     2  ,6*t(end)];% 12*t(end)^2 ,20*t(end)^3];


%% velocity at via points

j = 0;
k=2;
for i=num +1:num + numNodes-2
    
    invMtrix(i,j+1:j+8) = [0   ,  1   ,2*t(k)  , 3*t(k)^2, 0   ,  -1   ,-2*t(k)  , -3*t(k)^2];% t(i)^4, t(i)^5];
    k = k+1;
    j = j+4;
end

%% accelerations at via points
num2 = num + numNodes-2;
j = 0;
k = 2;
for i=num2 +1:num2 + numNodes-2
    
    invMtrix(i,j+1:j+8) = [0   ,  0   ,2  , 6*t(k), 0   ,  0   ,-2  , -6*t(k)];% t(i)^4, t(i)^5];
    k = k+1;
    j = j+4;
end


coeffs = invMtrix\knowns;

a = coeffs;