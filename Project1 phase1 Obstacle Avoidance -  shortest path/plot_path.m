function plot_path(map, path)
% PLOT_PATH Visualize a path through an environment
%   PLOT_PATH(map, path) creates a figure showing a path through the
%   environment.  path is an N-by-3 matrix where each row corresponds to the
%   (x, y, z) coordinates of one point along the path.
boundary = map.boundary;
block = map.blocks;
for i = 1:size(block,1)
    
	x1 = block(i,1);
	x2 = block(i,4);
	y1 = block(i,2);
	y2 = block(i,5);
	z1 = block(i,3);
	z2 = block(i,6);
    
    
  	red =  block(i,7);
    green = block(i,8);
    blue = block(i,9);
    r =0;
    g= 0;
    b= 0;
    
   	if red == 255
		r = 1;
    elseif green == 255
		g = 1;
    elseif	blue == 255
		b = 1;
    end
    
	p1 = [x1 y1 z1]; 
	p2 = [x2 y1 z1];
	p3 = [x2 y1 z2];
	p4 = [x1 y1 z2];
	p5 = [x1 y2 z1];
	p6 = [x2 y2 z1];
	p7 = [x2 y2 z2];
	p8 = [x1 y2 z2];


x = [p1(1) p5(1) p2(1) p1(1) p4(1) p1(1);p2(1) p6(1) p6(1) p5(1) p3(1) p2(1);...
    p3(1) p7(1) p7(1) p8(1) p7(1) p6(1);p4(1) p8(1) p3(1) p4(1) p8(1) p5(1)];
y = [p1(2) p5(2) p2(2) p1(2) p4(2) p1(2);p2(2) p6(2) p6(2) p5(2) p3(2) p2(2);...
    p3(2) p7(2) p7(2) p8(2) p7(2) p6(2);p4(2) p8(2) p3(2) p4(2) p8(2) p5(2)];
z = [p1(3) p5(3) p2(3) p1(3) p4(3) p1(3);p2(3) p6(3) p6(3) p5(3) p3(3) p2(3);...
    p3(3) p7(3) p7(3) p8(3) p7(3) p6(3);p4(3) p8(3) p3(3) p4(3) p8(3) p5(3)];
fill3(x,y,z,[r g b]);

hold on;
grid on
end

xlim([boundary(1) boundary(4)])
ylim([boundary(2) boundary(5)])
zlim([boundary(3) boundary(6)])
xlabel('X axis')
ylabel('Y axis')
zlabel('Z axis')
plot3(path(:,1),path(:,2),path(:,3),'m','linewidth',2)

end