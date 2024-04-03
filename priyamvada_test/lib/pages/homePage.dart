// import 'dart:js';
// import 'dart:js';

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlatformFile? _imagePicker;
  Future<void> _pickAudio(BuildContext context) async {
    try{
      FilePickerResult? _result= await FilePicker.platform.pickFiles(type: FileType.audio);
      if (_result==null) return;

      setState((){
        _imagePicker=_result.files.first;
      });
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Priyamvada"),
      ),
      body:Column(
        children: [
          // Image.memory(Uint8List.fromList(_imagePicker!.bytes!),width:300 ,height: 300,),
          ElevatedButton(onPressed: () {_pickAudio(context);}, child:const Text("Upload audio"))
        ],
      ),
    );
  }
}