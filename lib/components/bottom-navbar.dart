import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tcg_scanner/constants.dart';
import 'package:tcg_scanner/screens/picture-card/take-picture-screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  // Obter a câmera globalmente ou de outro lugar (neste caso, apenas um exemplo)
  CameraDescription? camera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      setState(() {
        camera = cameras.first;
      });
    } catch (e) {
      print("Error fetching cameras: $e");
    }
  }

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(55),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                      backgroundColor: currentIndex == 1
                          ? kPrimaryColor
                          : kPrimaryLightColor,
                      elevation: 0.1,
                      onPressed: () async {
                        if (camera != null) {
                          setBottomBarIndex(1);
                          try {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    TakePictureScreen(camera: camera!),
                              ),
                            );
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          print("Câmera não disponível.");
                        }
                      },
                      child: Icon(
                        Icons.photo_camera,
                        color: currentIndex == 1
                            ? kPrimaryLightColor
                            : kPrimaryColor,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: currentIndex == 0
                                ? kPrimaryColor
                                : kPrimaryLightColor,
                          ),
                          onPressed: () {
                            setBottomBarIndex(0);
                          },
                          splashColor: Colors.white,
                        ),
                        Container(width: size.width * 0.20),
                        IconButton(
                          icon: Icon(
                            Icons.folder,
                            color: currentIndex == 2
                                ? kPrimaryColor
                                : kPrimaryLightColor,
                          ),
                          onPressed: () {
                            setBottomBarIndex(2);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
