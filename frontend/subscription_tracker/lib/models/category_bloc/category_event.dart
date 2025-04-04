abstract class CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final String category;

  AddCategoryEvent(this.category);
}

class UpdateCategoryEvent extends CategoryEvent {
  final int index;
  final String category;

  UpdateCategoryEvent(this.index, this.category);
}

class DeleteCategoryEvent extends CategoryEvent {
  final int index;

  DeleteCategoryEvent(this.index);
}
