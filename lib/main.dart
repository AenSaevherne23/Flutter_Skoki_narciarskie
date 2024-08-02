import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator punktów za skok narciarski',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScoreCalculator(title: 'Kalkulator punktów za skok narciarski'),
    );
  }
}

class ScoreCalculator extends StatefulWidget {
  const ScoreCalculator({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ScoreCalculatorState createState() => _ScoreCalculatorState();
}

class _ScoreCalculatorState extends State<ScoreCalculator> {
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController judge1Controller = TextEditingController();
  final TextEditingController judge2Controller = TextEditingController();
  final TextEditingController judge3Controller = TextEditingController();
  final TextEditingController windPointsController = TextEditingController();

  String selectedHillType = 'Normalna'; 

  final Map<String, double> hillTypeCoefficients = {
    'Normalna': 2.0,
    'Duża': 1.8,
    'Mamucia': 1.2,
  };

  double calculateScore() {
    try {
      double distance = double.parse(distanceController.text);
      double judge1 = double.parse(judge1Controller.text);
      double judge2 = double.parse(judge2Controller.text);
      double judge3 = double.parse(judge3Controller.text);
      double windPoints = double.parse(windPointsController.text);

      double totalDistancePoints = 0;

      double roundedDistance = (distance * 2).round() / 2;
      double roundedJudge1 = (judge1 * 2).round() / 2;
      double roundedJudge2 = (judge2 * 2).round() / 2;
      double roundedJudge3 = (judge3 * 2).round() / 2;

      double hillTypeCoefficient = hillTypeCoefficients[selectedHillType] ?? 2.0;

      if (selectedHillType == 'Normalna') {
        totalDistancePoints = 60 + ((roundedDistance - 90) * hillTypeCoefficient);
      } else if (selectedHillType == 'Duża') {
        totalDistancePoints = 60 + ((roundedDistance - 120) * hillTypeCoefficient);
      } else if (selectedHillType == 'Mamucia') {
        totalDistancePoints = 120 + ((roundedDistance - 200) * hillTypeCoefficient);
      }

      totalDistancePoints = totalDistancePoints.clamp(0, double.infinity);

      double totalScore = totalDistancePoints + roundedJudge1 + roundedJudge2 + roundedJudge3 + windPoints;
      return double.parse(totalScore.toStringAsFixed(1)); 
    } catch (e) {
      print(e);
      return 0.0;
    }
  }

  void resetFields() {
    distanceController.clear();
    judge1Controller.clear();
    judge2Controller.clear();
    judge3Controller.clear();
    windPointsController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField<String>(
              value: selectedHillType,
              items: hillTypeCoefficients.keys.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedHillType = value ?? 'Normalna';
                });
              },
              decoration: InputDecoration(labelText: 'Typ skoczni'),
            ),
            TextField(
              controller: distanceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Odległość (metry)'),
            ),
            TextField(
              controller: judge1Controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Nota sędziego 1'),
            ),
            TextField(
              controller: judge2Controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Nota sędziego 2'),
            ),
            TextField(
              controller: judge3Controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Nota sędziego 3'),
            ),
            TextField(
              controller: windPointsController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Punkty za wiatr'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text('Oblicz punkty'),
                ),
                ElevatedButton(
                  onPressed: resetFields,
                  child: Text('Resetuj'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Wynik: ${calculateScore()}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    distanceController.dispose();
    judge1Controller.dispose();
    judge2Controller.dispose();
    judge3Controller.dispose();
    windPointsController.dispose();
    super.dispose();
  }
}
