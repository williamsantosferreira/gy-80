% Read File

file = 'roll.csv';
data = csvread(file);

accx = data(:,1);
accy = data(:,2);
accz = data(:,3);

gyrox = data(:,4);
gyroy = data(:,5);
gyroz = data(:,6);