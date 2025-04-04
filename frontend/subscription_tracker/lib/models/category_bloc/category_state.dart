class CategoryState {
  final List<String> categories;

  const CategoryState(this.categories);

  CategoryState.zero() : this(['Все', 'Android', 'iOS', 'Flutter']);
}
