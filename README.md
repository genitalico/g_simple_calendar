# g_simple_calendar

Simple Calendar Widget 

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

## Props

| props           | types               | defaultValues                                |
| --------------- | ------------------- | -------------------------------------------- |
| date            | DateTime            |                                              |
| selectedColor   | Color               | Colors.grey                                  |
| celdTextColor   | Color               | Colors.black                                 |
| titleStyle      | TextStyle           | TextStyle(color: Colors.black, fontSize: 18) |
| celTextEmpty    | String              | X                                            |
| onRangeSelected | Function(List<int>) | null, get data selected days                 |
| visibleTitle    | bool                | false                                        |

## Install

Add `g_simple_calendar` as a dependency in pubspec.yaml For help on adding as a dependency, view the [documentation](https://flutter.io/using-packages/).

## Usage

```dart
Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GSimpleCalendar(
        date: DateTime.now(),
      ),
    );
  }
```

## About me

[80bits.com](https://80bits.com)

[80bits.blog](https://80bits.blog)

