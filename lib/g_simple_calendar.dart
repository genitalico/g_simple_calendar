import 'package:flutter/material.dart';
import 'package:g_simple_calendar/gCellButton.dart';
import 'package:g_simple_calendar/gCustomButtonModel.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ui' as ui;

class GSimpleCalendar extends StatefulWidget {
  final DateTime date;
  final List<GCustomButtonModel> customButtons;
  final Function(List<int>) onRangeSelected;
  final bool visibleTitle;
  const GSimpleCalendar(
      {Key key,
      @required this.date,
      this.customButtons,
      this.onRangeSelected,
      this.visibleTitle: true})
      : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<GSimpleCalendar> {
  Widget _body;
  List<GCellButton> _celds;
  int _sInit = 0;
  int _countClick = 0;
  List<int> _selectedRange;
  final int _celdsLength = 49;
  @override
  void initState() {
    super.initState();

    this._selectedRange = List<int>();

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

    _celds = List<GCellButton>();

    _celds.add(GCellButton(enable: false, label: 'L'));
    _celds.add(GCellButton(enable: false, label: 'M'));
    _celds.add(GCellButton(enable: false, label: 'M'));
    _celds.add(GCellButton(enable: false, label: 'J'));
    _celds.add(GCellButton(enable: false, label: 'V'));
    _celds.add(GCellButton(enable: false, label: 'S'));
    _celds.add(GCellButton(enable: false, label: 'D'));

    _celds.addAll(_getEmptyList(weekday));

    //Days of month
    for (int i = 1; i <= totalDays; i++) {
      GCellButton celd;

      var selected = this._selectedRange.where((element) => element == i);

      if (selected.length != 0) {
        celd = GCellButton(
          label: i.toString(),
          number: i,
          fillColor: Colors.grey,
          onPressed: (number) {
            _onPressedceld(number);
          },
        );
      } else {
        var _customButtons = List<GCustomButtonModel>();

        if (this.widget.customButtons != null)
          _customButtons = this.widget.customButtons;

        var custom = _customButtons.where((element) => element.number == i);

        if (custom.length > 0) {
          celd = GCellButton(
            fillColor: custom.first.fillColor,
            label: i.toString(),
            number: i,
            enable: custom.first.enable,
            onPressed: (number) {
              _onPressedceld(number);
            },
          );
        } else {
          celd = GCellButton(
            label: i.toString(),
            number: i,
            onPressed: (number) {
              _onPressedceld(number);
            },
          );
        }
      }

      _celds.add(celd);
    }
    //Days of month

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

    var listToColum = List<Widget>();

    if (widget.visibleTitle) {
      listToColum.add(Align(
        alignment: Alignment.center,
        child: Text(
          _title,
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
    if (value == 0) return;

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

  List<GCellButton> _getEmptyList(int count) {
    var list = List<GCellButton>();
    for (int i = 1; i < count; i++) {
      var celd = GCellButton(
        enable: false,
        label: '0',
        number: 0,
        onPressed: (number) {},
      );
      list.add(celd);
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _body);
  }
}
