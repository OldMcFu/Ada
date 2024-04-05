import socket

# Define the server address and port
server_address = ('localhost', 45100)

# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

# Bind the socket to the server address
sock.bind(server_address)

print(f"UDP server is listening on {server_address}")

while True:
    # Receive message from client
    data, address = sock.recvfrom(4096)

    print(f"Received message from {address}: {data.decode()}")

    # Echo back the message to the client
    sock.sendto(data, address)
    
