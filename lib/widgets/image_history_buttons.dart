import 'package:flutter/material.dart';
import 'package:image_editor/providers/image_preview_provider.dart';

class ImageHistoryButtons extends StatelessWidget {
  final ImageStateProvider imageStateProvider;
  const ImageHistoryButtons({super.key, required this.imageStateProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: imageStateProvider.currentStep > 0
                ? imageStateProvider.historyBack
                : null,
            icon: Icon(Icons.arrow_back_ios)),
        IconButton(
            onPressed: imageStateProvider.currentStep <
                    imageStateProvider.imageHistory.length - 1
                ? imageStateProvider.historyForward
                : null,
            icon: Icon(Icons.arrow_forward_ios)),
      ],
    );
  }
}
