import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Feature extends StatelessWidget {
  const Feature({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    this.press,
  }) : super(key: key);

  final String title;
  final String icon;
  final Color color;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = (size.width - 120) / 2 - 18;

    return GestureDetector(
      onTap: press,
      child: Container(
        height: width,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: color,
              ),
              child: SvgPicture.asset(icon, width: 18, height: 18),
            ),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
