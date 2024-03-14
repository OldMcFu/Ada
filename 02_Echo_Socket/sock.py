import socket

target_host = "127.0.0.1"
target_port = 12321

# create a socket connection
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# let the client connect
client.connect((target_host, target_port))
while 1:
    # send some data
    # input
    input1 = input()
    client.send(input1.encode())
    print("Send Data: " + input1)
    # get some data
    response = client.recv(1024)
    print (response)    