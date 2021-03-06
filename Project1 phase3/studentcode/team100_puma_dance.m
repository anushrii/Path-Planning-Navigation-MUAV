%% PUMA Dance
% Starter code by Katherine J. Kuchenbecker
% MEAM 520 at the University of Pennsylvania
%% Clean up
% Clear all variables and functions.  You should do this before calling any PUMA functions.
clear all
% Move the cursor to the top of the command window so new text is easily seen.
home
%% Definitions
% Define team number.
teamnumber = 100;
% Define student names.
studentnames = 'Addwiteey Chrungoo and Anushree Singh';
% Load the dance file from disk.
load team100
% Pull the list of via point times out of the dance matrix for use below.
tvia = dance(:,1);
% Initialize the function that calculates angles.
team100_get_angles
% Define music filename (without team number).
musicfilename = 'Turkey in the Straw N';
%% Music

% Load the piece of music for the robot to dance to.
%[y,Fs] = audioread([num2str(teamnumber) ' ' musicfilename '.wav']);
[y,Fs] = wavread([num2str(teamnumber) ' ' musicfilename '.wav']);

% Calculate the duration of the music.
musicduration = (length(y)-1)/Fs;
% Calculate the duration of silence at the start of the dance.
silenceduration = abs(min(tvia));

% Create a time vector for the entire piece of music, for use in plotting.
t = ((min(tvia):(1/Fs):musicduration))';

% Pad the start of the music file with zeros for the silence.
y = [zeros(length(t)-length(y),2); y];


%% Choose duration

% Set the start and stop times of the segment we want to test.
% To play the entire dance, set tstart = t(1) and tstop = t(end).
tstart = t(1);
tstop = t(end);

% Select only the part of the music that we want to play right now, from
% tstart to tstop.
yplay = y(1+round(Fs*(tstart - t(1))):round(Fs*(tstop-t(1))),:);

% Put this snippet into an audio player so we can listen to it.
music = audioplayer(yplay,Fs);


%% Plot music

% Pull first audio channel and downsample it for easier display.
factordown = 30;
ydown = downsample(y(:,1),factordown);

% Downsample the time vector too.
tdown = downsample(t,factordown);

% Open figure and clear it.
figure(2)
clf

% Plot one of the sound channels to look at.
plot(tdown,ydown,'Color',[.2 .4 0.8]);
xlim([floor(t(1)) ceil(t(end))])

% Turn on hold to allow us to plot more things on this graph.
hold on

% Plot a vertical line at the time of each of the via points.
for i = 1:length(tvia)
    plot(tvia(i)*[1 1],ylim,'k--')
end

% Plot vertical lines at the start and stop times.
plot(tstart*[1 1],ylim,'k:')
plot(tstop*[1 1],ylim,'k:')

% Add a vertical line to show where we are in the music.
hline = plot(tstart*[1 1],ylim,'r-');

% Turn off hold.
hold off

% Set the title to show the team number and the name of the song.
title(['Team ' num2str(teamnumber) ': ' musicfilename])


%% Start robot

% Open figure 1 and clear it.
figure(1)
clf

% Initialize the PUMA simulation.
pumaStart()

% Set the view so we are looking from roughly where the camera will be.
view(80,20)

% The PUMA always starts with all joints at zero except joint 5, which
% starts at -pi/2 radians.  You can check this by calling pumaAngles.
thetahome = pumaAngles;

% Call pumaServo once to initialize timers.
pumaServo(thetahome);


%% Initialize dance

% Calculate the joint angles where the robot should start.
thetastart = team100_get_angles(tstart);

% Calculate time needed to get from home pose to starting pose moving at
% angular speed of 0.5 radians per second on the joint that has the
% farthest to go.
tprep = abs(max(thetastart - thetahome)) / .5;

% Start the built-in MATLAB timer.
tic

% Slowly servo the robot to its starting position, in case we're
% not starting at the beginning of the dance.
while(true)
    % Get the current time for preparation move.
    tnow = toc;
    
    % Check to see whether preparation move is done.
    if (tnow > tprep)
        
        % Servo the robot to the starting pose.
        pumaServo(thetastart)
        
        % Break out of the infinite while loop.
        break

    end
    
    % Calculate joint angles.
    thetanow = team100_linear_trajectory(tnow,0,tprep,thetahome,thetastart);

    % Servo the robot to this pose to prepare to dance.
    pumaServo(thetanow);
end

% Initialize history vectors for holding time and angles.  We preallocate
% these for speed, making them much larger than we will need.
thistory = zeros(10000,1);
thetahistory = zeros(10000,6);

% Initialize our counter at zero.
i = 0;


%% Start music and timer

% Start the zero-padded music so we hear it.
play(music);

% Start the built-in MATLAB timer so we can keep track of where we are in
% the song.
tic


%% Dance

% Enter an infinite loop.
while(true)
    % Increment our counter.
    i = i+1;
    
    % Get the current time elapsed and add it to the time where we're
    % starting in the song. Store this value in the thistory vector.   
    thistory(i) = toc + tstart;
    
    % Check if we have passed the end of the performance.
    if (thistory(i) > tstop)
        
        % Break out of the infinite while loop.
        break

    end
    
    % Calculate the joint angles for the robot at this point in time and
    % store in our thetahistory matrix.
    [thetahistory(i,:) velhistory(i,:)] = team100_get_angles(thistory(i))';

    % Servo the robot to these new joint angles.
    pumaServo(thetahistory(i,:));
        
    % Move the line on the music plot.
    set(hline,'xdata',thistory(i)*[1 1]);
end

% Stop the PUMA robot.
pumaStop
% Remove the unused ends of the history vector and matrix, which we
% preallocated for speed.
thistory(i:end) = [];
thetahistory(i:end,:) = [];
%% Plot output
% Open figure 3 and clear it.
figure;
subplot(2,3,1)
plot(thistory,thetahistory(:,1),'r-');
hold on;
plot(thistory,velhistory(:,1),'g-');
title('joint 1 theta and velocity')
%plot(thistory,velhistory(:,1),'g-');
subplot(2,3,2)
plot(thistory,thetahistory(:,2),'r-');
hold on;
plot(thistory,velhistory(:,2),'g-');
title('joint 2 theta and velocity')
%plot(thistory,velhistory(:,2),'g-');
subplot(2,3,3)
plot(thistory,thetahistory(:,3),'r-');
hold on;
plot(thistory,velhistory(:,3),'g-');
title('joint 3 theta and velocity')
%plot(thistory,velhistory(:,3),'g-');
subplot(2,3,4)
plot(thistory,thetahistory(:,4),'r-');
hold on;
plot(thistory,velhistory(:,4),'g-');
title('joint 4 theta and velocity')
%plot(thistory,velhistory(:,4),'g-');
subplot(2,3,5)
plot(thistory,thetahistory(:,5),'r-');
hold on;
plot(thistory,velhistory(:,5),'g-');
title('joint 5 theta and velocity')
%plot(thistory,velhistory(:,5),'g-');
subplot(2,3,6)
plot(thistory,thetahistory(:,6),'r-');
hold on;
plot(thistory,velhistory(:,6),'g-');
title('joint 6 theta and velocity')

%hold on;
%title(['Team ' num2str(teamnumber) ': Joint Angles and Joint Velocities over Time'])
%plot(thistory,velhistory(:,6),'g-');
% Plot the joint angles and joint velocities versus time to make it easy to
% show how they changed during the dance.  You should use the variables
% thetahistory and thistory for this.

axis([0 1 0 1])
%text(0,0,'You need to complete this plot.','horizontalalignment','center')
