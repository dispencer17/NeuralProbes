%% ===================== calculations =======================

% Constants
gamma = 0.85;
Kt = 2.65;

% wire and post contstants
Ew = 213e9; %Pa
Lw = 3900; % length of wire in um
rw = 19/2; % radius of wire in um
Iw = (pi/4)*rw^4;

Ep = 0.621e6;
Lp = 270; % um - difference of total length (536 um) and offset (30 um)
rp = 39/2;
Ip = (pi/4)*rp^4;
yp = linspace(0,220,100);

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


%% ================ Calcualte Ep (from post 15) ==================

[YWYP] = xlsread('Post_15_test.xlsx');
YW = YWYP(:,1);
YP = YWYP(:,2);

eta = sqrt(1 + n^2);
theta = asin(YP ./ (gamma*Lp));

c = Kt / (3*eta);
A = Ip / (Ew*Iw);
B = (Lw^3) / (Lp^2);
C = theta ./ (sin(phi - theta));

EP = YW ./ (c * A * B * C); % Post modulud calculated at each deflection position

%% ================= Uncertainty Quanitification ================ 

N = 1000; % sample size for monte carlo

Ew_sd = Ew*0.005;
Lw_sd = 100/2;
rw_sd = 1.27/2;

Ep_sd = Ep*0.005;
Lp_sd = 5/2;
rp_sd = 1/2;
% yp_sd = linspace(0,);


% Monte Carlo Sampling
Ew_mc = normrnd(Ew,Ew_sd,N,1); % random normally distributed sampling of values
Lw_mc = normrnd(Lw,Lw_sd,N,1);
rw_mc = normrnd(rw,rw_sd,N,1);
Iw_mc = (pi/4)*rw_mc.^4; % Moment Inertia of circular cross-section

Ep_mc = normrnd(Ep,Ep_sd,N,1); % Same as above for the post
Lp_mc = normrnd(Lp,Lp_sd,N,1);
rp_mc = normrnd(rp,rp_sd,N,1);
Ip_mc = (pi/4)*rp_mc.^4;

yp_mc = linspace(0,210,1000); % Evenly spaced deflection from 0 to 210 microns (1000 points)

n = 0;  % no lateral force, just vertical
phi = pi / 2;   % initial angle

% some parameter definitions
eta = sqrt(1 + n^2);
theta = asin(yp_mc ./ (gamma*Lp_mc));

% Derived equation for large dflection relationship between yw and yp
c = Kt / (3*eta);
A = Ip_mc ./ (Ew_mc.*Iw_mc);
B = (Lw_mc.^3) ./ (Lp_mc.^2);
C = theta ./ (sin(phi - theta));

yw_mc = c * Ep_mc .* A .* B .* C;
[m, n] = size(yw_mc); % size of array (used for plotting)


%% ======================== plots ===========================


% Model plot with uncertainty region
figure(1)
hold all
for i = 1:length(yp_mc)
   plot(ones(1,m)*yp_mc(i),yw_mc(:,i),'color',[0.7 0.7 1])
end
plot(yp, yw, '-', 'linewidth', 1)
xlim([0 210])
ylim([0 400])
xlabel('yp (microns)')
ylabel('yw (microns)')
title('Model with Uncertainty')



% Plot measured smaple results (10 posts)
figure(2)
names = {'post_4','post_5','post_6','post_7','post_8','post_11','post_13','post_14','post_15'};
start = [24, 13, 7, 29, 5, 17, 21, 17, 11];
for i = 1:9
    [data] = xlsread(char(names(i)));
    hold on
    scatter(data(1:end,2),data(1:end,1),'.')
end
xlim([0 210])
ylim([0 400])
xlabel('yp (microns)')
ylabel('yw (microns)')
title('Measured Data (10 posts)')



% Plot of 10 post data superimposed onto model
figure(3)
hold all
for i = 1:length(yp_mc)
   plot(ones(1,m)*yp_mc(i),yw_mc(:,i),'color',[0.7 0.7 1])
end
hold on
plot(yp, yw, '-', 'linewidth', 1)
names = {'post_4','post_5','post_6','post_7','post_8','post_11','post_13','post_14','post_15'};
start = [24, 13, 7, 29, 5, 17, 21, 17, 11];
for i = 1:9
    [data] = xlsread(char(names(i)));
    hold on
    scatter(data(1:end,2),data(1:end,1),'.')
end
xlim([0 210])
ylim([0 400])
xlabel('yp (microns)')
ylabel('yw (microns)')
title('Measured Data Superimposed on Model')



% Plot of 10 post data (linear elastic region truncated) superimposed onto
% model 
figure(4)
hold all
for i = 1:length(yp_mc)
   plot(ones(1,m)*yp_mc(i),yw_mc(:,i),'color',[0.7 0.7 1])
end
hold on
plot(yp, yw, '-', 'linewidth', 1)
for i = 1:9
    [data] = xlsread(char(names(i)));
    hold on
    scatter(data(start(i):end,2) - data(start(i),2),data(start(i):end,1) - data(start(i),1),'.')
end
xlim([0 210])
ylim([-20 400])
xlabel('yp (microns)')
ylabel('yw (microns)')
title('Measured Data (truncated) Superimposed on Model')

