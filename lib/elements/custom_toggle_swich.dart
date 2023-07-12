// import 'package:flutter/material.dart';

// class ToggleButton extends StatefulWidget {
//   final String button1Value;
//   final String button2Value;
//   final String button1Label;
//   final String button2Label;
//   final String selectedValue;
//   final Function(String) onTimeWindowChanged;

//   const ToggleButton({
//     Key? key,
//     required this.button1Value,
//     required this.button2Value,
//     required this.button1Label,
//     required this.button2Label,
//     required this.selectedValue,
//     required this.onTimeWindowChanged,
//   }) : super(key: key);

//   @override
//   _ToggleButtonState createState() => _ToggleButtonState();
// }

// const double width = 200.0;
// const double height = 30.0;
// const double loginAlign = -1;
// const double signInAlign = 1;
// const Color selectedColor = Colors.white;
// const Color normalColor = Colors.black54;

// class _ToggleButtonState extends State<ToggleButton> {
//   late double xAlign;
//   late Color button1Color;
//   late Color button2Color;

//   @override
//   void initState() {
//     super.initState();
//     xAlign = loginAlign;
//     button1Color = selectedColor;
//     button2Color = normalColor;
//   }

//   @override
//   Widget build(BuildContext context) {

//     final isSelected1 = selectedValue == button1Value;
//     final isSelected2 = selectedValue == button2Value;
//     return Center(
//       child: Container(
//         width: width,
//         height: height,
//         decoration: const BoxDecoration(
//           color: Colors.grey,
//           borderRadius: BorderRadius.all(
//             Radius.circular(50.0),
//           ),
//         ),
//         child: Stack(
//           children: [
//             AnimatedAlign(
//               alignment: Alignment(xAlign, 0),
//               duration: const Duration(milliseconds: 300),
//               child: Container(
//                 width: width * 0.5,
//                 height: height,
//                 decoration: const BoxDecoration(
//                   color: Colors.lightGreen,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(50.0),
//                   ),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   xAlign = loginAlign;
//                   button1Color = selectedColor;
//                   button2Color = normalColor;
//                 });
//               },
//               child: Align(
//                 alignment: const Alignment(-1, 0),
//                 child: Container(
//                   width: width * 0.5,
//                   color: Colors.transparent,
//                   alignment: Alignment.center,
//                   child: Text(
//                     widget.button1Label,
//                     style: TextStyle(
//                       color: button1Color,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 if (!isSelected) {
//           onTimeWindowChanged(value);
//         }
//                 setState(() {
//                   xAlign = signInAlign;
//                   button2Color = selectedColor;
//                   button1Color = normalColor;

//                 });
//               },
//               child: Align(
//                 alignment: const Alignment(1, 0),
//                 child: Container(
//                   width: width * 0.5,
//                   color: Colors.transparent,
//                   alignment: Alignment.center,
//                   child: Text(
//                     widget.button2Label,
//                     style: TextStyle(
//                       color: button2Color,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ToggleButton extends StatelessWidget {
//   final String button1Label;
//   final String button1Value;
//   final String button2Label;
//   final String button2Value;
//   final String selectedValue;
//   final Function(String) onTimeWindowChanged;

//   const ToggleButton({
//     required this.button1Label,
//     required this.button1Value,
//     required this.button2Label,
//     required this.button2Value,
//     required this.selectedValue,
//     required this.onTimeWindowChanged,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isSelected1 = selectedValue == button1Value;
//     final isSelected2 = selectedValue == button2Value;

//     return Row(
//       children: [
//         _buildToggleButton(button1Label, button1Value, isSelected1),
//         _buildToggleButton(button2Label, button2Value, isSelected2),
//       ],
//     );
//   }

//   Widget _buildToggleButton(String label, String value, bool isSelected) {
//     return GestureDetector(
//       onTap: () {
//         if (!isSelected) {
//           onTimeWindowChanged(value);
//         }
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.lightGreen : Colors.transparent,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:moviedb/Theme/app_colors.dart';

class ToggleButton extends StatefulWidget {
  final String button1Value;
  final String button2Value;
  final String button1Label;
  final String button2Label;
  final String selectedValue;
  final Function(String) onTimeWindowChanged;

  const ToggleButton({
    Key? key,
    required this.button1Value,
    required this.button2Value,
    required this.button1Label,
    required this.button2Label,
    required this.selectedValue,
    required this.onTimeWindowChanged,
  }) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

const double width = 200.0;
const double height = 30.0;
const double leftAlign = -1;
const double rightAlign = 1;
const Color selectedColor = AppColors.firstMainGradientColor;
const Color normalColor = AppColors.drawerBackGround;

class _ToggleButtonState extends State<ToggleButton> {
  late double xAlign;
  late Color button1Color;
  late Color button2Color;

  @override
  void initState() {
    super.initState();
    xAlign = leftAlign;
    button1Color = selectedColor;
    button2Color = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    final isSelected1 = widget.selectedValue == widget.button1Value;
    final isSelected2 = widget.selectedValue == widget.button2Value;

    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: const BorderRadius.all(
            Radius.circular(50.0),
          ),
          border: Border.all(
            color: AppColors.drawerBackGround,
          ),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(xAlign, 0),
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: width * 0.5,
                height: height,
                decoration: const BoxDecoration(
                  color: AppColors.drawerBackGround,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!isSelected1) {
                  setState(() {
                    xAlign = leftAlign;
                    button1Color = selectedColor;
                    button2Color = normalColor;
                  });
                  widget.onTimeWindowChanged(widget.button1Value);
                }
              },
              child: Align(
                alignment: const Alignment(-1, 0),
                child: Container(
                  width: width * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    widget.button1Label,
                    style: TextStyle(
                      color: button1Color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!isSelected2) {
                  setState(() {
                    xAlign = rightAlign;
                    button2Color = selectedColor;
                    button1Color = normalColor;
                  });
                  widget.onTimeWindowChanged(widget.button2Value);
                }
              },
              child: Align(
                alignment: const Alignment(1, 0),
                child: Container(
                  width: width * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    widget.button2Label,
                    style: TextStyle(
                      color: button2Color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
