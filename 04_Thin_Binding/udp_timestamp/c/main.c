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

#define PORT 8888
#define BUF_SIZE 1024

int main() {
    int sockfd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_len = sizeof(client_addr);
    char buffer[BUF_SIZE];
    struct timespec hw_timestamp;

    // Create socket
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }

    // Set socket option to enable SO_TIMESTAMPING
    int timestampOn =
      SOF_TIMESTAMPING_RX_SOFTWARE | SOF_TIMESTAMPING_TX_SOFTWARE |
      SOF_TIMESTAMPING_SOFTWARE | SOF_TIMESTAMPING_RX_HARDWARE |
      SOF_TIMESTAMPING_TX_HARDWARE | SOF_TIMESTAMPING_RAW_HARDWARE |
      //SOF_TIMESTAMPING_OPT_TSONLY |
      0;
    if (setsockopt(sockfd, SOL_SOCKET, SO_TIMESTAMPING, &timestampOn, sizeof(timestampOn)) < 0) {
        perror("Failed to set socket option");
        exit(EXIT_FAILURE);
    }

    // Clear server address structure
    memset(&server_addr, 0, sizeof(server_addr));

    // Fill server address structure
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // Bind socket with server address
    if (bind(sockfd, (const struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }

    while (1) {
        // Receive message from client with hardware timestamp
        memset(buffer, 0, BUF_SIZE);
        struct msghdr msg = {0};
        struct iovec iov = {0};
        msg.msg_name = &client_addr;
        msg.msg_namelen = sizeof(client_addr);
        msg.msg_iov = &iov;
        msg.msg_iovlen = 1;
        iov.iov_base = buffer;
        iov.iov_len = BUF_SIZE;
        msg.msg_control = &hw_timestamp;
        msg.msg_controllen = sizeof(hw_timestamp);

        int len = recvmsg(sockfd, &msg, 0);
        if (len < 0) {
            perror("Recvmsg failed");
            exit(EXIT_FAILURE);
        }
        buffer[len] = '\0';

        // Convert hardware timestamp to human-readable format
        struct timespec *hw_ts = NULL;
        for (struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg); cmsg != NULL; cmsg = CMSG_NXTHDR(&msg, cmsg)) {
            if (cmsg->cmsg_level == SOL_SOCKET && cmsg->cmsg_type == SCM_TIMESTAMPING) {
                struct timespec *ts = (struct timespec *)CMSG_DATA(cmsg);
                hw_ts = ts + 1;  // Hardware transmit timestamp
                break;
            }
        }
        if (hw_ts != NULL) {
            time_t sec = hw_ts->tv_nsec;
            struct tm *tm_info = localtime(&sec);
            char timebuf[64];
            strftime(timebuf, sizeof(timebuf), "%Y-%m-%d %H:%M:%S", tm_info);
            printf("Message from client: %s", buffer);
            printf("Hardware timestamp: %s.%09ld\n", timebuf, hw_ts->tv_nsec);
        } else {
            printf("Hardware timestamp not available.\n");
        }
    }

    close(sockfd);
    return 0;
}