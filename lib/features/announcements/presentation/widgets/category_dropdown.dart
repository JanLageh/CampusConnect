import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/categories_provider.dart';
import '../providers/announcement_form_provider.dart';

/// Dropdown widget for selecting announcement category
class CategoryDropdown extends ConsumerWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final formState = ref.watch(announcementFormProvider);
    final formNotifier = ref.read(announcementFormProvider.notifier);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No categories available. Please contact an administrator.',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: formState.categoryId,
          decoration: const InputDecoration(
            labelText: 'Category *',
            hintText: 'Select a category',
            border: OutlineInputBorder(),
          ),
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (categoryId) {
            if (categoryId != null) {
              final category = categories.firstWhere(
                (cat) => cat.id == categoryId,
              );
              formNotifier.updateCategory(categoryId, category.name);
            }
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error loading categories: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
