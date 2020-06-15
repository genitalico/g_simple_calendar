import 'package:flutter_test/flutter_test.dart';

import 'package:g_simple_calendar/g_simple_calendar.dart';

void main() {
  testWidgets('Simple Calendar Widget', (WidgetTester tester) async {
    var date = DateTime.now();

    await tester.pumpWidget(GSimpleCalendar(
      date: date,
    ));
  });
}
