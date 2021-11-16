rosshutdown;
clc;
size = 1000;
rosinit('10.0.0.112'); % ROS_MASTER_IP
sub = rossubscriber('/imu_send/data'); %topic name
msg = rosmessage(sub);

i = 1;

accx = zeros(size,1);
accy = zeros(size,1);
accz = zeros(size,1);
gyrox = zeros(size,1);
gyroy = zeros(size,1);
gyroz = zeros(size,1);

while(i<=size)
    display(i);
    
    msg = receive(sub);
    
    accx(i,1) = (msg.Linear.X);
    accy(i,1) = (msg.Linear.Y);
    accz(i,1) = (msg.Linear.Z);
    
    gyrox(i,1) = msg.Angular.X;
    gyroy(i,1) = msg.Angular.Y;
    gyroz(i,1) = msg.Angular.Z;
    
    i = i+1;
end

choose = input('Would you like to save this data? Y or N: ','s');

if(choose == 'y'|| choose == 'Y')
    matriz_mpu = [accx accy accz gyrox gyroy gyroz];
    nome = input('Digite o nome do arquivo: ','s');
    
    nome = strcat(nome,'.csv');
    
    csvwrite(nome,matriz_mpu);
end


