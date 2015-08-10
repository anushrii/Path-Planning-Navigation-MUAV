%% minimum trajectory

%% M-file to compute a quintic polynomial reference trajectory

function a = min_jerk( d) 
% q0 = initial position
% v0 = initial velocity
% ac0 = initial acceleration
% q1 = final position
% v1 = final velocity
% ac1 = final acceleration
% t0 = initial time
% tf = final time

% q0,v0,ac0,q1,v1,ac1,t0,tf
q0 = d(1); v0= d(2); ac0 = d(3); q1 = d(4);v1 = d(5);ac1=d(6);t0=d(7); tf=d(8);
%%
t = linspace(t0,tf,100*(tf-t0));
c = ones(size(t));
%%
M = [ 1 t0 t0^2 t0^3 t0^4 t0^5;
0 1 2*t0 3*t0^2 4*t0^3 5*t0^4;
0 0 2 6*t0 12*t0^2 20*t0^3;
1 tf tf^2 tf^3 tf^4 tf^5;
0 1 2*tf 3*tf^2 4*tf^3 5*tf^4;
0 0 2 6*tf 12*tf^2 20*tf^3];
%%
b=[q0; v0; ac0; q1; v1; ac1];
a = inv(M)*b;

% qd = position trajectory
% vd = velocity trajectory
% ad = acceleration trajectory8.2. TRAJECTORIES FOR POINT T