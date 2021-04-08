import 'package:donkeykong/controllers/initial_bidings.dart';
import 'package:donkeykong/ui/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors
            .black, //Mudar para branco facilita na criação da fase exibido o grid
      ),
      home: MainScreen(),
      initialBinding: InitialBidings(),
    );
  }
}
