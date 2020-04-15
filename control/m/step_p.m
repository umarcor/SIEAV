r = 10; % Reference (setpoint)
t = 0:Ts:12;
Kp = 1250;

% Closed loop

fsys_p = feedback( Kp * psys, 1 ) % Proportional controller (continuous plant)
fsys_d = feedback( Kp * dsys, 1 ) % Proportional controller (discretized plant)

step(r * fsys_p , t);
hold on
step(r * fsys_d , t);

% Manual implementation of the discrete proportional controller

x = 0;
y = 0;
yv = 0;
k = 1;

for i=t
  yv(k) = y;

  e = r-y;
  u = Kp * e;

  xk = x;
  x = dsys.A * xk + dsys.B * u;
  y = dsys.C * xk + dsys.D * u;

  k = k+1;
end

stairs(t, yv)

% Manual implementation of the discrete proportional controller and the discrete plant

y = 0;
yv = 0;
k = 1;

[Nd, Dd]=tfdata(dpsys, 'v');

for i=t
  yv(k) = y;

  e = r-y;
  u = Kp * e;

  y = Nd(2) * u - Dd(2) * y;

  k = k+1;
end

stairs(t, yv)

% From HDL simulation

fid = fopen('../soft_singleproc_bin.bin')
stairs(t, fread(fid, 'double'))
fclose(fid)

fid = fopen('../soft_twoproc_bin.bin')
stairs(t, fread(fid, 'double'))
fclose(fid)

hold off
legend('fsys_p', 'fsys_d', 'man\_ss', 'man\_diffe', 'hdl\_single', 'hdl\_two')
