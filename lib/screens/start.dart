import 'package:flutter/material.dart';
import 'package:notpad/screens/home.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            Column(
              children: [
                Icon(Icons.start, size: 100.0, color: Colors.blue),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Welcome to your Calculator.",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalculatorApp()),
                    );
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18.0),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
