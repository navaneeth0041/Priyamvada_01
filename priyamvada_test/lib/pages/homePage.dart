import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:priyamvada_test/pages/list_screen.dart';
import 'package:priyamvada_test/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StorageService service = StorageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform
                      .pickFiles(allowMultiple: false, type: FileType.any);
                  if (result == null) {
                    print("Error: No file selected");
                  } else {
                    final path = result.files.single.path;
                    final fileName = result.files.single.name;
                    service.uploadFile(fileName, path!);
                  }
                },
                child: Text("Upload ")),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListScreen()));
                },
                child: Text("Move to List ")),
          ],
        )),
      ),
    );
  }
}