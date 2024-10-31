import 'package:flutter/material.dart';
import 'package:smartfarm/screens/page.dart';
import 'package:smartfarm/screens/signup.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('Data');

  bool Light = true;
  bool Fan = false;
  bool Door = false;

  @override
  void initState() {
    super.initState();
    _DeviceStates();
  }

  void _DeviceStates() async {
    DatabaseEvent event = await _databaseRef.once();
    if (event.snapshot.value != null) {
      final data = event.snapshot.value as Map?;
      setState(() {
        Light = data?['light'] == 'ON';
        Fan = data?['fan'] == 'ON';
        Door = data?['door'] == 'CLOSED';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SMART-FARM',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 57, 115, 41),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _databaseRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data?.snapshot.value == null) {
                    return Center(child: Text('Aucune donnée disponible'));
                  } else {
                    final data = snapshot.data?.snapshot.value as Map?;
                    final humidity = data?['humidity']?.toString() ?? 'N/A';
                    final temperature =
                        data?['temperature']?.toString() ?? 'N/A';
                    final FODDER = data?['FODDER']?.toString() ?? 'N/A';

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      children: [
                        createGridItem(context, 'assets/images/bt.jpg',
                            'LIGHTS', Light ? 'ON' : 'OFF'),
                        createGridItem(context, 'assets/images/eau.png',
                            'HUMIDITY', '$humidity%'),
                        createGridItem(context, 'assets/images/weather.png',
                            'TEMPERATURE', '$temperature°C'),
                        createGridItem(context, 'assets/images/door.png',
                            'DOOR', Door ? 'CLOSED' : 'OPEN'),
                        createGridItem(context, 'assets/images/sack.png',
                            'FODDER', '$FODDER'),
                        createGridItem(context, 'assets/images/power.png',
                            'ELECTRIC FAN', Fan ? 'ON' : 'OFF'),
                      ],
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageS(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 57, 115, 41),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  'NEXT',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createGridItem(
      BuildContext context, String imagePath, String title, String status) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (title == 'LIGHTS') {
            Light = !Light;
            _databaseRef.update({
              'light': Light ? 'ON' : 'OFF',
            });
          } else if (title == 'ELECTRIC FAN') {
            Fan = !Fan;
            _databaseRef.update({
              'fan': Fan ? 'ON' : 'OFF',
            });
          } else if (title == 'DOOR') {
            Door = !Door;
            _databaseRef.update({
              'door': Door ? 'CLOSED' : 'OPEN',
            });
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '$title updated to ${title == 'LIGHTS' ? (Light ? "ON" : "OFF") : title == 'ELECTRIC FAN' ? (Fan ? "ON" : "OFF") : (Door ? "CLOSED" : "OPEN")}'),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath,
                height: 50, color: Color.fromARGB(255, 57, 115, 41)),
            SizedBox(height: 20.0),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 115, 41)),
            ),
            SizedBox(height: 4.0),
            Text(
              status,
              style: TextStyle(
                  fontSize: 14, color: Color.fromARGB(255, 57, 115, 41)),
            ),
          ],
        ),
      ),
    );
  }
}
