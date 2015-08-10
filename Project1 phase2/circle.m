function [desired_state] = circle(t, qn)
% CIRCLE trajectory generator for a circle

% =================== Your code goes here ===================
% You have to set the pos, vel, acc, yaw and yawdot variables

% x = sin(t/2*5).*cos(t);
% y = sin(t/2*5).*sin(t);
% z = cos(t/2*5);



r=5;

tmax = 9.5;
% c = 2.5;
w = 2*pi/tmax;

% w = 1/2*pi*0.01;
% x = r*cos(w*t);
% y = r*sin(w*t);
% z = 2.5*t;


if t > tmax
   
    x= 5;
    y = 0;
    z = 2.5;
    pos = [x; y; z];
    vel = [0; 0; 0 ];
    acc = [0; 0 ; 0];
else
  
    q0 = 0;
    v0 = 0;
    ac0 = 0;
    q1 = tmax*w;
    v1 = 0;
    ac1 = 0;
    t0 = 0;
    tf = tmax;
 
 d =[q0,v0,ac0,q1,v1,ac1,t0,tf];
 a = min_jerk(d) ;
 % q0,v0,ac0,q1,v1,ac1,t0,tf
% qt  = a(1) + a(2)*t + a(3)*t^2 + a(4)*t^3 + a(5)*t^4 + a(6)*t^5;
 a4 = a(4);
 a5 = a(5);
 a6 = a(6);
%     x = r*cos(w*qt);
%     y = r*sin(w*qt);
%     z = 2.5*(qt/tmax);
 
qt = (a4*t^3 + a5*t^4 + a6*t^5);%*w;
    x = r*cos(qt);
    y = r*sin(qt);
    z = (2.5/(2*pi))*(qt);
    
   dx = -5*sin(a6*t^5 + a5*t^4 + a4*t^3)*(5*a6*t^4 + 4*a5*t^3 + 3*a4*t^2);%-5*sin(w*(a6*t^5 + a5*t^4 + a4*t^3))*(a6*t^5 + a5*t^4 + a4*t^3);
   dy = 5*cos(a6*t^5 + a5*t^4 + a4*t^3)*(5*a6*t^4 + 4*a5*t^3 + 3*a4*t^2);%5*cos(w*(a6*t^5 + a5*t^4 + a4*t^3))*(a6*t^5 + a5*t^4 + a4*t^3);
  % dz = (5*(5*a6*t^4 + 4*a5*t^3 + 3*a4*t^2))/(2*tmax);
   dz = (8959626780035405*a6*t^4)/4503599627370496 + (1791925356007081*a5*t^3)/1125899906842624 + (5375776068021243*a4*t^2)/4503599627370496;
   
  d2x = - 5*cos(a6*t^5 + a5*t^4 + a4*t^3)*(5*a6*t^4 + 4*a5*t^3 + 3*a4*t^2)^2 - 5*sin(a6*t^5 + a5*t^4 + a4*t^3)*(20*a6*t^3 + 12*a5*t^2 + 6*a4*t);
  d2y = 5*cos(a6*t^5 + a5*t^4 + a4*t^3)*(20*a6*t^3 + 12*a5*t^2 + 6*a4*t) - 5*sin(a6*t^5 + a5*t^4 + a4*t^3)*(5*a6*t^4 + 4*a5*t^3 + 3*a4*t^2)^2;
  d2z = (8959626780035405*a6*t^3)/1125899906842624 + (5375776068021243*a5*t^2)/1125899906842624 + (5375776068021243*a4*t)/2251799813685248;
  % d2x = -5*cos(w*(a6*t^5 + a5*t^4 + a4*t^3))*(a6*t^5 + a5*t^4 + a4*t^3)^2;
%    d2y = -5*sin(w*(a6*t^5 + a5*t^4 + a4*t^3))*(a6*t^5 + a5*t^4 + a4*t^3)^2;
%    d2z = (5*(20*a6*t^3 + 12*a5*t^2 + 6*a4*t))/(2*tmax);
 
%     dx = -r*w*sin(w*t);
%     dy = r*w*cos(w*t);
%     dz =  2.5/tmax;
% 
%     d2x = -r*w^2*cos(w*t);
%     d2y = -r*w^2*sin(w*t);
%     d2z = 0 ;

    pos = [x; y; z];
    vel = [dx; dy; dz];
    acc = [d2x; d2y; d2z];
 end



% if t > tmax
%    
%     x= 5;
%     y = 0;
%     z = 2.5;
%     pos = [x; y; z];
%     vel = [0; 0; 0 ];
%     acc = [0; 0 ; 0];
% else
%  
%    
% 
%     x = r*cos(w*t);
%     y = r*sin(w*t);
%     z = 2.5*(t/tmax);
%  
%  
%     dx = -r*w*sin(w*t);
%     dy = r*w*cos(w*t);
%     dz =  2.5/tmax;
% 
%     d2x = -r*w^2*cos(w*t);
%     d2y = -r*w^2*sin(w*t);
%     d2z = 0 ;
% 
%     pos = [x; y; z];
%     vel = [dx; dy; dz];
%     acc = [d2x; d2y; d2z];
%  end
% 



yaw = 0;
yawdot = 0;

% =================== Your code ends here ===================

desired_state.pos = pos(:);
desired_state.vel = vel(:);
desired_state.acc = acc(:);
desired_state.yaw = yaw;
desired_state.yawdot = yawdot;

end
