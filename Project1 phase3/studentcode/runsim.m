% close all;
% clear all;
% clc;
addpath(genpath('./'));
tic
%% Plan paths
disp('Planning ...');
map = load_map('maps/map2.txt', 0.1, 2.0, 0.25);
% start = {[0  4.0 5.0]};
% stop  = {[18  4.0 5.0]};

start = {[0.0  -4.9 0.0]};
stop  = {[0.0  4.0 6.0]};

nquad = length(start);
for qn = 1:nquad
    path{qn} = dijkstra(map, start{qn}, stop{qn}, true);
end

j=1;
paths = path{1,1};
if nquad == 1
    plot_path(map, path{1});
    hold on
else
    % you could modify your plot_paths to handle cell input for multiple robots
end

toc
%% Additional init script
init_script;


% for t=0:0.01:20
% desired_state = trajectory_generator(t, qn);
% hold on
% plot3(desired_state.pos(1),desired_state.pos(2),desired_state.pos(3),'b*')
% end

% Run trajectory
trajectory = test_trajectory(start, stop, map, paths, true); % with visualization
