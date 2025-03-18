import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'setup_screen5.dart'; // ✅ Next setup screen

class SetupScreen4 extends StatefulWidget {
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  const SetupScreen4({
    super.key,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  @override
  State<SetupScreen4> createState() => _SetupScreen4State();
}

class _SetupScreen4State extends State<SetupScreen4> {
  double? latitude;
  double? longitude;
  bool _isFetchingLocation = false;

  Future<void> _getLocation() async {
    setState(() => _isFetchingLocation = true);

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } catch (e) {
      debugPrint("❌ Location Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to get location. Enable GPS.")),
      );
    }

    setState(() => _isFetchingLocation = false);
  }

  void _nextStep() {
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please get your location first!")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => SetupScreen5(
              email: widget.email,
              firstName: widget.firstName,
              lastName: widget.lastName,
              password: widget.password,
              latitude: latitude!,
              longitude: longitude!,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 40),

            // ✅ Title
            const Text(
              "Get Your Location",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ✅ Subtitle
            const Text(
              "We need your location to improve our services.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // ✅ Location Display
            Center(
              child: Column(
                children: [
                  if (latitude != null && longitude != null)
                    Text(
                      "Latitude: $latitude\nLongitude: $longitude",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 20),

                  // ✅ Get Location Button
                  ElevatedButton.icon(
                    onPressed: _isFetchingLocation ? null : _getLocation,
                    icon: const Icon(Icons.my_location),
                    label:
                        _isFetchingLocation
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text("Get My Location"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ✅ Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
