abstract class AppApiService {
  Future<String> get(
    Uri url, {
    Map<String, String>? headers,
  });
}
