abstract class AppWorkerService {
  Future<R> execute<T, R>(T message, R Function(T) action);
}