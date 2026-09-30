import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension TimestampX on Timestamp? {
  String get formattedTime {
    if (this == null) return '';

    final date = this!.toDate();
    return DateFormat('hh:mm a').format(date);
  }

  String get formattedDate {
    if (this == null) return '';

    final date = this!.toDate();
    return DateFormat('dd MMM yyyy').format(date);
  }

  String get formattedDateTime {
    if (this == null) return '';

    final date = this!.toDate();
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }
}
