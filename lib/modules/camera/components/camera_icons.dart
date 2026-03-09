import 'package:flutter/material.dart';

//enum 으로 해도될듯
class CameraIcons extends StatelessWidget {
  const CameraIcons({Key? key, required this.icon, required this.onTap}) : super(key: key);
  final icon;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return   InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: icon,
      )
    );
  }
}
