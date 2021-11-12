#include <iostream>
#include "ros/ros.h"
#include "std_msgs/String.h"


int main(int argc, char **argv){
	std_msgs::String msg;
	
	ros::init (argc,argv, "print");
	ros::NodeHandle n;

	ros::Publisher pub = n.advertise<std_msgs::String>("topic_test",1000);

	while(ros::ok()){
		msg.data = "Hello World";

		pub.publish(msg);	
	}

}
