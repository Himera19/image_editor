import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor/services/phyton_filter_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../constants/filter_type_enum.dart';
import '../services/native_library_service.dart';

/// Applying image filters using native C++.
class FilterApplyFunctions {
  static final NativeLibrary _native = NativeLibrary();

  /// Apply grayscale filter to image using native C++ code.
  Future<File?> _applyGrayscaleFilter(File inputFile) async {
    return _applyNativeFilter(
        inputFile: inputFile, nativeFilter: _native.applyGrayScale);
  }

  /// Apply blur filter to image using native C++ code.
  Future<File?> _applyBlurFilter(File inputFile) async {
    return _applyNativeFilter(
        inputFile: inputFile, nativeFilter: _native.applyBlur);
  }

  /// Apply sharpen filter to image using native C++ code.
  Future<File?> _applySharpenFilter(File inputFile) async {
    return _applyNativeFilter(
        inputFile: inputFile, nativeFilter: _native.applySharpen);
  }

  /// Apply edge filter to image using native C++ code.
  Future<File?> _applyEdgeFilter(File inputFile) async {
    return _applyNativeFilter(
        inputFile: inputFile, nativeFilter: _native.applyEdge);
  }

  /// Return the path of filter applied image in the temporary directory.
  static Future<String> _getOutPathDir() async {
    final dir = await getTemporaryDirectory();
    return p.join(
        dir.path, "filtered_${DateTime.now().millisecondsSinceEpoch}.jpg");
  }

  /// Applies the given native filter function to the input image.
  /// Returns the filtered image file if successful, otherwise null.
  static Future<File?> _applyNativeFilter(
      {required File inputFile,
      required Function(Pointer<Utf8>, Pointer<Utf8>) nativeFilter}) async {
    try {
      final output = await _getOutPathDir();
      final inputPtr = inputFile.path.toNativeUtf8();
      final outputPtr = output.toNativeUtf8();
      nativeFilter(inputPtr, outputPtr);

      // Free allocated memory to prevent memory leaks.
      malloc.free(inputPtr);
      malloc.free(outputPtr);

      final resultFile = File(output);

      // Return filter applied image file.
      // Check file is null instead of directly return.
      return await resultFile.exists() ? resultFile : null;
    } catch (e) {
      debugPrint('Error while filter applying with native: $e');
      return inputFile;
    }
  }

  /// Send to isolate port with image and filter properties
  void _filterWorker(List<dynamic> args) async {
    try {
      final SendPort sendPort = args[0];
      final String inputPath = args[1];
      final int filterIndex = args[2];
      final RootIsolateToken rootToken = args[3];
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootToken);

      final type = FilterType.values[filterIndex];
      final file = File(inputPath);
      File? result;
      switch (type) {
        case FilterType.grayscale:
          result = await _applyGrayscaleFilter(file);
          break;
        case FilterType.blur:
          result = await _applyBlurFilter(file);
          break;
        case FilterType.sharpen:
          result = await _applySharpenFilter(file);
          break;
        case FilterType.edge:
          result = await _applyEdgeFilter(file);
          break;
        case FilterType.cartoon:
          result = await PhytonFilterService.applyCartoonFilter(file);
      }

      // Send filter and image properties to isolate via SendPort.
      sendPort.send(result?.path ?? '');
    } catch (e) {
      debugPrint('Error while filter sending to port: $e');
    }
  }

  /// Apply filter to image in isolate.
  /// Using isolate to prevent to ui frozen etc. via using another thread than
  /// main.
  Future<File?> applyFilterInIsolate({
    required File image,
    required FilterType type,
  }) async {
    try {
      final receivePort = ReceivePort();
      final rootToken = RootIsolateToken.instance!;

      // Run isolate with got filter and image properties via ReceivePort.
      Isolate.spawn(_filterWorker,
          [receivePort.sendPort, image.path, type.index, rootToken]);
      final resultPath = await receivePort.first as String;

      // Return filter applied image path.
      return File(resultPath);
    } catch (e) {
      debugPrint('Error while filter applying with isolate: $e');
      return File(image.path);
    }
  }
}
