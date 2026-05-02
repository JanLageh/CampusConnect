import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/auth_providers.dart';

/// Model for category data
class CategoryModel {
  final String id;
  final String name;
  final bool isActive;
  final DateTime? createdAt;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.isActive,
    this.createdAt,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

/// Provider for streaming categories from Firestore
final categoriesStreamProvider = StreamProvider<List<CategoryModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);

  return firestore
      .collection('categories')
      .where('isActive', isEqualTo: true)
      .orderBy('name')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc))
            .toList();
      });
});

/// Provider for getting active categories as a list
final activeCategoriesProvider = Provider<AsyncValue<List<CategoryModel>>>((
  ref,
) {
  return ref.watch(categoriesStreamProvider);
});
