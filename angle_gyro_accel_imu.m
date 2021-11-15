% Gyro Angle
function [acc_p acc_r gyro_y gyro_x] = angle_gyro_accel_imu(accx,accy,accz,gyrox,gyroy,gyroz)
    freq = 100;

%% Angle from Accelerometer
    acc_p = zeros(length(accx),1);
    acc_r = zeros(length(accy),1);
    
for i=1:length(accx)
     acc_p(i,1) = atan2(accx(i),sqrt((accy(i)*accy(i))+(accz(i)*accz(i))));
     acc_r(i,1) = atan2(accy(i),sqrt((accx(i)*accx (i))+(accz(i)*accz(i))));
end

%% Angle from Gyroscope
   gyro_x = zeros(length(gyrox),1);
   gyro_y = zeros(length(gyroy),1);
   
   for i = 2:length(gyrox)
      gyro_y(i,1) = (gyro_y(i-1)+gyroy(i-1)*1/freq); 
      gyro_x(i,1) =(gyro_x(i-1)+gyrox(i-1)*1/freq);
   end    
      
end
