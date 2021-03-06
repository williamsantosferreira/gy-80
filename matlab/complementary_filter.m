clear;
clc;

movement_file = 'data1.csv';
stationary_file = 'stationary.csv';

data = csvread(movement_file);
calib = csvread(stationary_file);

accx = data(:,1);
accy = data(:,2);
accz = data(:,3);

gyrox = data(:,4);
gyroy = data(:,5);
gyroz = data(:,6);

len = length(accx);
f = 100;
dt = 1/f;
a = 0.98;

%% CALIBRATION

calib_acc = [calib(:,1) calib(:,2) calib(:,3)];
calib_gyro = [calib(:,4) calib(:,5) calib(:,6)];

mean_calib_acc = mean(calib_acc);
mean_calib_gyro = mean(calib_gyro);

accx = accx - mean_calib_acc(1);
accy = accy - mean_calib_acc(2);
accz = accz + (-1 - mean_calib_acc(3));

gyrox = gyrox - mean_calib_gyro(1);
gyroy = gyroy - mean_calib_gyro(2);
gyroz = gyroz - mean_calib_gyro(3);

%% ACCEL ANGLES
[accx_,accy_,accz_]= low_pass_filter();

acc_pitch = zeros(len,1);
acc_roll = zeros(len,1);

for i=1:len
   %Without filtering
   acc_roll(i) = atan2(accy(i),sqrt(accz(i)*accz(i)+accx(i)*accx(i)));
   acc_pitch(i) = -atan2(accx(i),sqrt(accz(i)*accz(i)+accy(i)*accy(i)));
   
   %Pre-filtering
   %acc_roll(i) = atan2(accy_(i),sqrt(accz_(i)*accz_(i)+accx_(i)*accx_(i)));
   %acc_pitch(i) = -atan2(accx_(i),sqrt(accz_(i)*accz_(i)+accy_(i)*accy_(i)));
end

%% GYRO ANGLES
[gyrox_,gyroy_,gyroz_]=high_pass_filter();

gyro_pitch = zeros(len,1);
gyro_roll = zeros(len,1);

for i=2:len
    %Without filtering
   gyro_pitch(i) = gyro_pitch(i-1) + gyroy(i)*dt;
   gyro_roll(i) = gyro_roll(i-1) + gyrox(i)*dt;
   
   % Pre-filtering
   %gyro_pitch(i) = gyro_pitch(i-1) + gyroy_(i)*dt;
   %gyro_roll(i) = gyro_roll(i-1) + gyrox_(i)*dt;
   
end

%% COMPLEMENTARY FILTER
cf_pitch = zeros(len,1);
cf_roll = zeros(len,1);

for i=2:len
   cf_pitch(i) = a*(cf_pitch(i-1)+gyro_pitch(i)-gyro_pitch(i-1))+(1-a)*acc_pitch(i);  
   cf_roll(i) = a*(cf_roll(i-1)+gyro_roll(i)-gyro_roll(i-1))+(1-a)*acc_roll(i); 
end

%% PLOTTING

subplot(1,2,1)
plot(cf_pitch);
title('PITCH');
ylim([-pi/2,pi/2]);

subplot(1,2,2)
plot(cf_roll);
title('ROLL');
ylim([-pi/2,pi/2]);

