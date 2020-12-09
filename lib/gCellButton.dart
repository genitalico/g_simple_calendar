import 'package:flutter/material.dart';

class GCellButton extends StatelessWidget {
  final String label;
  final number;
  final Color textColor;
  final bool enable;
  final Color fillColor;
  final Function(int) onPressed;

  const GCellButton(
      {Key key,
      this.label,
      this.enable: true,
      this.textColor: Colors.black,
      this.fillColor: Colors.transparent,
      this.onPressed,
      this.number: 0});

  @override
  Widget build(BuildContext context) {
    if (this.enable) {
      var _enableButton = Expanded(
          child: Directionality(
        textDirection: TextDirection.ltr,
        child: FlatButton(
          padding: EdgeInsets.all(0),
          color: this.fillColor,
          textColor: this.textColor,
          onPressed: () {
            this.onPressed(this.number);
          },
          child: Text(
            this.label,
            softWrap: false,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          ),
        ),
      ));

      return _enableButton;
    }

    var _disableButton = Expanded(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        color: this.fillColor,
        textColor: this.textColor,
        onPressed: () {},
        child: Text(
          this.label,
          softWrap: false,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        ),
      ),
    ));

    return _disableButton;
  }
}
