function [path, num_expanded] = dijkstra(map, startOrg, goalOrg, astar)
% DIJKSTRA Find the shortest path from start to goal.
%   PATH = DIJKSTRA(map, start, goal) returns an M-by-3 matrix, where each row
%   consists of the (x, y, z) coordinates of a point on the path.  The first
%   row is start and the last row is goal.  If no path is found, PATH is a
%   0-by-3 matrix.  Consecutive points in PATH should not be farther apart than
%   neighboring cells in the map (e.g.., if 5 consecutive points in PATH are
%   co-linear, don't simplify PATH by removing the 3 intermediate points).
%
%   PATH = DIJKSTRA(map, start, goal, astar) finds the path using euclidean
%   distance to goal as a heuristic if astar is true.
%
%   [PATH, NUM_EXPANDED] = DIJKSTRA(...) returns the path as well as
%   the number of points that were visited while performing the search.

if nargin < 4
    astar = false;
end

% [map] = load_map('map0.txt', 0.1, 2.0, 0.3);
% startOrg = [0.0  -4.9 0.2];
% goalOrg  = [8.0  18.0 3.0];

% map = load_map('emptyMap.txt', 0.25, 10.0, 4.0);
% start = [1.81 2.40, 5.5];
% goal = [9.8 8.7 0.2];


maps = map.gridmap;
xy_res = map.xy_res;
z_res = map.z_res;
% margin = map.margin;
boundary = map.boundary;

[sparseGraph, ~] = updatecostmap(maps);
[start, goal, start_sub, goal_sub]=  getIndices(map,startOrg,goalOrg);
sz = size(maps);
% get min distance for A* from all nodes to goal node
% [mindist] =  getMinDist(valid_points,goal_sub,s);


% if size(graph)==[0,0]
%  cost = 0;
%  path = [];
% else
% 
% sparseGraph = getGraph (graph);

V = 1:size(sparseGraph,1); % vertices of the graph
%% distances of the vertices from the start
dist_vertices = inf(size(V));
dist_vertices_f = dist_vertices;

dist_vertices_f(start) = 0;
dist_vertices(start) = 0; %g_score[start] := 0 
dist_vertices_f(start) = dist_vertices(start)+ sqrt(sum((start_sub - goal_sub).^2)); %f_score[start] := g_score[start] + heuristic_cost_estimate(start, goal)

% sqrt(sum((start_sub - goal_sub).^2))
doesBelongToS= logical(ones(size(V))); % vertices that belong to spt_set are 1's and rest 0's

queue = [V',dist_vertices_f'] ;
 a = size(V,2);


prev = zeros(size(V));
while(a>0)
 %===============================================================================================
 %****************************** A* *************************** %
    if astar == true
  [~, u] = min(queue(:,2)); %lowest f_score[] value
  if u==goal
      
     break;
     display('angoor')
  end


  [x, ~, dis] = find(sparseGraph(:,u));
  dis(isnan(dis)) = 0;
  
  sDis = dist_vertices(u) + dis; %tentative_g_score := g_score[current] + dist_between(current,neighbor)
  prev(1,x(sDis < dist_vertices(x)')) = u;

  %for all neighbours of u
 for i = 1:size(x,1)
  if (doesBelongToS(x(i))==1)
%   hbour node = x(i)
     
     if dist_vertices(x(i))> sDis(i)
       dist_vertices(x(i)) =  sDis(i);
       
      [nx ny nz ] = ind2sub(sz,x(i));
      n_xyz = [nx ny nz];
      dist = sqrt(sum(n_xyz - goal_sub).^2);
      
       dist_vertices_f(x(i)) =  dist_vertices(x(i)) + dist;
     end

    queue(x(i),2) = dist_vertices_f(x(i)); 
  end
 end

  doesBelongToS(u) =  0;
%   dist_vertices(u) = inf; 
  queue(u,2) = inf;
  a= a-1;
  
    end
%===============================================================================================   
 %********************************** A* end ***********************
 
 %===============================================================================================
 %******************************* Dijkstras **********************
 if astar == false
  [s u] = min(queue(:,2));
 % doesBelongToS(u) =  0;
  if u==goal
     break;
  end


  [x y dis] = find(sparseGraph(:,u));
  dis(isnan(dis)) = 0;
  sDis = s + dis;
  prev(1,x(sDis < dist_vertices(x)')) = u;

  %for all neighbours of u
 for i = 1:size(x,1)
  if (doesBelongToS(x(i))==1)
    dist_vertices(x(i)) = min(dist_vertices(x(i)),sDis(i));
    queue(x(i),2) = dist_vertices(x(i)); 
  end
 end

   doesBelongToS(u) =  0;
  queue(u,2) = inf;
   a= a-1;
 %*******************************Dijkstras end ********************
 %===============================================================================================
 end
end

cost = dist_vertices(goal);
if (cost==inf)
    path = [];
else
    path = goal; 
    temp = prev(goal);
  while (temp~=start)
        path = [temp;path];
        temp = prev(temp);
  end
    path = [start; path];
end

[pathx pathy pathz] = ind2sub(size(maps),path);
i = (pathx-1)*xy_res + boundary(1);
j = (pathy-1)*xy_res + boundary(2);
k = (pathz-1)*z_res + boundary(3);
path = [i j k];
if startOrg(1)> boundary(1) && startOrg(2)> boundary(2) && startOrg(3) > boundary(3) && startOrg(1) ~= path(1,1) || startOrg(1) ~= path(1,2) || startOrg(1) ~= path(1,3)
    path = [startOrg ; path];

if goalOrg(1)<boundary(4) && goalOrg(2)<boundary(5) && goalOrg(3) < boundary (6)&& goalOrg(1) ~= path(end,1) || goalOrg(1) ~= path(end,2) || goalOrg(1) ~= path(end,3)
    path = [ path ;goalOrg(1),goalOrg(2),goalOrg(3)];
end

% path = [startOrg(1),startOrg(2),startOrg(3); path];

num_expanded = sum(~doesBelongToS);
plot_path(map, path)
end







