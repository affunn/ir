#include <WiFi.h>
#include <PubSubClient.h>

const char* ssid = "KAYATI WIFI";
const char* password = "12345yati";
const char* mqtt_server = "broker.hivemq.com";

WiFiClient espClient;
PubSubClient client(espClient);

#define IR_PIN 19
#define LED_PIN 2

int counter = 0;
int lastIRState = HIGH;

void reconnect() {
  while (!client.connected()) {
    if (client.connect("ESP32_IR_COUNTER")) {
      // connected
    } else {
      delay(2000);
    }
  }
}

void setup() {
  pinMode(IR_PIN, INPUT);
  pinMode(LED_PIN, OUTPUT);

  Serial.begin(115200);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
  }

  client.setServer(mqtt_server, 1883);
}

void loop() {
  if (!client.connected()) reconnect();
  client.loop();

  int currentIRState = digitalRead(IR_PIN);

  // DETEKSI OBJEK LEWAT (HIGH → LOW)
  if (lastIRState == HIGH && currentIRState == LOW) {
    counter++;

    digitalWrite(LED_PIN, HIGH); // LED nyala
    delay(300);
    digitalWrite(LED_PIN, LOW);

    char msg[10];
    itoa(counter, msg, 10);
    client.publish("esp32/count", msg);
  }

  lastIRState = currentIRState;
  delay(50); // debounce ringan
}
