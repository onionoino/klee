import 'package:flutter/material.dart';

/// the view layer of the image widget used in home page
class HomeImage extends StatelessWidget {
  const HomeImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipOval(
        child: Image.asset(
          "images/KleeIcon.jpg",
          alignment: Alignment.center,
          colorBlendMode: BlendMode.saturation,
          width: MediaQuery
              .of(context)
              .size
              .width / 1.25,
          height: MediaQuery
              .of(context)
              .size
              .width / 1.25,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
