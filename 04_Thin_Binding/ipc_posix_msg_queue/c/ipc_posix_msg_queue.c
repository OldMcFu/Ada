#include <stdio.h>
#include <mqueue.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/time.h>

struct Message_Type
{
    int         value;
    long        timestamp;
};

int create_writer_mq(const char *name)
{
    struct mq_attr init_attr;

    init_attr.mq_flags = 0;
    init_attr.mq_maxmsg = 1;
    init_attr.mq_msgsize = sizeof(struct Message_Type);
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
    init_attr.mq_msgsize = sizeof(struct Message_Type);
    init_attr.mq_curmsgs = 0;

    mqd_t mqd = mq_open(name, O_RDONLY | O_CLOEXEC, 0660, &init_attr);

    return mqd;
}

void close_reader_mq(int mqd)
{
    mq_close(mqd);
}

int writer_mq(int mqd, const struct Message_Type* msg)
{
    int loaded_msgs = 0;
    struct Message_Type buf;
    
    struct mq_attr attr;

    // Check if message is in queue
    mq_getattr(mqd, &attr);
    loaded_msgs = attr.mq_curmsgs;

    while (loaded_msgs != 0)
    {
        // Remove old messages
        mq_receive(mqd, (char *) &buf, sizeof(buf), NULL);
        loaded_msgs = loaded_msgs - 1;
    }

    return mq_send(mqd, (const char *) msg, sizeof(*msg), 0);
    
}

int reader_mq(int mqd, struct Message_Type* out)
{
    int ret = -1;

    ret = mq_receive(mqd, (char *) out, sizeof(*out), NULL);

    return ret;
}