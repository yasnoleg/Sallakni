import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

//COLORS
class Couleur {
  Color White = Colors.white;
  Color Black = Colors.black;
  Color Grey = Color.fromARGB(255, 231, 230, 230);
  Color Transparent = Colors.transparent;
  
  HexColor LightBlue = HexColor('#83c9f4');
  HexColor LightGreen = HexColor('#b8f2e6');
  HexColor LightRed = HexColor('#ffa69e');
  HexColor LightPurple = HexColor('#B799FF');
}

//TEXT STYLES
const HugeTitleStyle = TextStyle(
  fontSize: 27,
  fontWeight: FontWeight.w800,
  fontFamily: 'huge_title',
  letterSpacing: 1,
  color: Colors.black,
);

const SmallTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  fontFamily: 'small_title',
  color: Colors.black,
);

const TitleStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  fontFamily: 'title',
  color: Colors.black,
  letterSpacing: 2,
);

const StyleText = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  letterSpacing: 2,
  fontFamily: 'text',
  color: Colors.black,
);

const MidTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w300,
  letterSpacing: 2,
  fontFamily: 'text',
  color: Colors.black,
);

const SmallTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w300,
  fontFamily: 'small_text',
  color: Colors.black,
);

const VerySmallTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w300,
  fontFamily: 'small_text',
  color: Colors.black,
);

const HintTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w300,
  color: Colors.black26,
  fontFamily: 'small_text'
);

const LableTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: Colors.black45,
  fontFamily: 'text',
);

const ButtonTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontFamily: 'small_title',
);
//-----------------------------------------


//dots

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0;
        final dashHeight = 4.0;
        return Flex(
          children: List.generate(14, (_) {
            return Padding(
              padding: EdgeInsets.only(bottom: 2.5),
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          direction: Axis.vertical,
        );
      },
    );
  }
}