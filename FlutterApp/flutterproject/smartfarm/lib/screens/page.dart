import 'package:flutter/material.dart';
import 'package:smartfarm/screens/home.dart';
import 'package:firebase_database/firebase_database.dart';

class PageS extends StatefulWidget {
  PageS({super.key});

  @override
  _PageSState createState() => _PageSState();
}

class _PageSState extends State<PageS> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('eggs');
  bool iFan = false;
  @override
  void initState() {
    super.initState();
    _initializeFanState();
  }

  void _initializeFanState() async {
    final snapshot = await _databaseRef.child('electricFan').get();
    if (snapshot.exists) {
      setState(() {
        iFan = snapshot.value == 'ON';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SMART-FARM-Hatchery-eggs',
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
                    final numberofeggs =
                        data?['numberofeggs']?.toString() ?? 'N/A';

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      children: [
                        createGridItem(context, 'assets/images/weather.png',
                            'TEMPERATURE', '$temperature°C'),
                        createGridItem(context, 'assets/images/eau.png',
                            'HUMIDITY', '$humidity%'),
                        createGridItem(context, 'assets/images/door.png',
                            'NUMBER OF EGGS', '$numberofeggs'),
                        createGridItem(context, 'assets/images/power.png',
                            'ELECTRIC FAN', iFan ? 'ON' : 'OFF'),
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
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 57, 115, 41),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  'Prev',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
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
        if (title == 'ELECTRIC FAN') {
          setState(() {
            iFan = !iFan;
            _databaseRef.update({
              'electricFan': iFan ? 'ON' : 'OFF',
            });
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title updated')),
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
