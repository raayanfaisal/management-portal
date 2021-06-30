import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../building_blocks/repository.dart';
import 'model.dart';

class CategoryRepository implements Repository {
  final _firestore = FirebaseFirestore.instance;
  final _categoriesSubject = BehaviorSubject<List<CategoryModel>>();

  CategoryRepository() {
    _categoriesSubject.addStream(_categories());
  }

  Future<void> createCategory({
    required String name,
    required String color,
    String? description,
  }) async {
    await _categoriesColle
        .add(CategoryModel(name: name, color: color).toJson());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _categoriesColle.doc(category.id).update(category.toJson());
  }

  Future<void> removeCategory(CategoryModel category) async {
    await _categoriesColle.doc(category.id).delete();
  }

  Stream<List<CategoryModel>> categories() => _categoriesSubject;

  Stream<List<CategoryModel>> _categories() {
    return _categoriesColle.snapshots().map((snapshot) {
      return snapshot.docs.map(_snapshotToCategoryModel).toList();
    });
  }

  CollectionReference<Map<String, dynamic>> get _categoriesColle {
    return _firestore.collection('portal').doc('v0').collection('categories');
  }

  static CategoryModel _snapshotToCategoryModel(DocumentSnapshot document) {
    return CategoryModel.fromJson(Map.from(document.data() as Map))
        .copyWith(id: document.id);
  }
}
