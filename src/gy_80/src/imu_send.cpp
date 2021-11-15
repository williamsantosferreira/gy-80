#include "ros/ros.h"
#include "IMU.h"
#include <iostream>
#include "geometry_msgs/Twist.h"

int main(int argc,char** argv){
	geometry_msgs::Twist msg;
	GY80 imu;	
	
	ros::init(argc,argv,"imu_send");

	ros::NodeHandle n("~");

	ros::Publisher pub = n.advertise<geometry_msgs::Twist>("data",1000);

	ros::Rate freq(100);
	while(ros::ok()){
		imu.read();
	
		msg.linear.x = imu.read_ax();
		msg.linear.y = imu.read_ay();
		msg.linear.z = imu.read_az();
	
		msg.angular.x = imu.read_gx();
		msg.angular.y = imu.read_gy();
		msg.angular.z = imu.read_gz();

		pub.publish(msg);

	freq.sleep();
				
}	
	return 0;
}
