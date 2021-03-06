function [viaPoints, timeViaPoints] = getNodes(map,path)

%% calculating allowable nodes on path by A*

% map = load_map('maps/map1.txt', 0.1, 2.0, 0.25);
% start = {[0.0  -4.9 0.2]};
% stop  = {[6.0  18.0-6 3.0]};
% nquad = length(start);
% for qn = 1:nquad
%     path{qn} = dijkstra(map, start{qn}, stop{qn}, true);
% end
% 
% if nquad == 1
%     plot_path(map, path{1});
%     hold on
% %     plot3(via_points(:,1),via_points(:,2),via_points(:,3),'r*','linewidth',2)
% else
%     % you could modify your plot_paths to handle cell input for multiple robots
% end
% path = path{1,1};
% for i=1:size(path)-1
%     slope(i) = (path(i,3)-path(i+1,3))/ sqrt((path(i,1)-path(i+1,1))^2 + (path(i,2)-path(i+1,2))^2)
%     %slope2 = (path(i+1,3)-path(i+2,3))/ sqrt((path(i+1,1)-path(i+2,1))^2 + (path(i+1,2)-path(i+2,2))^2)
% end

% calulate slope components of x,y and z



slope = zeros(size(path,1),3);

for i=1:size(path,1)-1
    slope(i,1) = (path(i,1)-path(i+1,1));
    slope(i,2) = (path(i,2)-path(i+1,2));
    slope(i,3) = (path(i,3)-path(i+1,3));
    %slope2 = (path(i+1,3)-path(i+2,3))/ sqrt((path(i+1,1)-path(i+2,1))^2 + (path(i+1,2)-path(i+2,2))^2)
end

slopeDel = zeros(size(path,1),3);
for i = 1:size(path,1)-1
    slopeDel(i,1) = slope(i,1)-slope(i+1,1);
    slopeDel(i,2) = slope(i,2)-slope(i+1,2);
    slopeDel(i,3) = slope(i,3)-slope(i+1,3);
end
 d = find(abs(slopeDel)<1*10^-10);
 slopeDel(d) = 0;
 
 j=1;
 for i=1:size(path)-1
    if(abs(slopeDel(i,1))>0||abs(slopeDel(i,2))>0||abs(slopeDel(i,3)))
%          viaPoints(j,:) = [path(i+1,:),i+1];
       viaPoints(j,:) = path(i+1,:);
        j=j+1;  
    end
    
 end
 
 % set conditions for chosing intermediate points
 
%  i=1;
%  pathExtended = [];
%  while(i~=size(viaPoints,1)-1)
%      
%     pathExtended = [pathExtended ; path(viaPoints(i,end):5:viaPoints(i+1,end),:)];
%     i = i+1;
%  end
%  
%  
% viaPoints = pathExtended;
% viaPoints = unique(viaPoints,'rows');

m = map.gridmap;
% node = size(m,1)*size(m,2)*size(m,3);
% [xn,yn,zn] = size(m);
% [X Y Z] = ndgrid(1:xn,1:yn,1:zn);
% all = [X(:) Y(:) Z(:)];
% 
% linear = sub2ind(size(m),all(:,1),all(:,2),all(:,3));
% 
% valid =find(m(linear));
% 
% [i j k] = ind2sub(size(m),linear(valid));
% valid_points = [i(:),j(:),k(:)];
% 
% tol = 0.25;



% viaPoints = [path(1,:);viaPoints];
% point1 = viaPoints(1,:);

newVia =[];
viaPoints = path;
point1 = viaPoints(1,:);
for j=1:size(viaPoints)-1
 
    for i = j:size(viaPoints)-1     
          point2 = viaPoints(i+1,:);
          t=0:.001:1;
          C=repmat(point1,length(t),1)'+(point2-point1)'*t;
          collision = collide(map, C');
            if(collision==0)
                 boom = [point1;point2];
            end
     end
    newVia = [newVia;boom];
    point1 = boom(2,:);
end

newVia = unique(newVia,'rows');

% t=0:.01:1;
% viaPoints =[];
% for i=1:size(newVia)-1
%     point1 = newVia(i,:);
%     point2 = newVia(i+1,:);
%     C=repmat(point1,length(t),1)'+(point2-point1)'*t;
%     viaPoints = [viaPoints; C'];
% end
% viaPoints = unique(viaPoints,'rows');

viaPoints = newVia;


hold on
plot3(viaPoints(:,1),viaPoints(:,2),viaPoints(:,3),'r*','linewidth',2)
   
% viaPoints = [path(1,:);viaPoints];
distance= zeros((size(viaPoints,1)-1),1);
% segment lengths
for i=1:size(viaPoints)-1
   distance(i) = sqrt((viaPoints(i+1,1)-viaPoints(i,1))^2 + (viaPoints(i+1,2)-viaPoints(i,2))^2 + (viaPoints(i+1,3) -viaPoints(i,3))^2);
    
end
% tmax = 20;

% % dismax = sum(distance);
% % tmax = dismax/1.5; %max_vel = 1.4;
% % 
% % 
% % display(tmax)
% % 
% % % timeVia = (tmax/dismax).*distance;
% % 
% % timeVia = (tmax/dismax).*((distance).^(1/2));
% % 
% % newtimeVia = timeVia +  (tmax - sum(timeVia))/size(timeVia,1);

time = zeros(size(viaPoints,1),1);
time(1) = 0;
for i=1:size(viaPoints,1)-1
    time(i+1) = time(i) + 1.35*sqrt(distance(i));
    
end
timeViaPoints = time;



% timeViaPoints= zeros((size(viaPoints,1)-1),1);
% for i=1:size(newtimeVia,1)
%     if(i==1)
%     timeViaPoints(i) = newtimeVia(i)  ;
%     else
%     timeViaPoints(i) = newtimeVia(i) + timeViaPoints(i-1);
%     end
% end
% timeViaPoints = [0;timeViaPoints];








