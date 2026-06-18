import 'package:flutter/material.dart';

/// State manager for ID verification journey
class JourneyStateManager with ChangeNotifier {

  bool _isJourneyStarted = false;
  bool _isJourneyCompleted = false;
  String _journeyId = '';

  bool get isJourneyStarted => _isJourneyStarted;
  bool get isJourneyCompleted => _isJourneyCompleted;

  String get journeyId => _journeyId;

  void setJourneyStatus(bool status) {
    _isJourneyStarted = status;
    notifyListeners();
  }

  void setJourneyCompleted(bool status) {
    _isJourneyCompleted = status;
    notifyListeners();
  }

  void setJourneyId(String journeyId) {
    _journeyId = journeyId;
    notifyListeners();
  }

  void resetAll() {
     _isJourneyStarted = false;
     _isJourneyCompleted = false;
     _journeyId = '';
     notifyListeners();
  }

}