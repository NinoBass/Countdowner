import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Timer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Countdown Timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _minutes = 0;
  int _seconds = 0;
  int _countDownDuration = 0;
  Duration get countDownDuration => Duration(seconds: _countDownDuration);
  int get countDownMinutesInSeconds => Duration(minutes: _minutes).inSeconds;

  Timer? _timer;

  void toggleCountdown() {
    //Stop Countdown Logic
    //Basically, if countdown is active, stop it and reset the duration
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      _countDownDuration = 0;
      setState(() {});

      return;
    }

    //If countdown is not active,
    _countDownDuration = countDownMinutesInSeconds + _seconds;
    setState(() {});
    if (_countDownDuration == 0) {
      return;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (_countDownDuration > 0) {
          _countDownDuration--;
          setState(() {});
        } else {
          _timer?.cancel();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${countDownDuration.inMinutes.remainder(60)}:${(countDownDuration.inSeconds.remainder(60).toString().padLeft(2, '0'))}',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Minutes',
                      ),
                      onChanged: (val) {
                        setState(() {
                          _minutes = val.isEmpty ? 0 : int.parse(val);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Seconds',
                      ),
                      onChanged: (val) {
                        setState(() {
                          _seconds = val.isEmpty ? 0 : int.parse(val);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: toggleCountdown,
                child: Text(
                  (_timer?.isActive ?? false) ? 'Stop Timer' : 'Start Timer',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
