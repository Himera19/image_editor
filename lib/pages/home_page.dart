import 'package:flutter/material.dart';
import 'package:image_editor/providers/image_preview_provider.dart';
import 'package:image_editor/widgets/image_filter_list.dart';
import 'package:image_editor/widgets/image_history_buttons.dart';
import 'package:image_editor/widgets/image_preview_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Filter')),
      body: Padding(
        padding: const EdgeInsets.all(20),

        // Wrapped with Consumer for image states.
        child: Consumer<ImageStateProvider>(
          builder: (BuildContext context, ImageStateProvider imageStateProvider,
              Widget? child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: imageStateProvider.selectedImage == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                ImagePreviewWidget(imageStateProvider: imageStateProvider),
                const SizedBox(height: 20),

                if (imageStateProvider.selectedImage != null) ...[
                  ImageHistoryButtons(imageStateProvider: imageStateProvider)
                ],

                /// If image selected, show filter options.
                if (imageStateProvider.selectedImage != null) ...[
                  ImageFilterList(imageStateProvider: imageStateProvider)
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
