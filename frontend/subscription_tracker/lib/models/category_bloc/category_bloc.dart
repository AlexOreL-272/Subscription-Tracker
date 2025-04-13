import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:subscription_tracker/models/category_bloc/category_event.dart';
import 'package:subscription_tracker/models/category_bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  static const _boxName = 'categoriesBox';
  static const categoriesKey = 'categories';

  late final Box<List> _box;

  static const _compactionThreshold = 100;
  int _saveOperations = 0;

  CategoryBloc() : super(CategoryState.zero()) {
    on<InitializeCategoriesEvent>(_initialize);
    on<AddCategoryEvent>(_addCategory);
    on<RenameCategoryEvent>(_renameCategory);
    on<DeleteCategoryEvent>(_deleteCategory);

    add(InitializeCategoriesEvent());
  }

  Future<void> _initialize(
    InitializeCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    _box = await Hive.openBox<List>(_boxName);
    final savedCategories = _box.get(categoriesKey);

    // for debug only
    // TODO: remove
    // final savedCategories = <String>['Все', 'Android', 'iOS', 'Flutter'];
    // await _box.put(categoriesKey, savedCategories);

    if (savedCategories != null && savedCategories.isNotEmpty) {
      emit(CategoryState(List<String>.from(savedCategories)));
    }
  }

  Future<void> _addCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final newCats = List<String>.from(state.categories)..add(event.category);
    await _box.put(categoriesKey, newCats);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(CategoryState(newCats));
  }

  Future<void> _renameCategory(
    RenameCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final newCats = List<String>.from(state.categories)
      ..[event.index] = event.newName;
    await _box.put(categoriesKey, newCats);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(CategoryState(newCats));
  }

  Future<void> _deleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    final newCats = List<String>.from(state.categories)..remove(event.category);
    await _box.put(categoriesKey, newCats);

    _saveOperations++;
    if (_saveOperations >= _compactionThreshold) {
      _saveOperations = 0;
      await _box.compact();
    }

    emit(CategoryState(newCats));
  }

  @override
  Future<void> close() {
    Hive.close();
    return super.close();
  }
}
