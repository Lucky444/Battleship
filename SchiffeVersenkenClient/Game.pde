import processing.net.*;

Client myClient = null;
int clientId = -1;

boolean GameGoing = false;

boolean myTurn = false;

void connect() {
  myClient = new Client(this, IP, PORT);
  WritePacket(byte(0));
}

void handleData() {

  if (myClient.available() > 0) {

    byte[] byteBuffer = new byte[10];
    int byteCount = myClient.readBytes(byteBuffer);
    if (byteCount > 0) {
      HandlePacket(byteBuffer);
    }
  }
}

void HandlePacket(byte[] buffer) {

  byte identifier = buffer[0];

  switch(identifier) {

    case(0):
    //Handshaking ID
    if (clientId == -1) {
      clientId = int(buffer[1]);
      if(clientId == 0){
         myTurn = true; 
      }
    }
    break;
    case(1):
    //Readieness Update
    rB.readyPeople = int(buffer[1]);
    break;
    case(2):
    //Game start Signal
    GameGoing = true;
    break;
    case(3):
    //Turn change Event
    myTurn = !myTurn;
    break;
    case(4):
    //Shot event
    boolean hit = false;
    if(!myTurn && grid.grid[int(buffer[1])][int(buffer[2])].set){
        grid.grid[int(buffer[1])][int(buffer[2])].hit = true;
        hit = true;
    }
    WritePacket(byte(3),new byte[]{buffer[1],buffer[2], byte(hit)});
    break;
    case(5):
    //Shot confirmed
    if(myTurn){
     
      int x = int(buffer[1]);
      int y = int(buffer[2]);
      boolean hitConf = boolean(buffer[3]);
      
      if(hitConf){      
        playGrid.grid[x][y].display = 2;     
      }
      
      WritePacket(byte(4));
    }
    break;
  }
}

void WritePacket(byte id) {
  myClient.write(new byte[]{id});
}

void WritePacket(byte id, byte[] data) {
  byte[] send = new byte[data.length + 1];
  send[0] = id;
  for (int i = 0; i < data.length; i++) {
    send[i+1] = data[i];
  }
  myClient.write(send);
}
