--> Ao utilizar a biblioteca do IMU, o nó precisa estar dessa forma no CMAKE:
target_link_libraries(imu_send ${catkin_LIBRARIES} -lwiringPi)
