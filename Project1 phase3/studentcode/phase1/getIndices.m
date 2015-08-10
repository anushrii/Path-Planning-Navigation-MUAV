% to get the indices of start and goal in the map
 function [start, goal, start_sub, goal_sub]=  getIndices(map,start,goal)


maps = map.gridmap;
xy_res = map.xy_res;
z_res = map.z_res;
% margin = map.margin;
boundary = map.boundary;
% points = [0.0  -1.0 2.0; 
%          3.0  17.0 4.0; 
%          0.0  -5.0 0.5];
points = [start ; goal];
%      
x = floor((points(:,1)- boundary(1))*1/xy_res) + 1;
y = floor((points(:,2)- boundary(2))*1/xy_res) + 1;
z = floor((points(:,3)- boundary(3))*1/z_res) + 1;

for i = 1:size(x,1);
if x(i) > size(maps,1)
    x(i) = size(maps,1);
end

if y(i) > size(maps,2)
    y(i) = size(maps,2);
end

if z(i)  > size(maps,3)
    z(i) = size(maps,3);
end

if x(i) < 0
    x(i) = 1;
end

if y(i) < 0
    y(i) = 1;
end

if z(i) < 0
    z(i) = 1;
end
end

start_sub = [x(1) y(1) z(1)];
goal_sub = [x(2) y(2) z(2)];

start    = sub2ind(size(maps),x(1),y(1),z(1));
goal = sub2ind(size(maps),x(2),y(2),z(2));


 end