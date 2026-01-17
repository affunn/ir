const client = mqtt.connect('wss://broker.hivemq.com:8884/mqtt');

client.on('connect', () => {
  console.log('Connected to MQTT');
  client.subscribe('esp32/count');
});

client.on('message', (topic, message) => {
  if (topic === 'esp32/count') {
    document.getElementById('count').innerText =
      message.toString();
  }
});
