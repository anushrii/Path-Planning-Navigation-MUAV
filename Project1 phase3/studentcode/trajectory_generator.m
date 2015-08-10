function [ desired_state ] = trajectory_generator(t, qn, map, path)
% TRAJECTORY_GENERATOR: Turn a Dijkstra or A* path into a trajectory
%
% NOTE: This function would be called with variable number of input
% arguments. In init_script, it will be called with arguments
% trajectory_generator([], [], map, path) and later, in test_trajectory,
% it will be called with only t and qn as arguments, so your code should
% be able to handle that. This can be done by checking the number of
% arguments to the function using the "nargin" variable, check the
% MATLAB documentation for more information.
%
% map: The map structure returned by your load_map function
% path: This is the path returned by your planner (dijkstra function)
%
% desired_state: Contains all the information that is passed to the
% controller, as in phase 2
%
% It is suggested to use "persistent" variables to store map and path
% during the initialization call of trajectory_generator, e.g.
% persistent map0 path0
% map0 = map;
% path0 = path;
persistent  map0 path0 ax ay az timeViaPoints  %tmax clock1
if nargin == 4
map0   = map;
path0  = path{1,1}; 
%clock1 = clock;
%% code here the reduced set of nodes for smoothening 

% ==============================================================================================
[viaPoints, timeViaPoints] = getNodes(map0,path0);

%===============================================================================================
ax=getCoeffs_minjerk(viaPoints,timeViaPoints,1);
ay=getCoeffs_minjerk(viaPoints,timeViaPoints,2);
az=getCoeffs_minjerk(viaPoints,timeViaPoints,3);

  
%===============================================================================================
else
%  time = etime(clock,clock1);

       for i=1:length(timeViaPoints)-1
        
        if t>=timeViaPoints(i) && t< timeViaPoints(i+1)
           
          x = ax(i,1) + ax(i,2)*t + ax(i,3)*t^2 + ax(i,4)*t^3 + ax(i,5)*t^4 + ax(i,6)*t^5;	
          y = ay(i,1) + ay(i,2)*t + ay(i,3)*t^2 + ay(i,4)*t^3 + ay(i,5)*t^4 + ay(i,6)*t^5;	
          z = az(i,1) + az(i,2)*t + az(i,3)*t^2 + az(i,4)*t^3 + az(i,5)*t^4 + az(i,6)*t^5;
          
          dx = ax(i,2) + 2*ax(i,3)*t + 3*ax(i,4)*t^2 + 4*ax(i,5)*t^3 + 5*ax(i,6)*t^4;	
          dy = ay(i,2) + 2*ay(i,3)*t + 3*ay(i,4)*t^2 + 4*ay(i,5)*t^3 + 5*ay(i,6)*t^4;	
          dz = az(i,2) + 2*az(i,3)*t + 3*az(i,4)*t^2 + 4*az(i,5)*t^3 + 5*az(i,6)*t^4;
          
          d2x = 2*ax(i,3) + 6*ax(i,4)*t + 4*3*ax(i,5)*t^2 + 5*4*ax(i,6)*t^3;	
          d2y = 2*ay(i,3) + 6*ay(i,4)*t + 4*3*ay(i,5)*t^2 + 5*4*ay(i,6)*t^3;	
          d2z = 2*az(i,3) + 6*az(i,4)*t + 4*3*az(i,5)*t^2 + 5*4*az(i,6)*t^3;
          
          pos = [x; y; z];
          vel = [dx; dy; dz];
          acc = [d2x; d2y; d2z];
         
        end
%================================================================================================    
          if(t>=timeViaPoints(end))
          
          pos = [path0(end,1); path0(end,2); path0(end,3)];
          vel = [0; 0; 0];
          acc = [0; 0; 0];
              
          end

        end    
%===============================================================================================
       
          
    
yaw = 0;
yawdot = 0;

desired_state.pos = pos(:);
desired_state.vel = vel(:);
desired_state.acc = acc(:);
desired_state.yaw = yaw;
desired_state.yawdot = yawdot;

 end

