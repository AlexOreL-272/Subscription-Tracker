import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_tracker/models/category_bloc/category_event.dart';
import 'package:subscription_tracker/models/category_bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryState.zero()) {
    on<AddCategoryEvent>((event, emit) {
      final newCats = List<String>.from(state.categories)..add(event.category);

      emit(CategoryState(newCats));
    });

    on<RenameCategoryEvent>((event, emit) {
      final newCats = List<String>.from(state.categories)
        ..[event.index] = event.newName;

      // final newCats = List<String>.from(state.categories)
      // ..[event.index] = event.category;

      emit(CategoryState(newCats));
    });

    on<DeleteCategoryEvent>((event, emit) {
      final newCats = List<String>.from(state.categories)
        ..remove(event.category);

      emit(CategoryState(newCats));
    });
  }
}
