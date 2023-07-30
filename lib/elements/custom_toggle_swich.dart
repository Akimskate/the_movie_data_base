import 'package:flutter/material.dart';
import 'package:moviedb/Theme/app_colors.dart';

class ToggleButton extends StatefulWidget {
  final String button1Value;
  final String button2Value;
  final String button1Label;
  final String button2Label;
  final String selectedValue;
  final Function(String) onValueChange;

  const ToggleButton({
    Key? key,
    required this.button1Value,
    required this.button2Value,
    required this.button1Label,
    required this.button2Label,
    required this.selectedValue,
    required this.onValueChange,
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

class _ToggleButtonState extends State<ToggleButton>
    with AutomaticKeepAliveClientMixin {
  late double xAlign;
  late Color button1Color;
  late Color button2Color;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    xAlign = leftAlign;
    button1Color = selectedColor;
    button2Color = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                  widget.onValueChange(widget.button1Value);
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
                  widget.onValueChange(widget.button2Value);
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
