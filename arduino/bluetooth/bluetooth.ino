#include "BluetoothSerial.h"
#include <Arduino.h>

BluetoothSerial SerialBT;

void setup() {
  Serial.begin(115200);
  SerialBT.begin("ESP32test"); // Bluetooth device name
  Serial.println("The device started, now you can pair it with Bluetooth!");

  // Get the Bluetooth MAC address and print it
  uint8_t btAddress[6];
  esp_read_mac(btAddress, ESP_MAC_BT);
  Serial.print("Bluetooth MAC Address: ");
  for (int i = 0; i < 6; i++) {
    Serial.print(btAddress[i], HEX);
    if (i < 5) {
      Serial.print(':');
    }
  }
  Serial.println();
}

void loop() {
  if (SerialBT.available()) {
   // Serial.println("Bluetooth device connected!");
    Serial.write(SerialBT.read());
  }

}
