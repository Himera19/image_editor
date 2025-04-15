import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';

import 'package:flutter/widgets.dart';

/// Call functions from native C++ code.
typedef _NativeFilterFunc = ffi.Void Function(
    ffi.Pointer<Utf8> inputPath, ffi.Pointer<Utf8> outPath);

/// For access native C++ codes in Dart.
typedef FilterFunc = void Function(
    ffi.Pointer<Utf8> inputPath, ffi.Pointer<Utf8> outPath);

/// Get and use filters with libraries.
class NativeLibrary {
  late final ffi.DynamicLibrary _lib;
  late final FilterFunc applyGrayScale;
  late final FilterFunc applyBlur;
  late final FilterFunc applySharpen;
  late final FilterFunc applyEdge;

  NativeLibrary() {
    try {
      // Load libraries based on platform.
      if (Platform.isAndroid) {
        _lib = ffi.DynamicLibrary.open("libfilters.so");
      }else if (Platform.isIOS) {
        _lib = DynamicLibrary.process();
      }else if (Platform.isLinux || Platform.isMacOS) {
        _lib = ffi.DynamicLibrary.open('filters.dylib');
      } else {
        throw UnsupportedError('Platform not supported.');
      }

      // Get filters from C++ code and set to defined variables.
      applyGrayScale = _lib
          .lookup<ffi.NativeFunction<_NativeFilterFunc>>('apply_grayscale')
          .asFunction();
      applyBlur = _lib
          .lookup<ffi.NativeFunction<_NativeFilterFunc>>('apply_blur')
          .asFunction();
      applySharpen = _lib
          .lookup<ffi.NativeFunction<_NativeFilterFunc>>('apply_sharpen')
          .asFunction();
      applyEdge = _lib
          .lookup<ffi.NativeFunction<_NativeFilterFunc>>('apply_edge')
          .asFunction();
    } catch (e) {
      debugPrint('Error while fetching effects from native library: $e');
    }
  }
}
