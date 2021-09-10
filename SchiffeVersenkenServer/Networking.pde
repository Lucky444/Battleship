import processing.net.*;

Server myServer;
int connectedClients = 0;
int readyClients = 0;

void connect() {
  myServer = new Server(this, PORT);
  WritePacket(byte(0));
}

void handleData() {

  if (myServer.available() != null) {

    Client thisC = myServer.available();

    byte[] byteBuffer = new byte[10];
    byteBuffer = thisC.readBytes();
    if (byteBuffer.length > 0) {
      HandlePacket(byteBuffer);
    }
  }
}

void HandlePacket(byte[] buffer) {

  byte identifier = buffer[0];

  switch(identifier) {
    case(0):
    //Handshake Request
    WritePacket(byte(0), new byte[]{byte(connectedClients)});
    connectedClients ++;
    break;
    case(1):
    //Readiness Update
    boolean b = boolean(buffer[1]);
    if (b)
      readyClients ++;
    else
      readyClients --;

    if (readyClients >= connectedClients) {
      WritePacket(byte(2));
    } else {
      WritePacket(byte(1), new byte[]{byte(readyClients)});
    }
    break;
    case(2):
    WritePacket(byte(4),new byte[]{buffer[1],buffer[2]});
    break;
    case(3):
    //Shot confirmed Event
    WritePacket(byte(5),new byte[]{buffer[1],buffer[2],buffer[3]});
    break;
    case(4):
    //End of turn event
    WritePacket(byte(3));
    break;
  }
}

void WritePacket(byte id) {
  myServer.write(new byte[]{id});
}

void WritePacket(byte id, byte[] data) {
  byte[] send = new byte[data.length + 1];
  send[0] = id;
  for (int i = 0; i < data.length; i++) {
    send[i+1] = data[i];
  }
  myServer.write(send);
}
