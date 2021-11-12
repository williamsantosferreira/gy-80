#include <wiringPiI2C.h>
#include <wiringPi.h>
#include <iostream>
#include "ros/ros.h"
#include "std_msgs/String.h"
#include <sstream>
#include <unistd.h>

#define pi 3.1415
#define g 9.8

//address
#define Accel_Address 0x53 //ADXL345
#define Gyro_Address 0x69 //L3G4200D
#define Mag_Address 0x1E //HMC5883L
#define Temp_Address 0x77 //BMP085

//accelerometer 
#define POWER_CTL 0x2D
#define DATAX0 0x33 
#define DATAY0 0X35
#define DATAZ0 0x37


//gyroscope
#define CTRL_REG1 0x20
#define CTRL_REG2 0x21
#define CTRL_REG3 0x22
#define CTRL_REG4 0x23
#define CTRL_REG5 0x24
#define OUT_X_H 0x29
#define OUT_Y_H 0x2B
#define OUT_Z_H 0x2D

//magnetometer
#define REG_STATUS 0x09
#define REG_IDENT_A 0x0A
#define REG_IDENT_B 0x0B
#define REG_IDENT_C 0x0C
#define REG_CONFIG_A 0x00
#define REG_CONFIG_B 0x01
#define REG_MODE 0x02
#define MAG_X_H 0x03
#define MAG_X_L 0x04
#define MAG_Y_H 0x07
#define MAG_Y_L 0x08
#define MAG_Z_H 0x05
#define MAG_Z_L 0x06

//temperature and pressure?


struct Sensor_data{
	float ax,ay,az;
	float gx,gy,gz;
	float mx,my,mz;
};

short read_data(int device,int addr){
	short high_byte,low_byte,value;
	
	high_byte = wiringPiI2CReadReg8(device, addr);
	low_byte = wiringPiI2CReadReg8(device, addr-1);
	value = (high_byte << 8) | low_byte;

	return value;
}

class GY80{
	private:
		Sensor_data device;
		int accel;
		int gyro;
		int mag;
	public:
		GY80(){
			int value;
			
			//Devices Configuration
			accel = wiringPiI2CSetup(Accel_Address);
			gyro = wiringPiI2CSetup(Gyro_Address);
			mag = wiringPiI2CSetup(Mag_Address);

			//Accel Registers Configuration
			wiringPiI2CWriteReg8 (accel, POWER_CTL, 8);

			//Gyro Registers Configuration
			wiringPiI2CWriteReg8 (gyro, CTRL_REG1, 0b00001111);
			wiringPiI2CWriteReg8 (gyro, CTRL_REG2, 0b00000000);
			wiringPiI2CWriteReg8 (gyro, CTRL_REG3, 0b00001000);
			wiringPiI2CWriteReg8 (gyro, CTRL_REG4, 0b00000000);
			wiringPiI2CWriteReg8 (gyro, CTRL_REG5, 0b00110000);		

			//Mag Registers Configuration
			value = wiringPiI2CReadReg8(mag,REG_MODE);
			value &= 0b11111100;
			value |= 0b00;
			wiringPiI2CWriteReg8(mag, REG_MODE, value);

			value = wiringPiI2CReadReg8(mag, REG_CONFIG_A);
			value &= 0b10011111;
			value |= (0b00 << 5);
			wiringPiI2CWriteReg8(mag,REG_CONFIG_A, value);

			wiringPiI2CWriteReg8(mag, REG_CONFIG_B, 0b001 << 5);

			value = wiringPiI2CReadReg8(mag,REG_CONFIG_A);
			value &= 0b11100011;
			value |= (0b100 << 2);

			wiringPiI2CWriteReg8(mag, REG_CONFIG_A, value);

		}
		void read_accel();
		void read_gyro();
		void read_mag();

		float read_ax();
		float read_ay();
		float read_az();

		float read_gx();
		float read_gy();
		float read_gz();

		float read_mx();
		float read_my();
		float read_mz();
};

void GY80::read_accel(){ //
	device.ax = (float(read_data(accel,DATAX0))/256.0);
	device.ay = (float(read_data(accel,DATAY0))/256.0);
	device.az = (float(read_data(accel,DATAZ0))/256.0);	
}

void GY80::read_gyro(){ // rad/s
	device.gx = (float(read_data(gyro,OUT_X_H))*pi/45000.0);
	device.gy = (float(read_data(gyro,OUT_Y_H))*pi/45000.0);
	device.gz = (float(read_data(gyro,OUT_Z_H))*pi/45000.0);	
}

void GY80::read_mag(){
	device.mx = wiringPiI2CReadReg16(mag,MAG_X_H);
	device.my = wiringPiI2CReadReg16(mag,MAG_Y_H);
	device.mz = wiringPiI2CReadReg16(mag,MAG_Z_H);
}

float GY80::read_ax(){
	return device.ax;
}

float GY80::read_ay(){
	return device.ay;
}

float GY80::read_az(){
	return device.az;
}

float GY80::read_gx(){
	return device.gx;
}

float GY80::read_gy(){
	return device.gy;
}

float GY80::read_gz(){
	return device.gz;	
}

float GY80::read_mx(){
	return device.mx;
}

float GY80::read_my(){
	return device.my;
}

float GY80::read_mz(){
	return device.mz;	
}

