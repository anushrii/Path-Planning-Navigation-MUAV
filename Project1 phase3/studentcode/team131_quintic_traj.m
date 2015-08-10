function [thetas qdot] = team131_quintic_traj(t,tvia1,tvia2,thetavia1,thetavia2,vel1,vel2)
	t0 = tvia1;
	tf = tvia2;
	thetas = zeros(6,1);
	q0 = thetavia1;% radians
	v0 = vel1;% rad/s
	alpha0 = zeros(1,6); % rad/s^2
	qf = thetavia2;%1.3;   % radians
	vf = vel2;%[0 0 0 0 0 0];     % rad/s
	alphaf = zeros(1,6); % rad/s^2

	mat = [1    t0   t0^2     t0^3    t0^4    t0^5; 
	       0     1   2*t0   3*t0^2  4*t0^3  5*t0^4; 
	       0     0      2     6*t0 12*t0^2 20*t0^3;
	       1    tf   tf^2     tf^3    tf^4    tf^5; 
	       0     1   2*tf   3*tf^2  4*tf^3  5*tf^4;
	       0     0      2     6*tf 12*tf^2 20*tf^3];
	
	for i = 1:6
		conditions = [q0(i) v0(i) alpha0(i) qf(i) vf(i) alphaf(i)]';
		coeffs = mat \ conditions;
		a0 = coeffs(1);
		a1 = coeffs(2);
		a2 = coeffs(3);
		a3 = coeffs(4);
		a4 = coeffs(5);
		a5 = coeffs(6);
		thetas(i,1) = a0 + a1*t + a2*t.^2 + a3*t.^3 + a4*t.^4 + a5*t.^5;	
        qdot(i,1) = a1 + 2*a2*t + 3*a3*t.^2 + 4*a4*t.^3 + 5*a5*t.^4;
    end
