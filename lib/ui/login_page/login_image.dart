import 'package:flutter/cupertino.dart';

/// the view layer of the image used in login page
class LoginImage extends StatelessWidget {
  const LoginImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ClipOval(
            child: Image.asset(
      "images/Klee.jpg",
      alignment: Alignment.center,
      colorBlendMode: BlendMode.saturation,
      fit: BoxFit.cover,
    )));
  }
}
