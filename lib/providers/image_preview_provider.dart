import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/filter_type_enum.dart';
import '../utils/filter_apply_functions.dart';

class ImageStateProvider extends ChangeNotifier {
  File? _selectedImage;
  File? _tempImage;
  FilterType? _selectedFilter;
  List<File> _imageHistory = [];
  List<FilterType> _filterHistory = [];
  int _currentStep = -1;
  double _beforeAfterVal = 0.5;
  bool _isLoading = false;

  File? get selectedImage => _selectedImage;
  File? get originalImage => _tempImage;
  List<File> get imageHistory => _imageHistory;
  List<FilterType> get filterHistory => _filterHistory;
  int get currentStep => _currentStep;
  FilterType? get selectedFilter => _selectedFilter;
  double get beforeAfterVal => _beforeAfterVal;
  bool get isLoading => _isLoading;

  /// Select image with [ImagePicker].
  /// Set selected image path to [_selectedImage].
  Future<void> selectImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();

      final XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }

      // Add original image to history.
      _imageHistory.add(_selectedImage!);
      _currentStep++;

      notifyListeners();
    } catch (e) {
      debugPrint('Error while image selecting: $e');
    }
  }

  /// Applies the [_selectedFilter] to [_selectedImage] using
  /// [FilterApplyFunctions].
  /// Set loading state to true until filter applied and new file returned.
  /// If the operation completes successfully, updates the history and image
  /// state.
  Future<void> applyFilter(FilterType? filter) async {
    try {
      FilterApplyFunctions filterApplyFunctions = FilterApplyFunctions();
      _selectedFilter = filter;

      // If image or filter not selected, return.
      if (_selectedImage == null || _selectedFilter == null) return;

      _isLoading = true;
      notifyListeners();

      // Save original image for before/after comparison.
      _tempImage = _selectedImage;
      notifyListeners();

      // Apply selected filter in an isolate.
      final File? result = await filterApplyFunctions.applyFilterInIsolate(
          image: _selectedImage!, type: _selectedFilter!);

      // If result is valid, update history and image state.
      if (result != null && result.existsSync()) {
        // If a new filter is applied after stepping back, remove the forward
        // history.
        if (_currentStep < _imageHistory.length - 1) {
          _imageHistory = _imageHistory.sublist(0, _currentStep + 1);
        }
        if (_currentStep < _filterHistory.length) {
          _filterHistory = _filterHistory.sublist(0,
              _currentStep);
        }

        // Add filter applied image path to history.
        _imageHistory.add(result);
        _filterHistory.add(_selectedFilter!);
        _currentStep++;
        notifyListeners();

        // Set filter applied image.
        _selectedImage = result;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error while filter applying with provider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear everything while removing image.
  void removeImage() {
    try {
      _selectedImage = null;
      _tempImage = null;
      _beforeAfterVal = 0.5;
      _selectedFilter = null;
      _isLoading = false;
      _currentStep = -1;
      _imageHistory = [];
      _filterHistory = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error while image removing: $e');
    }
  }

  /// Change before/after slider value.
  void changeVal(double val) {
    _beforeAfterVal = val;
    notifyListeners();
  }

  /// Move back in filter applied image history.
  void historyBack() {
    _currentStep--;
    _selectedImage = _imageHistory[_currentStep];
    _tempImage = _currentStep > 0 ? _imageHistory[_currentStep - 1] : null;
    _selectedFilter =
        _currentStep > 0 ? _filterHistory[_currentStep - 1] : null;
    notifyListeners();
  }

  /// Move forward in filter applied image history.
  void historyForward() {
    _currentStep++;
    _selectedImage = _imageHistory[_currentStep];
    _tempImage = _currentStep > 0 ? _imageHistory[_currentStep - 1] : null;
    _selectedFilter =
        _currentStep > 0 ? _filterHistory[_currentStep - 1] : null;

    notifyListeners();
  }
}
