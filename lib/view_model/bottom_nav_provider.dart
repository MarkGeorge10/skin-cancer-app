import 'package:flutter/material.dart';

class BottomNavProvider with ChangeNotifier {
  int _selectedItem = 0;
  int get selectedItem => _selectedItem;

  void changeScreenState(int index) {
    _selectedItem = index;
    notifyListeners();
  }
}