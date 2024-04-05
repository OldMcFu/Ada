#include <stdio.h>
#include <mqueue.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>

int create_writer_mq(const char *name)
{
    struct mq_attr init_attr;

    init_attr.mq_flags = 0;
    init_attr.mq_maxmsg = 1;
    init_attr.mq_msgsize = 8;
    init_attr.mq_curmsgs = 0;

    mq_unlink(name);
    mqd_t mqd = mq_open(name, O_RDWR | O_CREAT | O_EXCL | O_CLOEXEC , 0660, &init_attr);

    return mqd;
}

void close_write_mq(int mqd, const char *name)
{
    mq_close(mqd);
    mq_unlink(name);
}

int create_reader_mq(const char *name)
{
    struct mq_attr init_attr;
    
    init_attr.mq_flags = 0;
    init_attr.mq_maxmsg = 1;
    init_attr.mq_msgsize = 8;
    init_attr.mq_curmsgs = 0;
    mqd_t mqd = mq_open(name, O_RDONLY | O_CLOEXEC, 0660, &init_attr);

    return mqd;
}

void close_reader_mq(int mqd)
{
    mq_close(mqd);
}

int writer_mq(int mqd, const char msg)
{
    int loaded_msgs = 0;
    char str[2] = {msg, '\0'};
    char buff[8] = {'\0'};
    struct mq_attr attr;

    // Check if message is in queue
    mq_getattr(mqd, &attr);
    loaded_msgs = attr.mq_curmsgs;

    while (loaded_msgs != 0)
    {
        // Remove old messages
        mq_receive(mqd, buff, attr.mq_msgsize, NULL);
        loaded_msgs = loaded_msgs - 1;
    }

    return mq_send(mqd, str, strlen(str), 0);
}

int reader_mq(int mqd, char* out)
{
    int ret = -1;
    char buff[8] = {'\0'};

    ret = mq_receive(mqd, buff, 8, NULL);
    *out = buff[0];
    return ret;
}