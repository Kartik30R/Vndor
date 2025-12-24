abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);
}

class ServerFailure extends Failure {
  const ServerFailure(String message, [String? code])
      : super(message, code);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message)
      : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message)
      : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message)
      : super(message);
}
