#include <SoftwareSerial.h> 
SoftwareSerial module_bluetooth(0, 1); // pin RX | TX
 

char data = 0;             
void setup() 
{
  Serial.begin(9600);         
  pinMode(3,INPUT);  //inisialisasi LED menjadi output
}
void loop()
{
  if(Serial.available() > 0)  
  {
    data = Serial.read();Serial.print(data);    //Reading data and print to monitor
    Serial.print("\n"); 
    //input data      
    if(data == '1'){
    analogWrite(3, HIGH);
    delay(500);
    }
    else if(data == '0'){      
    analogWrite(3, LOW);
    delay(500); 
    } 
     else if(data == '5'){      
    analogWrite(3, 127);
    delay(500); 
     }
    }
  }
