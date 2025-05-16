import 'package:hive/hive.dart';

class CategoryRepo {
  static const _boxName = 'categoriesBox';
  static const categoriesKey = 'categories';

  late final Box<List> _box;

  static const _compactionThreshold = 100;
  int _saveOperations = 0;

  late final List<String> _categories;

  Future<void> init() async {
    _box = await Hive.openBox<List>(_boxName);
    final savedCategories = _box.get(categoriesKey);

    if (savedCategories != null && savedCategories.isNotEmpty) {
      _categories = List<String>.from(savedCategories);
    } else {
      _categories = ['Все'];
    }
  }

  Future<void> close() async {
    await _box.compact();
    await _box.close();
  }

  Future<void> put(String category) async {
    _categories.add(category);

    await _box.put(categoriesKey, _categories);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }
  }

  Future<void> update(String oldCategory, String newCategory) async {
    final index = _categories.indexOf(oldCategory);
    _categories[index] = newCategory;

    await _box.put(categoriesKey, _categories);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }
  }

  Future<void> updateByIndex(int index, String newCategory) async {
    _categories[index] = newCategory;

    await _box.put(categoriesKey, _categories);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }
  }

  Future<void> delete(String category) async {
    _categories.remove(category);

    await _box.put(categoriesKey, _categories);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }
  }

  List<String> get categories => _categories;
}
