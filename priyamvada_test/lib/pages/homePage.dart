// import 'dart:js';
// import 'dart:js';

import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlatformFile? _imagePicker;
  bool _loading=false;
  final Dio dio =Dio();
  double progress=0.0;

  Future<bool> saveFile(String url, String fileName) async {
 Directory directory;
 try {
    if (Platform.isAndroid) {
      if (await _requestPermission(Permission.storage)) {
        print("Storage permission granted");
        Directory? directory = await getExternalStorageDirectory();
        if (directory == null) {
          print("Failed to get external storage directory");
          return false;
        }
        print("External storage directory: ${directory.path}");

        File saveFile = File(directory.path + "/$fileName");
        await dio.download(url, saveFile.path, onReceiveProgress: (downloaded, totalSize) {
          setState(() {
            progress = downloaded / totalSize;
          });
        });
        print("Download completed for Android");
        return true;
      } else {
        return false;
      }
    } else {
      if (await _requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
      } else {
        return false;
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveFile = File(directory.path + "/$fileName");
        print("Starting download to: ${saveFile.path}");
        await dio.download(url, saveFile.path, onReceiveProgress: (downloaded, totalSize) {
          setState(() {
            progress = downloaded / totalSize;
          });
        });
        print("Download completed");
        if (Platform.isIOS) {
          ImageGallerySaver.saveFile(saveFile.path, isReturnPathOfIOS: true);
        }
        return true;
      }
    }
 } catch (e) {
    print("Exception occurred: $e");
 }
 return false; //THE CONDITION
}


  downloadFile() async {
    setState(() {
      _loading=true;
    });

    bool downloaded= await saveFile("https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",
    "video.mp4");// name of the file that we want to keep
    if (downloaded){
      print("File downloaded");
    }
    else {
      print("Problem in downloading the file");
    }

    setState(() {
      _loading=false;
    });
  } 

  Future<bool> _requestPermission(Permission permission)async{
    if (await permission.isGranted){
      return true;
    }
    else{
      var result= await permission.request();
      if (result==PermissionStatus.granted){
        return true;
      }else{
        return false;
      }
    }
  }

  

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
        title:const Text("Priyamvada_01;"),
      ),
      body:Column(
        children: [
          // Image.memory(Uint8List.fromList(_imagePicker!.bytes!),width:300 ,height: 300,),
          ElevatedButton(onPressed: () {_pickAudio(context);}, child:const Text("Upload audio")),
          const SizedBox(height: 40),
          ElevatedButton(onPressed: () {downloadFile();}, child: Text("Download audio")),
          LinearProgressIndicator(value: progress,minHeight: 10,)
        ],
      ),
    );
  }
}