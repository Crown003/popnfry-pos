import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
// import 'services/firestore_service.dart';

class MenuUploadPage extends StatefulWidget {
  const MenuUploadPage({Key? key}) : super(key: key);

  @override
  State<MenuUploadPage> createState() => _MenuUploadPageState();
}

class _MenuUploadPageState extends State<MenuUploadPage> {
  bool _isLoading = false;
  String _statusMessage = "Ready to upload";
  double _progressValue = 0.0;

  Future<void> _handleUpload() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Starting upload...";
      _progressValue = 0.1;
    });

    try {
      // simulate a small delay to show UI
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _statusMessage = "Uploading categories and items...";
        _progressValue = 0.5;
      });

      // Calling your existing static method
      await FirestoreService.bulkInsertMenuData(fullMenuJson);

      setState(() {
        _progressValue = 1.0;
        _statusMessage = "Upload Complete!";
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🎉 Menu uploaded successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _progressValue = 0.0;
        _statusMessage = "Upload Failed";
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu Uploader")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                LinearProgressIndicator(value: _progressValue),
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ] else ...[
                const Icon(
                  Icons.cloud_upload_outlined,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Bulk Upload Menu",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "This will upload the Pizza, Momos, Burgers, and Beverage data to your Firestore.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _handleUpload,
                    icon: const Icon(Icons.upload),
                    label: const Text("START UPLOAD"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// DATA CONSTANT
// ---------------------------------------------------------

const Map<String, dynamic> fullMenuJson = {
  "categories": [
    {
      "name": "Hot Dog",
      "icon": "fastfood",
      "items": [
        {
          "name": "New Yorker Hot Dog",
          "price": 160,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Chicago Hot Dog",
          "price": 160,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Texas Style Chili Hot Dog",
          "price": 160,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Chilli Pepper Hot Dog",
          "price": 160,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Springdale Hot Dog",
          "price": 160,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Hotti 'N' Spicy Ball Dog",
          "price": 160,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Veggie Champ Classic Hot Dog",
          "price": 120,
          "isVeg": true,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Veggie Champ BBQ Hot Dog",
          "price": 120,
          "isVeg": true,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Veggie Champ Tandoori Hot Dog",
          "price": 120,
          "isVeg": true,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
      ],
    },
    {
      "name": "Momos",
      "icon": "dinner_dining",
      "items": [
        {
          "name": "Chicken Kothe (6pcs)",
          "price": 90,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Hot Chicken Garlic (6pcs)",
          "price": 100,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Chicken Suimai (6pcs)",
          "price": 110,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Wheat Momo Chilli Chicken (6pcs)",
          "price": 140,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Chicken Cheese Momos (6pcs)",
          "price": 160,
          "isVeg": false,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Veggie Supreme (6pcs)",
          "price": 90,
          "isVeg": true,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Spicy Ginger Green (6pcs)",
          "price": 100,
          "isVeg": true,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Corn Mix (6pcs)",
          "price": 110,
          "isVeg": true,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Spicy Mushroom & Mix Veg Paneer Momo (6pcs)",
          "price": 120,
          "isVeg": true,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Soya Momo (6pcs)",
          "price": 120,
          "isVeg": true,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
        {
          "name": "Cheese Momo (6pcs)",
          "price": 160,
          "isVeg": true,
          "imagePlaceholder": "",
          "haveVarients": false,
          "varients": [],
        },
      ],
    },
  ],
};
