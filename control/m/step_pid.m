% PI(D) controller

Kp = 800;
Ki = 40;
Kd = 0;

csys = feedback( (Kp + Ki/s + Kd*s) * psys, 1 );

step(r*csys, t, 'yellow')

axis([0 12 0 11])
