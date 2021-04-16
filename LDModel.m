%% calculations

% Constants
gamma = 0.85;
Kt = 2.65;

% wire and post contstants
Ew = 213e9; %Pa
Lw = 2600; % length of wire in um
rw = 19/2; % radius of wire in um
Iw = (pi/4)*rw^4;

Ep = 0.621e9;
Lp = 506; % um - difference of total length (536 um) and offset (30 um)
rp = 39/2;
Ip = (pi/4)*rp^4;
yp = linspace(0,400,100);

n = 0;
phi = pi / 2;

% some parameter definitions
eta = sqrt(1 + n^2);
theta = asin(yp ./ (gamma*Lp));

c = Kt / (3*eta);
A = Ip / (Ew*Iw);
B = (Lw^3) / (Lp^2);
C = theta ./ (sin(phi - theta));

yw = c * Ep * A * B * C;

%% Calcualte Ep

[YWYP] = xlsread('Post_15_test.xlsx');
YW = YWYP(:,1);
YP = YWYP(:,2);

eta = sqrt(1 + n^2);
theta = asin(YP ./ (gamma*Lp));

c = Kt / (3*eta);
A = Ip / (Ew*Iw);
B = (Lw^3) / (Lp^2);
C = theta ./ (sin(phi - theta));

EP = YW ./ (c * A * B * C);

scatter(1:length(EP),EP,'.')

%% Uncertainty Quanitification

Ew_sd = Ew*0.005;
Lw_sd = 100;
rw_sd = 1.27;
Iw_sd = (pi/4)*rw_sd^4;

Lp_Sd = 5;
rp_sd = 1;
Ip_sd = (pi/4)*rp_sd^4;
% yp_sd = linspace(0,);

% Monte Carlo Sampling



%% plots

% plot model of
scatter(yp, yw, '.')
xlabel('Post Deflection')
ylabel('Wire Deflection')
title('yp vs yw')
