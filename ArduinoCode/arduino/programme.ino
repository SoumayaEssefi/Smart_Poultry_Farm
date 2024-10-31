#include <ESP32Servo.h>
#include <analogWrite.h>
#include <tone.h>
#include <ESP32Tone.h>
#include <ESP32PWM.h>

#include <RFID.h>
#include <chawkiForAll.h>
#include <deprecated.h>
#include <hum_temp.h>
#include <require_cpp11.h>
#include <screen_I2C.h>

#include <chawkiForAll.h>
#include <ESP32Servo.h>

#define DHT_PIN1 25
#define DHT_TYPE DHT11
#define DHT_PIN2 19
#define SERVO_PIN 27
#define led_pin 12
#define fan_Pin 14
#define led_light 26
#define digitalPin 32  //pour le relais badelha define
#define analogPin 35 

int Niveau;
int max2;
int min2;

const char *firebaseHost = "https://smart-624cb-default-rtdb.firebaseio.com";
const char *databaseSecret = "YsrEXVzW7zd43roHkItP4pWPq7mxsaPoX2RFCIPd";
chawkiForAll all1;
chawkiForAll all2;
  float temperature;
  float humidity;
  float temperature2;
  float humidity2;
  String elect;
  String status;
  String statu;
  String door;
  Servo DoorServo;
void setup() {
  Serial.begin(115200);
  all1.initDHT(DHT_PIN1, DHT_TYPE);
  all2.initDHT(DHT_PIN2, DHT_TYPE);

  // wifi
  all1.initWiFi("soumaya", "soumaya1234");
  all1.connectToWiFi();
  Serial.println("Connected to WiFi!");

  // initiate firebase
  all1.initFb(firebaseHost,databaseSecret );
  DoorServo.attach(SERVO_PIN);  
  pinMode(DHT_PIN1, INPUT);
  pinMode(DHT_PIN2, INPUT);
  pinMode(led_pin,OUTPUT);
  pinMode(fan_Pin,OUTPUT);
  pinMode(led_light,OUTPUT);
 Serial.begin(115200);  //
  Niveau = 0;
  max2 = 900;  
  min2 = 600;
  pinMode(digitalPin, OUTPUT);  


}

void loop() {
  temperature = all1.readTemperature( );
  humidity = all1.readHumidity();
  all1.setFbFloat("Data/temperature", temperature);
  all1.setFbFloat("Data/humidity", humidity);
  all1.getFbString("Data/light", status);
  all1.getFbString("Data/fan", statu);
  all1.getFbString("Data/door", door);
  temperature2 = all2.readTemperature();
  humidity2 = all2.readHumidity();
  all1.setFbFloat("eggs/temperature", temperature2);
  all1.setFbFloat("eggs/humidity", humidity2);
  all1.getFbString("eggs/electricFan", elect);
  Serial.print(elect);

  Serial.print(status);
  if(status=="ON"){

  digitalWrite(led_light, HIGH);
  Serial.println(" che3let");

  delay(1000);
  }
  else {
  digitalWrite(led_light, LOW);
  Serial.println(" tfet");
  
  }
  Serial.print(statu);
  if(statu=="ON"){

  digitalWrite(fan_Pin, HIGH);
  Serial.println(" che3let fan");

  delay(1000);
  }
  else {
  digitalWrite(fan_Pin, LOW);
  Serial.println(" tfet fan");
  
  }
  if (door=="OPEN") {
    DoorServo.write(0);
    Serial.println("open");  
  } 
  else {
    DoorServo.write(80); 
    Serial.println("closed"); 
  }
  if(elect=="ON"){

  digitalWrite(led_pin, HIGH);
  Serial.println(" che3let");

  delay(1000);
  }
  else {
  digitalWrite(led_pin, LOW); // nhotoo f 14 yemchii f 23 mymchich 
  Serial.println(" tfet");
  
  }
  Niveau = analogRead(analogPin);  
  Serial.print("Niveau d'eau: ");
  Serial.println(Niveau);
  if (Niveau < min2) {
    digitalWrite(digitalPin, HIGH);  
    delay(500);
  }
  if (Niveau > max2) {
    digitalWrite(digitalPin, LOW); 
  }

  delay(2000);  


}
