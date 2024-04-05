import 'package:flutter/material.dart';
import 'package:priyamvada_test/storage_service.dart';
class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
       
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  StorageService storageService = StorageService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: storageService.listFiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data!.items[index].name),
                );
              });
        }
        return Text("Some error occurred");
      },
    ));
  }
}