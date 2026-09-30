class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => message;
}

class InvalidEmailOrPasswordException extends AppException {
  InvalidEmailOrPasswordException(super.message);
}

class WeakPasswordException extends AppException {
  WeakPasswordException(super.message);
}

class InvalidEmailException extends AppException {
  InvalidEmailException(super.message);
}

class UserDisabledException extends AppException {
  UserDisabledException(super.message);
}

class WrongPasswordException extends AppException {
  WrongPasswordException(super.message);
}

class UserNotFoundException extends AppException {
  UserNotFoundException(super.message);
}

class EmailAlreadyInUseException extends AppException {
  EmailAlreadyInUseException(super.message);
}

class OperationNotAllowedException extends AppException {
  OperationNotAllowedException(super.message);
}

class PermissionDeniedException extends AppException {
  PermissionDeniedException(super.message);
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class TimeoutAppException extends AppException {
  TimeoutAppException(super.message);
}

class UnknownAppException extends AppException {
  UnknownAppException(super.message);
}
