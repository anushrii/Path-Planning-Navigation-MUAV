% minimumjerk
function[aa]=getCoeffs_minjerk(viaPoints,timeViaPoints,xyz)

for i=1:size(viaPoints)-1
       
    q0 = viaPoints(i,xyz);
    v0 = 0;
    ac0 = 0;
    q1 = viaPoints(i+1,xyz);
    v1 = 0;
    ac1 = 0;
    t0 = timeViaPoints(i);
    tf = timeViaPoints(i+1);
 
     d =[q0,v0,ac0,q1,v1,ac1,t0,tf];
     a = min_jerk(d) ;
    aa(i,:) = a';
end