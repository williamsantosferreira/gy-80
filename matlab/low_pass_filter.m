% Low Pass Filter Accelerometer
function [accx_,accy_,accz_]= low_pass_filter();
clear;
clc;

file = 'roll.csv';
alpha = 0.98;

data = csvread(file);
accx = data(:,1);
accy = data(:,2);
accz = data(:,3);

accx_ = zeros(length(accx),1);
accy_ = zeros(length(accx),1);
accz_ = zeros(length(accx),1);
for i=2:length(accx)
   accx_(i,1) =  alpha*(accx_(i-1,1))+(1-alpha)*accx(i,1);
   accy_(i,1) =  alpha*(accy_(i-1,1))+(1-alpha)*accy(i,1);
   accz_(i,1) =  alpha*(accz_(i-1,1))+(1-alpha)*accz(i,1);
end
end
