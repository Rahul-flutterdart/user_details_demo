// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../services/api_services.dart';


class UserProvider with ChangeNotifier {

  final ApiService _apiService;

  UserProvider(this._apiService);

  List<User> _users = [];
  List<User> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int _currentPage = 2;
  bool _hasMore = true;
  bool get hasMore => _hasMore;
  Future<void> loadCachedUsers() async {
    final box = await Hive.openBox<User>('usersBox');
    _users = box.values.toList();
    notifyListeners();
  }

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (_isLoading) return;

    if (!_hasMore && !isRefresh) return;

    // final connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.none) {
    //   _error = 'No internet connection.';
    //   notifyListeners();
    //   return;
    // }

    if (isRefresh) {
      _currentPage = 2;
      _hasMore = true;
      _users.clear();
      notifyListeners();
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    final box = await Hive.openBox<User>('usersBox');

    try {
      final response = await _apiService.fetchUsers(page: _currentPage);

      if (response.data.isNotEmpty) {
        _users.addAll(response.data);
        _currentPage++;
        _hasMore = response.page < response.totalPages;


        await box.clear();
        await box.addAll(_users);
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _users.clear();
      debugPrint('Fetch error: $e');
      _error = e.toString();


      if (box.isNotEmpty) {
        _users = box.values.toList();
      }
    } finally {
      await box.close();
      _isLoading = false;
      notifyListeners();
    }
  }


}
