import 'package:flutter/material.dart';
import '../widgets/arpoi.dart';

class ArWordPage extends StatefulWidget {
  const ArWordPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArWordPageState();
}

class _ArWordPageState extends State<ArWordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language"),
      ),
      body: const Center(
          // Here we load the Widget with the AR Poi experience
          child: ArPoiWidget()),
    );
  }
}
