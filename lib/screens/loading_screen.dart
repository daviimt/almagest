import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      SpinKitFadingCube(
        color: Colors.black,
        size: 40,
      ),
      SizedBox(height: 60),
      Text('NO INTERNET CONNECTION',
          style: TextStyle(color: Colors.black, fontSize: 25)),
    ]);
  }
}
