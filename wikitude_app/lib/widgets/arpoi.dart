// Import necessary packages and libraries.
import 'package:augmented_reality_plugin_wikitude/architect_widget.dart';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:flutter/material.dart';

// Define a stateful widget for the AR view.
class ArPoiWidget extends StatefulWidget {
  const ArPoiWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArPoiWidgetState();
}

// Define the state for the AR widget.
class _ArPoiWidgetState extends State<ArPoiWidget> with WidgetsBindingObserver {
  late ArchitectWidget architectWidget;
  String wikitudeTrialLicenseKey =
      "05m3ik7jy8Ip/hoRgpAs/yTab8PPOrPA5h2GddiYoP2D/QD/kfhiRjkW/1UaotVAZ3+db3aJ+Q0bc/6yXOkZWMVQq+ckAIJFqFuKP/Ts/N/WoeOaH01KlMaFh9DnmI0Ls41Tu6DhSMZlzpfza2HZFua2PMaKL3aD0TgLI7SKHJ5TYWx0ZWRfXxSB7Rx+OccwOz2vIlkWx7oqDxXE9CGpYAm47mRD6Gpn1AeWrVGEjauQwfzSxmRrjPi1GixSV8kgZ+5Dg68rGj+W+NATxa+1eptmXr208w4ZsrzojlnyFuNqstS6xzlR88dWKdGZH7kKP2+lQjlinm9YZixeIWr8EvytGBNFR+/kK0bNfc69vALLRUN2R2sv1MUDZPRSrAKPGzQc+IpkFF8f7gjs5QQy4tsrbWX5RJMlSpV7xOYLY0JjhKCILyGelhZl8vcGGVgIqvErQfTQiNPtUPljB2n4j+le3k8r5vR52HEEr427ihVKvj+dYC0WI4j8vrCtXGjIIGAda8b8cEvrhqDuncoL7OEOgLKFJxEg2ERqBE+NkXBjbGySGdrLe9PFSqODU43NSNQdcsPZ+kkhkvOtllmunWQM6X3QRzpjgDwQaeJD9i/Iqroq/Q6Ju/b41Qi3WXpZAaNY/DWBXj1yV4YYCymiSgnj0dCz9e9ar1T1NBNbjQOXTKMMeCj1Er196ClShKp9HVH6RubBftYVhDOIGsW2iP0rhaNDhqj591MN0zZ+rGAW2UIMZCf1ovELGshDCKjObSqh/Usp9dZFmRXR2hK2X7ntRlOe+83Zrkyqp3CTCscsHNbnL/TTrM0xPlzjP9HIsnj/Oc+goYfEFfJ5/hUYgA==";
  StartupConfiguration startupConfiguration = StartupConfiguration(
      cameraPosition: CameraPosition.BACK,
      cameraResolution: CameraResolution.AUTO);
  List<String> features = ["geo"];

  @override
  void initState() {
    super.initState();

    // Add this widget as an observer of app lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Create the ArchitectWidget for AR view.
    architectWidget = ArchitectWidget(
      onArchitectWidgetCreated: onArchitectWidgetCreated,
      licenseKey: wikitudeTrialLicenseKey,
      startupConfiguration: startupConfiguration,
      features: features,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.orange),
      child: architectWidget,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes.
    switch (state) {
      case AppLifecycleState.paused:
        architectWidget.pause();
        break;
      case AppLifecycleState.resumed:
        architectWidget.resume();
        break;
      default:
    }
  }

  @override
  void dispose() {
    // Pause and destroy the AR widget and remove the observer.
    architectWidget.pause();
    architectWidget.destroy();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Callback when the ArchitectWidget is created.
  Future<void> onArchitectWidgetCreated() async {
    architectWidget.load(
        "AR/MultiplePois/index.html", onLoadSuccess, onLoadFailed);
    architectWidget.resume();
  }

  // Callback when AR content is successfully loaded.
  Future<void> onLoadSuccess() async {
    debugPrint("Successfully loaded Architect World");
  }

  // Callback when AR content fails to load.
  Future<void> onLoadFailed(String error) async {
    debugPrint("Failed to load Architect World");
    debugPrint(error);
  }
}
