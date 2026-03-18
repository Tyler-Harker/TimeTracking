import 'package:flutter/material.dart';
import '../theme/color_schemes.dart';

class PaginatedListView<T> extends StatelessWidget {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool isLoading;
  final Widget Function(BuildContext, T) itemBuilder;
  final VoidCallback? onNextPage;
  final VoidCallback? onPreviousPage;

  const PaginatedListView({
    super.key,
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.isLoading,
    required this.itemBuilder,
    this.onNextPage,
    this.onPreviousPage,
  });

  int get totalPages => (totalCount / pageSize).ceil();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      itemBuilder(context, items[index]),
                ),
        ),
        if (totalPages > 1)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.slate700)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: page > 1 ? onPreviousPage : null,
                ),
                const SizedBox(width: 8),
                Text(
                  'Page $page of $totalPages',
                  style: TextStyle(color: AppColors.slate300),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: page < totalPages ? onNextPage : null,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
