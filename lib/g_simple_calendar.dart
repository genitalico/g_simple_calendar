import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ui' as ui;

class GSimpleCalendar extends StatefulWidget {
  final DateTime date;
  final Color selectedColor;
  final Color celdTextColor;
  final TextStyle titleStyle;
  final String celTextEmpty;
  final Function(List<int>) onRangeSelected;
  final bool visibleTitle;
  final List<int> blockedDays;
  final Color colorBlockedDays;
  const GSimpleCalendar(
      {Key key,
      @required this.date,
      this.selectedColor,
      this.celdTextColor,
      this.titleStyle,
      this.celTextEmpty,
      this.onRangeSelected,
      this.visibleTitle: false,
      this.blockedDays,
      this.colorBlockedDays})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<GSimpleCalendar> {
  List<int> selectedRange() => _selectedRange;

  Widget _body;
  List<Widget> _celds;
  int _sInit = 0;
  int _countClick = 0;
  List<int> _selectedRange;
  final int _celdsLength = 49;
  Color _selectedColor;
  @override
  void initState() {
    super.initState();

    this._selectedRange = List<int>();
    this._selectedColor = widget.selectedColor ?? Colors.grey;

    _body = _buildDesign();
  }

  DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  Widget _buildDesign() {
    int year = widget.date.year;
    int month = widget.date.month;
    var initDate = DateTime(year, month, 1);
    var totalDays = lastDayOfMonth(initDate).day;
    var weekday = initDate.weekday;
    print(totalDays);

    _celds = List<Widget>();

    _celds.add(_celdText('L'));
    _celds.add(_celdText('M'));
    _celds.add(_celdText('M'));
    _celds.add(_celdText('J'));
    _celds.add(_celdText('V'));
    _celds.add(_celdText('S'));
    _celds.add(_celdText('D'));

    _celds.addAll(_getEmptyList(weekday));

    for (int i = 1; i <= totalDays; i++) {
      Widget celd;
      var text = i.toString();

      Color _selectedColorTemp;
      bool blocked = false;
      var r = _selectedRange.where((x) => x == i);

      if (r.length > 0) _selectedColorTemp = _selectedColor;
      if (widget.blockedDays != null) {
        var bl = widget.blockedDays.where((x) => x == i);
        if (bl.length > 0) {
          blocked = true;
          if (widget.colorBlockedDays != null)
            _selectedColorTemp = widget.colorBlockedDays;
          else
            _selectedColorTemp = Colors.grey;
        }
      }

      celd = _celdButton(
          i, text, widget.celdTextColor, _selectedColorTemp, blocked);

      _celds.add(celd);
    }

    int diffDays = _celdsLength + 1 - (totalDays + weekday);
    _celds.addAll(_getEmptyList(diffDays));

    var rows = List<Row>();

    for (int i = 0; i < _celdsLength; i = i + 7) {
      var split = _celds.skip(i).take(7).toList();
      var row = Row(
        textDirection: TextDirection.ltr,
        children: split,
      );

      rows.add(row);
    }

    var tag = ui.window.locale.toLanguageTag().replaceFirst('-', '_');
    initializeDateFormatting();
    var newFormat = intl.DateFormat.yMMM(tag).format(widget.date);

    newFormat =
        newFormat.replaceFirst(newFormat[0], newFormat[0].toUpperCase());

    String _title = newFormat;

    TextStyle _titleStyle = widget.titleStyle ??
        TextStyle(color: widget.celdTextColor ?? Colors.black, fontSize: 18);

    var listToColum = List<Widget>();

    if (widget.visibleTitle) {
      listToColum.add(Align(
        alignment: Alignment.center,
        child: Text(
          _title,
          style: _titleStyle,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        ),
      ));
    }

    listToColum.add(SizedBox(
      height: 25,
    ));

    listToColum.add(rows[0]);
    listToColum.add(rows[1]);
    listToColum.add(rows[2]);
    listToColum.add(rows[3]);
    listToColum.add(rows[4]);
    listToColum.add(rows[5]);
    listToColum.add(rows[6]);

    return Container(
      margin: EdgeInsets.all(10),
      child: Column(children: listToColum),
    );
  }

  void _onPressedceld(int value) {
    _countClick++;

    if (_countClick == 1) {
      _sInit = value;
      _selectedRange.add(_sInit);

      if (this.widget.onRangeSelected != null)
        this.widget.onRangeSelected(_selectedRange);
    }

    if (_countClick == 2) {
      while (_sInit < value) {
        _sInit++;
        _selectedRange.add(_sInit);
      }

      if (this.widget.onRangeSelected != null)
        this.widget.onRangeSelected(_selectedRange);
    }

    if (_countClick == 3) {
      _countClick = 0;
      _selectedRange.clear();

      if (this.widget.onRangeSelected != null)
        this.widget.onRangeSelected(_selectedRange);
    }

    setState(() {
      _body = _buildDesign();
    });
  }

  Widget _celdText(String text) {
    Color textColor = widget.celdTextColor ?? Colors.black;
    return Expanded(
      child: Text(
        text,
        style: TextStyle(color: textColor),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      ),
    );
  }

  List<Widget> _getEmptyList(int count) {
    String _text = widget.celTextEmpty ?? 'X';
    var list = List<Widget>();
    for (int i = 1; i < count; i++) {
      var celd = _celdButton(0, _text, widget.celdTextColor, null, true);
      list.add(celd);
    }

    return list;
  }

  Widget _celdButton(int value, String text, Color colorText, Color fillColor,
      bool isBlocked) {
    String _text = text;
    if (_text.isEmpty) _text = 'X';
    if (_text == null) {
      _text = '-';
    }

    Color _colorText;
    if (colorText == null)
      _colorText = Colors.black;
    else
      _colorText = colorText;

    Color _fillColor;
    if (fillColor == null)
      _fillColor = Colors.transparent;
    else
      _fillColor = fillColor;

    if (isBlocked) {
      return Expanded(
          child: Directionality(
        textDirection: TextDirection.ltr,
        child: FlatButton(
          padding: EdgeInsets.all(0),
          color: _fillColor,
          textColor: _colorText,
          onPressed: () {},
          child: Text(
            _text,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }

    return Expanded(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        color: _fillColor,
        textColor: _colorText,
        onPressed: () {
          _onPressedceld(value);
        },
        child: Text(
          _text,
          softWrap: false,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _body);
  }
}
