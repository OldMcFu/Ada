#include "udp_hw_timestamp.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>
#include <errno.h>

#include <arpa/inet.h>
#include <errno.h>
#include <inttypes.h>
#include <linux/errqueue.h>
#include <linux/net_tstamp.h>
#include <linux/sockios.h>
#include <net/if.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <unistd.h>
#include <sys/resource.h>

#define BUF_SIZE 1024

struct sockaddr_in client_addr;
socklen_t client_len = sizeof(client_addr);

int setup_timestamp_udp(int sockfd)
{
    // Set socket option to enable SO_TIMESTAMPING
    int timestampOn = SOF_TIMESTAMPING_RX_HARDWARE | 0;
    if (setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMPING, &timestampOn, sizeof(timestampOn)) < 0)
    {
        return -1;
    }

    return 0;
}

int read_msg(int sockfd, char *udpMsg, int len, int *timestamp)
{
    struct msghdr msg = {0};
    struct iovec iov = {0};
    struct timespec hw_timestamp;

    msg.msg_name = &client_addr;
    msg.msg_namelen = sizeof(client_addr);
    msg.msg_iov = &iov;
    msg.msg_iovlen = 1;
    iov.iov_base = udpMsg;
    iov.iov_len = len;
    msg.msg_control = &hw_timestamp;
    msg.msg_controllen = sizeof(hw_timestamp);

    int length = recvmsg(sockfd, &msg, 0);
    if (length < 0 || len < length)
    {
        perror("Recvmsg failed");
        exit(EXIT_FAILURE);
    }
    udpMsg[length] = '\0';

    // Convert hardware timestamp to human-readable format
    struct timespec *hw_ts = NULL;
    struct timespec sw_ts;
    for (struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg); cmsg != NULL; cmsg = CMSG_NXTHDR(&msg, cmsg))
    {
        if (cmsg->cmsg_level == SOL_SOCKET && cmsg->cmsg_type == SCM_TIMESTAMPING)
        {
            struct timespec *ts = (struct timespec *)CMSG_DATA(cmsg);
            hw_ts = ts + 1; // Hardware transmit timestamp
            break;
        }
    }

    if (hw_ts != NULL)
    {
        *timestamp = hw_ts->tv_nsec;
    }
    else
    {
        if (clock_gettime(CLOCK_MONOTONIC, &sw_ts) == -1) {
               perror("clock_gettime");
               exit(EXIT_FAILURE);
           }
           uint64_t tmp = sw_ts.tv_nsec;
        *timestamp = tmp;
        //printf("Hardware timestamp not available.\n");
    }

    return length;
}