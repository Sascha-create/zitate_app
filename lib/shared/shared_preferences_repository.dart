import 'package:shared_preferences/shared_preferences.dart';
import 'package:zitate_app/shared/database_repository.dart';

class SharedPreferencesRepository implements DatabaseRepository {
  SharedPreferencesAsync prefs = SharedPreferencesAsync();

  //String _lastQuote = "";

  @override
  Future<void> saveQuote(String quote) async {
    await prefs.setString("lastQuote", quote);
  }

  @override
  Future<String> getSavedQuote() async {
    String quote = await prefs.getString("lastQuote") ?? "Kein Zitat gefunden";
    return quote;
  }
}
