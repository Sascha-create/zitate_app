abstract class DatabaseRepository {
  Future<void> saveQuote(String quote);

  Future<String> getSavedQuote();

  Future<void> deleteSavedQuote();

    Future<void> saveCategory(String category);

  Future<String> getSavedCategory();
}
