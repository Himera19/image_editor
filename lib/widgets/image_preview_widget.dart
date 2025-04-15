import 'dart:io';

import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/providers/image_preview_provider.dart';

class ImagePreviewWidget extends StatelessWidget {
  final ImageStateProvider imageStateProvider;
  const ImagePreviewWidget({super.key, required this.imageStateProvider});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: imageStateProvider.selectedImage == null
            ? IconButton(
                icon: Column(
                  children: [
                    const Icon(Icons.add_a_photo, size: 48),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Select",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
                onPressed: imageStateProvider.selectImage)
            : Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: imageStateProvider.isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                width: 25,
                              ),
                              Text('Filter applying...'),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: imageStateProvider.originalImage != null
                                ? BeforeAfter(
                                    value: imageStateProvider.beforeAfterVal,
                                    before: _smartPreview(
                                        imageFile:
                                            imageStateProvider.originalImage!),
                                    after: _smartPreview(
                                        imageFile:
                                            imageStateProvider.selectedImage!),
                                    direction: SliderDirection.horizontal,
                                    onValueChanged:
                                        imageStateProvider.changeVal)
                                : _smartPreview(
                                    imageFile:
                                        imageStateProvider.selectedImage!),
                          ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: imageStateProvider.isLoading
                            ? Colors.grey
                            : Colors.red,
                      ),
                      onPressed: imageStateProvider.isLoading
                          ? null
                          : imageStateProvider.removeImage),
                ],
              ));
  }

  /// Show preview image in low quality for better performance
  Widget _smartPreview({required File imageFile}) {
    return Image.file(
      imageFile,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.low,
      cacheWidth: 800,
    );
  }
}
