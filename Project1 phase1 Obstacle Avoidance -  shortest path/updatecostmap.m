
 function [costMap, valid_points] = updatecostmap(m)

%  m = map.gridmap;
node = size(m,1)*size(m,2)*size(m,3);
[xn,yn,zn] = size(m);
[X Y Z] = ndgrid(1:xn,1:yn,1:zn);
all = [X(:) Y(:) Z(:)];

linear = sub2ind(size(m),all(:,1),all(:,2),all(:,3));

valid =find(~m(linear));

[i j k] = ind2sub(size(m),linear(valid));
valid_points = [i(:),j(:),k(:)];

[nX nY nZ] = ndgrid([-1 0 1],[-1 0 1],[-1 0 1]);
neighbours = [nX(:) nY(:) nZ(:)];
neighbours(ismember(neighbours,[0,0,0],'rows'),:) = [];

% for converting in to a 3D array
D_3 = reshape(neighbours',1,3,[]);
neighbours_3D = bsxfun(@plus,valid_points,D_3);

% making 3D matrix for nodes
% validp = repmat(valid_points,1,26);
% valid_3D = reshape(validp,[],3,26);

% distances = sqrt(sum(((valid_3D - neighbours_3D).^2),2));



v1 = reshape(valid_points,1,[]);
v2 = repmat(v1,26,1);
valid2D = reshape(v2,[],3);
neighbour2D = reshape((permute(neighbours_3D,[3 1 2])),[],3);
% distances2D = reshape((permute(distances,[3 1 2])),[],1);

inValx = find(neighbour2D(:,1)<1);
neighbour2D(inValx,:) = [];
valid2D(inValx,:) = [];
% distances2D(inValx,:) = [];

inValy = find(neighbour2D(:,2)<1);
neighbour2D(inValy,:) = [];
valid2D(inValy,:) = [];
% distances2D(inValy,:) = [];

inValz = find(neighbour2D(:,3)<1);
neighbour2D(inValz,:) = [];
valid2D(inValz,:) = [];
% distances2D(inValz,:) = [];


inValx_ = find(neighbour2D(:,1)>size(m,1));
neighbour2D(inValx_,:) = [];
valid2D(inValx_,:) = [];
% distances2D(inValx_,:) = [];

inValy_ = find(neighbour2D(:,2)>size(m,2));
neighbour2D(inValy_,:) = [];
valid2D(inValy_,:) = [];
% distances2D(inValy,:) = [];

inValz_ = find(neighbour2D(:,3)>size(m,3));
neighbour2D(inValz_,:) = [];
valid2D(inValz_,:) = [];
% distances2D(inValz_,:) = [];

distances2D = sqrt(sum(((valid2D - neighbour2D).^2),2));

valid2D_idx = sub2ind(size(m),valid2D(:,1),valid2D(:,2),valid2D(:,3));
neighbour2D_idx = sub2ind(size(m),neighbour2D(:,1),neighbour2D(:,2),neighbour2D(:,3));

ind = find(m(neighbour2D_idx)==0);
valid2D_idx = valid2D_idx(ind);
neighbour2D_idx = neighbour2D_idx(ind);
distances2D = distances2D(ind);

costMap = (sparse(valid2D_idx, neighbour2D_idx, distances2D, node,node))';
%
 end

% cost_matrix = sparse(node,node);
% 
% for i = 1:size(valid_points,1)
%     i
%    node = valid_points(i,:);
%    node_idx = sub2ind(size(m),node(1),node(2),node(3));
%    nebor = bsxfun(@plus,node,neighbours);
%    nebor_inx = sub2ind(size(m),nebor(:,1),nebor(:,2),nebor(:,3));
%    valid_neighbors =  find(m(nebor_inx)==0);
%    [nebor_i nebor_j nebor_k] = ind2sub(size(m),valid_neighbors);
%    nb = [nebor_i(:),nebor_j(:),nebor_k(:)];
%    
%    id_nb = sub2ind(size(m), nb(:,1),nb(:,2),nb(:,3));
%    distances = pdist2(node, nb);
%    
%    cost_matrix(id_nb,node_idx) = distances; 
%        
% end