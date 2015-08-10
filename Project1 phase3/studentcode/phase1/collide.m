 function [C] = collide(map, points)
% COLLIDE Test whether points collide with an obstacle in an environment.
%   C = collide(map, points).  points is an M-by-3 matrix where each
%   row is an (x, y, z) point.  C in an M-by-1 logical vector;
%   C(i) = 1 if M(i, :) touches an obstacle and is 0 otherwise.


maps = map.gridmap;
xy_res = map.xy_res;
z_res = map.z_res;
% margin = map.margin;
boundary = map.boundary;
% points = [0.0  -1.0 2.0; 
%          3.0  17.0 4.0; 
%          0.0  -5.0 0.5];
C = zeros(size(points,1),1);
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


if(maps(x(i),y(i),z(i))==1)
    C(i)= 1; 
end
end

C = logical(C);
 end
