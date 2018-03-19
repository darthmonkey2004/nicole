#include <IRremote.h>
int type = 0;
int bits = 0;
long address = 0;
long code = 0;
int id = 0;
IRsend irsend;

void setup()
{
  Serial.begin(9600);
}

// Storage for the recorded code
int codeType = -1; // The type of code
unsigned long codeValue; // The code value if not raw
unsigned int rawCodes[RAWBUF]; // The durations if raw
int codeLen; // The length of the code
int toggle = 0; // The RC5/6 toggle state

void sendCode(int repeat) {
  if (codeType == NEC) {
    if (repeat) {
      irsend.sendNEC(REPEAT, codeLen);
      Serial.println("Sent NEC repeat");
    } 
    else {
      irsend.sendNEC(codeValue, codeLen);
      Serial.print("Sent NEC ");
      Serial.println(codeValue, HEX);
    }
  } 
  else if (codeType == SONY) {
    irsend.sendSony(codeValue, codeLen);
    Serial.print("Sent Sony ");
    Serial.println(codeValue, HEX);
  } 
  else if (codeType == PANASONIC) {
    irsend.sendPanasonic(codeValue, codeLen);
    Serial.print("Sent Panasonic");
    Serial.println(codeValue, HEX);
  }
  else if (codeType == JVC) {
    irsend.sendJVC(codeValue, codeLen, false);
    Serial.print("Sent JVC");
    Serial.println(codeValue, HEX);
  }
  else if (codeType == RC5 || codeType == RC6) {
    if (!repeat) {
      // Flip the toggle bit for a new button press
      toggle = 1 - toggle;
    }
    // Put the toggle bit into the code to send
    codeValue = codeValue & ~(1 << (codeLen - 1));
    codeValue = codeValue | (toggle << (codeLen - 1));
    if (codeType == RC5) {
      Serial.print("Sent RC5 ");
      Serial.println(codeValue, HEX);
      irsend.sendRC5(codeValue, codeLen);
    } 
    else {
      irsend.sendRC6(codeValue, codeLen);
      Serial.print("Sent RC6 ");
      Serial.println(codeValue, HEX);
    }
  } 
  else if (codeType == UNKNOWN /* i.e. raw */) {
    // Assume 38 KHz
    irsend.sendRaw(rawCodes, codeLen, 38);
    Serial.println("Sent raw");
  }
  else if (codeType == SAMSUNG) {
    irsend.sendSAMSUNG(codeValue, codeLen);
    Serial.println("Sent SAMSUNG");
    Serial.println(codeValue, HEX);
  }
  else if (codeType == WHYNTER) {
    irsend.sendWhynter(codeValue, codeLen);
    Serial.println("Sent Whynter");
    Serial.println(codeValue, HEX);
  }
  else if (codeType == AIWA_RC_T501) {
    irsend.sendAiwaRCT501(codeValue);
    Serial.println("Sent AIWA_RC_T501");
    Serial.println(codeValue, HEX);
  }
  else if (codeType == LG) {
    irsend.sendLG(codeValue, codeLen);
    Serial.println("Sent LG");
    Serial.println(codeValue, HEX);
  }
  else if (codeType == SANYO) {
    Serial.println("Sorry, Sanyo is still under development. Check back later!");
  }
  else if (codeType == MITSUBISHI) {
    Serial.println("Sorry, Mitsubishi is still under development. Check back later!");
  }
  else if (codeType == DISH) {
    irsend.sendDISH(codeValue, codeLen);
    Serial.println("Sent Dish");
    Serial.println(codeValue, HEX);
  }
  else if (codeType == SHARP) {
    irsend.sendSharpRaw(codeValue, codeLen);
    Serial.println("Sent Sharp (raw)");
    Serial.println(codeValue, HEX);
  }
  else if (codeType == DENON) {
    irsend.sendDenon(codeValue, codeLen);
    Serial.println("Sent Denon");
    Serial.println(codeValue, HEX);
  }
  delay (100);
  irrecv.enableIRIn();
}

void getSerial()
{
  String in_str = Serial.readStringUntil(':');
    if (in_str)
  {
    codeType = in_str;
    Serial.print("CodeType=");
    Serial.println(codeType);
    String in_str = Serial.readStringUntil(';');
    int in = in_str.toInt();
    repeat = in;
    Serial.print("Repeat=");
    Serial.println(repeat);
    in = 0;
    String in_str = Serial.readStringUntil(',');
    int in = in_str.toInt();
    codeLen = in;
    Serial.print("CodeLength=");
    Serial.println(codeLen);
    String in_str = Serial.readStringUntil('\n');
    int strlen = in_str.length();
    strlen = ++strlen;
    char toarray[strlen];
    in_str.toCharArray(toarray,sizeof(toarray));
    codeValue = atoi(toarray);
    Serial.print("CodeValue=");
    Serial.println(codeValue, HEX);
  }
}
void loop() {
  if (Serial.read() != -1) {
    getSerial();
    sendCode(repeat);
  }
}
