import 'package:flutter/material.dart';
import 'package:image_editor/providers/image_preview_provider.dart';

import '../constants/filter_list.dart';

class ImageFilterList extends StatelessWidget {
  final ImageStateProvider imageStateProvider;
  const ImageFilterList({super.key, required this.imageStateProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Select Filter',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filterList.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> filter = filterList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ChoiceChip(
                  showCheckmark: false,
                  avatar: imageStateProvider.selectedFilter == filter['type']
                      ? imageStateProvider.isLoading
                          ? CircularProgressIndicator()
                          : Icon(Icons.done)
                      : null,
                  label: Text(filter['name']),
                  selected: imageStateProvider.selectedFilter == filter['type'],
                  onSelected: (_) async {
                    if (imageStateProvider.isLoading ||
                        imageStateProvider.selectedFilter == filter['type']) {
                      return;
                    }
                    await imageStateProvider.applyFilter(filter['type']);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
