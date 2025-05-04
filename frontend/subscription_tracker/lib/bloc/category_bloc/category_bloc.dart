import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/bloc/category_bloc/category_event.dart';
import 'package:subscription_tracker/bloc/category_bloc/category_state.dart';
import 'package:subscription_tracker/repo/category_repo/category_repo.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepo categoryRepo;

  CategoryBloc({required this.categoryRepo}) : super(CategoryState.zero()) {
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
    emit(CategoryState(categoryRepo.categories));
  }

  Future<void> _addCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    await categoryRepo.put(event.category);
    emit(CategoryState(categoryRepo.categories));
  }

  Future<void> _renameCategory(
    RenameCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    await categoryRepo.updateByIndex(event.index, event.newName);
    emit(CategoryState(categoryRepo.categories));
  }

  Future<void> _deleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    await categoryRepo.delete(event.category);
    emit(CategoryState(categoryRepo.categories));
  }

  @override
  Future<void> close() async {
    await categoryRepo.close();
    return super.close();
  }
}
