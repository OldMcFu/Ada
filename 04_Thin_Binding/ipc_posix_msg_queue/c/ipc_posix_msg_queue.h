
#pragma once

int create_writer_mq(const char* name);
void close_write_mq(int mqd, const char* name);;

int create_reader_mq(const char* name);
void close_reader_mq(int mqd);

int writer_mq(int mqd, const char msg);
char reader_mq(int mqd);

