% High Pass Filter
function [gyrox_,gyroy_,gyroz_]=high_pass_filter();
clear;
clc;

file = 'roll.csv';
alpha = 0.95;
dt = 1/100;

data = csvread(file);
gyrox = data(:,4);
gyroy = data(:,5);
gyroz = data(:,6);

gyrox_ = zeros(length(gyrox),1);
gyroy_ = zeros(length(gyrox),1);
gyroz_ = zeros(length(gyrox),1);
for i=2:length(gyrox)
   gyrox_(i,1) =  alpha*(gyrox_(i-1,1)+(gyrox(i,1)-gyrox(i-1,1))*dt);
   gyroy_(i,1) =  alpha*(gyroy_(i-1,1)+(gyroy(i,1)-gyroy(i-1,1))*dt);
   gyroz_(i,1) =  alpha*(gyroz_(i-1,1)+(gyroz(i,1)-gyroz(i-1,1))*dt);
end
end