import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'side_panel.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("App Bar"),
      ),
      body: Row(
        children: [
          // Left Side Panel
          SidePanel(
            id: "leftPanel",
            defaultWidth: 220.0,
            minWidth: 205.0,
            maxWidth: 500.0,
            handlePosition: HandlePosition.right,
            child: Container(
              color: Colors.red,
              child: const Text("Left Panel Content"),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Center',
              ),
            ),
          ),
          SidePanel(
            id: "rightPanel",
            defaultWidth: 220.0,
            minWidth: 205.0,
            maxWidth: 500.0,
            handlePosition: HandlePosition.left,
            child: Container(
              color: Colors.blue,
              child: const Text("Right Panel Content"),
            ),
          ),
        ],
      ),
    );
  }
}
