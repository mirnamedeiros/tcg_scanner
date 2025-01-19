import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
    this.topImage = "assets/images/hat.png",
  }) : super(key: key);

  final String topImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                topImage,
                width: 420,
              ),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}
