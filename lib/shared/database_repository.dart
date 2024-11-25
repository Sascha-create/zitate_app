abstract class DatabaseRepository {
  Future<void> saveQuote(String quote);

  Future<String> getQuote();
}
