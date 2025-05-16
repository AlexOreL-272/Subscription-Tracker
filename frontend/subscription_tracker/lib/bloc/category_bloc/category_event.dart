abstract class CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final String category;

  AddCategoryEvent(this.category);
}

class ForceUpdateCategoriesEvent extends CategoryEvent {}

class RenameCategoryEvent extends CategoryEvent {
  final int index;
  final String newName;

  RenameCategoryEvent(this.index, this.newName);
}

class DeleteCategoryEvent extends CategoryEvent {
  final String category;

  DeleteCategoryEvent(this.category);
}

class InitializeCategoriesEvent extends CategoryEvent {}
