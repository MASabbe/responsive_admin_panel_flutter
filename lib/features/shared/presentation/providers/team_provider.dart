import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_admin_panel_flutter/features/shared/data/models/team_model.dart';

class TeamProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isEmpty = false;

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
