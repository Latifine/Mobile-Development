import 'arword.dart';
import 'package:flutter/material.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';

// Define a stateful widget for the home page.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

// Define the state for the home page.
class _HomePageState extends State<HomePage> {
  List<String> features = ["geo"]; // List of AR features to check

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language Game Wikitude"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: navigateToWords,
          child: const Text("Collect words from the same language!"),
        ),
      ),
    );
  }

  // Function to navigate to the AR word collection page.
  void navigateToWords() {
    checkDeviceCompatibility().then((value) => {
          if (value.success)
            {
              requestARPermissions().then((value) => {
                    if (value.success)
                      {
                        // If the device is compatible and permissions are granted,
                        // navigate to the AR word collection page.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ArWordPage(),
                          ),
                        )
                      }
                    else
                      {
                        debugPrint("AR permissions denied"),
                        debugPrint(value.message)
                      }
                  })
            }
          else
            {debugPrint("Device incompatible"), debugPrint(value.message)}
        });
  }

  // Function to check device compatibility for AR.
  Future<WikitudeResponse> checkDeviceCompatibility() async {
    return await WikitudePlugin.isDeviceSupporting(features);
  }

  // Function to request AR permissions.
  Future<WikitudeResponse> requestARPermissions() async {
    return await WikitudePlugin.requestARPermissions(features);
  }
}
