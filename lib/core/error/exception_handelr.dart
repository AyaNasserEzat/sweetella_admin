import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:sweetella_admin/core/error/failure.dart';

class ExceptionHandler {
  const ExceptionHandler();

  static Failure handle(Object error) {
    if (error is FirebaseException) {
      return Failure(_mapFirebaseError(error.code));
    }

    if (error is DioException) {
      return Failure(_mapDioError(error));
    }

    if (error is PlatformException) {
      return const Failure(FailureKind.platform);
    }

    return const Failure(FailureKind.unknown);
  }

  static FailureKind _mapFirebaseError(String code) {
    switch (code) {
      case 'permission-denied':
        return FailureKind.forbidden;

      case 'unauthenticated':
        return FailureKind.unauthorized;

      case 'not-found':
        return FailureKind.notFound;

      case 'unavailable':
        return FailureKind.network;

      default:
        return FailureKind.firebase;
    }
  }

  static FailureKind _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return FailureKind.network;

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        if (statusCode == 401) {
          return FailureKind.unauthorized;
        }

        if (statusCode == 403) {
          return FailureKind.forbidden;
        }

        if (statusCode == 404) {
          return FailureKind.notFound;
        }

        if (statusCode != null && statusCode >= 500) {
          return FailureKind.server;
        }

        return FailureKind.unknown;

      default:
        return FailureKind.unknown;
    }
  }
}
