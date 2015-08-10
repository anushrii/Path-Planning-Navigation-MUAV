 function map = load_map(filename, xy_res, z_res, margin)

% fprintf('%1.35f\n',margin)
% whos margin
%  filename = 'emptyMap.txt';
%   xy_res = 0.25;
%   z_res = 10;
%   margin = 4;
file = fopen(filename);
 block = [];
 boundary = [];
j= 0;
while 1
    
temp = '';
hash = '#';
 t = fgetl(file);
  if ~ischar(t)
    break
  elseif strcmp (t,temp) || strcmp(t,hash)
      continue
  end
 text = textscan(t,'%s');
 bla = text{1,1};
 if strcmp (bla{1},'boundary')
     
  %   for i = 1:6
%      number = bla{i +1};
     by_xmin = str2double(bla{2});%*1/xy_res; 
     by_ymin = str2double(bla{3});%/xy_res; 
     by_zmin = str2double(bla{4});%/z_res;
     by_xmax = str2double(bla{5});%/xy_res; 
     by_ymax = str2double(bla{6});%/xy_res; 
     by_zmax = str2double(bla{7});%/z_res; 
     boundary = [by_xmin by_ymin by_zmin by_xmax by_ymax by_zmax];
  %    end
 end
 if strcmp (bla{1},'block')
  if strcmp (bla{1},'block')
     j = j +1;
    for i = 1:9
     number = bla{i +1};
     block(j,i) = str2double(number); 
     end
 end
 end

end

% if mod((by_xmax - by_xmin),xy_res)
%     mapx = numel((by_xmin):xy_res:(by_xmax));
% else
%     mapx = numel((by_xmin):xy_res:(by_xmax)) - 1; 
% end
% %%%%%%%%%
% if  mod((by_ymax - by_ymin),xy_res)
%     mapy = numel((by_ymin):xy_res:(by_ymax));
% else
%     mapy = numel((by_ymin):xy_res:(by_ymax))-1;
% end
% %%%%%%%%%
% if     mod((by_zmax - by_zmin),z_res)
%     mapz = numel((by_zmin):z_res:(by_zmax));
% else
%     mapz = numel((by_zmin):z_res:(by_zmax))-1;
% end

mapx = ceil((by_xmax - by_xmin)*1/xy_res);% + 1;

mapy = ceil((by_ymax - by_ymin)*1/xy_res);% + 1;

mapz = ceil((by_zmax - by_zmin)*1/z_res);% + 1;

map1 = zeros(mapx,mapy,mapz);
 
if size(block)~=0
    
b_xmin = block(:,1);%*1/xy_res;
b_ymin = block(:,2);%*1/xy_res;
b_zmin = block(:,3);%*1/z_res;
b_xmax = block(:,4);%*1/xy_res;
b_ymax = block(:,5);%*1/xy_res;
b_zmax = block(:,6);%*1/z_res;
b_r = block(:,7);
b_g = block(:,8);
b_b = block(:,9);
b_rgb = [b_r ; b_g ; b_b];

% mapx = numel((by_xmin*xy_res):xy_res:(by_xmax*xy_res)) -1;
% mapy = numel((by_ymin*xy_res):xy_res:(by_ymax*xy_res)) -1;
% mapz = numel((by_zmin*z_res):z_res:(by_zmax*z_res)) -1;

margin_x = margin;%*1/xy_res;
margin_y = margin;%*1/xy_res;
margin_z = margin;%*1/z_res;
% fprintf('%1.35f\n',margin_x)
% map = zeros(mapx,mapy,mapz);

for i = 1:size(block,1)
    
    if b_xmin(i) > by_xmin
%         obs_xmin = (by_xmin - b_xmin(i)) - margin_x;
        obs_xmin = (b_xmin(i) - by_xmin)*(1/xy_res) - margin_x*(1/xy_res);
    else
        obs_xmin = (b_xmin(i) - by_xmin)*(1/xy_res);
    end
    
  
    
     if b_ymin(i) > by_ymin
        obs_ymin = (b_ymin(i) - by_ymin)*(1/xy_res) - margin_y*(1/xy_res);
      else
        obs_ymin = (b_ymin(i) - by_ymin)*(1/xy_res);
      end
      
      if b_zmin(i) > by_zmin
        obs_zmin = (b_zmin(i) - by_zmin)*(1/z_res) - margin_z*(1/z_res);
      else
        obs_zmin = (b_zmin(i) - by_zmin)*(1/z_res);
      end
    
    if b_xmax(i) < by_xmax
        obs_xmax = (b_xmax(i) - by_xmin)*(1/xy_res) + margin_x*(1/xy_res);
    else
        obs_xmax = (b_xmax(i) - by_xmin)*(1/xy_res);
    end
   
     if b_ymax(i) < by_ymax
        obs_ymax = (b_ymax(i) - by_ymin)*(1/xy_res) + margin_y*(1/xy_res);
    else
        obs_ymax = (b_ymax(i) - by_ymin)*(1/xy_res);
     end
     
     if b_zmax(i) < by_zmax
        obs_zmax = (b_zmax(i) - by_zmin)*(1/z_res) + margin_z*(1/z_res);
    else
        obs_zmax = (b_zmax(i) - by_zmin)*(1/z_res);
     end
    
     
    obs_xmin = floor(obs_xmin)+1;
    obs_ymin = floor(obs_ymin)+1;
    obs_zmin = floor(obs_zmin)+1;
    obs_xmax = floor(obs_xmax)+1;
    obs_ymax = floor(obs_ymax)+1;
    obs_zmax = floor(obs_zmax)+1;
    
    
       if obs_xmin < 0
        obs_xmin = 1;
      end
    if obs_xmax > mapx
        obs_xmax = mapx;
    end
    
      if obs_ymin < 0
        obs_ymin = 1;
     end
    if obs_ymax > mapy
        obs_ymax = mapy;
    end
    
      if obs_zmin < 0
        obs_zmin = 1;
     end
    if obs_zmax > mapz
        obs_zmax = mapz;
    end
   
    
    map1(obs_xmin:obs_xmax,obs_ymin:obs_ymax,obs_zmin:obs_zmax) = 1;
    
end

end
map.gridmap = map1;
if size(block)~=0
    map.rgb = b_rgb;
end
map.boundary = boundary;

map.xy_res = xy_res;
map.z_res = z_res;
map.margin = margin;
% by_min = boundary(1);
% by_max = boundary(2);


% LOAD_MAP Load a map from disk.
%  MAP = LOAD_MAP(filename, xy_res, z_res, margin).  Creates an occupancy grid
%  map where a node is considered fill if it lies within 'margin' distance of
%  on abstacle.



 end
