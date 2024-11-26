import 'package:shared_preferences/shared_preferences.dart';
import 'package:zitate_app/shared/database_repository.dart';

const String lastQuote = 'lastQuote';

class SharedPreferencesRepository implements DatabaseRepository {
  SharedPreferencesAsync prefs = SharedPreferencesAsync();

  @override
  Future<void> saveQuote(String quote) async {
    await prefs.setString(lastQuote, quote);
  }

  @override
  Future<String> getSavedQuote() async {
    String quote = await prefs.getString(lastQuote) ?? "Kein Zitat gefunden";
    return quote;
  }

  @override
  Future<void> deleteSavedQuote() async {
    await prefs.remove(lastQuote);
  }
}
