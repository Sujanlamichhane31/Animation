import 'package:flutter/material.dart';
import 'package:newone/viewmodels/home_model.dart';
import 'package:newone/viewmodels/home_view.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeView(
        
        ),
      ),
      
    );
  }
}
