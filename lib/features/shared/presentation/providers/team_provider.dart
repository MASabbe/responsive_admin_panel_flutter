import 'package:flutter/material.dart';

class TeamProvider extends ChangeNotifier {
  bool _isLoading = false;
  final bool _isEmpty = false;

  bool get isLoading => _isLoading;

  bool get isEmpty => _isEmpty;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    try {

    } catch (e) {
      debugPrint('Error initializing team service: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<Object> getTeams() async {
    _isLoading = true;
    notifyListeners();
    try {

    } catch (e) {
      debugPrint('Error getting teams: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return [];
  }

}
