

#pragma once


int setup_timestamp_udp(int sockfd);
int read_msg(int sockfd, char* udpMsg, int len, int* timestamp);