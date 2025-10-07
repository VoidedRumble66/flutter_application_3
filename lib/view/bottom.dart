import 'package:flutter_application_3/theme/tema.dart';
import 'package:flutter/material.dart';

BottomNavigationBar menuBottom(
    BuildContext context, int index, Function update) {
  return BottomNavigationBar(
    selectedItemColor: MiTema.verde,
    items: [_tab1(), _tab2()],
    currentIndex: index,
    iconSize: 40,
    onTap: (value) {
      update(value);
    },
  );
}

BottomNavigationBarItem _tab1() {
  return const BottomNavigationBarItem(
      icon: Icon(Icons.access_alarm), label: 'Tab1');
}

BottomNavigationBarItem _tab2() {
  return const BottomNavigationBarItem(
      icon: Icon(Icons.accessible_forward_sharp), label: 'Tab2');
}
